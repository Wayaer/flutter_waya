import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

typedef CheckboxStateChanged = bool Function(bool? value);

class CheckboxState extends StatelessWidget {
  const CheckboxState({
    Key? key,
    required this.value,
    this.tristate = false,
    this.onChanged,
    required this.onWaitChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.initState,
    this.dispose,
    this.didChangeDependencies,
    this.didUpdateWidget,
  }) : super(key: key);

  /// Whether this checkbox is checked.
  ///
  /// This property must not be null.
  final bool? value;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox with the new
  /// value.
  ///
  /// If this callback is null, the checkbox will be displayed as disabled
  /// and will not respond to input gestures.
  ///
  /// When the checkbox is tapped, if [tristate] is false (the default) then
  /// the [onChanged] callback will be applied to `!value`. If [tristate] is
  /// true this callback cycle from false to true to null.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Checkbox(
  ///   value: _throwShotAway,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue!;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool?>? onChanged;

  final CheckboxStateChanged? onWaitChanged;

  /// {@template flutter.material.checkbox.mouseCursor}
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
  /// When [value] is null and [tristate] is true, [MaterialState.selected] is
  /// included as a state.
  ///
  /// If null, then the value of [CheckboxThemeData.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], a [MouseCursor] that implements
  ///    `MaterialStateProperty` which is used in APIs that need to accept
  ///    either a [MouseCursor] or a [MaterialStateProperty<MouseCursor>].
  final MouseCursor? mouseCursor;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  ///
  /// If [fillColor] returns a non-null color in the [MaterialState.selected]
  /// state, it will be used instead of this color.
  final Color? activeColor;

  /// {@template flutter.material.checkbox.fillColor}
  /// The color that fills the checkbox, in all [MaterialState]s.
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// {@tool snippet}
  /// This example resolves the [fillColor] based on the current [MaterialState]
  /// of the [Checkbox], providing a different [Color] when it is
  /// [MaterialState.disabled].
  ///
  /// ```dart
  /// Checkbox(
  ///   value: true,
  ///   onChanged: (_){},
  ///   fillColor: MaterialStateProperty.resolveWith<Color>((states) {
  ///     if (states.contains(MaterialState.disabled)) {
  ///       return Colors.orange.withOpacity(.32);
  ///     }
  ///     return Colors.orange;
  ///   })
  /// )
  /// ```
  /// {@end-tool}
  /// {@endtemplate}
  ///
  /// If null, then the value of [activeColor] is used in the selected
  /// state. If that is also null, the value of [CheckboxThemeData.fillColor]
  /// is used. If that is also null, then [ThemeData.disabledColor] is used in
  /// the disabled state, [ThemeData.toggleableActiveColor] is used in the
  /// selected state, and [ThemeData.unselectedWidgetColor] is used in the
  /// default state.
  final MaterialStateProperty<Color?>? fillColor;

  /// {@template flutter.material.checkbox.checkColor}
  /// The color to use for the check icon when this checkbox is checked.
  /// {@endtemplate}
  ///
  /// If null, then the value of [CheckboxThemeData.checkColor] is used. If
  /// that is also null, then Color(0xFFFFFFFF) is used.
  final Color? checkColor;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// Checkbox displays a dash when its value is null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  final bool tristate;

  /// {@template flutter.material.checkbox.materialTapTargetSize}
  /// Configures the minimum size of the tap target.
  /// {@endtemplate}
  ///
  /// If null, then the value of [CheckboxThemeData.materialTapTargetSize] is
  /// used. If that is also null, then the value of
  /// [ThemeData.materialTapTargetSize] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialTapTargetSize], for a description of how this affects tap targets.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// {@template flutter.material.checkbox.visualDensity}
  /// Defines how compact the checkbox's layout will be.
  /// {@endtemplate}
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// If null, then the value of [CheckboxThemeData.visualDensity] is used. If
  /// that is also null, then the value of [ThemeData.visualDensity] is used.
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  final VisualDensity? visualDensity;

  /// The color for the checkbox's [Material] when it has the input focus.
  ///
  /// If [overlayColor] returns a non-null color in the [MaterialState.focused]
  /// state, it will be used instead.
  ///
  /// If null, then the value of [CheckboxThemeData.overlayColor] is used in the
  /// focused state. If that is also null, then the value of
  /// [ThemeData.focusColor] is used.
  final Color? focusColor;

  /// The color for the checkbox's [Material] when a pointer is hovering over it.
  ///
  /// If [overlayColor] returns a non-null color in the [MaterialState.hovered]
  /// state, it will be used instead.
  ///
  /// If null, then the value of [CheckboxThemeData.overlayColor] is used in the
  /// hovered state. If that is also null, then the value of
  /// [ThemeData.hoverColor] is used.
  final Color? hoverColor;

  /// {@template flutter.material.checkbox.overlayColor}
  /// The color for the checkbox's [Material].
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
  /// the value of [CheckboxThemeData.overlayColor] is used. If that is
  /// also null, then the value of [ThemeData.toggleableActiveColor] with alpha
  /// [kRadialReactionAlpha], [ThemeData.focusColor] and [ThemeData.hoverColor]
  /// is used in the pressed, focused and hovered state.
  final MaterialStateProperty<Color?>? overlayColor;

  /// {@template flutter.material.checkbox.splashRadius}
  /// The splash radius of the circular [Material] ink response.
  /// {@endtemplate}
  ///
  /// If null, then the value of [CheckboxThemeData.splashRadius] is used. If
  /// that is also null, then [kRadialReactionRadius] is used.
  final double? splashRadius;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@template flutter.material.checkbox.shape}
  /// The shape of the checkbox's [Material].
  /// {@endtemplate}
  ///
  /// If this property is null then [CheckboxThemeData.shape] of [ThemeData.checkboxTheme]
  /// is used. If that's null then the shape will be a [RoundedRectangleBorder]
  /// with a circular corner radius of 1.0.
  final OutlinedBorder? shape;

  /// {@template flutter.material.checkbox.side}
  /// The color and width of the checkbox's border.
  ///
  /// This property can be a [MaterialStateBorderSide] that can
  /// specify different border color and widths depending on the
  /// checkbox's state.
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// If this property is not a [MaterialStateBorderSide] and it is
  /// non-null, then it is only rendered when the checkbox's value is
  /// false. The difference in interpretation is for backwards
  /// compatibility.
  /// {@endtemplate}
  ///
  /// If this property is null, then [CheckboxThemeData.side] of
  /// [ThemeData.checkboxTheme] is used. If that is also null, then the side
  /// will be width 2.
  final BorderSide? side;

  /// The width of a checkbox widget.
  static const double width = 18.0;

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
      builder: (_, bool? value, Function update) => Checkbox(
          tristate: tristate,
          mouseCursor: mouseCursor,
          activeColor: activeColor,
          fillColor: fillColor,
          checkColor: checkColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          overlayColor: overlayColor,
          splashRadius: splashRadius,
          materialTapTargetSize: materialTapTargetSize,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus,
          shape: shape,
          side: side,
          value: value,
          onChanged: (bool? v) async {
            if (onWaitChanged != null) {
              final result = onWaitChanged!.call(v);
              if (result) update(v);
            } else {
              onChanged?.call(v);
            }
          }));
}
