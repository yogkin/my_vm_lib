///布局状态
enum LoadState {
  //鱼骨状态，首次进入列表
  VIEW_SKELETON,
  //加载数据成功，但无数据
  NOT_DATA,
  //加载出错，且无数据
  NETWORK_ERROR,
  //加载数据成功，且有数据
  SHOW_DATA,
}
