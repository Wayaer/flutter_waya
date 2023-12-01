part of 'overlay.dart';

extension ExtensionToast on Toast {
  Future<ExtendedOverlayEntry?> show() => ExtendedOverlay().showToast(this);
}

class Toast extends StatelessWidget {
  const Toast(
    this.message, {
    super.key,
    this.options,
    this.style,
    this.icon,
  });

  /// 文字
  final String message;

  /// UI配置
  final ToastOptions? options;

  /// icon 样式 不传 仅显示文字
  final ToastStyle? style;

  /// 自定义icon [icon] 优先于 [ToastStyle]
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final currentOptions = GlobalWayUI().toastOptions.merge(options);
    Widget current =
        currentOptions.buildText?.call(message, currentOptions.iconColor) ??
            BText(message,
                textAlign: TextAlign.center,
                color: currentOptions.iconColor,
                maxLines: 5,
                fontSize: 14);
    if ((icon ?? style?.value) != null) {
      current = IconBox(
          icon: icon ?? style?.value,
          direction: currentOptions.direction,
          spacing: currentOptions.spacing,
          size: currentOptions.iconSize,
          color: currentOptions.iconColor,
          title: current);
    }
    current = Universal(
        onTap: currentOptions.onTap,
        margin: currentOptions.margin,
        decoration: currentOptions.decoration ??
            BoxDecoration(
                color: currentOptions.backgroundColor,
                borderRadius: BorderRadius.circular(6)),
        padding: currentOptions.padding,
        child: current);

    if (currentOptions.animationStyle != null) {
      current = FlAnimation(
          style: currentOptions.animationStyle!,
          stayDuration: currentOptions.duration
              .subtract(kFlAnimationDuration, kFlAnimationDuration),
          child: current);
    }
    return ModalWindows(
        options: currentOptions.modalWindowsOptions.copyWith(
            absorbing: currentOptions.absorbing,
            ignoring: currentOptions.ignoring,
            alignment: currentOptions.positioned),
        child: current);
  }
}

/// Toast
/// 关闭 closeToast();
/// 添加 await Toast 关闭后继续执行之后的方法
Future<ExtendedOverlayEntry?> showToast(String message,
        {ToastStyle? style, IconData? icon, ToastOptions? options}) =>
    Toast(message, options: options, icon: icon, style: style).show();

bool closeToast() => ExtendedOverlay().closeToast();

/// Toast类型
/// 如果使用custom  请设置 [customIcon]
enum ToastStyle { success, fail, info, warning, smile }

extension ExtensionToastStyle on ToastStyle {
  Future<ExtendedOverlayEntry?> show(String message,
          {IconData? icon, ToastOptions? options}) =>
      Toast(message, options: options, icon: icon, style: this).show();

  IconData get value {
    switch (this) {
      case ToastStyle.success:
        return WayIcons.success;
      case ToastStyle.fail:
        return WayIcons.fail;
      case ToastStyle.info:
        return WayIcons.info;
      case ToastStyle.warning:
        return WayIcons.warning;
      case ToastStyle.smile:
        return WayIcons.smile;
    }
  }
}

typedef ToastOptionsBuildText = Widget Function(String text, Color color);

class ToastOptions {
  const ToastOptions(
      {this.backgroundColor = const Color(0xEE000000),
      this.iconColor = const Color(0xFFFFFFFF),
      this.decoration,
      this.onTap,
      this.textStyle,
      this.duration = const Duration(milliseconds: 1500),
      this.positioned = Alignment.center,
      this.ignoring = false,
      this.absorbing = false,
      this.animationStyle = AnimationStyle.verticalHunting,
      this.iconSize = 18,
      this.spacing = 10,
      this.padding = const EdgeInsets.all(14),
      this.margin = const EdgeInsets.all(30),
      this.direction = Axis.horizontal,
      this.buildText,
      this.modalWindowsOptions = const ModalWindowsOptions()});

  final AnimationStyle? animationStyle;

  /// 背景色
  final Color? backgroundColor;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  /// Toast 装饰器 会替换 [backgroundColor]
  final BoxDecoration? decoration;

  /// Toast onTap
  final GestureTapCallback? onTap;

  /// 显示文字样式
  final TextStyle? textStyle;

  /// Toast显示时间
  final Duration duration;

  /// Toast 定位
  final AlignmentGeometry positioned;

  /// Toast 是否忽略子组件点击事件响应背景点击事件 默认 false
  /// true [onTap] 和 [modalWindowsOptions.onTap] 都会失效
  final bool ignoring;

  /// 是否吸收子组件的点击事件且不响应背景点击事件 默认 false
  /// [onTap] != null 时  无效
  final bool absorbing;

  /// icon
  final Color iconColor;

  /// icon size
  final double iconSize;

  /// Toast icon spacing
  final double spacing;

  /// Toast icon direction
  final Axis direction;

  /// 全局Toast的 modalWindowsOptions
  final ModalWindowsOptions modalWindowsOptions;

  /// 重新 build Text
  final ToastOptionsBuildText? buildText;

  ToastOptions copyWith({
    AlignmentGeometry? positioned,
    bool? ignoring,
    bool? absorbing,
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
    GestureTapCallback? onTap,
    TextStyle? textStyle,
    Duration? duration,
    Color? iconColor,
    double? iconSize,
    double? spacing,
    Axis? direction,
    ModalWindowsOptions? modalWindowsOptions,
    ToastOptionsBuildText? buildText,
  }) =>
      ToastOptions(
          modalWindowsOptions: modalWindowsOptions ?? this.modalWindowsOptions,
          positioned: positioned ?? this.positioned,
          ignoring: ignoring ?? this.ignoring,
          absorbing: ignoring ?? this.absorbing,
          backgroundColor: backgroundColor ?? this.backgroundColor,
          margin: margin ?? this.margin,
          padding: padding ?? this.padding,
          decoration: decoration ?? this.decoration,
          onTap: onTap ?? this.onTap,
          textStyle: textStyle ?? this.textStyle,
          duration: duration ?? this.duration,
          iconColor: iconColor ?? this.iconColor,
          iconSize: iconSize ?? this.iconSize,
          spacing: spacing ?? this.spacing,
          buildText: buildText ?? this.buildText,
          direction: direction ?? this.direction);

  ToastOptions merge([ToastOptions? options]) => ToastOptions(
      modalWindowsOptions: options?.modalWindowsOptions ?? modalWindowsOptions,
      positioned: options?.positioned ?? positioned,
      ignoring: options?.ignoring ?? ignoring,
      absorbing: options?.ignoring ?? absorbing,
      backgroundColor: options?.backgroundColor ?? backgroundColor,
      margin: options?.margin ?? margin,
      padding: options?.padding ?? padding,
      decoration: options?.decoration ?? decoration,
      onTap: options?.onTap ?? onTap,
      textStyle: options?.textStyle ?? textStyle,
      duration: options?.duration ?? duration,
      iconColor: options?.iconColor ?? iconColor,
      iconSize: options?.iconSize ?? iconSize,
      spacing: options?.spacing ?? spacing,
      buildText: options?.buildText ?? buildText,
      direction: options?.direction ?? direction);
}
