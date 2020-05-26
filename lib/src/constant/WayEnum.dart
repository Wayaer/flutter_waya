enum LineType {
  outline,
  underline,
}
enum AutoScrollAnimation {
  l2r, //从左往右执行动画
  r2l, //从右往左执行动画
  t2b, //从上往下执行动画
  b2t //从下往上执行动画 默认是从下往上的
}
enum IndicatorType {
  none,
  slide,
  warm,
  color,
  scale,
  drop,
}
enum DateType {
  yearSecond, //2020-1-1 00:00:00
  yearMinute, //2020-1-1 00:00
//  yearHour, //2020-1-1 00
  yearDay, //2020-1-1
  monthSecond, //1-1 00:00:00
  monthMinute, //1-1 00:00
//  monthHour, //1-1 00
  monthDay, //1-1
//  daySecond, //1 00:00:00
//  dayMinute, //1 00:00
//  dayHour, //1 00
  hourSecond, //00:00:00
  hourMinute, //00:00
}
enum LoadingType {
  circular, //圆圈
  linear, //横条
  refresh, //不常用 下拉刷新圆圈
}
enum PushMode {
  cupertino, //从右往左push
  material, //从下往上 push
}
enum InputTextType {
  password, //密码
  number, //整数
  text, //文本
  decimal, //小数
  letter, //字母
  chinese, //中文
  email, //邮箱
  mobilePhone, //手机号码
  phone, //电话号码
  idCard, //身份证
  ip, //ip地址
  positive, //正数
  negative, //负数
}

//刷新类型
enum RefreshCompletedType {
  refresh,
  refreshFailed,
  refreshToIdle,
  onLoading,
  loadFailed,
  loadNoData,
  twoLevel,
}
enum StretchyHeaderAlignment {
  bottom,
  center,
  top,
}
enum TabBarLevelPosition {
  right,
  left,
}
