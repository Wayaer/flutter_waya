enum LineType {
  outLine, //外边框四周
  underline, //下划线
}

enum MarqueeAnimation {
  l2r, //从左往右执行动画
  r2l, //从右往左执行动画
  t2b, //从上往下执行动画
  b2t //从下往上执行动画 默认是从下往上的
}

enum DateType {
  dateTime, //2020-1-1 00:00
  data, //2020-1-1
  time, //00:00:00
  monthSecond, //1-1 00:00:00
}
enum PushMode {
  Cupertino, //从右往左push
  Material, //从下往上 push
}
