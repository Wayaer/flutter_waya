import 'dart:async';

import 'package:flutter_waya/flutter_waya.dart';

enum DateTimeDist {
  /// 2020-01-01 00:00:00.000
  yearMillisecond,

  /// 2020-01-01 00:00:00
  yearSecond,

  /// 2020-01-01 00:00
  yearMinute,

  /// 2020-01-01 00
  yearHour,

  /// 2020-01-01
  yearDay,

  /// 2020-01
  yearMonth,

  /// 01-01 00:00:00.00
  monthMillisecond,

  /// 01-01 00:00:00
  monthSecond,

  /// 01-01 00:00
  monthMinute,

  /// 01-01 00
  monthHour,

  /// 01-01
  monthDay,

  /// 01 00:00:00.000
  dayMillisecond,

  /// 01 00:00:00
  daySecond,

  /// 01 00:00
  dayMinute,

  /// 01 00
  dayHour,

  /// 00:00:00.000
  hourMillisecond,

  /// 00:00:00
  hourSecond,

  /// 00:00
  hourMinute,
}

/// DateTime 扩展
extension ExtensionDateTime on DateTime {
  /// 转换指定长度的字符串
  String format([DateTimeDist? dist, bool dual = true]) {
    final DateTime date = this;
    dist ??= DateTimeDist.yearSecond;
    final String year = date.year.toString();
    final String month =
        dual ? date.month.padLeft(2, '0') : date.month.toString();
    final String day = dual ? date.day.padLeft(2, '0') : date.day.toString();
    final String hour = dual ? date.hour.padLeft(2, '0') : date.hour.toString();
    final String minute =
        dual ? date.minute.padLeft(2, '0') : date.minute.toString();
    final String second =
        dual ? date.second.padLeft(2, '0') : date.second.toString();
    final String millisecond =
        dual ? date.millisecond.padLeft(2, '0') : date.millisecond.toString();
    // final String microsecond =
    //     dual ? date.microsecond.padLeft(2, '0') : date.microsecond.toString();
    switch (dist) {
      case DateTimeDist.yearMillisecond:
        return '$year-$month-$day $hour:$minute:$second.$millisecond';
      case DateTimeDist.yearSecond:
        return '$year-$month-$day $hour:$minute:$second';
      case DateTimeDist.yearMinute:
        return '$year-$month-$day $hour:$minute';
      case DateTimeDist.yearHour:
        return '$year-$month-$day $hour';
      case DateTimeDist.yearDay:
        return '$year-$month-$day';
      case DateTimeDist.yearMonth:
        return '$year-$month';
      case DateTimeDist.monthMillisecond:
        return '$month-$day $hour:$minute:$second.$millisecond';
      case DateTimeDist.monthSecond:
        return '$month-$day $hour:$minute:$second';
      case DateTimeDist.monthMinute:
        return '$month-$day $hour:$minute';
      case DateTimeDist.monthHour:
        return '$month-$day $hour';
      case DateTimeDist.monthDay:
        return '$month-$day';
      case DateTimeDist.dayMillisecond:
        return '$day $hour:$minute:$second.$millisecond';
      case DateTimeDist.daySecond:
        return '$day $hour:$minute:$second';
      case DateTimeDist.dayMinute:
        return '$day $hour:$minute';
      case DateTimeDist.dayHour:
        return '$day $hour';
      case DateTimeDist.hourMillisecond:
        return '$hour:$minute:$second.$millisecond';
      case DateTimeDist.hourSecond:
        return '$hour:$minute:$second';
      case DateTimeDist.hourMinute:
        return '$hour:$minute';
    }
  }

  /// Return whether it is leap year.
  /// 是否是闰年
  bool get isLeapYearByYear =>
      year % 4 == 0 && year % 100 != 0 || year % 400 == 0;

  /// 获取时间区间内所有的日期
  List<DateTime> getDaysForRange(DateTime endDate) {
    List<DateTime> result = [];
    DateTime date = this;
    while (date.difference(endDate).inDays <= 0) {
      result.add(date);
      date = date.add(const Duration(hours: 24));
    }
    return result;
  }
}

extension ExtensionDuration on Duration {
  /// final _delay = 3.seconds;
  /// print('+ wait $_delay');
  /// await _delay.delayed();
  /// print('- finish wait $_delay');
  /// print('+ callback in 700ms');
  Future<T> delayed<T>([FutureOr<T> Function()? callback]) =>
      Future<T>.delayed(this, callback);

  /// Timer
  Timer timer([Function? function]) {
    late Timer timer;
    timer = Timer(this, () {
      if (function != null) function.call();
      timer.cancel();
    });
    return timer;
  }

  /// 需要手动释放timer
  Timer timerPeriodic(void Function(Timer timer) callback) =>
      Timer.periodic(this, (Timer time) => callback(time));

  /// 以毫秒结尾
  String toEndMillisecondsString() => toString().removeSuffixLength(3);

  /// 以秒结尾
  String toEndSecondsString() => toString().removeSuffixLength(7);

  /// 以分结尾
  String toEndMinutesString() => toString().removeSuffixLength(10);

  /// 以时结尾
  String toEndHoursString() => toString().removeSuffixLength(13);
}
