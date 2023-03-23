import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class JsonParse extends StatefulWidget {
  JsonParse(this.json, {super.key})
      : list = <dynamic>[],
        isList = false;

  JsonParse.list(this.list, {super.key})
      : json = list.asMap(),
        isList = true;

  final Map<dynamic, dynamic> json;
  final List<dynamic> list;
  final bool isList;

  @override
  State<JsonParse> createState() => _JsonParseState();
}

class _JsonParseState extends ExtendedState<JsonParse> {
  Map<String, bool> mapFlag = <String, bool>{};

  @override
  Widget build(BuildContext context) => Universal(
      isScroll: true,
      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children);

  List<Widget> get children {
    final List<Widget> list = [];
    widget.json.builderEntry((MapEntry<dynamic, dynamic> entry) {
      final dynamic key = entry.key;
      final dynamic content = entry.value;
      final List<Widget> row = [];
      if (isTap(content)) {
        row.add(ToggleRotate(
            rad: pi / 2,
            clockwise: true,
            isRotate: (mapFlag[key.toString()]) ?? false,
            child: const Icon(Icons.arrow_right_rounded, size: 18)));
      } else {
        row.add(const SizedBox(width: 14));
      }
      row.addAll([
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
          addInkWell: true,
          crossAxisAlignment: CrossAxisAlignment.start,
          onTap: !isTap(content)
              ? null
              : () {
                  mapFlag[key.toString()] = !(mapFlag[key.toString()] ?? false);
                  setState(() {});
                },
          children: row));
      list.add(const SizedBox(height: 4));
      if ((mapFlag[key.toString()]) ?? false) {
        list.add(getContentWidget(content));
      }
    });
    return list;
  }

  Widget getContentWidget(dynamic content) => content is List
      ? JsonParse.list(content)
      : content is Map<String, dynamic>
          ? JsonParse(content)
          : JsonParse({content.runtimeType: content.toString()});

  Widget getValueWidget(dynamic content) {
    String text = '';
    Color color = Colors.transparent;
    if (content == null) {
      text = 'null';
      color = Colors.grey;
    } else if (content is num) {
      text = content.toString();
      color = Colors.teal;
    } else if (content is String) {
      text = '"$content"';
      color = Colors.redAccent;
    } else if (content is bool) {
      text = content.toString();
      color = Colors.blue;
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
