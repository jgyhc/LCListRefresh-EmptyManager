//
//  LCListRefreshManager.h
//
//
//  Created by Zgmanhui on 16/4/14.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "LCEmptyPageView.h"
/// 分页显示列表数据处理器
@protocol LCListRefreshManagerDelegate;


@interface LCListRefreshManager : NSObject

- (instancetype)initWithDelegate:(id<LCListRefreshManagerDelegate>)delegate pageCount:(NSUInteger)pageCount inTableView:(UITableView *)tableView;

/// 绑定UITableView
@property (nonatomic, weak) UITableView *tableView;
/// 数据回掉
@property (nonatomic, weak) id<LCListRefreshManagerDelegate> delegate;

/// 数据中心
@property (nonatomic, readonly) NSMutableArray *datas;
/// 分页页数 【第一页是0】
@property (nonatomic, readonly) NSUInteger pageNo;
/// 分页每页显示多少条
@property (nonatomic, readonly) NSUInteger pageCount;
/// 是否还有更多数据
@property (nonatomic, readonly) BOOL haveMoreData;
/// 是否正在加载数据
@property (nonatomic, readonly) BOOL isLoading;

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) LCEmptyPageView *emptyPageView;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) LCEmptyPageViewStatus status;
@end


/**
 *  分页显示列表数据处理器
 */
@protocol LCListRefreshManagerDelegate <NSObject>

/// 加载数据
- (void)lc_listRefreshManager:(LCListRefreshManager *)listRefreshManager loadDataWithPageNo:(long)pageIndex pageCount:(long)pageSize completion:(void (^)(NSArray *datas, NSError *error))completion;


@optional

/// 加载数据开始
- (void)lc_listRefreshManagerBeginLoading:(LCListRefreshManager *)listRefreshManager;
/// 加载数据完成
- (void)lc_listRefreshManagerEndLoading:(LCListRefreshManager *)listRefreshManager;

/// 加载数据失败
- (void)lc_listRefreshManagerFailure:(LCListRefreshManager *)listRefreshManager error:(NSError *)error;


@end

