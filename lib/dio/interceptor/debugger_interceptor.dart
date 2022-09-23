import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

class DebuggerInterceptor<T> extends InterceptorsWrapper {
  DebuggerInterceptor({this.isShow = true});

  bool isShow;
  DebuggerInterceptorDataModel data = DebuggerInterceptorDataModel();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    data.requestTime = DateTime.now();
    data.requestOptions = options;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    data.response = response;
    data.responseTime = DateTime.now();
    DebuggerInterceptorHelper().addData(data);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    data.error = err;
    data.responseTime = DateTime.now();
    DebuggerInterceptorHelper().addData(data);
    super.onError(err, handler);
  }
}

class DebuggerInterceptorDataModel {
  DebuggerInterceptorDataModel(
      {this.requestOptions, this.response, this.error});

  RequestOptions? requestOptions;
  Response<dynamic>? response;
  DioError? error;

  DateTime? requestTime;

  DateTime? responseTime;

  Map<String, dynamic> toMap() => {
        'requestOptions': requestOptionsToMap(requestOptions).addAllT({
          'requestTime': requestTime?.format(DateTimeDist.yearMillisecond),
        }),
        'response': responseToMap(response).addAllT({
          'requestOptions': requestOptionsToMap(response?.requestOptions),
          'responseTime': responseTime?.format(DateTimeDist.yearMillisecond),
        }),
        'error': {
          'error': error?.error,
          'type': error?.type,
          'message': error?.message,
          'requestOptions': requestOptionsToMap(error?.requestOptions),
          'response': responseToMap(error?.response),
          'stackTrace': error?.stackTrace.toString(),
          'errorTime': responseTime?.format(DateTimeDist.yearMillisecond),
        }
      };

  Map<String, dynamic> requestOptionsToMap([RequestOptions? requestOptions]) =>
      {
        'baseUrl': (requestOptions ?? this.requestOptions)?.baseUrl,
        'path': (requestOptions ?? this.requestOptions)?.path,
        'uri': (requestOptions ?? this.requestOptions)?.uri.path,
        'method': (requestOptions ?? this.requestOptions)?.method,
        'requestHeaders': (requestOptions ?? this.requestOptions)?.headers,
        'data': (requestOptions ?? this.requestOptions)?.data,
        'queryParameters':
            (requestOptions ?? this.requestOptions)?.queryParameters,
        'contentType': (requestOptions ?? this.requestOptions)?.contentType,
        'receiveTimeout':
            (requestOptions ?? this.requestOptions)?.receiveTimeout,
        'sendTimeout': (requestOptions ?? this.requestOptions)?.sendTimeout,
        'connectTimeout':
            (requestOptions ?? this.requestOptions)?.connectTimeout,
        'extra': (requestOptions ?? this.requestOptions)?.extra,
        'responseType':
            (requestOptions ?? this.requestOptions)?.responseType.toString(),
        'receiveDataWhenStatusError':
            (requestOptions ?? this.requestOptions)?.receiveDataWhenStatusError,
        'followRedirects':
            (requestOptions ?? this.requestOptions)?.followRedirects,
        'maxRedirects': (requestOptions ?? this.requestOptions)?.maxRedirects,
        'hashCode': (requestOptions ?? this.requestOptions)?.hashCode,
      };

  Map<String, dynamic> responseToMap([Response? response]) => {
        'data': (response ?? this.response)?.data,
        'statusCode': (response ?? this.response)?.statusCode,
        'statusMessage': (response ?? this.response)?.statusMessage,
        'extra': (response ?? this.response)?.extra,
        'headers': (response ?? this.response)?.headers,
        'isRedirect': (response ?? this.response)?.isRedirect,
        'realUri': (response ?? this.response)?.realUri.toString(),
        'redirects': (response ?? this.response)?.redirects.builder((item) => {
              'location': item.location,
              'statusCode': item.statusCode,
              'method': item.method,
            })
      };

  Map<String, dynamic> errorToMap([DioError? error]) => {
        'error': (error ?? this.error)?.error,
        'type': (error ?? this.error)?.type,
        'message': (error ?? this.error)?.message,
        'requestOptions':
            requestOptionsToMap((error ?? this.error)?.requestOptions),
        'response': responseToMap((error ?? this.error)?.response),
        'stackTrace': (error ?? this.error)?.stackTrace.toString(),
        'errorTime': responseTime?.format(DateTimeDist.yearMillisecond),
      };
}

class DebuggerInterceptorHelper {
  factory DebuggerInterceptorHelper() =>
      _singleton ??= DebuggerInterceptorHelper._();

  DebuggerInterceptorHelper._();

  static DebuggerInterceptorHelper? _singleton;

  ExtendedOverlayEntry? overlayEntry;

  GlobalKey<DebuggerWindowsState> overlayKey = GlobalKey();

  List<DebuggerInterceptorDataModel> allData = [];

  void addData(DebuggerInterceptorDataModel data) {
    final widget = DebuggerWindows(
        key: overlayKey,
        onClose: () {
          overlayEntry?.remove();
          overlayEntry = null;
        });
    overlayEntry ??= showOverlay(widget, autoOff: true);
    allData.add(data);
    overlayKey.currentState?.refreshData();
  }
}

class DebuggerWindows extends StatefulWidget {
  const DebuggerWindows({super.key, this.onClose});

  final void Function()? onClose;

  @override
  State<DebuggerWindows> createState() => DebuggerWindowsState();
}

class DebuggerWindowsState extends State<DebuggerWindows> {
  bool hasWindows = false;
  ValueNotifier<Offset> iconOffSet =
      ValueNotifier<Offset>(const Offset(10, 10));

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((_) {
      iconOffSet.value = Offset(50, context.mediaQueryPadding.top + 20);
    });
  }

  void refreshData() {
    listState?.call(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ValueListenableBuilder<Offset>(
          valueListenable: iconOffSet,
          builder: (_, Offset value, __) => Universal(
              left: value.dx,
              top: value.dy,
              enabled: true,
              onTap: showListData,
              onDoubleTap: widget.onClose,
              onPanStart: (DragStartDetails details) =>
                  updatePositioned(details.globalPosition),
              onPanUpdate: (DragUpdateDetails details) =>
                  updatePositioned(details.globalPosition),
              decoration: BoxDecoration(
                  color: context.theme.primaryColor, shape: BoxShape.circle),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.bug_report_rounded,
                  size: 25, color: Colors.white)))
    ]);
  }

  Future<void> showListData() async {
    if (hasWindows) {
      pop();
    } else {
      hasWindows = true;
      await showBottomPopup(
          options: GlobalOptions()
              .bottomSheetOptions
              .copyWith(backgroundColor: Colors.transparent, enableDrag: true),
          widget: _HttpDataWindows(onState: (StateSetter setState) {
            listState = setState;
          }));
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

  StateSetter? listState;
}

class _HttpDataWindows extends StatelessWidget {
  const _HttpDataWindows({required this.onState});

  final void Function(StateSetter setState) onState;

  @override
  Widget build(BuildContext context) {
    return Universal(
        width: double.infinity,
        crossAxisAlignment: CrossAxisAlignment.end,
        margin: EdgeInsets.only(top: context.mediaQueryPadding.top + 60),
        decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10))),
        children: [
          const CloseButton().marginOnly(right: 10),
          StatefulBuilder(builder: (_, StateSetter setState) {
            onState(setState);
            final list = DebuggerInterceptorHelper().allData;
            return ScrollList.builder(
                itemCount: list.length,
                itemBuilder: (_, int index) => _HttpDataEntry(list[index]));
          }).expandedNull
        ]);
  }
}

class _HttpDataEntry extends StatelessWidget {
  const _HttpDataEntry(this.model);

  final DebuggerInterceptorDataModel model;

  @override
  Widget build(BuildContext context) {
    return Universal(
        onLongPress: () {
          model.toMap().toString().toClipboard;
          showToast('已复制');
        },
        onTap: () => showDetailData(),
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: context.theme.cardColor,
            boxShadow: getBoxShadow(
                color: context.theme.shadowColor.withOpacity(0.1), radius: 2)),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            BText(model.requestOptions?.method ?? 'unknown',
                fontSize: 16, fontWeight: FontWeight.bold),
            Universal(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                    color: statusCodeColor(model.response?.statusCode ?? 0),
                    borderRadius: BorderRadius.circular(4)),
                child: BText(model.response?.statusCode?.toString() ?? 'N/A',
                    color: Colors.white))
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Universal(
                visible:
                    model.requestOptions?.baseUrl.contains('https') ?? false,
                replacement:
                    const Icon(Icons.lock_open, size: 18, color: Colors.grey),
                child: const Icon(Icons.lock, size: 18, color: Colors.green)),
            BText(model.requestOptions?.baseUrl ?? 'N/A').expandedNull
          ]),
          const SizedBox(height: 10),
          BText(model.requestOptions?.path ?? 'unknown',
                  textAlign: TextAlign.start)
              .setWidth(double.infinity),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            BText(model.requestTime?.format(DateTimeDist.yearMillisecond) ??
                'unknown'),
            BText(
                '${stringToBytes(model.response?.data?.toString() ?? '')} kb'),
            BText(
                '${diffMillisecond(model.requestTime, model.responseTime)} ms'),
          ]),
        ]);
  }

  int stringToBytes(String data) {
    final bytes = utf8.encode(data);
    final size = Uint8List.fromList(bytes);
    return size.lengthInBytes;
  }

  String diffMillisecond(DateTime? requestTime, DateTime? responseTime) {
    if (requestTime != null && responseTime != null) {
      return responseTime.difference(requestTime).inMilliseconds.toString();
    }
    return '';
  }

  void showDetailData() async {
    showBottomPopup(
        options: GlobalOptions()
            .bottomSheetOptions
            .copyWith(backgroundColor: Colors.transparent, enableDrag: true),
        widget: _HttpDetailDataWindows(model));
  }

  Color statusCodeColor(int statusCode) {
    if (statusCode >= 100 && statusCode < 200) {
      return Colors.blue;
    } else if (statusCode >= 200 && statusCode < 300) {
      return Colors.green;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.yellow;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.orange;
    } else if (statusCode >= 500) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}

class _HttpDetailDataWindows extends StatefulWidget {
  const _HttpDetailDataWindows(this.model);

  final DebuggerInterceptorDataModel model;

  @override
  State<_HttpDetailDataWindows> createState() => _HttpDetailDataWindowsState();
}

class _HttpDetailDataWindowsState extends State<_HttpDetailDataWindows>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> tabs = ['request', 'response', 'error'];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Universal(
        width: double.infinity,
        crossAxisAlignment: CrossAxisAlignment.end,
        margin: EdgeInsets.only(top: context.mediaQueryPadding.top + 80),
        decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10))),
        children: [
          const CloseButton().marginOnly(right: 10),
          _HttpDataEntry(widget.model),
          TabBarMerge(
              controller: tabController,
              tabBar: TabBar(
                  labelColor: context.theme.indicatorColor,
                  labelStyle: const BTextStyle(fontWeight: FontWeight.bold),
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
                  tabs: tabs.builder((item) => Tab(child: BText(item)))),
              tabView: tabs.builder((item) {
                Widget entry = const SizedBox();
                if (item == tabs.first) {
                  entry = JsonParse(widget.model.requestOptionsToMap());
                } else if (item == tabs[1]) {
                  entry = JsonParse(widget.model.responseToMap());
                } else if (item == tabs.last) {
                  entry = JsonParse(widget.model.errorToMap());
                }
                return Universal(
                    isScroll: true,
                    safeBottom: true,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: entry);
              })).expandedNull
        ]);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
