import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

class DebuggerInterceptorDataModel {
  DebuggerInterceptorDataModel(
      {this.requestOptions, this.response, this.error});

  RequestOptions? requestOptions;

  Response<dynamic>? response;

  DioException? error;

  DateTime? requestTime;

  DateTime? responseTime;

  DateTime? errorTime;

  Map<String, dynamic> toMap() => {
        'requestOptions': requestOptionsToMap(),
        'response': responseToMap(),
        'error': errorToMap(),
      };

  Map<String, dynamic> requestOptionsToMap() =>
      (requestOptions?.toMap() ?? {}).addAllT(
          {'requestTime': requestTime?.format(DateTimeDist.yearMillisecond)});

  Map<String, dynamic> responseToMap() => (response?.toMap() ?? {}).addAllT({
        'responseTime': responseTime?.format(DateTimeDist.yearMillisecond),
      });

  Map<String, dynamic> errorToMap() => (error?.toMap() ?? {}).addAllT({
        'errorTime': errorTime?.format(DateTimeDist.yearMillisecond),
      });
}

class DebuggerInterceptor extends InterceptorsWrapper {
  DebuggerInterceptor({this.isShow = true});

  bool isShow;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final dataModel = DebuggerInterceptorDataModel();
    dataModel.requestTime = DateTime.now();
    dataModel.requestOptions = options;
    DebuggerInterceptorHelper().debugData.value[options.hashCode] = dataModel;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    DebuggerInterceptorHelper()
        .debugData
        .value[response.requestOptions.hashCode]
        ?.response = response;
    DebuggerInterceptorHelper()
        .debugData
        .value[response.requestOptions.hashCode]
        ?.responseTime = DateTime.now();
    DebuggerInterceptorHelper().showDebugIcon();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DebuggerInterceptorHelper()
        .debugData
        .value[err.requestOptions.hashCode]
        ?.error = err;
    DebuggerInterceptorHelper()
        .debugData
        .value[err.requestOptions.hashCode]
        ?.errorTime = DateTime.now();
    DebuggerInterceptorHelper().showDebugIcon();
    super.onError(err, handler);
  }
}

class DebuggerInterceptorHelper {
  factory DebuggerInterceptorHelper() =>
      _singleton ??= DebuggerInterceptorHelper._();

  DebuggerInterceptorHelper._();

  static DebuggerInterceptorHelper? _singleton;

  ExtendedOverlayEntry? _overlayEntry;

  ValueNotifier<Map<int, DebuggerInterceptorDataModel>> debugData =
      ValueNotifier({});

  void toggleDebugIcon() {
    if (_overlayEntry == null) {
      showDebugIcon();
    } else {
      closeDebugIcon();
    }
  }

  void closeDebugIcon() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void showDebugIcon() {
    final widget = _DebuggerWindows(
        showAllData: showDebugDataList,
        onClose: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        });
    _overlayEntry ??= widget.showOverlay(autoOff: true);
  }

  Future<void> showDebugDataList() => const _HttpDataWindows().popupBottomSheet(
      options: GlobalWayUI()
          .bottomSheetOptions
          .copyWith(backgroundColor: Colors.transparent, enableDrag: true));
}

class _HttpDataWindows extends StatelessWidget {
  const _HttpDataWindows();

  @override
  Widget build(BuildContext context) {
    return Universal(
        width: double.infinity,
        crossAxisAlignment: CrossAxisAlignment.end,
        margin: EdgeInsets.only(top: context.padding.top + 60),
        decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10))),
        children: [
          const CloseButton().marginOnly(right: 10),
          ValueListenableBuilder(
              valueListenable: DebuggerInterceptorHelper().debugData,
              builder: (_, Map<int, DebuggerInterceptorDataModel> map, __) {
                final values = map.valuesList().reversed;
                return ScrollList.builder(
                    itemCount: values.length,
                    itemBuilder: (_, int index) =>
                        _HttpDataEntry(values.elementAt(index), canTap: true));
              }).expanded
        ]);
  }
}

class _DebuggerWindows extends StatefulWidget {
  const _DebuggerWindows({required this.showAllData, this.onClose});

  final void Function()? onClose;
  final Future<void> Function() showAllData;

  @override
  State<_DebuggerWindows> createState() => _DebuggerWindowsState();
}

class _DebuggerWindowsState extends ExtendedState<_DebuggerWindows> {
  bool hasWindows = false;
  ValueNotifier<Offset> iconOffSet =
      ValueNotifier<Offset>(const Offset(10, 10));

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((_) {
      iconOffSet.value = Offset(50, context.padding.top + 20);
    });
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
                  size: 23, color: Colors.white)))
    ]);
  }

  Future<void> showListData() async {
    if (hasWindows) {
      pop();
    } else {
      hasWindows = true;
      await widget.showAllData();
      hasWindows = false;
    }
  }

  void updatePositioned(Offset offset) {
    if (offset.dx > 1 &&
        offset.dx < context.height - 24 &&
        offset.dy > context.statusBarHeight &&
        offset.dy <
            context.deviceHeight - context.bottomNavigationBarHeight - 24) {
      double dy = offset.dy;
      double dx = offset.dx;
      iconOffSet.value = Offset(dx -= 12, dy -= 26);
    }
  }
}

class _HttpDataEntry extends StatelessWidget {
  const _HttpDataEntry(this.model, {this.canTap = false});

  final DebuggerInterceptorDataModel model;

  final bool canTap;

  @override
  Widget build(BuildContext context) {
    final statusCode =
        model.response?.statusCode ?? model.error?.response?.statusCode;
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
                    color: statusCodeColor(statusCode ?? 0),
                    borderRadius: BorderRadius.circular(4)),
                child:
                    BText(statusCode?.toString() ?? 'N/A', color: Colors.white))
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Universal(
                visible:
                    model.requestOptions?.baseUrl.contains('https') ?? false,
                replacement:
                    const Icon(Icons.lock_open, size: 18, color: Colors.grey),
                child: const Icon(Icons.lock, size: 18, color: Colors.green)),
            BText(model.requestOptions?.baseUrl ?? 'N/A').expanded
          ]),
          const SizedBox(height: 10),
          BText(model.requestOptions?.path ?? 'unknown',
                  textAlign: TextAlign.start)
              .setWidth(double.infinity),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            BText(model.requestTime?.format(DateTimeDist.yearMillisecond) ??
                    'unknown')
                .expanded,
            BText(stringToBytes(model.response?.data?.toString() ?? ''),
                    textAlign: TextAlign.center)
                .expanded,
            BText(
              '${diffMillisecond(model.requestTime, model.responseTime)} ms',
              textAlign: TextAlign.end,
            ).expanded,
          ]),
        ]);
  }

  String stringToBytes(String data) {
    final bytes = utf8.encode(data);
    final size = Uint8List.fromList(bytes);
    return size.lengthInBytes.toStorageUnit();
  }

  String diffMillisecond(DateTime? requestTime, DateTime? responseTime) {
    if (requestTime == null || responseTime == null) return '';
    return responseTime.difference(requestTime).inMilliseconds.toString();
  }

  void showDetailData() {
    if (!canTap) return;
    _HttpDetailDataWindows(model).popupBottomSheet(
        options: GlobalWayUI()
            .bottomSheetOptions
            .copyWith(backgroundColor: Colors.transparent, enableDrag: true));
  }

  Color statusCodeColor(int statusCode) {
    if (statusCode >= 100 && statusCode < 200) {
      return Colors.blue;
    } else if (statusCode >= 200 && statusCode < 300) {
      return Colors.green;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.yellow;
    } else if (statusCode >= 400 && statusCode < 500) {
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

class _HttpDetailDataWindowsState extends ExtendedState<_HttpDetailDataWindows>
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
        margin: EdgeInsets.only(top: context.padding.top + 80),
        decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10))),
        children: [
          const CloseButton().marginOnly(right: 10),
          _HttpDataEntry(widget.model),
          TabBarMerge(
              tabBar: TabBar(
                  labelColor: context.theme.indicatorColor,
                  labelStyle: const BTextStyle(fontWeight: FontWeight.bold),
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
                  tabs: tabs.builder((item) => Tab(child: BText(item)))),
              tabBarView: TabBarView(
                  controller: tabController,
                  children: tabs.builder((item) {
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
                  }))).expanded
        ]);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
