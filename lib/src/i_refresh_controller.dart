///刷新列表接口
///
abstract class IMYRefreshController {
  void refreshCompleted({bool resetFooterState = false});

  void loadNoData();

  void loadComplete();

  void refreshFailed();

  void loadFailed();

  void dispose();
}
