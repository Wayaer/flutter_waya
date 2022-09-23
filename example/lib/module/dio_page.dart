import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curiosity/flutter_curiosity.dart';
import 'package:flutter_waya/flutter_waya.dart';

class ExtendedDioPage extends StatefulWidget {
  const ExtendedDioPage({super.key});

  @override
  State<ExtendedDioPage> createState() => _ExtendedDioPageState();
}

class _ExtendedDioPageState extends State<ExtendedDioPage> {
  String? cachePath;
  Map<String, dynamic> res = {};

  StateSetter? progressState;

  @override
  void initState() {
    super.initState();
    Curiosity().native.appPath.then((value) {
      if (isAndroid) {
        cachePath = value?.externalCacheDir;
      } else if (isIOS) {
        cachePath = value?.cachesDirectory;
      } else if (isMacOS) {
        cachePath = value?.cachesDirectory;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        padding: const EdgeInsets.all(20),
        appBar: AppBarText('ExtendedDio'),
        children: [
          Wrap(alignment: WrapAlignment.center, children: [
            ElevatedText('get', onTap: get),
            ElevatedText('post', onTap: post),
            ElevatedText('put', onTap: put),
            ElevatedText('delete', onTap: delete),
            ElevatedText('patch', onTap: patch),
            ElevatedText('download', onTap: download),
            ElevatedText('upload', onTap: upload),
          ]),
          StatefulBuilder(builder: (_, state) {
            progressState = state;
            return count == null && total == null
                ? const SizedBox()
                : BText('total: $total  count: $count')
                    .marginSymmetric(vertical: 10);
          }),
          JsonParse(res)
        ]);
  }

  void get() async {
    final value = await ExtendedDio().get(
        'https://lf3-beecdn.bytetos.com/obj/ies-fe-bee/bee_prod/biz_216/bee_prod_216_bee_publish_6676.json');
  }

  void post() async {}

  void put() async {}

  void delete() async {}

  void patch() async {}

  int? count;
  int? total;

  void download() async {
    res = {};
    setState(() {});
    if (cachePath == null) {
      showToast('缓存地址为null');
      return;
    }
    final data = await ExtendedDio().download(
        'https://dldir1.qq.com/qqfile/qq/PCQQ9.6.1/QQ9.6.1.28732.exe',
        '${cachePath!}QQ.exe', onReceiveProgress: (int count, int total) {
      this.count = count;
      this.total = total;
      progressState?.call(() {});
    });
    res = data.toMap();
    setState(() {});
  }

  void upload() async {}
}
