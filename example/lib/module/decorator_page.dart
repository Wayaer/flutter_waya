import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter_waya/flutter_waya.dart';

class DecoratorBoxPage extends StatefulWidget {
  const DecoratorBoxPage({super.key});

  @override
  State<DecoratorBoxPage> createState() => _DecoratorBoxPageState();
}

class _DecoratorBoxPageState extends ExtendedState<DecoratorBoxPage> {
  FocusNode focusNodeWithDecoratorBox = FocusNode();
  FocusNode focusNodeWithDecoratorBoxState = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('DecoratorBox'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('DecoratorBox'),
          DecoratorBox(
              decoration: decoration,
              footers: footers,
              headers: headers,
              prefixes: prefixes,
              suffixes: suffixes,
              expand: true,
              child: TextField(focusNode: focusNodeWithDecoratorBox)),
          const Partition('DecoratorBoxState with FocusNode'),
          DecoratorBoxState(
              listenable: Listenable.merge([focusNodeWithDecoratorBoxState]),
              onFocus: () => focusNodeWithDecoratorBoxState.hasFocus,
              decoration: decoration,
              footers: footers,
              headers: headers,
              prefixes: prefixes,
              suffixes: suffixes,
              expand: true,
              child: TextField(focusNode: focusNodeWithDecoratorBoxState)),
          const Partition('DecoratorBoxState with TextEditingController'),
          DecoratorBoxState(
              listenable: Listenable.merge([textEditingController]),
              onFocus: () => textEditingController.text.isNotEmpty,
              decoration: decoration,
              footers: footers,
              headers: headers,
              prefixes: prefixes,
              suffixes: suffixes,
              expand: true,
              child: TextField(controller: textEditingController)),
        ]);
  }

  BoxDecorative get decoration => BoxDecorative(
      fillColor: Colors.blue.withOpacity(0.2),
      borderType: BorderType.outline,
      borderSide: context.theme.inputDecorationTheme.enabledBorder?.borderSide,
      focusedBorderSide:
          context.theme.inputDecorationTheme.focusedBorder?.borderSide ??
              BorderSide(color: context.theme.primaryColor),
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10));

  List<DecoratorPendant> get footers => const [
        DecoratorPendant(
            widget: Text('footer'),
            maintainSize: true,
            mode: DecoratorPendantVisibilityMode.focused),
        DecoratorPendant(
            widget: Text('footer'),
            maintainSize: true,
            mode: DecoratorPendantVisibilityMode.unfocused,
            positioned: DecoratorPendantPosition.outer),
      ];

  List<DecoratorPendant> get headers => const [
        DecoratorPendant(
            widget: Text('header'),
            maintainSize: true,
            mode: DecoratorPendantVisibilityMode.focused),
        DecoratorPendant(
            widget: Text('header'),
            maintainSize: true,
            mode: DecoratorPendantVisibilityMode.unfocused,
            positioned: DecoratorPendantPosition.outer),
      ];

  List<DecoratorPendant> get prefixes => const [
        DecoratorPendant(
            widget: Text('prefix'),
            maintainSize: true,
            mode: DecoratorPendantVisibilityMode.focused),
        DecoratorPendant(
            widget: Text('prefix'),
            maintainSize: true,
            mode: DecoratorPendantVisibilityMode.unfocused,
            positioned: DecoratorPendantPosition.outer),
      ];

  List<DecoratorPendant> get suffixes => const [
        DecoratorPendant(
            widget: Text('suffix'),
            maintainSize: true,
            mode: DecoratorPendantVisibilityMode.focused),
        DecoratorPendant(
            widget: Text('suffix'),
            maintainSize: true,
            mode: DecoratorPendantVisibilityMode.unfocused,
            positioned: DecoratorPendantPosition.outer),
      ];
}
