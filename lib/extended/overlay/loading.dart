part of 'overlay.dart';

/// loading 加载框 关闭 closeLoading();
ExtendedOverlayEntry? showLoading({
  /// 通常使用自定义的
  Widget? custom,

  /// 底层模态框配置
  ModalWindowsOptions? options,

  /// 官方 ProgressIndicator 底部加个组件
  Widget? extra,

  /// 以下为官方三个 ProgressIndicator 配置
  double? value,
  Color? backgroundColor,
  Animation<Color>? valueColor,
  double strokeWidth = 4.0,
  String? semanticsLabel,
  String? semanticsValue,
  LoadingStyle? style,
}) =>
    Loading(
            custom: custom,
            extra: extra,
            options: options,
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue,
            style: style)
        .show();

bool closeLoading() => ExtendedOverlay().closeLoading();

class LoadingOptions {
  const LoadingOptions({
    this.custom,
    this.style = LoadingStyle.circular,
    this.options = const ModalWindowsOptions(),
  });

  final Widget? custom;
  final LoadingStyle style;
  final ModalWindowsOptions options;

  LoadingOptions copyWith({
    Widget? custom,
    LoadingStyle? style,
    ModalWindowsOptions? options,
  }) =>
      LoadingOptions(
          custom: custom ?? this.custom,
          style: style ?? this.style,
          options: options ?? this.options);

  LoadingOptions merge([LoadingOptions? options]) => LoadingOptions(
      custom: options?.custom ?? custom,
      style: options?.style ?? style,
      options: options?.options ?? this.options);
}

enum LoadingStyle {
  /// 圆圈
  circular,

  /// 横条
  linear,

  /// 不常用 下拉刷新圆圈
  refresh,
}

extension ExtensionLoading on Loading {
  ExtendedOverlayEntry? show() => ExtendedOverlay().showLoading(this);
}

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    this.strokeWidth = 4.0,
    this.style,
    this.custom,
    this.value,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.backgroundColor,
    this.options,
    this.extra,
  });

  /// 以下为官方三个 ProgressIndicator 配置
  final LoadingStyle? style;
  final double? value;
  final Animation<Color>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final Color? backgroundColor;
  final double strokeWidth;

  /// 官方 ProgressIndicator 底部加个组件
  final Widget? extra;

  /// 通常使用自定义的
  final Widget? custom;

  /// 底层模态框配置
  final ModalWindowsOptions? options;

  @override
  Widget build(BuildContext context) {
    final loadingOptions = GlobalWayUI()
        .loadingOptions
        .copyWith(custom: custom, style: style, options: options);
    Widget windows = custom ??
        buildLoadingStyle(style) ??
        loadingOptions.custom ??
        buildLoadingStyle(loadingOptions.style) ??
        const SizedBox();
    return ModalWindows(options: loadingOptions.options, child: windows);
  }

  Widget? buildLoadingStyle(LoadingStyle? style) {
    final List<Widget> children = [];
    switch (style) {
      case LoadingStyle.circular:
        children.add(CircularProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      case LoadingStyle.linear:
        children.add(LinearProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      case LoadingStyle.refresh:
        children.add(RefreshProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue));
        break;
      default:
        return null;
    }
    if (extra != null) children.add(extra!);

    return Universal(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: children);
  }
}
