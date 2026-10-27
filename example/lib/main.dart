import 'package:app/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

import 'package:app/module/animation_page.dart';
import 'package:app/module/display_page.dart';
import 'package:app/module/input_page.dart';
import 'package:app/module/page_view_page.dart';
import 'package:app/module/progress_page.dart';
import 'package:app/module/tools_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 40;
  runApp(const App());
}

/// 全局白天 / 黑夜模式，改动后整个示例即时生效。
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

const Color _seedColor = Color(0xFF4C6FFF);

ThemeData _buildTheme(Brightness brightness) {
  final ColorScheme scheme = ColorScheme.fromSeed(seedColor: _seedColor, brightness: brightness);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurface),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: appNavigatorKey,
        scaffoldMessengerKey: appScaffoldMessengerKey,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        themeMode: themeMode,
        title: 'FlutterWaya',
        home: const HomePage(),
      ),
    );
  }
}

/// 首页：按功能分类展示 flutter_waya 提供的全部组件。
///
/// 分类与 `lib/flutter_waya.dart` 中的导出顺序保持一致：
/// 动画与交互 / 进度与加载 / 分页与指示器 / 输入与表单 / 展示与布局 / 计时与工具。
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ExtendedScaffold(
      enableDoubleClickExit: true,
      appBar: AppBarText('Flutter Waya 12.0.0'),
      isScroll: true,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.auto_awesome_mosaic_outlined, size: 28, color: scheme.onPrimaryContainer),
              ),
              14.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Flutter Waya', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    4.heightBox,
                    Text(
                      'Flutter 3.47 · 轻量 UI 组件画廊',
                      style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            '点击分类查看组件示例，每个示例都附带用法注释。',
            style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
        ..._categories.map((Category category) => CategoryCard(category: category)),
      ],
    );
  }

  List<Category> get _categories => [
    Category(
      title: '动画与交互',
      subtitle:
          'FlAnimationCounter · FlToggleRotate · FlExpansionTiles · FlElasticBuilder · FlBubbleButton · '
          'FlAnimationWave · FlAutoCollapsingBuilder · 弹出菜单',
      icon: Icons.animation,
      page: () => const AnimationPage(),
    ),
    Category(
      title: '进度与加载',
      subtitle: 'FlLinearProgress · FlLinearProgress.gradient',
      icon: Icons.linear_scale,
      page: () => const ProgressPage(),
    ),
    Category(
      title: '分页与指示器',
      subtitle: 'FlPageView · FlPageViewController · FlPageViewTransform · FlIndicator',
      icon: Icons.swipe,
      page: () => const PageViewPage(),
    ),
    Category(
      title: '输入与表单',
      subtitle: 'FlPINTextField · FlDecoratorBox · FlDecoratorPendant · FlBorderType · 输入限制',
      icon: Icons.edit_outlined,
      page: () => const InputPage(),
    ),
    Category(
      title: '展示与布局',
      subtitle:
          'FlWrapper · FlDottedLineBorder · FlRatingStars · FlShimmery · FlSwitch · '
          'FlFlipCard · KeepAlive',
      icon: Icons.widgets_outlined,
      page: () => const DisplayPage(),
    ),
    Category(
      title: '计时与工具',
      subtitle:
          'FlCounter · FlSendVerificationCode · FlEvent / FlEventBus · FlScreenAdaptation · '
          'SystemUiOverlayStyle',
      icon: Icons.handyman_outlined,
      page: () => const ToolsPage(),
    ),
  ];
}

class Category {
  const Category({required this.title, required this.subtitle, required this.icon, required this.page});

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() page;
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => push(category.page()),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, size: 22, color: scheme.onPrimaryContainer),
                ),
                14.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      4.heightBox,
                      Text(
                        category.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                6.widthBox,
                Icon(Icons.chevron_right, color: scheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarText extends AppBar {
  AppBarText(String text, {super.key}) : super(title: Text(text), actions: const <Widget>[ThemeModeButton()]);
}

/// 白天 / 黑夜切换按钮，所有示例页面共用。
class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? '切换为白天模式' : '切换为黑夜模式',
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}

/// 示例中的小按钮
class ElevatedText extends StatelessWidget {
  const ElevatedText(this.text, {super.key, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return FlElasticBuilder(
      withOpacity: true,
      builder: (_, elasticUp, elastic, elasticDown) => MouseRegion(
        onEnter: (_) => elasticUp(),
        onExit: (_) => elasticDown(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Material(
            color: scheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              onTapDown: (_) => elastic(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 示例中的分组标题
class Partition extends StatelessWidget {
  const Partition(this.title, {super.key, this.onTap, this.marginTop = 20});

  final String title;
  final GestureTapCallback? onTap;
  final double marginTop;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget header = Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(2)),
        ),
        8.widthBox,
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
          ),
        ),
        if (onTap != null) Icon(Icons.touch_app_outlined, size: 16, color: scheme.outline),
      ],
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: marginTop, bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            10.heightBox,
            Divider(height: 1, thickness: 1, color: scheme.outlineVariant.withValues(alpha: 0.35)),
          ],
        ),
      ),
    );
  }
}

const List<Color> colorList = <Color>[...Colors.accents, ...Colors.primaries];

/// 统一的页面脚手架：
/// - 支持 SafeArea、滚动、Stack 布局
/// - 返回键优先关闭 Overlay（Toast / Loading），再执行返回
class ExtendedScaffold extends StatelessWidget {
  const ExtendedScaffold({
    super.key,
    this.safeLeft = false,
    this.safeTop = false,
    this.safeRight = false,
    this.safeBottom = false,
    this.isStack = false,
    this.isScroll = false,
    this.canHideOverlay = true,
    this.appBar,
    this.child,
    this.padding,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset,
    this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.enableDoubleClickExit = false,
  });

  final List<Widget>? children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isStack;
  final bool isScroll;
  final EdgeInsetsGeometry? padding;
  final bool canHideOverlay;
  final Widget? child;
  final Widget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool? resizeToAvoidBottomInset;
  final bool safeLeft;
  final bool safeTop;
  final bool safeRight;
  final bool safeBottom;
  final bool enableDoubleClickExit;

  static DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    final Widget scaffold = Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      appBar: buildAppBar(context),
      bottomNavigationBar: bottomNavigationBar,
      body: universal,
    );
    return canHideOverlay
        ? PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              if (didPop) return;
              if (enableDoubleClickExit) {
                final now = DateTime.now();
                if (_dateTime != null && now.difference(_dateTime!).inMilliseconds < 2500) {
                  SystemNavigator.pop();
                } else {
                  _dateTime = now;
                  showToast('再次点击返回键退出');
                }
              } else {
                pop();
              }
            },
            child: scaffold,
          )
        : scaffold;
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    if (appBar is AppBar) return appBar as AppBar;
    return appBar == null
        ? null
        : PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight - 12), child: appBar!);
  }

  Universal get universal => Universal(
    expand: true,
    padding: padding,
    isScroll: isScroll,
    safeLeft: safeLeft,
    safeTop: safeTop,
    safeRight: safeRight,
    safeBottom: safeBottom,
    isStack: isStack,
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    child: child,
    children: children ?? const <Widget>[],
  );
}
