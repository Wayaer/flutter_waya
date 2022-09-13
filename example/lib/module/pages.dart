import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ExtendedFutureBuilderPage extends StatelessWidget {
  const ExtendedFutureBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool? showError = true;
    return ExtendedScaffold(
        padding: const EdgeInsets.all(20),
        appBar: AppBarText('ExtendedFutureBuilder '),
        children: <Widget>[
          ExtendedFutureBuilder<String>(
            initialData: '初始的数据 点击刷新',
            future: () async {
              await 2.seconds.delayed();
              if (showError == null) {
                showError = true;
                return 'null 点击刷新 错误';
              } else if (showError!) {
                showError = false;
                return Future.error('错误 点击刷新正常');
              } else {
                showError = null;
                return '正常 点击刷新为 null';
              }
            },
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
            },
          ),
        ]);
  }
}
