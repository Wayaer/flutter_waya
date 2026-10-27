import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() {
  group('FlEvent', () {
    test('on<E> 按泛型过滤事件', () async {
      final FlEvent<dynamic> event = FlEvent<dynamic>();
      final Future<List<String>> received = event.on<String>().take(1).toList();
      event.send(1);
      event.send('hello');
      expect(await received, <String>['hello']);
      event.close();
    });

    test('listen 返回可取消的订阅', () async {
      final FlEvent<int> event = FlEvent<int>();
      final StreamSubscription<int> subscription = event.listen((dynamic data) {});
      expect(subscription, isA<StreamSubscription<int>>());
      await subscription.cancel();
      event.close();
    });

    test('flEventDestroy 后仍可继续发送事件', () {
      flEventDestroy();
      expect(() => flSendEvent('after destroy'), returnsNormally);
    });
  });

  group('FlPageView 索引', () {
    testWidgets('循环模式支持非 0 initial', (WidgetTester tester) async {
      final FlPageViewController controller = FlPageViewController(isLoop: true, initial: 2);
      addTearDown(controller.dispose);
      await tester.pumpWidget(_pageViewApp(controller, itemCount: 5));
      await tester.pumpAndSettle();
      expect(controller.getPage(), 2.0);
      expect(controller.getIndex(controller.realPage + 2), 2);
      expect(controller.getIndex(controller.realPage + 4), 4);
      controller.jump(4);
      await tester.pumpAndSettle();
      expect(controller.getPage(), 4.0);
    });

    testWidgets('非循环模式索引等于 item 索引', (WidgetTester tester) async {
      final FlPageViewController controller = FlPageViewController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_pageViewApp(controller, itemCount: 6));
      await tester.pumpAndSettle();
      expect(controller.getPage(), 0.0);
      expect(controller.getIndex(0), 0);
      expect(controller.getIndex(5), 5);
      controller.jump(3);
      await tester.pumpAndSettle();
      expect(controller.getPage(), 3.0);
    });

    testWidgets('stopAutoPlay 后手动翻页不会恢复自动播放', (WidgetTester tester) async {
      final FlPageViewController controller = FlPageViewController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 200,
                child: FlPageView(
                  controller: controller,
                  itemCount: 10,
                  disposeController: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(milliseconds: 100),
                  autoPlayAnimationDuration: const Duration(milliseconds: 20),
                  builder: (FlPageViewController pageController, int? count) => PageView.builder(
                    controller: pageController,
                    itemCount: count,
                    itemBuilder: (_, int index) => Text('$index'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      controller.stopAutoPlay();
      await tester.pump(const Duration(milliseconds: 300));
      expect(controller.getPage(), closeTo(0, 0.01));
      final Future<void> nextFuture = controller.next(duration: const Duration(milliseconds: 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      await nextFuture;
      await tester.pump();
      expect(controller.getPage(), closeTo(1, 0.01));
      await tester.pump(const Duration(milliseconds: 400));
      expect(controller.getPage(), closeTo(1, 0.01));
    });
  });

  testWidgets('FlPageView 应用退到后台时暂停自动播放', (WidgetTester tester) async {
    final FlPageViewController controller = FlPageViewController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: FlPageView(
                controller: controller,
                itemCount: 10,
                disposeController: false,
                autoPlay: true,
                autoPlayInterval: const Duration(milliseconds: 100),
                autoPlayAnimationDuration: const Duration(milliseconds: 20),
                builder: (FlPageViewController pageController, int? count) => PageView.builder(
                  controller: pageController,
                  itemCount: count,
                  itemBuilder: (_, int index) => Text('$index'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(milliseconds: 500));
    expect(controller.getPage(), closeTo(0, 0.01));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 30));
    expect(controller.getPage(), closeTo(1, 0.01));
    controller.stopAutoPlay();
  });

  testWidgets('FlSwitch 运行时修改 size 会同步渲染尺寸', (WidgetTester tester) async {
    Widget build(Size size) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: FlSwitch(value: false, size: size, onChanged: (_) {}),
        ),
      ),
    );
    await tester.pumpWidget(build(const Size(48, 24)));
    expect(tester.getSize(find.byType(FlSwitch)), const Size(48, 24));
    await tester.pumpWidget(build(const Size(100, 40)));
    expect(tester.getSize(find.byType(FlSwitch)), const Size(100, 40));
  });

  test('FlNumberLimitFormatter 拒绝包含非法字符的输入', () {
    final FlNumberLimitFormatter formatter = FlNumberLimitFormatter(3, 2);
    const TextEditingValue oldValue = TextEditingValue(text: '1');
    expect(formatter.formatEditUpdate(oldValue, const TextEditingValue(text: '12a')), oldValue);
    expect(formatter.formatEditUpdate(oldValue, const TextEditingValue(text: '1e5')), oldValue);
    expect(formatter.formatEditUpdate(oldValue, const TextEditingValue(text: '.5')), oldValue);
    const TextEditingValue validValue = TextEditingValue(text: '12');
    expect(formatter.formatEditUpdate(oldValue, validValue), validValue);
  });

  testWidgets('FlExpansionTiles 非受控模式父级重建不会收起', (WidgetTester tester) async {
    final List<bool> changes = <bool>[];
    Widget build() => MaterialApp(
      home: Scaffold(
        body: FlExpansionTiles(
          isExpanded: false,
          onExpansionChanged: changes.add,
          builder: (_, VoidCallback expand, bool isExpanded, Widget? rotation) =>
              GestureDetector(onTap: expand, child: const Text('header')),
          child: const Text('content'),
        ),
      ),
    );
    await tester.pumpWidget(build());
    await tester.tap(find.text('header'));
    await tester.pumpAndSettle();
    expect(changes, <bool>[true]);
    await tester.pumpWidget(build());
    await tester.pumpAndSettle();
    expect(changes, <bool>[true]);
  });

  testWidgets('FlScreenAdaptation 的 builder 能获取到 Scope', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FlScreenAdaptation(
          designWidth: 375,
          scaleType: FlScreenAdaptationScaleType.width,
          builder: (BuildContext context, bool scaled) {
            final FlScreenAdaptationScope scope = FlScreenAdaptationScope.of(context);
            return Text('$scaled:${scope.scaleRatio}');
          },
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlDecoratorBox 在无界宽度下不会崩溃', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FlDecoratorBox<String>(
              prefixes: <FlDecoratorPendant<String>>[const Text('P').toDecoratorPendant<String>()],
              suffixes: <FlDecoratorPendant<String>>[const Text('S').toDecoratorPendant<String>()],
              child: const SizedBox(width: 40, height: 20),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlMultiPopupMenuButton 选中后会重建', (WidgetTester tester) async {
    final List<FlMultiPopupMenuButtonItem<String, int>> menus = <FlMultiPopupMenuButtonItem<String, int>>[
      FlMultiPopupMenuButtonItem<String, int>(
        key: 'key',
        builder: (
          BuildContext context,
          String key,
          int? value,
          VoidCallback onOpened,
          VoidCallback onCanceled,
          PopupMenuItemSelected<int> onSelected,
        ) => GestureDetector(onTap: () => onSelected(1), child: Text('$value')),
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FlMultiPopupMenuButton<String, int>(menus: menus)),
      ),
    );
    expect(find.text('null'), findsOneWidget);
    await tester.tap(find.text('null'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('FlPINTextField 按字素拆分 emoji', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController(text: '😀');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlPINTextField(
            controller: controller,
            maxLength: 2,
            autoFocus: false,
            textBuilder: (String text) => Text('[$text]'),
          ),
        ),
      ),
    );
    expect(find.text('[😀]'), findsOneWidget);
    expect(find.text('[]'), findsOneWidget);
  });

  testWidgets('FlDottedLineBorder 长度为 0 不会死循环', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(border: FlDottedLineBorder(length: 0, space: 0)),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlLinearProgress 在无界宽度下不会崩溃', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(children: <Widget>[FlLinearProgress(progressColor: Colors.blue)]),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlElasticBuilder 保持瞬变交互语义', (WidgetTester tester) async {
    late Function elasticUp;
    late Function elasticDown;
    late Function elastic;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FlElasticBuilder(
              scale: 0.5,
              builder: (_, Function up, Function elasticCallback, Function down) {
                elasticUp = up;
                elastic = elasticCallback;
                elasticDown = down;
                return const SizedBox(width: 20, height: 20);
              },
            ),
          ),
        ),
      ),
    );
    double currentScale() => tester
        .widget<Transform>(find.descendant(of: find.byType(FlElasticBuilder), matching: find.byType(Transform)))
        .transform
        .storage[0];
    expect(currentScale(), 1.0);
    elasticDown();
    await tester.pump();
    expect(currentScale(), 0.5);
    elasticUp();
    await tester.pump();
    expect(currentScale(), 1.0);
    final Future<void> pending = elastic() as Future<void>;
    await tester.pump();
    expect(currentScale(), 0.5);
    await tester.pump(const Duration(milliseconds: 100));
    await pending;
    await tester.pump();
    expect(currentScale(), 1.0);
  });

  testWidgets('FlDecoratorBox 渲染 pendant 自身 child', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlDecoratorBox<String>(
            prefixes: <FlDecoratorPendant<String>>[const Text('P').toDecoratorPendant<String>()],
            child: const Text('main'),
          ),
        ),
      ),
    );
    expect(find.text('P'), findsOneWidget);
    expect(find.text('main'), findsOneWidget);
  });

  testWidgets('FlCounter 关闭 autoStart 后停止计时', (WidgetTester tester) async {
    Widget build(bool autoStart) => MaterialApp(
      home: Scaffold(
        body: FlCounter.up(
          autoStart: autoStart,
          interval: const Duration(milliseconds: 10),
          step: const Duration(milliseconds: 1),
          builder: (Duration duration, bool isRunning, VoidCallback start, VoidCallback stop) => Text('$isRunning'),
        ),
      ),
    );
    await tester.pumpWidget(build(true));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('true'), findsOneWidget);
    await tester.pumpWidget(build(false));
    await tester.pump();
    expect(find.text('false'), findsOneWidget);
  });

  test('FlEventBus emit 期间移除其他订阅者不会重复回调', () {
    final FlEventBus bus = FlEventBus();
    final List<String> calls = <String>[];
    late final void Function(dynamic) a;
    late final void Function(dynamic) b;
    a = (dynamic _) => calls.add('a');
    b = (dynamic _) {
      calls.add('b');
      bus.remove('emitTest', a);
    };
    bus.add('emitTest', a);
    bus.add('emitTest', b);
    bus.emit('emitTest');
    expect(calls.length, 2);
    expect(calls.toSet(), <String>{'a', 'b'});
    bus.remove('emitTest');
  });

  testWidgets('FlPINTextField 超长输入也会触发 onDone', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    int doneCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlPINTextField(
            controller: controller,
            maxLength: 4,
            autoFocus: false,
            onDone: (String text) => doneCount++,
          ),
        ),
      ),
    );
    controller.text = '12345';
    await tester.pump();
    expect(doneCount, 1);
  });

  testWidgets('FlFlipCard hint 在销毁后安全结束', (WidgetTester tester) async {
    FlFlipCardController? controller;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlFlipCardStateful(
            front: (_, FlFlipCardController flipController) {
              controller = flipController;
              return const Text('front');
            },
            back: (_, FlFlipCardController flipController) => const Text('back'),
          ),
        ),
      ),
    );
    final Future<bool> pending = controller!.hint(duration: const Duration(milliseconds: 100));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();
    expect(await pending, isFalse);
  });

  testWidgets('FlRatingStars 在 RTL 下从右向左计分', (WidgetTester tester) async {
    double? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Center(
              child: FlRatingStars(
                starCount: 5,
                starSize: const Size(20, 20),
                starSpacing: 4,
                onChanged: (double realStars, double selectedStars) => selected = selectedStars,
                builder: (bool isSelected) =>
                    Icon(Icons.star, size: 20, color: isSelected ? Colors.amber : Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
    final Rect rect = tester.getRect(find.byType(FlRatingStars));
    await tester.tapAt(Offset(rect.right - 2, rect.center.dy));
    await tester.pump();
    expect(selected, isNotNull);
    expect(selected!, lessThan(1));
    final ClipRect clip = tester.widget<ClipRect>(
      find.descendant(of: find.byType(FlRatingStars), matching: find.byType(ClipRect)),
    );
    final Rect clipRect = clip.clipper!.getClip(tester.getSize(find.byType(FlRatingStars)));
    expect(clipRect.left, greaterThan(0));
  });

  testWidgets('FlLinearProgress 的 curve 会作用于显示进度', (WidgetTester tester) async {
    double? captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 100,
            height: 10,
            child: FlLinearProgress(
              progressColor: Colors.blue,
              percent: 1,
              animation: true,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              builder: (BuildContext context, double percent) {
                captured = percent;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(captured, isNotNull);
    expect(captured!, lessThan(0.4));
  });

  testWidgets('FlSwitch 拖拽过半后按逻辑位置打开', (WidgetTester tester) async {
    bool? changed;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FlSwitch(
              value: false,
              dragStartBehavior: DragStartBehavior.down,
              onChanged: (bool value) => changed = value,
            ),
          ),
        ),
      ),
    );
    await tester.drag(find.byType(FlSwitch), const Offset(12, 0), touchSlopX: 0);
    await tester.pumpAndSettle();
    expect(changed, isTrue);
  });

  testWidgets('FlShimmery 支持自定义颜色数量', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlShimmery(
            colors: const <Color>[Colors.transparent, Colors.white, Colors.transparent],
            child: const SizedBox(width: 100, height: 40),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlCounter 手动停止不会触发 onEnds', (WidgetTester tester) async {
    int ends = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlCounter.up(
            value: Duration.zero,
            interval: const Duration(milliseconds: 10),
            step: const Duration(milliseconds: 1),
            onEnds: (Duration duration) => ends++,
            builder: (Duration duration, bool isRunning, VoidCallback start, VoidCallback stop) =>
                ElevatedButton(onPressed: stop, child: const Text('stop')),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('stop'));
    await tester.pump();
    expect(ends, 0);
  });

  testWidgets('FlIndicator count 为 0 时不崩溃', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: FlIndicator(count: 0, index: 0, position: 0))),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  test('flEventListen 返回可取消的订阅', () async {
    final StreamSubscription<dynamic> subscription = flEventListen((dynamic data) {});
    await subscription.cancel();
  });

  testWidgets('FlScreenAdaptation 使用 MediaQuery 宽度计算缩放', (WidgetTester tester) async {
    late double ratio;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(750, 1000)),
          child: FlScreenAdaptation(
            designWidth: 375,
            scaleType: FlScreenAdaptationScaleType.width,
            builder: (BuildContext context, bool scaled) {
              ratio = FlScreenAdaptationScope.of(context).scaleRatio;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(ratio, 2.0);
  });

  testWidgets('FlSwitch 慢速拖拽松手后按位置切换', (WidgetTester tester) async {
    bool? changed;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: FlSwitch(value: false, onChanged: (bool value) => changed = value)),
        ),
      ),
    );
    final TestGesture gesture = await tester.startGesture(tester.getCenter(find.byType(FlSwitch)));
    await gesture.moveBy(const Offset(18, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(12, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(12, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(changed, isTrue);
  });

  testWidgets('FlShimmery 运行时修改 duration 不会重建 ticker', (WidgetTester tester) async {
    Widget build(Duration duration) => MaterialApp(
      home: Scaffold(
        body: FlShimmery(duration: duration, child: const SizedBox(width: 100, height: 40)),
      ),
    );
    await tester.pumpWidget(build(const Duration(seconds: 1)));
    await tester.pumpWidget(build(const Duration(seconds: 2)));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  test('FlShimmerDirection.fromRBLT 从右下角开始', () {
    const FlShimmerDirection direction = FlShimmerDirection.fromRBLT();
    expect(direction.begin, Alignment.bottomRight);
    expect(direction.end, Alignment.centerLeft);
  });

  testWidgets('FlFlipCardStateful 动画中重复点击不会重复触发 onFlipStart', (WidgetTester tester) async {
    int starts = 0;
    int ends = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlFlipCardStateful(
            duration: const Duration(milliseconds: 200),
            onFlipStart: (FlFlipCardState state) => starts++,
            onFlipEnd: (FlFlipCardState state) => ends++,
            front: (_, FlFlipCardController controller) => const Text('front'),
            back: (_, FlFlipCardController controller) => const Text('back'),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(FlFlipCardStateful));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byType(FlFlipCardStateful));
    await tester.pumpAndSettle();
    expect(starts, 1);
    expect(ends, 1);
  });

  testWidgets('FlLinearProgress 切换 animation 不会重建 ticker', (WidgetTester tester) async {
    Widget build(bool animation) => MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 100,
          height: 10,
          child: FlLinearProgress(progressColor: Colors.blue, animation: animation),
        ),
      ),
    );
    await tester.pumpWidget(build(true));
    await tester.pumpWidget(build(false));
    await tester.pumpWidget(build(true));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlPageViewTransform 在没有 PageStorage 的页面中可用', (WidgetTester tester) async {
    final PageController controller = PageController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: PageView.builder(
          controller: controller,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) =>
              FlPageViewTransform(controller: controller, index: index, child: Text('$index')),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlCounter 手动停止后 isRunning 立即变为 false', (WidgetTester tester) async {
    late VoidCallback stop;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlCounter.up(
            interval: const Duration(milliseconds: 10),
            step: const Duration(milliseconds: 1),
            builder: (Duration duration, bool isRunning, VoidCallback start, VoidCallback stopTiming) {
              stop = stopTiming;
              return Text('$isRunning');
            },
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('true'), findsOneWidget);
    stop();
    await tester.pump();
    expect(find.text('false'), findsOneWidget);
  });

  test('FlEventBus 按订阅顺序回调', () {
    final FlEventBus bus = FlEventBus();
    final List<String> calls = <String>[];
    bus.add('orderTest', (dynamic data) => calls.add('a'));
    bus.add('orderTest', (dynamic data) => calls.add('b'));
    bus.add('orderTest', (dynamic data) => calls.add('c'));
    bus.emit('orderTest');
    expect(calls, <String>['a', 'b', 'c']);
    bus.remove('orderTest');
  });

  testWidgets('FlDecoratorBox 的 builder 挂件同样受 needFocus 控制', (WidgetTester tester) async {
    bool focused = false;
    Widget build() => MaterialApp(
      home: Scaffold(
        body: FlDecoratorBox<String>(
          onFocus: () => focused,
          suffixes: <FlDecoratorPendant<String>>[
            FlDecoratorPendant<String>.builder(
              needFocus: true,
              builder: (FlDecoratorBoxStatus<String> status) => const Text('suffix'),
            ),
          ],
          child: const Text('main'),
        ),
      ),
    );
    await tester.pumpWidget(build());
    expect(find.text('suffix'), findsNothing);
    focused = true;
    await tester.pumpWidget(build());
    expect(find.text('suffix'), findsOneWidget);
  });

  testWidgets('FlDecoratorBox 隐藏挂件不会留下额外间距', (WidgetTester tester) async {
    const Key childKey = Key('decorator_child');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              child: FlDecoratorBox<String>(
                onFocus: () => false,
                spacing: const FlDecoratorBoxSpacing(outerRowSpacing: 20),
                prefixes: <FlDecoratorPendant<String>>[
                  const Text('hidden').toDecoratorPendant<String>(needFocus: true),
                ],
                child: const SizedBox(key: childKey, width: double.infinity, height: 20),
              ),
            ),
          ),
        ),
      ),
    );
    final double boxLeft = tester.getTopLeft(find.byType(FlDecoratorBox<String>)).dx;
    expect(tester.getTopLeft(find.byKey(childKey)).dx, boxLeft);
  });

  testWidgets('FlDecoratorBox 多个挂件之间使用配置间距', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlDecoratorBox<String>(
            spacing: const FlDecoratorBoxSpacing(outerRowSpacing: 12, outerColumnSpacing: 10),
            prefixes: <FlDecoratorPendant<String>>[
              const Text('A').toDecoratorPendant<String>(),
              const Text('B').toDecoratorPendant<String>(),
            ],
            headers: <FlDecoratorPendant<String>>[
              const Text('H1').toDecoratorPendant<String>(),
              const Text('H2').toDecoratorPendant<String>(),
            ],
            child: const Text('C'),
          ),
        ),
      ),
    );
    expect(tester.getTopLeft(find.text('B')).dx - tester.getTopRight(find.text('A')).dx, 12);
    expect(tester.getTopLeft(find.text('H2')).dy - tester.getBottomLeft(find.text('H1')).dy, 10);
  });

  test('FlWrapperPainter 尖角与主体无缝衔接并支持圆角', () {
    final ui.Canvas canvas = ui.Canvas(ui.PictureRecorder());
    final FlWrapperPainter painter = FlWrapperPainter(spineHeight: 10, angle: 90, offset: 20, spineRadius: 0);
    final FlWrapperPainter endPainter = FlWrapperPainter(
      spineHeight: 10,
      angle: 90,
      offset: 20,
      spineRadius: 0,
      formBottom: true,
    );
    const Size size = Size(100, 50);
    expect(
      painter.buildDefaultSpinePath(canvas, 10, FlSpineStyle.top, size).getBounds(),
      rectMoreOrLessEquals(const Rect.fromLTRB(20, 0, 40, 10)),
    );
    expect(
      painter.buildDefaultSpinePath(canvas, 10, FlSpineStyle.bottom, size).getBounds(),
      rectMoreOrLessEquals(const Rect.fromLTRB(20, 40, 40, 50)),
    );
    expect(
      painter.buildDefaultSpinePath(canvas, 10, FlSpineStyle.left, size).getBounds(),
      rectMoreOrLessEquals(const Rect.fromLTRB(0, 20, 10, 40)),
    );
    expect(
      painter.buildDefaultSpinePath(canvas, 10, FlSpineStyle.right, size).getBounds(),
      rectMoreOrLessEquals(const Rect.fromLTRB(90, 20, 100, 40)),
    );
    expect(
      endPainter.buildDefaultSpinePath(canvas, 10, FlSpineStyle.top, size).getBounds(),
      rectMoreOrLessEquals(const Rect.fromLTRB(60, 0, 80, 10)),
    );
    expect(
      painter.buildBoxBySpineStyle(canvas, FlSpineStyle.top, 100, 50).getBounds(),
      rectMoreOrLessEquals(const Rect.fromLTRB(0, 10, 100, 50)),
    );
    expect(
      painter.buildBoxBySpineStyle(canvas, FlSpineStyle.left, 100, 50).getBounds(),
      rectMoreOrLessEquals(const Rect.fromLTRB(10, 0, 100, 50)),
    );
    expect(painter.buildDefaultSpinePath(canvas, 0, FlSpineStyle.top, size).getBounds(), Rect.zero);

    final FlWrapperPainter rounded = FlWrapperPainter(spineHeight: 10, angle: 90, offset: 20, spineRadius: 4);
    final Rect roundedTop = rounded.buildDefaultSpinePath(canvas, 10, FlSpineStyle.top, size).getBounds();
    // 连接处圆角让底边向两侧扩展，同时底边仍贴合主体边缘
    expect(roundedTop.left, closeTo(16, 0.001));
    expect(roundedTop.right, closeTo(44, 0.001));
    expect(roundedTop.bottom, 10);
  });

  test('FlDottedLineBorder 非统一边框可正常绘制', () {
    final ui.Canvas canvas = ui.Canvas(ui.PictureRecorder());
    const FlDottedLineBorder border = FlDottedLineBorder(
      top: BorderSide(color: Colors.red, width: 2),
      bottom: BorderSide(color: Colors.blue),
      length: 4,
      space: 2,
    );
    expect(() => border.paint(canvas, const Rect.fromLTWH(0, 0, 100, 50)), returnsNormally);
  });

  test('FlDottedLinePainter 支持自定义线段长度与圆角', () {
    final ui.Canvas canvas = ui.Canvas(ui.PictureRecorder());
    final FlDottedLinePainter painter = FlDottedLinePainter(
      gap: 10,
      length: 5,
      radius: 8,
      strokeCap: ui.StrokeCap.round,
    );
    expect(() => painter.paint(canvas, const Size(100, 50)), returnsNormally);
    final Path path = painter.getDashedPath(
      a: const math.Point<double>(0, 0),
      b: const math.Point<double>(100, 0),
      gap: 10,
      length: 5,
    );
    final List<ui.PathMetric> metrics = path.computeMetrics().toList();
    expect(metrics.length, 7);
    for (final ui.PathMetric metric in metrics) {
      expect(metric.length, closeTo(5, 0.001));
    }
    final FlDottedLinePainter same = FlDottedLinePainter(
      gap: 10,
      length: 5,
      radius: 8,
      strokeCap: ui.StrokeCap.round,
    );
    expect(painter.shouldRepaint(same), isFalse);
    expect(
      painter.shouldRepaint(FlDottedLinePainter(gap: 10, length: 5, radius: 12, strokeCap: ui.StrokeCap.round)),
      isTrue,
    );
  });

  testWidgets('FlDottedLineBorder 支持圆角', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: FlDottedLineBorder.all(color: Colors.black, length: 6, space: 4),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlIndicator 各样式都能正常绘制', (WidgetTester tester) async {
    for (final FlIndicatorStyle style in FlIndicatorStyle.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: FlIndicator(count: 3, index: 2, position: 2.5, style: style)),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('FlIndicator 选中圆点更大时画布同步放大', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: FlIndicator(count: 3, index: 0, position: 0, size: 10, activeSize: 14, space: 6),
          ),
        ),
      ),
    );
    // 宽 = 3 * 10 + 2 * 6 + (14 - 10)，高取选中圆点直径
    expect(tester.getSize(find.byType(FlIndicator)), const Size(46, 14));
    expect(tester.takeException(), isNull);
  });

  test('FlIndicatorPainter 选中尺寸变化时触发重绘', () {
    const FlIndicator indicator = FlIndicator(count: 3, index: 0, position: 0, size: 10);
    const FlIndicator resized = FlIndicator(count: 3, index: 0, position: 0, size: 10, activeSize: 14);
    final FlIndicatorPainter painter = indicator.createPainter(Colors.red, Colors.grey);
    final FlIndicatorPainter resizedPainter = resized.createPainter(Colors.red, Colors.grey);
    expect(resizedPainter.shouldRepaint(painter), isTrue);
  });

  testWidgets('FlPageView animate 到真实索引', (WidgetTester tester) async {
    final FlPageViewController controller = FlPageViewController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_pageViewApp(controller, itemCount: 6));
    await tester.pumpAndSettle();
    final Future<void> animation = controller.animate(3, duration: const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    await animation;
    expect(controller.getPage(), closeTo(3, 0.01));
  });

  testWidgets('FlExpansionTiles 背景色或头部为 ListTile 时不报错', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlExpansionTiles(
            isExpanded: true,
            backgroundColor: Colors.amber,
            builder: (BuildContext context, VoidCallback expand, bool isExpanded, Widget? rotation) =>
                ListTile(onTap: expand, title: const Text('header'), trailing: rotation),
            child: const Text('content'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlPINTextField 在 Row 中不会因无界宽度报错', (WidgetTester tester) async {
    final TextEditingController first = TextEditingController();
    final TextEditingController second = TextEditingController();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: <Widget>[
              FlPINTextField(controller: first),
              FlPINTextField(controller: second),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(FlPINTextField).first).width, 160);
  });

  testWidgets('FlAnimationCounter part 样式动画结束后合并为单个文本', (WidgetTester tester) async {
    int value = 100;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => GestureDetector(
              onTap: () => setState(() => value = 120),
              child: FlAnimationCounter.up(
                style: FlCounterStyle.part,
                value: '$value',
                builder: (String text) => Text(text),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Text), findsOneWidget);
    await tester.tap(find.text('100'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(find.text('120'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });
}

Widget _pageViewApp(FlPageViewController controller, {required int itemCount}) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: 300,
        height: 200,
        child: FlPageView(
          controller: controller,
          itemCount: itemCount,
          disposeController: false,
          builder: (FlPageViewController pageController, int? count) => PageView.builder(
            controller: pageController,
            itemCount: count,
            itemBuilder: (_, int index) => Text('$index'),
          ),
        ),
      ),
    ),
  ),
);
