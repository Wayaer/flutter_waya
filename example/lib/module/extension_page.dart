import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ExtensionPage extends StatelessWidget {
  const ExtensionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ExtensionPage'),
        padding: const EdgeInsets.all(20),
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ElevatedText('ExtensionFunction',
              onTap: () => push(const _ExtensionFunctionPage())),
          ElevatedText('ExtensionContext',
              onTap: () => push(const _ExtensionContextPage())),
          ElevatedText('ExtensionNum',
              onTap: () => push(const _ExtensionNumPage())),
          ElevatedText('ExtensionString',
              onTap: () => push(const _ExtensionStringPage())),
          ElevatedText('ExtensionList',
              onTap: () => push(const _ExtensionListPage())),
          ElevatedText('ExtensionMap',
              onTap: () => push(const _ExtensionMapPage())),
          ElevatedText('ExtensionDateTime',
              onTap: () => push(const _ExtensionDateTimePage())),
          ElevatedText('ExtensionDuration',
              onTap: () => push(const _ExtensionDurationPage())),
        ]);
  }
}

class _ExtensionDurationPage extends StatelessWidget {
  const _ExtensionDurationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ExtensionDurationPage'),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _Item('\$duration.delayed()', '转换指定长度的字符串'),
          _Item('\$duration.timer()', 'Timer'),
          _Item('\$duration.timerPeriodic()', '需要手动释放timer'),
        ]);
  }
}

class _ExtensionDateTimePage extends StatelessWidget {
  const _ExtensionDateTimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ExtensionDateTimePage'),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _Item('\$dateTime.format()', '转换指定长度的字符串'),
          _Item('\$dateTime.isLeapYearByYear', '是否是闰年'),
        ]);
  }
}

class _ExtensionMapPage extends StatelessWidget {
  const _ExtensionMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ExtensionListPage'),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        isScroll: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _Item('\$map.keysList()', ''),
          _Item('\$map.valuesList()', ''),
          _Item('\$map.builderEntry()', ''),
          _Item('\$map.addAllT()', 'addAll map 并返回 新map'),
          _Item('\$map.updateT()', 'update map 并返回 新map'),
          _Item('\$map.updateAllT()', 'update map 并返回 新map'),
        ]);
  }
}

class _ExtensionListPage extends StatelessWidget {
  const _ExtensionListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ExtensionListPage'),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        isScroll: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _Item('\$list.builder()', 'list.map.toList()'),
          _Item('\$list.builderEntry()', 'list.asMap().entries.map.toList()'),
          _Item('\$list.generate()', ''),
          _Item('\$list.addT()', '添加子元素 并返回 新数组'),
          _Item('\$list.addAllT()', '添加数组 并返回 新数组'),
          _Item('\$list.insertT()', '插入子元素 并返回 新数组'),
          _Item('\$list.insertAllT()', '插入数组 并返回 新数组'),
          _Item('\$list.replaceRangeT()', '替换指定区域 返回 新数组'),
          _Item('\$list.base64Encode', ''),
          _Item('\$list.utf8Decode', ''),
          _Item('\$list.uInt8ListFrom32BitList', ''),
          _Item('\$list.toUtf8', ''),
        ]);
  }
}

class _ExtensionStringPage extends StatelessWidget {
  const _ExtensionStringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ExtensionStringPage'),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        isScroll: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _Item('\$string.parseInt', '转换为int'),
          _Item('\$string.parseDouble', '转换为Double'),
          _Item('\$string.toMd5', 'md5 加密'),
          _Item('\$string.toEncodeBase64', 'Base64加密'),
          _Item('\$string.toDecodeBase64', 'Base64解密'),
          _Item('\$string.toClipboard', '复制到粘贴板'),
          _Item('\$string.isEmail', '验证邮箱'),
          _Item('\$string.isChinaPhone', '手机号验证'),
          _Item('\$string.utf8ToList', 'utf8ToList'),
          _Item('\$string.utf8Encode', '进行utf8编码'),
          _Item('\$string.formatDigitPattern()', '每隔 x位 加 pattern'),
          _Item('\$string.formatDigitPatternEnd()', '每隔 x位 加 pattern, 从末尾开始'),
          _Item('\$string.reverse', 'reverse'),
          _Item('\$string.removePrefix', '移出头部指定 [prefix] 不包含不移出'),
          _Item('\$string.removeSuffix', '移出尾部指定 [suffix] 不包含不移出'),
          _Item('\$string.removePrefixLength', '移出头部指定长度'),
          _Item('\$string.removeSuffixLength', '移出尾部指定长度'),
        ]);
  }
}

class _ExtensionFunctionPage extends StatelessWidget {
  const _ExtensionFunctionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ExtensionFunctionPage'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ValueBuilder<int>(
              initialValue: 0,
              builder: (_, int? value, ValueCallback<int> updater) {
                return Column(children: <Widget>[
                  const Text('防抖函数'),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(value.toString())),
                  ElevatedText('点击+1',
                      onTap: () {
                        int v = value ?? 0;
                        updater(v += 1);
                      }.debounce()),
                ]);
              }),
          const SizedBox(height: 10),
          ValueBuilder<int>(
              initialValue: 0,
              builder: (_, int? value, ValueCallback<int> updater) {
                return Column(children: <Widget>[
                  const Text('未添加防抖'),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(value.toString())),
                  ElevatedText('点击+1', onTap: () {
                    int v = value ?? 0;
                    updater(v += 1);
                  }),
                ]);
              }),
          const SizedBox(height: 30),
          ValueBuilder<int>(
              initialValue: 0,
              builder: (_, int? value, ValueCallback<int> updater) {
                return Column(children: <Widget>[
                  const Text('节流函数'),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(value.toString())),
                  ElevatedText('点击+1',
                      onTap: () async {
                        await 2.seconds.delayed(() {
                          int v = value ?? 0;
                          updater(v += 1);
                        });
                      }.throttle()),
                ]);
              }),
          const SizedBox(height: 10),
          const _NoThrottle(),
        ]);
  }
}

class _NoThrottle extends StatefulWidget {
  const _NoThrottle({Key? key}) : super(key: key);

  @override
  _NoThrottleState createState() => _NoThrottleState();
}

class _NoThrottleState extends State<_NoThrottle> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Text('未节流函数'),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(i.toString())),
      ElevatedText('点击+1', onTap: () async {
        await 2.seconds.delayed(() {});
        i++;
        setState(() {});
      }),
    ]);
  }
}

class _ExtensionNumPage extends StatelessWidget {
  const _ExtensionNumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ExtensionNumPage'),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        isScroll: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _Item('\$num.generate()', '创建指定长度的List'),
          _Item('\$num.length', 'num 长'),
          _Item('\$num.fromMicrosecondsSinceEpoch()', '微秒时间戳转换 DateTime'),
          _Item('\$num.fromMillisecondsSinceEpoch()', '毫秒时间戳转换 DateTime'),
          _Item('\$num.milliseconds()', '返回 Duration(milliseconds:\$num)'),
          _Item('\$num.milliseconds()', '返回 Duration(milliseconds:\$num)'),
          _Item('\$num.seconds()', '返回 Duration()'),
          _Item('\$num.minutes()', '返回 Duration()'),
          _Item('\$num.hours()', '返回 Duration()'),
          _Item('\$num.days()', '返回 Duration()'),
          _Item('\$num.days()', '返回 Duration()'),
          _Item('\$num.contains()', '是否包含'),
        ]);
  }
}

class _ExtensionContextPage extends StatelessWidget {
  const _ExtensionContextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        isScroll: true,
        appBar: AppBarText('ExtensionContextPage'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _Item('context.focusNode()',
              '移出焦点 focusNode==null  移出焦点 （可用于关闭键盘） focusNode！!= null 获取焦点'),
          _Item('context.autoFocus()', '自动获取焦点'),
          _Item('context.mediaQuerySize', 'MediaQuery.of(context).size'),
          _Item('context.height', 'MediaQuery.of(context).height'),
          _Item('context.width', 'MediaQuery.of(context).width'),
          _Item('context.mediaQuery', 'MediaQuery.of(context)'),
          _Item('context.theme', ' Theme.of(context)'),
          _Item('context.isDarkMode',
              'Theme.of(context).brightness == Brightness.dark'),
          _Item('context.iconColor', 'Theme.of(context).iconTheme.color'),
          _Item('context.textTheme', 'Theme.of(context).textTheme'),
          _Item('context.devicePixelRatio',
              'MediaQuery.of(context).devicePixelRatio'),
          _Item('context.textScaleFactor',
              'MediaQuery.of(context).textScaleFactor'),
          _Item('context.mediaQueryShortestSide',
              'MediaQuery.of(context).shortestSide'),
          _Item('context.orientation', 'MediaQuery.of(context).orientation'),
          _Item('context.isLandscape',
              'MediaQuery.of(context).isLandscape == Orientation.landscape'),
          _Item('context.isPortrait',
              'MediaQuery.of(context).isPortrait == Orientation.portrait'),
          _Item('context.getWidgetBounds', '获取widget Rect'),
          _Item(
              'context.getWidgetLocalToGlobal', '获取widget在屏幕上的坐标,widget必须渲染完成'),
        ]);
  }
}

class _Item extends StatelessWidget {
  const _Item(this.func, this.description, {Key? key}) : super(key: key);
  final String func;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Universal(
        crossAxisAlignment: CrossAxisAlignment.start,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: getBaseBoxShadow(context.theme.shadowColor)),
        children: [
          RText(textAlign: TextAlign.start, texts: [
            'use :   ',
            func,
          ], styles: [
            context.textTheme.subtitle1!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            context.textTheme.bodyText2!,
          ]).sizedBox(width: double.infinity),
          const SizedBox(height: 5),
          RText(maxLines: 3, textAlign: TextAlign.start, texts: [
            'description :   ',
            description,
          ], styles: [
            context.textTheme.subtitle1!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            context.textTheme.bodyText2!.copyWith(),
          ]).sizedBox(width: double.infinity),
        ]);
  }
}
