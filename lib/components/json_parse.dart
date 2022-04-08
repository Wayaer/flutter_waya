import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class JsonParse extends StatefulWidget {
  JsonParse(this.json, {Key? key})
      : list = <dynamic>[],
        isList = false,
        super(key: key);

  JsonParse.list(this.list, {Key? key})
      : json = list.asMap(),
        isList = true,
        super(key: key);

  final Map<dynamic, dynamic> json;
  final List<dynamic> list;
  final bool isList;

  @override
  _JsonParseState createState() => _JsonParseState();
}

class _JsonParseState extends State<JsonParse> {
  Map<String, bool> mapFlag = <String, bool>{};

  @override
  Widget build(BuildContext context) => Universal(
      isScroll: true,
      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children);

  List<Widget> get children {
    final List<Widget> list = <Widget>[];
    widget.json.builderEntry((MapEntry<dynamic, dynamic> entry) {
      final dynamic key = entry.key;
      final dynamic content = entry.value;
      final List<Widget> row = <Widget>[];
      if (isTap(content)) {
        row.add(ToggleRotate(
            rad: pi / 2,
            clockwise: true,
            isRotate: (mapFlag[key.toString()]) ?? false,
            child: const Icon(Icons.arrow_right_rounded, size: 18)));
      } else {
        row.add(const SizedBox(width: 14));
      }
      row.addAll(<Widget>[
        BText(widget.isList || isTap(content) ? '[$key]:' : ' $key :',
                fontWeight: FontWeight.w400,
                color: content == null ? Colors.grey : Colors.purple)
            .onDoubleTap(() {
          key.toString().toClipboard;
          showToast('已经复制$key');
        }),
        const SizedBox(width: 4),
        getValueWidget(content)
      ]);
      list.add(Universal(
          direction: Axis.horizontal,
          children: row,
          addInkWell: true,
          crossAxisAlignment: CrossAxisAlignment.start,
          onTap: !isTap(content)
              ? null
              : () {
                  mapFlag[key.toString()] = !(mapFlag[key.toString()] ?? false);
                  setState(() {});
                }));
      list.add(const SizedBox(height: 4));
      if ((mapFlag[key.toString()]) ?? false) {
        list.add(getContentWidget(content));
      }
    });
    return list;
  }

  Widget getContentWidget(dynamic content) => content is List
      ? JsonParse.list(content)
      : JsonParse(content as Map<String, dynamic>);

  Widget getValueWidget(dynamic content) {
    String text = '';
    Color color = Colors.transparent;
    if (content == null) {
      text = 'null';
      color = Colors.grey;
    } else if (content is int) {
      text = content.toString();
      color = Colors.teal;
    } else if (content is String) {
      text = '"$content"';
      color = Colors.redAccent;
    } else if (content is bool) {
      text = content.toString();
      color = color;
    } else if (content is double) {
      text = content.toString();
      color = Colors.teal;
    } else if (content is List) {
      text = content.isEmpty
          ? 'Array[0]'
          : 'Array<${content.runtimeType.toString()}>[${content.length}]';
      color = Colors.grey;
    } else {
      text = 'Object';
      color = Colors.grey;
    }
    return Universal(
        expanded: true,
        onTap: () {
          text.toClipboard;
          showToast('已复制');
        },
        onLongPress: () {
          text.toClipboard;
          showToast('已复制');
        },
        child: BText(text,
            color: color,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left));
  }

  bool isTap(dynamic content) => !(content == null ||
      content is int ||
      content is String ||
      content is bool ||
      content is double ||
      (content is List && content.isEmpty));
}

void setHttpData(ResponseModel res) {
  if (_httpDataOverlay == null) {
    _httpDataOverlay = showOverlay(_HttpDataPage(res), autoOff: true)!;
  } else {
    EventBus().emit('httpData', res);
  }
}

ExtendedOverlayEntry? _httpDataOverlay;

class _HttpDataPage extends StatefulWidget {
  const _HttpDataPage(this.res, {Key? key}) : super(key: key);
  final ResponseModel res;

  @override
  _HttpDataPageState createState() => _HttpDataPageState();
}

class _HttpDataPageState extends State<_HttpDataPage> {
  final List<ResponseModel> httpDataList = <ResponseModel>[];
  final String eventName = 'httpData';
  bool hasWindows = false;
  ValueNotifier<Offset> iconOffSet =
      ValueNotifier<Offset>(Offset(50, getStatusBarHeight + 20));

  @override
  void initState() {
    super.initState();
    httpDataList.add(widget.res);
    EventBus().add(eventName, (dynamic data) {
      if (data is ResponseModel) {
        httpDataList.insert(0, data);
        if (httpDataList.length > 30) httpDataList.removeLast();
      }
    });
  }

  @override
  void dispose() {
    EventBus().remove(eventName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ValueListenableBuilder<Offset>(
          valueListenable: iconOffSet,
          builder: (_, Offset value, __) => Positioned(
              left: value.dx,
              top: value.dy,
              child: Universal(
                  enabled: true,
                  onTap: showData,
                  onDoubleTap: () {
                    _httpDataOverlay?.remove();
                    _httpDataOverlay = null;
                  },
                  onPanStart: (DragStartDetails details) =>
                      updatePositioned(details.globalPosition),
                  onPanUpdate: (DragUpdateDetails details) =>
                      updatePositioned(details.globalPosition),
                  decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      shape: BoxShape.circle),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.bug_report_rounded,
                      size: 18, color: Colors.white))))
    ]);
  }

  Future<void> showData() async {
    if (hasWindows) {
      pop();
    } else {
      hasWindows = true;
      await showBottomPopup(
          options: GlobalOptions()
              .bottomSheetOptions
              .copyWith(backgroundColor: Colors.transparent),
          widget: httpDataWidget);
      hasWindows = false;
    }
  }

  void updatePositioned(Offset offset) {
    if (offset.dx > 1 &&
        offset.dx < deviceWidth - 24 &&
        offset.dy > getStatusBarHeight &&
        offset.dy < deviceHeight - getBottomNavigationBarHeight - 24) {
      double dy = offset.dy;
      double dx = offset.dx;
      iconOffSet.value = Offset(dx -= 12, dy -= 26);
    }
  }

  Widget get httpDataWidget => Universal(
      width: double.infinity,
      margin: EdgeInsets.only(top: context.mediaQueryPadding.top + 100),
      decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
      child: ScrollList.builder(
          itemCount: httpDataList.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (_, int index) {
            final ResponseModel res = httpDataList[index];
            return Universal(
                onLongPress: () {
                  res.toMap().toString().toClipboard;
                  showToast('已复制');
                },
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: context.theme.cardColor,
                    boxShadow: getBoxShadow(
                        color: context.theme.shadowColor.withOpacity(0.1),
                        radius: 2)),
                child: ValueBuilder<bool>(
                    initialValue: false,
                    builder: (_, bool? show, updater) {
                      show ??= false;
                      return !show
                          ? title(res.requestOptions.uri.path, onTap: () {
                              updater(true);
                            })
                          : Column(children: <Widget>[
                              title(res.requestOptions.uri.path, onTap: () {
                                updater(false);
                              }),
                              JsonParse(<String, dynamic>{
                                'requestOptions': res.requestOptionsToMap(),
                                'response': res.data is Map
                                    ? res.data
                                    : <String, dynamic>{
                                        'data': res.data.toString()
                                      },
                              }),
                            ]);
                    }));
          }));

  Widget title(String url, {GestureTapCallback? onTap}) => SimpleButton(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      text: url,
      maxLines: 2,
      child: BText(url, textAlign: TextAlign.start, fontSize: 13),
      onTap: onTap);
}
