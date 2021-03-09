enum HttpType { get, post, put, delete }
enum LineType { outline, underline }
enum AutoScrollAnimation {
  ///  从左往右执行动画
  l2r,

  ///  从右往左执行动画
  r2l,

  ///  从上往下执行动画
  t2b,

  ///  从下往上执行动画 默认是从下往上的
  b2t
}

enum ListType { builder, custom, separated }

///  Toast类型
///  如果使用custom  请设置 customIcon
enum ToastType { success, fail, info, warning, smile, custom }

enum IndicatorType { none, slide, warm, color, scale, drop }

enum CarouselLayout { stack, tinder }

enum DateTimeDist {
  ///  2020-01-01 00:00:00
  yearSecond,

  ///  2020-01-01 00:00
  yearMinute,

  ///  2020-01-01 00
  yearHour,

  ///  2020-01-01
  yearDay,

  ///  01-01 00:00:00
  monthSecond,

  ///  01-01 00:00
  monthMinute,

  ///  01-01 00
  monthHour,

  ///  01-01
  monthDay,

  ///  01 00:00:00
  daySecond,

  ///  01 00:00
  dayMinute,

  ///  01 00
  dayHour,

  ///  00:00:00
  hourSecond,

  ///  00:00
  hourMinute,
}
enum LoadingType {
  ///  圆圈
  circular,

  ///  横条
  linear,

  ///  不常用 下拉刷新圆圈
  refresh,
}
enum WidgetMode {
  ///  Cupertino风格
  cupertino,

  ///  Material风格
  material,

  ///
  ripple,
}
enum InputTextType {
  ///  字母和数字
  lettersNumbers,

  ///  密码 字母和数字和.
  password,

  ///  整数
  number,

  ///  文本
  text,

  ///  小数
  decimal,

  ///  字母
  letter,

  ///  中文
  chinese,

  ///  邮箱
  email,

  ///  手机号码
  mobilePhone,

  ///  电话号码
  phone,

  ///  身份证
  idCard,

  ///  ip地址
  ip,

  ///  正数
  positive,

  ///  负数
  negative,
}

///  刷新类型
enum RefreshCompletedType {
  refresh,
  refreshFailed,
  refreshToIdle,
  loading,
  loadFailed,
  loadNoData,
  twoLevel
}

enum StretchyHeaderAlignment { bottom, center, top }

enum TabBarLevelPosition {
  right,
  left,
}
enum PopupMode { left, top, right, bottom, center }
enum ListWheelChildDelegateType {
  ///  有大量子控件时使用 子组件不会全部渲染
  builder,

  ///  不推荐使用 子组件会全部渲染
  list,

  ///  一个提供无限通过循环显式列表的子级
  looping
}

enum PopupFromType {
  ///  从左边进入
  fromLeft,

  ///  从右边进入
  fromRight,

  ///  从头部进入
  fromTop,

  ///  从底部进入
  fromBottom,
}

enum CircularStrokeCap { butt, round, square }

enum LinearStrokeCap { butt, round, roundAll }

enum ArcType { half, full }

enum CountAnimationType {
  ///animation only on change part
  part,

  ///animation on all
  all,
}
