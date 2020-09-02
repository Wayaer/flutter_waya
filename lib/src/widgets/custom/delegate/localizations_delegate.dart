import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

///主要解决cupertino控件不能显示中文的问题
class CommonLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const CommonLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => <String>['zh', 'CN'].contains(locale.languageCode);

  @override
  SynchronousFuture<_DefaultCupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<_DefaultCupertinoLocalizations>(_DefaultCupertinoLocalizations(locale.languageCode));

  @override
  bool shouldReload(CommonLocalizationsDelegate old) => false;
}

class _DefaultCupertinoLocalizations extends CupertinoLocalizations {
  _DefaultCupertinoLocalizations(this._languageCode) : assert(_languageCode != null);
  final String _languageCode;
  static const LocalizationsDelegate<CupertinoLocalizations> delegate = CommonLocalizationsDelegate();
  final Map<String, Map<String, String>> _dict = <String, Map<String, String>>{
    'en': <String, String>{
      'alert': 'Alert',
      'copy': 'Copy',
      'paste': 'Paste',
      'cut': 'Cut',
      'selectAll': 'Select all',
      'today': 'Today',
      'forenoon': 'Forenoon',
      'afternoon': 'Afternoon'
    },
    'zh': <String, String>{
      'forenoon': '上午',
      'afternoon': '下午',
      'alert': '提醒',
      'copy': '复制',
      'paste': '粘贴',
      'cut': '剪切',
      'selectAll': '选择全部',
      'today': '今天'
    }
  };
  final Map<String, List> _months = <String, List>{
    'en': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    'enl': [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ],
    'zh': ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
  };
  final Map<String, List> _weekDays = <String, List>{
    'en': ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
    'enl': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
    'zh': ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  };

  String _get(String key) => _dict[_languageCode][key];

  @override
  String get alertDialogLabel => _get('alert');

  @override
  String get anteMeridiemAbbreviation => _get('forenoon');

  @override
  String get postMeridiemAbbreviation => _get('afternoon');

  @override
  String get copyButtonLabel => _get('copy');

  @override
  String get cutButtonLabel => _get('cut');

  @override
  String get pasteButtonLabel => _get('paste');

  @override
  String get selectAllButtonLabel => _get('selectAll');

  @override
  String get todayLabel => _get('today');

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.ymd;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder => DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String datePickerDayOfMonth(int dayIndex) => dayIndex.toString();

  @override
  String datePickerHour(int hour) => hour.toString();

  @override
  String datePickerHourSemanticsLabel(int hour) => hour.toString();

  @override
  String datePickerMediumDate(DateTime date) {
    return '${_weekDays[_languageCode][date.weekday - DateTime.monday]} '
        '${_months[_languageCode][date.month - DateTime.january]} '
        '${date.day.toString().padRight(2)}';
  }

  @override
  String datePickerMinute(int minute) => minute.toString().padLeft(2, '0');

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    if (minute == 1) return '1 分钟';
    return minute.toString() + ' 分钟';
  }

  @override
  String datePickerMonth(int monthIndex) => _months[_languageCode][monthIndex - 1];

  @override
  String datePickerYear(int yearIndex) => yearIndex.toString();

  @override
  String timerPickerHour(int hour) => hour.toString();

  @override
  String timerPickerHourLabel(int hour) => '时';

  @override
  String timerPickerMinute(int minute) => minute.toString();

  @override
  String timerPickerMinuteLabel(int minute) => '分';

  @override
  String timerPickerSecond(int second) => second.toString();

  @override
  String timerPickerSecondLabel(int second) => '秒';

  @override
  String get modalBarrierDismissLabel => "";

  @override
  String tabSemanticsLabel({int tabIndex, int tabCount}) => "";
}

class ChineseCupertinoLocalizations implements CupertinoLocalizations {
  final materialDelegate = GlobalMaterialLocalizations.delegate;
  final widgetsDelegate = GlobalWidgetsLocalizations.delegate;
  final local = const Locale('zh');

  MaterialLocalizations ml;

  Future init() async {
    ml = await materialDelegate.load(local);
    print(ml.pasteButtonLabel);
  }

  @override
  String get alertDialogLabel => ml.alertDialogLabel;

  @override
  String get anteMeridiemAbbreviation => ml.anteMeridiemAbbreviation;

  @override
  String get copyButtonLabel => ml.copyButtonLabel;

  @override
  String get cutButtonLabel => ml.cutButtonLabel;

  @override
  String get pasteButtonLabel => ml.pasteButtonLabel;

  @override
  String get postMeridiemAbbreviation => ml.postMeridiemAbbreviation;

  @override
  String get selectAllButtonLabel => ml.selectAllButtonLabel;

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.mdy;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder => DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String datePickerDayOfMonth(int dayIndex) {
    return dayIndex.toString();
  }

  @override
  String datePickerHour(int hour) => hour.toString().padLeft(2, "0");

  @override
  String datePickerHourSemanticsLabel(int hour) => "$hour" + "时";

  @override
  String datePickerMediumDate(DateTime date) => ml.formatMediumDate(date);

  @override
  String datePickerMinute(int minute) => minute.toString().padLeft(2, '0');

  @override
  String datePickerMinuteSemanticsLabel(int minute) => "$minute" + "分";

  @override
  String datePickerMonth(int monthIndex) => "$monthIndex";

  @override
  String datePickerYear(int yearIndex) => yearIndex.toString();

  @override
  String timerPickerHour(int hour) => hour.toString().padLeft(2, "0");

  @override
  String timerPickerHourLabel(int hour) => "$hour".toString().padLeft(2, "0") + "时";

  @override
  String timerPickerMinute(int minute) => minute.toString().padLeft(2, "0");

  @override
  String timerPickerMinuteLabel(int minute) => minute.toString().padLeft(2, "0") + "分";

  @override
  String timerPickerSecond(int second) => second.toString().padLeft(2, "0");

  @override
  String timerPickerSecondLabel(int second) => second.toString().padLeft(2, "0") + "秒";

  static const LocalizationsDelegate<CupertinoLocalizations> delegate = _ChineseDelegate();

  static Future<CupertinoLocalizations> load(Locale locale) {
    // var localizations = ChineseCupertinoLocalizations();
    // await localizations.init();
    return SynchronousFuture<CupertinoLocalizations>(ChineseCupertinoLocalizations());
  }

  @override
  String get modalBarrierDismissLabel => '';

  @override
  String tabSemanticsLabel({int tabIndex, int tabCount}) => '';

  @override
  String get todayLabel => "今天";
}

class _ChineseDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const _ChineseDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'zh';

  @override
  Future<CupertinoLocalizations> load(Locale locale) => ChineseCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<CupertinoLocalizations> old) => false;

  @override
  String toString() => 'ChineseCupertinoLocalizations.delegate(zh_CH)';
}
