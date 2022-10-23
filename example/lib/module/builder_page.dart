import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ExtendedBuilderPage extends StatelessWidget {
  const ExtendedBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool? showError = true;
    return ExtendedScaffold(
        padding: const EdgeInsets.all(20),
        appBar: AppBarText('ExtendedBuilder'),
        children: [
          const Partition('CustomFutureBuilder'),
          CustomFutureBuilder<String>(
              initialData: '初始的数据 点击刷新',
              future: () => future(showError),
              onDone: (_, data, reset) {
                return ElevatedText(data, onTap: reset);
              },
              onError: (_, error, reset) {
                return ElevatedText(error.toString(), onTap: reset);
              },
              onNone: (_, reset) {
                return ElevatedText('没有数据点击刷新', onTap: reset);
              },
              onWaiting: (_) {
                return const CircularProgressIndicator();
              }),
          const Partition('ExtendedFutureBuilder'),
          ExtendedFutureBuilder<String>(
              initialData: '初始的数据 点击刷新',
              future: future.call(false),
              onDone: (_, data) {
                return ElevatedText(data);
              },
              onError: (_, error) {
                return ElevatedText(error.toString());
              },
              onNone: (_, data) {
                return const ElevatedText('没有数据点击刷新');
              },
              onWaiting: (_, data) {
                return const CircularProgressIndicator();
              }),
          const Partition('ExtendedFutureBuilder'),
          CustomStreamBuilder<String>(
              stream: Stream.fromFuture(future(false)),
              onDone: (_, String data) {
                return ElevatedText(data);
              },
              onError: (_, error) {
                return ElevatedText(error.toString());
              },
              onNone: (_) {
                return const ElevatedText('没有数据点击刷新');
              },
              onWaiting: (_) {
                return const CircularProgressIndicator();
              }),
          const Partition('ExtendedFutureBuilder'),
          ExtendedStreamBuilder<String>(
              initialData: '初始的数据 点击刷新',
              stream: Stream.fromFuture(future(false)),
              onDone: (_, data) {
                return ElevatedText(data);
              },
              onError: (_, error) {
                return ElevatedText(error.toString());
              },
              onNone: (_, data) {
                return const ElevatedText('没有数据点击刷新');
              },
              onWaiting: (_, data) {
                return const CircularProgressIndicator();
              }),
        ]);
  }

  Future<String> future(bool? showError) async {
    await 2.seconds.delayed();
    if (showError == null) {
      showError = true;
      return 'null 点击刷新 错误';
    } else if (showError) {
      showError = false;
      return '错误 点击刷新正常';
    } else {
      showError = null;
      return '正常 点击刷新为 null';
    }
  }
}
