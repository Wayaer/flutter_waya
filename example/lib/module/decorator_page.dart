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
  FocusNode focusNode1 = FocusNode();
  TextEditingController editingController1 = TextEditingController();
  FocusNode focusNode2 = FocusNode();
  TextEditingController editingController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('DecoratorBox'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('DecoratorBox hasFocus(true)', marginTop: 0),
          DecoratorBox(
              hasFocus: true, decoration: buildDecoration, child: TextField()),
          const Partition('DecoratorBox hasFocus(false)', marginTop: 0),
          DecoratorBox(
              hasFocus: false, decoration: buildDecoration, child: TextField()),
          const Partition('DecoratorBoxState with FocusNode'),
          DecoratorBoxState(
              listenable: Listenable.merge([focusNode1]),
              onFocus: () => focusNode1.hasFocus,
              decoration: buildDecoration,
              footers: buildPendants,
              headers: buildPendants,
              prefixes: buildPendants,
              suffixes: buildPendants,
              child: TextField(focusNode: focusNode1)),
          const Partition('DecoratorBoxState with TextEditingController'),
          DecoratorBoxState(
              listenable: Listenable.merge([editingController1]),
              onEditing: () => editingController1.text.isNotEmpty,
              decoration: buildDecoration,
              footers: buildPendants,
              headers: buildPendants,
              prefixes: buildPendants,
              suffixes: buildPendants,
              child: TextField(controller: editingController1)),
          const Partition(
              'DecoratorBoxState with FocusNode TextEditingController'),
          DecoratorBoxState(
              listenable: Listenable.merge([focusNode2, editingController2]),
              onFocus: () => focusNode2.hasFocus,
              onEditing: () => editingController2.text.isNotEmpty,
              decoration: buildDecoration,
              footers: buildPendants,
              headers: buildPendants,
              prefixes: buildPendants,
              suffixes: buildPendants,
              child: TextField(
                  focusNode: focusNode2, controller: editingController2)),
        ]);
  }

  BoxDecorative buildDecoration(bool hasFocus, bool isEditing) => BoxDecorative(
      fillColor: Colors.blue.withValues(alpha: 0.2),
      borderType: BorderType.outline,
      borderSide: hasFocus
          ? BorderSide(color: context.theme.colorScheme.primary, width: 2)
          : BorderSide(
              color: context.theme.colorScheme.primaryContainer, width: 2),
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10));

  List<DecoratorPendant> get buildPendants => [
        ...DecoratorPendantVisibilityMode.values.builder((mode) =>
            DecoratorPendant(
                maintainSize: false,
                widget: Text(' ${mode.index} '),
                mode: mode,
                positioned: DecoratorPendantPosition.inner)),
        ...DecoratorPendantVisibilityMode.values.builder((mode) =>
            DecoratorPendant(
                maintainSize: false,
                widget: Text(' ${mode.index} '),
                mode: mode,
                positioned: DecoratorPendantPosition.outer))
      ];
}
