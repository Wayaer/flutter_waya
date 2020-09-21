enum LineType { outline, underline }
enum ElasticButtonType { onlyScale, withOpacity }
enum AutoScrollAnimation {
  ///从左往右执行动画
  l2r,

  ///从右往左执行动画
  r2l,

  ///从上往下执行动画
  t2b,

  ///从下往上执行动画 默认是从下往上的
  b2t
}

enum ListType { builder, custom, separated }

enum IndicatorType { none, slide, warm, color, scale, drop }

enum CarouselLayout { none, stack, tinder, custom }

enum DateType {
  ///2020-1-1 00:00:00
  yearSecond,

  ///2020-1-1 00:00
  yearMinute,

  ///2020-1-1 00
  ///  yearHour,
  ///   ///2020-1-1
  yearDay,

  ///1-1 00:00:00
  monthSecond,

  ///1-1 00:00
  monthMinute,

  ///1-1 00
  ///  monthHour,
  monthDay,

  ///1-1
  ///  daySecond, ///1 00:00:00
  ///  dayMinute, ///1 00:00
  ///  dayHour, ///1 00
  ///
  ///00:00:00
  hourSecond,

  ///00:00
  hourMinute,
}
enum LoadingType {
  ///圆圈
  circular,

  ///横条
  linear,

  ///不常用 下拉刷新圆圈
  refresh,
}
enum PushMode {
  ///从右往左push
  cupertino,

  ///从下往上 push
  material,
}
enum InputTextType {
  ///字母和数字
  lettersNumbers,

  ///密码 字母和数字和.
  password,

  ///整数
  number,

  ///文本
  text,

  ///小数
  decimal,

  ///字母
  letter,

  ///中文
  chinese,

  ///邮箱
  email,

  ///手机号码
  mobilePhone,

  ///电话号码
  phone,

  ///身份证
  idCard,

  ///ip地址
  ip,

  ///正数
  positive,

  ///负数
  negative,
}

///刷新类型
enum RefreshCompletedType { refresh, refreshFailed, refreshToIdle, onLoading, loadFailed, loadNoData, twoLevel }

enum StretchyHeaderAlignment { bottom, center, top }

enum TabBarLevelPosition {
  right,
  left,
}
enum PopupMode { left, top, right, bottom, center }
enum ListWheelChildDelegateType {
  ///有大量子控件时使用
  builder,

  ///普通的类似 ListView
  list,

  ///一个提供无限通过循环显式列表的子级
  looping
}

enum PopupFromType {
  ///从左边进入
  fromLeft,

  ///从右边进入
  fromRight,

  ///从头部进入
  fromTop,

  ///从底部进入
  fromBottom,
}
