import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

enum _SwitchType { material, adaptive }

typedef SwitchStateChanged = Future<bool> Function(bool value);

/// 官方版增加状态
class SwitchState extends StatelessWidget {
  const SwitchState(
      {super.key,
      required this.value,
      this.onChanged,
      this.activeColor,
      this.activeTrackColor,
      this.inactiveThumbColor,
      this.inactiveTrackColor,
      this.activeThumbImage,
      this.onActiveThumbImageError,
      this.inactiveThumbImage,
      this.onInactiveThumbImageError,
      this.thumbColor,
      this.trackColor,
      this.materialTapTargetSize,
      this.dragStartBehavior = DragStartBehavior.start,
      this.mouseCursor,
      this.focusColor,
      this.hoverColor,
      this.overlayColor,
      this.splashRadius,
      this.focusNode,
      this.autofocus = false,
      this.initState,
      this.dispose,
      this.didChangeDependencies,
      this.didUpdateWidget,
      this.onWaitChanged})
      : _switchType = _SwitchType.material;

  /// Creates an adaptive [Switch] based on whether the target platform is iOS
  /// or macOS, following Material design's
  /// [Cross-platform guidelines](https://material.io/design/platform-guidance/cross-platform-adaptation.html).
  ///
  /// On iOS and macOS, this constructor creates a [CupertinoSwitch], which has
  /// matching functionality and presentation as Material switches, and are the
  /// graphics expected on iOS. On other platforms, this creates a Material
  /// design [Switch].
  ///
  /// If a [CupertinoSwitch] is created, the following parameters are ignored:
  /// [activeTrackColor], [inactiveThumbColor], [inactiveTrackColor],
  /// [activeThumbImage], [onActiveThumbImageError], [inactiveThumbImage],
  /// [onInactiveThumbImageError], [materialTapTargetSize].
  ///
  /// The target platform is based on the current [Theme]: [ThemeData.platform].
  const SwitchState.adaptive({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.materialTapTargetSize,
    this.thumbColor,
    this.trackColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.autofocus = false,
    this.initState,
    this.dispose,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.onWaitChanged,
  }) : _switchType = _SwitchType.adaptive;

  /// Whether this switch is on or off.
  ///
  /// This property must not be null.
  final bool value;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Switch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  final SwitchStateChanged? onWaitChanged;

  /// The color to use when this switch is on.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  ///
  /// If [thumbColor] returns a non-null color in the [MaterialState.selected]
  /// state, it will be used instead of this color.
  final Color? activeColor;

  /// The color to use on the track when this switch is on.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor] with the opacity set at 50%.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  ///
  /// If [trackColor] returns a non-null color in the [MaterialState.selected]
  /// state, it will be used instead of this color.
  final Color? activeTrackColor;

  /// The color to use on the thumb when this switch is off.
  ///
  /// Defaults to the colors described in the Material design specification.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  ///
  /// If [thumbColor] returns a non-null color in the default state, it will be
  /// used instead of this color.
  final Color? inactiveThumbColor;

  /// The color to use on the track when this switch is off.
  ///
  /// Defaults to the colors described in the Material design specification.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  ///
  /// If [trackColor] returns a non-null color in the default state, it will be
  /// used instead of this color.
  final Color? inactiveTrackColor;

  /// An image to use on the thumb of this switch when the switch is on.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  final ImageProvider? activeThumbImage;

  /// An optional error callback for errors emitted when loading
  /// [activeThumbImage].
  final ImageErrorListener? onActiveThumbImageError;

  /// An image to use on the thumb of this switch when the switch is off.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  final ImageProvider? inactiveThumbImage;

  /// An optional error callback for errors emitted when loading
  /// [inactiveThumbImage].
  final ImageErrorListener? onInactiveThumbImageError;

  /// {@template flutter.material.switch.thumbColor}
  /// The color of this [Switch]'s thumb.
  ///
  /// Resolved in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// {@tool snippet}
  /// This example resolves the [thumbColor] based on the current
  /// [MaterialState] of the [Switch], providing a different [Color] when it is
  /// [MaterialState.disabled].
  ///
  /// ```dart
  /// Switch(
  ///   value: true,
  ///   onChanged: (_) => true,
  ///   thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
  ///     if (states.contains(MaterialState.disabled)) {
  ///       return Colors.orange.withOpacity(.48);
  ///     }
  ///     return Colors.orange;
  ///   }),
  /// )
  /// ```
  /// {@end-tool}
  /// {@endtemplate}
  ///
  /// If null, then the value of [activeColor] is used in the selected
  /// state and [inactiveThumbColor] in the default state. If that is also null,
  /// then the value of [SwitchThemeData.thumbColor] is used. If that is also
  /// null, then the following colors are used:
  ///
  /// | State    | Light theme                       | Dark theme                        |
  /// |----------|-----------------------------------|-----------------------------------|
  /// | Default  | `Colors.grey.shade50`             | `Colors.grey.shade400`            |
  /// | Selected | [ThemeData.toggleableActiveColor] | [ThemeData.toggleableActiveColor] |
  /// | Disabled | `Colors.grey.shade400`            | `Colors.grey.shade800`            |
  final MaterialStateProperty<Color?>? thumbColor;

  /// {@template flutter.material.switch.trackColor}
  /// The color of this [Switch]'s track.
  ///
  /// Resolved in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// {@tool snippet}
  /// This example resolves the [trackColor] based on the current
  /// [MaterialState] of the [Switch], providing a different [Color] when it is
  /// [MaterialState.disabled].
  ///
  /// ```dart
  /// Switch(
  ///   value: true,
  ///   onChanged: (_) => true,
  ///   thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
  ///     if (states.contains(MaterialState.disabled)) {
  ///       return Colors.orange.withOpacity(.48);
  ///     }
  ///     return Colors.orange;
  ///   }),
  /// )
  /// ```
  /// {@end-tool}
  /// {@endtemplate}
  ///
  /// If null, then the value of [activeTrackColor] is used in the selected
  /// state and [inactiveTrackColor] in the default state. If that is also null,
  /// then the value of [SwitchThemeData.trackColor] is used. If that is also
  /// null, then the following colors are used:
  ///
  /// | State    | Light theme                     | Dark theme                      |
  /// |----------|---------------------------------|---------------------------------|
  /// | Default  | `Color(0x52000000)`             | `Colors.white30`                |
  /// | Selected | [activeColor] with alpha `0x80` | [activeColor] with alpha `0x80` |
  /// | Disabled | `Colors.black12`                | `Colors.white10`                |
  final MaterialStateProperty<Color?>? trackColor;

  /// {@template flutter.material.switch.materialTapTargetSize}
  /// Configures the minimum size of the tap target.
  /// {@endtemplate}
  ///
  /// If null, then the value of [SwitchThemeData.materialTapTargetSize] is
  /// used. If that is also null, then the value of
  /// [ThemeData.materialTapTargetSize] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialTapTargetSize], for a description of how this affects tap targets.
  final MaterialTapTargetSize? materialTapTargetSize;

  final _SwitchType _switchType;

  /// {@macro flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@template flutter.material.switch.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// If null, then the value of [SwitchThemeData.mouseCursor] is used. If that
  /// is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], a [MouseCursor] that implements
  ///    `MaterialStateProperty` which is used in APIs that need to accept
  ///    either a [MouseCursor] or a [MaterialStateProperty<MouseCursor>].
  final MouseCursor? mouseCursor;

  /// The color for the button's [Material] when it has the input focus.
  ///
  /// If [overlayColor] returns a non-null color in the [MaterialState.focused]
  /// state, it will be used instead.
  ///
  /// If null, then the value of [SwitchThemeData.overlayColor] is used in the
  /// focused state. If that is also null, then the value of
  /// [ThemeData.focusColor] is used.
  final Color? focusColor;

  /// The color for the button's [Material] when a pointer is hovering over it.
  ///
  /// If [overlayColor] returns a non-null color in the [MaterialState.hovered]
  /// state, it will be used instead.
  ///
  /// If null, then the value of [SwitchThemeData.overlayColor] is used in the
  /// hovered state. If that is also null, then the value of
  /// [ThemeData.hoverColor] is used.
  final Color? hoverColor;

  /// {@template flutter.material.switch.overlayColor}
  /// The color for the switch's [Material].
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  /// {@endtemplate}
  ///
  /// If null, then the value of [activeColor] with alpha
  /// [kRadialReactionAlpha], [focusColor] and [hoverColor] is used in the
  /// pressed, focused and hovered state. If that is also null,
  /// the value of [SwitchThemeData.overlayColor] is used. If that is
  /// also null, then the value of [ThemeData.toggleableActiveColor] with alpha
  /// [kRadialReactionAlpha], [ThemeData.focusColor] and [ThemeData.hoverColor]
  /// is used in the pressed, focused and hovered state.
  final MaterialStateProperty<Color?>? overlayColor;

  /// {@template flutter.material.switch.splashRadius}
  /// The splash radius of the circular [Material] ink response.
  /// {@endtemplate}
  ///
  /// If null, then the value of [SwitchThemeData.splashRadius] is used. If that
  /// is also null, then [kRadialReactionRadius] is used.
  final double? splashRadius;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// initState
  final ValueCallback<BuildContext>? initState;

  /// dispose
  final ValueCallback<BuildContext>? dispose;

  /// didChangeDependencies
  final ValueCallback<BuildContext>? didChangeDependencies;

  /// didUpdateWidget
  final ValueCallback<BuildContext>? didUpdateWidget;

  @override
  Widget build(BuildContext context) => ValueBuilder<bool>(
      initialValue: value,
      initState: initState,
      dispose: dispose,
      didChangeDependencies: didChangeDependencies,
      didUpdateWidget: didUpdateWidget,
      builder: (_, bool? value, Function update) {
        switch (_switchType) {
          case _SwitchType.material:
            return Switch(
                value: value!,
                activeColor: activeColor,
                activeTrackColor: activeTrackColor,
                inactiveThumbColor: inactiveThumbColor,
                inactiveTrackColor: inactiveTrackColor,
                activeThumbImage: activeThumbImage,
                onActiveThumbImageError: onActiveThumbImageError,
                inactiveThumbImage: inactiveThumbImage,
                onInactiveThumbImageError: onInactiveThumbImageError,
                thumbColor: thumbColor,
                trackColor: trackColor,
                materialTapTargetSize: materialTapTargetSize,
                dragStartBehavior: dragStartBehavior,
                mouseCursor: mouseCursor,
                focusColor: focusColor,
                hoverColor: hoverColor,
                overlayColor: overlayColor,
                splashRadius: splashRadius,
                focusNode: focusNode,
                autofocus: autofocus,
                onChanged: (bool v) async {
                  onChanged?.call(v);
                  if (onWaitChanged != null) {
                    onWaitChanged!.call(v).then((result) => update(result));
                  } else {
                    update(v);
                  }
                });
          case _SwitchType.adaptive:
            return Switch.adaptive(
                value: value!,
                activeColor: activeColor,
                activeTrackColor: activeTrackColor,
                inactiveThumbColor: inactiveThumbColor,
                inactiveTrackColor: inactiveTrackColor,
                activeThumbImage: activeThumbImage,
                onActiveThumbImageError: onActiveThumbImageError,
                inactiveThumbImage: inactiveThumbImage,
                onInactiveThumbImageError: onInactiveThumbImageError,
                materialTapTargetSize: materialTapTargetSize,
                thumbColor: thumbColor,
                trackColor: trackColor,
                dragStartBehavior: dragStartBehavior,
                mouseCursor: mouseCursor,
                focusColor: focusColor,
                hoverColor: hoverColor,
                overlayColor: overlayColor,
                splashRadius: splashRadius,
                focusNode: focusNode,
                autofocus: autofocus,
                onChanged: (bool v) async {
                  onChanged?.call(v);
                  if (onWaitChanged != null) {
                    onWaitChanged!.call(v).then((result) => update(result));
                  } else {
                    update(v);
                  }
                });
        }
      });
}

/// 官方版增加状态
class CupertinoSwitchState extends StatelessWidget {
  const CupertinoSwitchState(
      {super.key,
      required this.value,
      this.onChanged,
      this.onWaitChanged,
      this.activeColor,
      this.trackColor,
      this.thumbColor,
      this.dragStartBehavior = DragStartBehavior.start,
      this.initState,
      this.dispose,
      this.didChangeDependencies,
      this.didUpdateWidget});

  /// Whether this switch is on or off.
  ///
  /// Must not be null.
  final bool value;

  /// Called when the user toggles with switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled, which has a reduced opacity.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// CupertinoSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  final SwitchStateChanged? onWaitChanged;

  /// The color to use when this switch is on.
  ///
  /// Defaults to [CupertinoColors.systemGreen] when null and ignores
  /// the [CupertinoTheme] in accordance to native iOS behavior.
  final Color? activeColor;

  /// The color to use for the background when the switch is off.
  ///
  /// Defaults to [CupertinoColors.secondarySystemFill] when null.
  final Color? trackColor;

  /// The color to use for the thumb of the switch.
  ///
  /// Defaults to [CupertinoColors.white] when null.
  final Color? thumbColor;

  /// {@template flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used to move the
  /// switch from on to off will begin at the position where the drag gesture won
  /// the arena. If set to [DragStartBehavior.down] it will begin at the position
  /// where a down event was first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for
  ///    the different behaviors.
  ///
  /// {@endtemplate}
  final DragStartBehavior dragStartBehavior;

  /// initState
  final ValueCallback<BuildContext>? initState;

  /// dispose
  final ValueCallback<BuildContext>? dispose;

  /// didChangeDependencies
  final ValueCallback<BuildContext>? didChangeDependencies;

  /// didUpdateWidget
  final ValueCallback<BuildContext>? didUpdateWidget;

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<bool>(
        initialValue: value,
        initState: initState,
        dispose: dispose,
        didChangeDependencies: didChangeDependencies,
        didUpdateWidget: didUpdateWidget,
        builder: (_, bool? value, Function update) => CupertinoSwitch(
            value: value!,
            activeColor: activeColor,
            trackColor: trackColor,
            thumbColor: thumbColor,
            dragStartBehavior: dragStartBehavior,
            onChanged: (bool v) async {
              onChanged?.call(v);
              if (onWaitChanged != null) {
                onWaitChanged!.call(v).then((result) => update(result));
              } else {
                update(v);
              }
            }));
  }
}
