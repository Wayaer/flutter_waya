# flutter_waya

[Web example](https://wayaer.github.io/flutter_waya/example/app/web/index.html#/)

`flutter_waya` 是一个面向 Flutter 的轻量 UI 组件库，提供动画、进度、分页、输入、展示布局、计时器等常用组件，并为公开 API 提供中文注释。

- 当前版本：`12.0.0`
- 环境要求：Flutter `>= 3.47.0`，Dart `>= 3.13.0`
- 仓库地址：<https://github.com/Wayaer/flutter_waya>

## 特性

- 组件按职责归类，目录清晰：`core` / `animation` / `feedback` / `paging` / `input` / `display` / `timing`。
- 覆盖动画、进度、分页、文本输入、评分、开关、计时器等常见场景。
- 所有公开类、参数与主要方法均带简洁中文注释。
- 所有公开组件类型统一使用 `Fl` 前缀，避免与业务代码命名冲突。
- 自带 52 项回归测试，覆盖关键边界与生命周期行为。
- 示例工程支持 Web 与 iOS。

## 安装

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_waya: ^12.0.0
```

本地开发也可以使用路径依赖：

```yaml
dependencies:
  flutter_waya:
    path: ../flutter_waya
```

## 快速开始

```dart
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_waya')),
        body: Center(
          child: FlLinearProgress(
            width: 160,
            height: 8,
            percent: 0.65,
            progressColor: Colors.blue
          )
        )
      )
    );
  }
}
```

## 组件分类

| 分类 | 目录 | 组件 |
|---|---|---|
| 基础能力 | `core` | `FlEvent` / `FlEventFactory` / `FlEventBus`、`flSendEvent` / `flEventListen` / `flEventDestroy`、`FlAutomaticKeepAliveClientWrapper` / `FlAutomaticKeepAliveClientMixinState`、`FlScreenAdaptation` / `FlScreenAdaptationScope`、`FlSystemUiOverlayStyleLight/Dark` |
| 动画与交互 | `animation` | `FlAnimationCounter`、`FlAutoCollapsingBuilder`、`FlBubbleButton`、`FlElasticBuilder`、`FlExpansionTiles`、`FlFlipCard` / `FlFlipCardStateful`、`FlMultiPopupMenuButton`、`FlPopupMenuButtonRotateBuilder`、`FlToggleRotate`、`FlAnimationWave` |
| 反馈与加载 | `feedback` | `FlLinearProgress`、`FlShimmery` |
| 分页与指示器 | `paging` | `FlPageView`、`FlPageViewController`、`FlIndicator`、`FlPageViewTransform` |
| 输入与选择 | `input` | `FlInputDecorationExtension`、`FlBorderType`、`FlTextInputLimitFormatter`、`FlNumberLimitFormatter`、`FlDecoratorBox`、`FlPINTextField`、`FlRatingStars`、`FlSwitch` |
| 展示与布局 | `display` | `FlWrapper`、`FlDottedLinePainter` / `FlDottedLineBorder` |
| 计时与验证码 | `timing` | `FlCounter`、`FlSendVerificationCode` |

## 常用组件示例

### 进度与加载

```dart
FlLinearProgress(
  progressColor: Colors.blue,
  percent: 0.7,
  animation: true,
  curve: Curves.easeOut
);

FlShimmery(
  child: Container(
    width: 160,
    height: 16,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(4)
    )
  )
);
```

### 分页与指示器

```dart
final FlPageViewController controller = FlPageViewController(isLoop: true);

FlPageView(
  controller: controller,
  itemCount: 5,
  height: 180,
  autoPlay: true,
  autoPlayInterval: const Duration(seconds: 3),
  builder: (FlPageViewController pageController, int? itemCount) => PageView.builder(
    controller: pageController,
    itemCount: itemCount,
    itemBuilder: (BuildContext context, int index) => Center(child: Text('第 $index 页'))
  )
);

FlIndicator(
  count: 5,
  index: 0,
  position: 0,
  style: FlIndicatorStyle.slide
);
```

### 输入与选择

```dart
FlSwitch(
  value: true,
  onChanged: (bool value) {}
);

FlRatingStars(
  value: 3,
  step: 0.5,
  starCount: 5,
  builder: (bool selected) => Icon(
    Icons.star,
    color: selected ? Colors.amber : Colors.grey
  ),
  onChanged: (double realStars, double selectedStars) {}
);

final TextEditingController pinController = TextEditingController();

FlPINTextField(
  controller: pinController,
  maxLength: 4
);
```

### 动画与交互

```dart
FlAnimationCounter.down(
  value: '128',
  builder: (String value) => Text(value)
);

FlElasticBuilder(
  builder: (BuildContext context, Function up, Function elastic, Function down) => GestureDetector(
    onTapDown: (_) => elastic(),
    child: const Text('弹性按钮')
  )
);

FlExpansionTiles(
  builder: (BuildContext context, VoidCallback expand, bool isExpanded, Widget? rotation) =>
      InkWell(onTap: expand, child: const Text('展开')),
  child: const Text('内容')
);

FlFlipCardStateful(
  front: (BuildContext context, FlFlipCardController controller) => const Text('Front'),
  back: (BuildContext context, FlFlipCardController controller) => const Text('Back')
);
```

### 展示与布局

```dart
FlWrapper(
  style: FlSpineStyle.left,
  spineRadius: 3,
  color: Colors.blue,
  child: const Text('带尖角的容器')
);

Container(
  width: 120,
  height: 48,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: FlDottedLineBorder.all(color: Colors.grey, length: 6, space: 4)
  )
);
```

### 计时器与事件

```dart
FlCounter.down(
  value: const Duration(seconds: 60),
  builder: (Duration duration, bool isRunning, VoidCallback start, VoidCallback stop) =>
      Text('${duration.inSeconds}s')
);

FlSendVerificationCode(
  onSendTap: () async => true,
  builder: (FlSendState state, int seconds) => Text('$state $seconds')
);

FlEventBus().add('refresh', (dynamic data) {});
FlEventBus().emit('refresh', 'data');
```

### 基础能力

```dart
FlScreenAdaptation(
  designWidth: 375,
  builder: (BuildContext context, bool scaled) => const Text('按 375 设计稿适配')
);
```

## 示例工程

示例位于 `example/`，按组件分类展示全部公开组件，代码内附用法注释。

```bash
cd example
flutter pub get
flutter run -d chrome
```

Web 构建：

```bash
cd example
flutter build web --release
```

iOS 模拟器构建：

```bash
cd example
flutter build ios --simulator --no-codesign
```

## 测试

```bash
flutter test
dart analyze
```

## 支持平台

- 组件库基于 Flutter 通用能力实现，可随 Flutter 项目发布到 Android、iOS、Web、macOS 等平台。
- 本仓库示例工程当前只保留 Web 与 iOS 平台目录。

## 许可证

MIT，详见 [LICENSE](LICENSE)。
