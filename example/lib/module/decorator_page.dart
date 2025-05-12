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
          const Partition('DecoratorBox hasFocus(true)', marginTop: 0),
          DecoratorBox(
              hasFocus: true,
              decoration: buildDecoration,
              child: TextField(focusNode: focusNodeWithDecoratorBox)),
          const Partition('DecoratorBox hasFocus(false)', marginTop: 0),
          DecoratorBox(
              hasFocus: false,
              decoration: buildDecoration,
              child: TextField(focusNode: focusNodeWithDecoratorBox)),
          const Partition('DecoratorBoxState with FocusNode'),
          DecoratorBoxState(
              listenable: Listenable.merge([focusNodeWithDecoratorBoxState]),
              onFocus: () => focusNodeWithDecoratorBoxState.hasFocus,
              decoration: buildDecoration,
              footers: footers(false),
              headers: headers(false),
              prefixes: prefixes(false),
              suffixes: suffixes(false),
              child: TextField(focusNode: focusNodeWithDecoratorBoxState)),
          const Partition('DecoratorBoxState with TextEditingController'),
          DecoratorBoxState(
              listenable: Listenable.merge([textEditingController]),
              onEditing: () => textEditingController.text.isNotEmpty,
              decoration: buildDecoration,
              footers: footers(true),
              headers: headers(true),
              prefixes: prefixes(true),
              suffixes: suffixes(true),
              child: TextField(controller: textEditingController)),
        ]);
  }

  BoxDecorative buildDecoration(bool hasFocus, bool isEditing) => BoxDecorative(
      fillColor: Colors.blue.withValues(alpha: 0.2),
      borderType: BorderType.outline,
      borderSide: hasFocus
          ? BorderSide(color: context.theme.primaryColor, width: 2)
          : context.theme.inputDecorationTheme.enabledBorder?.borderSide,
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10));

  List<DecoratorPendant> footers(bool isEditing) => [
        if (isEditing) ...[
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('editing'),
              mode: DecoratorPendantVisibilityMode.editing,
              positioned: DecoratorPendantPosition.outer),
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('notEditing'),
              mode: DecoratorPendantVisibilityMode.notEditing),
        ] else ...[
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('focused'),
              mode: DecoratorPendantVisibilityMode.focused,
              positioned: DecoratorPendantPosition.outer),
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('unfocused'),
              mode: DecoratorPendantVisibilityMode.unfocused),
        ]
      ];

  List<DecoratorPendant> headers(bool isEditing) => [
        if (isEditing) ...[
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('notEditing'),
              mode: DecoratorPendantVisibilityMode.notEditing),
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('editing'),
              mode: DecoratorPendantVisibilityMode.editing,
              positioned: DecoratorPendantPosition.outer),
        ] else ...[
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('focused'),
              mode: DecoratorPendantVisibilityMode.focused,
              positioned: DecoratorPendantPosition.outer),
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('unfocused'),
              mode: DecoratorPendantVisibilityMode.unfocused),
        ]
      ];

  List<DecoratorPendant> prefixes(bool isEditing) => [
        if (isEditing) ...[
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('editing'),
              mode: DecoratorPendantVisibilityMode.editing,
              positioned: DecoratorPendantPosition.outer),
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('notEditing'),
              mode: DecoratorPendantVisibilityMode.notEditing),
        ] else ...[
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('focused'),
              mode: DecoratorPendantVisibilityMode.focused,
              positioned: DecoratorPendantPosition.outer),
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('unfocused'),
              mode: DecoratorPendantVisibilityMode.unfocused),
        ]
      ];

  List<DecoratorPendant> suffixes(bool isEditing) => [
        if (isEditing) ...[
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('editing'),
              mode: DecoratorPendantVisibilityMode.editing,
              positioned: DecoratorPendantPosition.outer),
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('notEditing'),
              mode: DecoratorPendantVisibilityMode.notEditing),
        ] else ...[
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('focused'),
              mode: DecoratorPendantVisibilityMode.focused,
              positioned: DecoratorPendantPosition.outer),
          const DecoratorPendant(
              maintainSize: true,
              widget: Text('unfocused'),
              mode: DecoratorPendantVisibilityMode.unfocused),
        ]
      ];
}
