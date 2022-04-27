
import 'ref_status.dart';
import 'my_base_view_model.dart';

/// 下拉刷新基类
///
abstract class MYBaseListRefreshViewModel<T> extends MYBaseViewModel {
  /// 页面数据
  List<T> list = [];

  ///RefreshStatus
  LoadState refreshStatus = LoadState.VIEW_SKELETON;

  ///设置状态
  setRefresh(LoadState status) {
    refreshStatus = status;
    notifyListeners();
  }

  /// 第一次进入页面loading skeleton
  iniData() async {
    await refresh();
  }



  // 加载数据
  Future<List<T>> refresh();

  // 加载数据
  Future<List<T>> loadMoreData();
}
