import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class ExtensionPage extends StatelessWidget {
  const ExtensionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        backgroundColor: Colors.white,
        appBar: AppBarText('ExtensionPage'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedText('ExtensionFunction',
              onTap: () => push(const _ExtensionFunctionPage())),
          ElevatedText('ExtensionContext',
              onTap: () => push(const _ExtensionContextPage())),
          ElevatedText('ExtensionNum',
              onTap: () => push(const _ExtensionNumPage())),
        ]);
  }
}

class _ExtensionFunctionPage extends StatelessWidget {
  const _ExtensionFunctionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        appBar: AppBarText('ExtensionNumPage'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedText('ExtensionNum', onTap: () {}),
        ]);
  }
}

class _ExtensionContextPage extends StatelessWidget {
  const _ExtensionContextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        backgroundColor: Colors.white,
        appBar: AppBarText('ExtensionContextPage'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedText('ExtensionContext', onTap: () {}),
        ]);
  }
}
