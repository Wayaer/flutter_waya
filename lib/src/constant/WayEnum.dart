enum LineType {
  outLine, //外边框四周
  underline, //下划线
  none, //不显示线
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
enum InputTextType {
  password, //密码
  number, //整数
  text, //文本
  decimal, //小数
  letter, //字母
  chinese, //中文
  email, //邮箱
  mobilePhoneNumber, //国内手机号码
  phoneNumber, //国内电话号码
  dateTime, //日期格式
  idCard, //身份证
  ip, //ip地址
  url, //网址url
  positive, //正数
  negative, //负数

}