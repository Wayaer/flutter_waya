class WayConstant {
  static const double Radius = 5; //全局圆角大小
  static const double fontSize = 14; //全局默认字体大小
  static const double appBarHeight = 43; //导航栏高度
  static const int errorCode911 = 911; //网络请求失败
  static const int errorCode920 = 920; //网络请求已取消
  static const int errorCode930 = 930; //网络连接超时
  static const int errorCode940 = 940; //网络接收超时
  static const int errorCode950 = 950; //网络发送超时
  static const String errorMessage911 = '网络请求失败'; //网络请求失败
  static const String errorMessage920 = '网络请求已取消'; //网络请求已取消
  static const String errorMessage930 = '网络连接超时'; //网络连接超时
  static const String errorMessage940 = '网络接收超时'; //网络接收超时
  static const String errorMessage950 = '网络发送超时'; //网络发送超时
  static const String errorMessage960 = '服务器错误:'; //服务器错误
  static const String errorMessageT911 = 'Failed'; //网络请求失败
  static const String errorMessageT920 = 'Cancel'; //网络请求已取消
  static const String errorMessageT930 = 'Connect Timeout'; //网络连接超时
  static const String errorMessageT940 = 'Receive Timeout'; //网络接收超时
  static const String errorMessageT950 = 'Send Timeout'; //网络发送超时
  static const String errorMessageT960 = 'Response'; //服务器错误
  static const String regExpNumber = '-?[1-9]\d*'; //整数
  static const String regExpPositive = '-?[1-9]\d*'; //正数
  static const String regExpNegative = '-?[1-9.]\d*'; //负数
  static const String regExpPassword = '[a-zA-Z1-9.]'; //密码
  static const String regExpDecimal = '[0-9.]'; //小数
  static const String regExpLetter = '[a-zA-Z]'; //字母
  static const String regExpChinese = '[\u4e00-\u9fa5]'; //中文
  static const String regExpEmail = '\w[-\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\.)+[A-Za-z]{2,14}'; //邮箱
  static const String regExpPhoneNumber = '[0-9-()（）]{7,18}'; //国内电话号
  static const String regExpMobilePhoneNumber = '0?(13|14|15|17|18|19)[0-9]{9}'; //国内手机号
  static const String regExpDateTime = '\d{4}(\-|\/|.)\d{1,2}\1\d{1,2}'; //日期时间
  static const String regExpIdCard = '\d{17}[\d|x]|\d{15}'; //身份证
  static const String regExpIP =
      '(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)'; //ip
  static const String regExpUrl = '^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+'; //
}
