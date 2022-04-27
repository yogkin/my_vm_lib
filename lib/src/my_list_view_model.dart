import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'i_refresh_controller.dart';
import 'ref_status.dart';
import 'my_base_refresh_view_model.dart';

/// 下拉刷新viewModel类
///
abstract class MYBaseListViewModel<T> extends MYBaseListRefreshViewModel<T> {
  // 分页条目数量，默认20
  int pageSize = 20;

  // 当前页码
  int currentPageNum = 1;

  /// 加载数据
  /// [pageNum] 当前页码
  /// [params] 请求参数
  ///
  Future<List<T>> getListData({int pageNum});

  /// 获取 controller
  ///
  IMYRefreshController getRefreshController();

  IMYRefreshController get _refreshController => getRefreshController();

  @override
  Future<List<T>> refresh() async {
    try {
      currentPageNum = 1;
      var data = await getListData(pageNum: currentPageNum);
      if (data.isEmpty) {
        _refreshController.refreshCompleted(resetFooterState: false);
        _refreshController.loadNoData();
        setRefresh(LoadState.NOT_DATA);
      } else {
        list.clear();
        list.addAll(data);
        _refreshController.refreshCompleted();
        // 小于分页的数量,禁止上拉加载更多
        if (data.length < pageSize) {
          _refreshController.loadNoData();
        } else {
          //防止上次上拉加载更多失败,需要重置状态
          _refreshController.loadComplete();
        }
        setRefresh(LoadState.SHOW_DATA);
      }
      notifyListeners();
      return data;
    } catch (e, _) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      debugPrint(e.toString());
      _refreshController.refreshFailed();
      setRefresh(LoadState.NETWORK_ERROR);
      return null;
    }
  }

  /// 上拉加载更多
  /// 如果页面需要自己处理分页,可以重写此方法
  ///
  Future<List<T>> loadMoreData() async {
    try {
      var data = await getListData(pageNum: ++currentPageNum);
      if (data.isEmpty) {
        currentPageNum--;
        _refreshController.loadNoData();
      } else {
        list.addAll(data);
        if (data.length < pageSize) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      currentPageNum--;
      _refreshController.loadFailed();
      debugPrint('error--->\n' + e.toString());
      debugPrint('statck--->\n' + s.toString());
      return null;
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
