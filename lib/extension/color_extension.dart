import 'package:flutter/material.dart';

extension ExtensionColor on Color {
  bool get isTransparent => alpha == 0;

  MaterialColor get swatch =>
      Colors.primaries.firstWhere((Color c) => c.value == value,
          orElse: () => MaterialColor(value, getMaterialColorValues));

  Map<int, Color> get getMaterialColorValues => {
        50: _swatchShade(50),
        100: _swatchShade(100),
        200: _swatchShade(200),
        300: _swatchShade(300),
        400: _swatchShade(400),
        500: _swatchShade(500),
        600: _swatchShade(600),
        700: _swatchShade(700),
        800: _swatchShade(800),
        900: _swatchShade(900)
      };

  Color _swatchShade(int swatchValue) => HSLColor.fromColor(this)
      .withLightness(1 - (swatchValue / 1000))
      .toColor();

  Color get withBrightness {
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      return this;
    } else {
      return getMaterialColorValues[800]!;
    }
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true`.
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
