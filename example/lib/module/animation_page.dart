import 'package:app/main.dart';
import 'package:app/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 动画与交互分类页。
///
/// 覆盖组件：
/// - [FlAnimationCounter] 数字滚动
/// - [FlToggleRotate] 旋转图标
/// - [FlExpansionTiles] 展开收起
/// - [FlElasticBuilder] 弹性缩放
/// - [FlBubbleButton] 气泡按钮
/// - [FlAnimationWave] 波浪
/// - [FlAutoCollapsingBuilder] 滚动自动折叠
/// - [FlMultiPopupMenuButton] / [FlPopupMenuButtonRotateBuilder] 弹出菜单
class AnimationPage extends StatelessWidget {
  const AnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      isScroll: true,
      appBar: AppBarText('动画与交互'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: const [
        Partition('FlAnimationCounter · 数字滚动', marginTop: 0),
        _AnimationCounterDemo(),
        Partition('FlToggleRotate · 旋转'),
        _ToggleRotateDemo(),
        Partition('FlExpansionTiles · 展开收起'),
        _ExpansionTilesDemo(),
        Partition('FlElasticBuilder · 弹性缩放'),
        _ElasticDemo(),
        Partition('FlBubbleButton · 气泡按钮'),
        _BubbleDemo(),
        Partition('FlAnimationWave · 波浪'),
        _WaveDemo(),
        Partition('FlAutoCollapsingBuilder · 滚动折叠'),
        _AutoCollapsingDemo(),
        Partition('FlMultiPopupMenuButton / FlPopupMenuButtonRotateBuilder · 下拉菜单'),
        _PopupMenuDemo(),
        SizedBox(height: 60),
      ],
    );
  }
}

/// [FlAnimationCounter] 会在数值变化时做上下滚动动画。
/// - [FlCounterStyle.part]：只对变化的数字做动画
/// - [FlCounterStyle.all]：整体做动画
/// - [FlAnimationCounter.up] / [FlAnimationCounter.down]：控制滚动方向
class _AnimationCounterDemo extends StatelessWidget {
  const _AnimationCounterDemo();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      ValueBuilder<int>(
        initial: 100,
        builder: (_, int? value, Function updater) => Universal(
          onTap: () => updater((value ?? 0) + 2),
          padding: const EdgeInsets.all(8),
          child: FlAnimationCounter.up(
            style: FlCounterStyle.part,
            value: '${value ?? 0}',
            builder: (String text) => Text(text, style: const TextStyle(fontSize: 30)),
          ),
        ),
      ),
      ValueBuilder<int>(
        initial: 100,
        builder: (_, int? value, Function updater) => Universal(
          onTap: () => updater((value ?? 0) - 1),
          padding: const EdgeInsets.all(8),
          child: FlAnimationCounter.down(
            style: FlCounterStyle.all,
            value: '${value ?? 0}',
            builder: (String text) => Text(text, style: const TextStyle(fontSize: 30)),
          ),
        ),
      ),
    ],
  );
}

/// [FlToggleRotate] 让图标在 [turns] 圈内旋转，可配置方向、时长、曲线。
/// 通过 `builder` 暴露 `rotate` 回调，可自行绑定点击事件。
class _ToggleRotateDemo extends StatelessWidget {
  const _ToggleRotateDemo();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _buildRotate(context, turns: 0.5, duration: const Duration(milliseconds: 300)),
      _buildRotate(context, turns: 1, duration: const Duration(milliseconds: 600)),
      _buildRotate(context, turns: 1.5, duration: const Duration(seconds: 1)),
    ],
  );

  Widget _buildRotate(BuildContext context, {required double turns, required Duration duration}) => FlToggleRotate(
    turns: turns,
    duration: duration,
    onChanged: (bool value) => log('FlToggleRotate turns:$turns isRotate:$value'),
    builder: (Widget child, FlToggleRotateHandleRotation rotate) => GestureDetector(onTap: rotate, child: child),
    icon: (bool value) =>
        Icon(Icons.accessibility_sharp, size: 30, color: value ? Theme.of(context).colorScheme.primary : null),
  );
}

/// [FlExpansionTiles] 是自定义的展开收起组件：
/// - `builder` 自定义头部（可拿到旋转图标）
/// - `icon` 自定义展开箭头，会自动旋转 0.5 圈
class _ExpansionTilesDemo extends StatelessWidget {
  const _ExpansionTilesDemo();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FlExpansionTiles(
        icon: (bool isExpanded) =>
            Icon(Icons.expand_more, color: isExpanded ? Theme.of(context).colorScheme.primary : null),
        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        builder: (BuildContext context, VoidCallback expand, bool isExpanded, Widget? rotation) =>
            ListTile(onTap: expand, title: const Text('FlExpansionTiles'), trailing: rotation),
        children: List.generate(
          4,
          (int index) => Padding(
            padding: const EdgeInsets.all(12),
            child: Align(alignment: Alignment.centerLeft, child: Text('item$index')),
          ),
        ),
      ).expanded,
      10.widthBox,
      // ExpansionTile 是 Flutter 官方组件，用 .expanded 与自定义组件并排展示
      ExpansionTile(
        title: const Text('ExpansionTile'),
        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        children: List.generate(
          4,
          (int index) => Padding(
            padding: const EdgeInsets.all(12),
            child: Align(alignment: Alignment.centerLeft, child: Text('item$index')),
          ),
        ),
      ).expanded,
    ],
  );
}

/// [FlElasticBuilder] 提供按下缩放、松开回弹的交互包装。
///
/// `builder` 会返回三个能力：
/// - `elasticUp`：回弹到原始大小
/// - `elastic`：快速缩放一下（可按需传入间隔）
/// - `elasticDown`：缩小
class _ElasticDemo extends StatelessWidget {
  const _ElasticDemo();

  @override
  Widget build(BuildContext context) => FlElasticBuilder(
    withOpacity: true,
    scale: 0.92,
    builder: (_, Function elasticUp, Function elastic, Function elasticDown) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MouseRegion(
          onEnter: (_) => elasticUp(),
          onExit: (_) => elasticDown(),
          child: Universal(
            onTapDown: (_) => elastic(),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Text('Hover / Tap', style: TextStyle(color: Colors.white)),
          ),
        ),
        ElevatedText('FlElasticBuilder', onTap: () => showToast('点击 FlElasticBuilder')),
      ],
    ),
  );
}

/// [FlBubbleButton] 点击后播放气泡扩散动画。
/// `onTap` 返回 `Future<bool>`：`true` 表示进入气泡状态，`false` 表示退出。
class _BubbleDemo extends StatelessWidget {
  const _BubbleDemo();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      FlBubbleButton(
        size: 40,
        onTap: (bool value) async => !value,
        builder: (bool value) => Universal(
          isOval: true,
          alignment: Alignment.center,
          color: value ? Theme.of(context).colorScheme.primary : Colors.grey,
          child: const Text('点击', style: TextStyle(color: Colors.white)),
        ),
      ),
      const FlBubbleButton(
        size: 40,
        bubbleColor: FlBubbleColor(dotFirstColor: Color(0xff33b5e5), dotSecondColor: Color(0xff0099cc)),
        circleColor: FlCircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
        builder: _bubbleIcon,
      ),
      const FlBubbleButton(
        size: 40,
        bubbleColor: FlBubbleColor(dotFirstColor: Color(0xff669900), dotSecondColor: Color(0xff99cc00)),
        circleColor: FlCircleColor(start: Color(0xff669900), end: Color(0xff669900)),
        builder: _bubbleAlertIcon,
      ),
    ],
  );

  static Widget _bubbleIcon(bool value) =>
      Icon(Icons.error, color: value ? Colors.deepPurpleAccent : Colors.grey, size: 40);

  static Widget _bubbleAlertIcon(bool value) =>
      Icon(Icons.add_alert_outlined, color: value ? Colors.green : Colors.grey, size: 40);
}

/// [FlAnimationWave] 是一个持续流动的波浪裁剪层，可用于波浪背景、加载占位等。
/// - `value`：水位（0~1）
/// - `direction`：波浪方向
class _WaveDemo extends StatelessWidget {
  const _WaveDemo();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        height: 120,
        child: FlAnimationWave(value: 0.5, color: Theme.of(context).colorScheme.primary, direction: Axis.horizontal),
      ).expanded,
      10.widthBox,
      SizedBox(
        height: 120,
        child: FlAnimationWave(value: 0.5, color: Theme.of(context).colorScheme.secondary, direction: Axis.vertical),
      ).expanded,
    ],
  );
}

/// [FlAutoCollapsingBuilder] 监听 [ScrollController]：
/// 向上滚动时自身尺寸缩小到 [minSize]，向下滚动时恢复到 [maxSize]。
class _AutoCollapsingDemo extends StatefulWidget {
  const _AutoCollapsingDemo();

  @override
  State<_AutoCollapsingDemo> createState() => _AutoCollapsingDemoState();
}

class _AutoCollapsingDemoState extends State<_AutoCollapsingDemo> {
  final ScrollController controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 220,
    child: Stack(
      children: [
        ListView.builder(
          controller: controller,
          itemCount: colorList.length,
          itemBuilder: (BuildContext context, int index) => Container(
            height: index.isEven ? 80 : 40,
            alignment: Alignment.center,
            color: colorList[index],
            child: Text('$index', style: const TextStyle(color: Colors.white)),
          ),
        ),
        // 右下角悬浮块会随列表滚动自动折叠
        Positioned(
          right: 12,
          bottom: 12,
          child: FlAutoCollapsingBuilder(
            controller: controller,
            minSize: 12,
            maxSize: 72,
            damping: 1,
            child: Container(
              width: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.keyboard_double_arrow_up, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

const Map<String, List<String>> _popupMenus = {
  '性别': ['男', '女'],
  '年龄': ['12岁', '13岁', '14岁'],
  '地区': ['湖北', '四川', '重庆'],
};

/// [FlMultiPopupMenuButton] 用统一的 builder 构建多个下拉菜单，并共享打开/取消/选中回调。
///
/// [FlPopupMenuButtonRotateBuilder] 则把 [FlToggleRotate] 与 [PopupMenuButton] 组合，
/// 菜单打开/关闭时箭头自动旋转。
class _PopupMenuDemo extends StatefulWidget {
  const _PopupMenuDemo();

  @override
  State<_PopupMenuDemo> createState() => _PopupMenuDemoState();
}

class _PopupMenuDemoState extends State<_PopupMenuDemo> {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      FlMultiPopupMenuButton<String, String>(
        onSelected: (_, String key, String? value) => showToast('$key → $value'),
        menus: _popupMenus.entriesMapToList(
          (MapEntry<String, List<String>> entry) => FlMultiPopupMenuButtonItem<String, String>(
            key: entry.key,
            builder:
                (
                  BuildContext context,
                  String key,
                  String? value,
                  VoidCallback onOpened,
                  VoidCallback onCanceled,
                  PopupMenuItemSelected<String> onSelected,
                ) {
                  return Expanded(
                    child: FlToggleRotate(
                      turns: 0.5,
                      icon: const Icon(Icons.arrow_drop_down_circle_outlined).toToggleRotateIconBuilder,
                      builder: (Widget rotateIcon, FlToggleRotateHandleRotation rotate) {
                        return PopupMenuButton<String>(
                          initialValue: value ?? entry.value.first,
                          onCanceled: () {
                            onCanceled();
                            rotate();
                          },
                          onOpened: () {
                            onOpened();
                            rotate();
                          },
                          onSelected: (String item) {
                            onSelected(item);
                            rotate();
                          },
                          position: PopupMenuPosition.under,
                          child: Universal(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            direction: Axis.horizontal,
                            children: [Text(value ?? key).expanded, 10.widthBox, rotateIcon],
                          ),
                          itemBuilder: (_) => entry.value.builder(
                            (String item) => PopupMenuItem<String>(value: item, child: Text(item)),
                          ),
                        );
                      },
                    ),
                  );
                },
          ),
        ),
      ),
      12.heightBox,
      FlPopupMenuButtonRotateBuilder(
        turns: 0.25,
        icon: const Icon(Icons.arrow_circle_right_outlined).toToggleRotateIconBuilder,
        builder: (_, Widget rotate, VoidCallback onOpened, VoidCallback onClosed) {
          return PopupMenuButton<String>(
            onCanceled: onClosed,
            onOpened: onOpened,
            position: PopupMenuPosition.under,
            onSelected: (String value) {
              showToast('选中：$value');
              onClosed();
            },
            itemBuilder: (_) =>
                colorList.builder((Color item) => PopupMenuItem<String>(value: '$item', child: Text('$item'))),
            child: Universal(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              direction: Axis.horizontal,
              children: [const Icon(Icons.ac_unit), 10.widthBox, const Text('请选择').expanded, 10.widthBox, rotate],
            ),
          );
        },
      ),
    ],
  );
}
