# LCListRefresh-EmptyManager
对MJRefresh的再次封装，旨在统一管理下拉刷新和上拉加载的逻辑，在此基础上还给tableView的空白面做了统一的管理。
第一步设置管理对象
    self.manager = [[LCListRefreshManager alloc] initWithDelegate:self pageCount:030 inTableView:self.tableView];
    第二步设置空白页类型
    self.manager.status = LCEmptyPageViewStatusNoMessageNew;

第三步实现代理方法即可：
- (void)lc_listRefreshManager:(LCListRefreshManager *)listRefreshManager loadDataWithPageNo:(long)pageIndex pageCount:(long)pageSize completion:(void (^)(NSArray *datas, NSError *error))completion{
}

详情见demo
