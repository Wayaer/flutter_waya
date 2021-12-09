import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:waya/main.dart';

class JsonParsePage extends StatelessWidget {
  const JsonParsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('JsonParse Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedText('JsonParse', onTap: () => push(_JsonParsePage())),
          ElevatedText('JsonParse.list',
              onTap: () => push(_JsonParseListPage())),
        ]);
  }
}

class _JsonParsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> json =
        jsonDecode('{"name":"BeJson","url":"http://www.bejson.com",'
                '"page":88,"num":88.88,"isNonProfit":true,"address":'
                '{"street":"科技园路.","city":"江苏苏州","country":"中国"},'
                '"links":[{"name":"Google","url":"http://www.google.com"},'
                '{"name":"Baidu","url":"http://www.baidu.com"},'
                '{"name":"SoSo","url":"http://www.SoSo.com"}]}')
            as Map<dynamic, dynamic>;
    return ExtendedScaffold(
        appBar: AppBarText('JsonParse'),
        mainAxisAlignment: MainAxisAlignment.center,
        body: JsonParse(json));
  }
}

class _JsonParseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> json = jsonDecode(
            '[{"name":"Google","url":"http://www.google.com"},{"name":"Baidu",'
            '"url":"http://www.baidu.com"},{"name":"SoSo","url":"http://www.SoSo.com"}]')
        as List<dynamic>;
    return ExtendedScaffold(
        appBar: AppBarText('JsonParse.list'),
        mainAxisAlignment: MainAxisAlignment.center,
        body: JsonParse.list(json));
  }
}
