//
//  LCListRefreshManager.m
//  
//
//  Created by Zgmanhui on 16/4/14.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "LCListRefreshManager.h"

@interface LCListRefreshManager ()<LCEmptyPageViewdelegate>

/// 数据中心
@property (nonatomic, readwrite) NSMutableArray *datas;
/// 分页页数 【第一页是1】
@property (nonatomic, readwrite) NSUInteger pageIndex;
/// 分页每页显示多少条
@property (nonatomic, readwrite) NSUInteger pageSize;
/// 是否还有更多数据
@property (nonatomic, readwrite) BOOL haveMoreData;
/// 是否正在加载数据
@property (nonatomic, readwrite) BOOL isLoading;
@end

@implementation LCListRefreshManager

- (instancetype)initWithDelegate:(id<LCListRefreshManagerDelegate>)delegate pageCount:(NSUInteger)pageCount inTableView:(UITableView *)tableView; {
    self = [self init];
    if (self) {
        self.delegate = delegate;
        self.pageSize = pageCount;
        self.tableView = tableView;
        self.haveMoreData = YES;
    }
    return self;
}



- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadDatas)];

    tableView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];

    tableView.mj_footer = footer;
    [tableView.mj_header beginRefreshing];
}


- (void)handleGoEvent {
    //按钮事件
}

#pragma mark - 数据加载
- (void)reloadDatas {
    if (self.isLoading) {
        return;
    }
    
    [self reloadDataWithCompletion:^(NSError *error) {
        if (error == nil) {
            [self.tableView reloadData];
        }
        else {
            [self loadFailure:error];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.haveMoreData) {
            [self.tableView.mj_footer resetNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)loadMoreDatas {
    if (self.isLoading) {
        return;
    }
    
    [self loadMoreDataWithCompletion:^(NSError *error) {
        if (error == nil) {
            [self.tableView reloadData];
        }
        else {
            [self loadFailure:error];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!self.haveMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/// 重新加载数据
- (void)reloadDataWithCompletion:(void (^)(NSError *error)) completion; {
    [self loadDataWithCompletion:completion isReload:YES];
}

/// 加载更多数据
- (void)loadMoreDataWithCompletion:(void (^)(NSError *error))completion; {
    [self loadDataWithCompletion:completion isReload:NO];
}

- (void)loadDataWithCompletion:(void (^)(NSError *error))completion isReload:(BOOL)isReload {
    if (self.isLoading) {       // 为了安全起见，在这里也加了限制，理论上应该不会出现这样的情况
        completion(nil);
        return ;
    }
    
    if (isReload) {
        self.haveMoreData = YES;
    }
        
    if (!self.haveMoreData) {
        completion(nil);
        return ;
    }
    
    if ([self.delegate respondsToSelector:@selector(lc_listRefreshManager:loadDataWithPageNo:pageCount:completion:)]) {
        [self beginLoading];
        __weak typeof(self) wself = self;
        [self.delegate lc_listRefreshManager:self loadDataWithPageNo:isReload?1:self.pageIndex pageCount:self.pageSize completion:^(NSArray *datas, NSError *error) {
            if (isReload) {//是否重新加载
                [self.tableView.mj_header endRefreshing];
                [wself.datas removeAllObjects];//重新加载移除所有内容
                wself.pageIndex = 1;
                if (datas != nil && datas.count != 0) {//如果数据不为空 并且长度不等于0
                    [self.emptyPageView removeFromSuperview];//移除所有空页面视图
                    wself.pageIndex ++;
                    [wself.datas addObjectsFromArray:datas];//把内容加到data中
                    if (datas.count < wself.pageSize) {//数据小于最大内容数量时  判定为没有多余内容了
                        wself.haveMoreData = NO;
                    }
                }else {//如果没有内容了
                    wself.haveMoreData = NO;
                    if (!_isShow) {
                        [wself.tableView addSubview:wself.emptyPageView];
                    }else {
                        //                        [ProgressHUD show:@"暂无数据"];
                        //不需要显示空页面的话 在这里做其他操作
                    }
                }
            }else {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.emptyPageView removeFromSuperview];//移除所有空页面视图
                if (datas != nil && datas.count != 0) {//如果数据不为空 并且长度不等于0
                    wself.pageIndex ++;//页码+ 1
                    [wself.datas addObjectsFromArray:datas];
                    if (datas.count < wself.pageSize) {//数据小于最大内容数量时  判定为没有多余内容了
                        wself.haveMoreData = NO;
                    }
                }else {//如果没有内容了
                    wself.haveMoreData = NO;
                }
            }

        }];
    }
}

- (void)beginLoading {
    self.isLoading = YES;
    if ([self.delegate respondsToSelector:@selector(lc_listRefreshManagerBeginLoading:)]) {
        [self.delegate lc_listRefreshManagerBeginLoading:self];
    }
}

- (void)endLoading {
    self.isLoading = NO;
    if ([self.delegate respondsToSelector:@selector(lc_listRefreshManagerEndLoading:)]) {
        [self.delegate lc_listRefreshManagerEndLoading:self];
    }
}

- (void)loadFailure:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(lc_listRefreshManagerFailure:error:)]) {
        [self.delegate lc_listRefreshManagerFailure:self error:error];
    }
}

#pragma mark - Getter & Setter

- (void)setStatus:(LCEmptyPageViewStatus)status {
    _status = status;
    self.emptyPageView.status = status;
}

- (LCEmptyPageView *)emptyPageView {
    if (!_emptyPageView) {
        _emptyPageView = [[LCEmptyPageView alloc] init];
        _emptyPageView.frame = self.tableView.bounds;
        _emptyPageView.delegate = self;
    }
    return _emptyPageView;
}


- (NSUInteger)pageIndex {
	if(!_pageIndex) {
		_pageIndex = 1;
	}
	return _pageIndex;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end
