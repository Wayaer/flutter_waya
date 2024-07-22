import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_waya/flutter_waya.dart';

class TextFieldPage extends StatelessWidget {
  const TextFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('TextField'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('TextFieldWithDecoratorBox with TextField'),
          builderTextFieldWithDecoratorBoxBuilder(
              builder: (FocusNode? focusNode) =>
                  TextField(focusNode: focusNode)),
          const Partition('TextFieldWithDecoratorBox with TextFormField'),
          builderTextFieldWithDecoratorBoxBuilder(
              builder: (FocusNode? focusNode) =>
                  TextFormField(focusNode: focusNode)),
          const Partition('TextFieldWithDecoratorBox with CupertinoTextField'),
          builderTextFieldWithDecoratorBoxBuilder(
              builder: (FocusNode? focusNode) =>
                  CupertinoTextField(focusNode: focusNode)),
          const Partition(
              'TextFieldWithDecoratorBox with CupertinoTextField.borderless'),
          builderTextFieldWithDecoratorBoxBuilder(
              builder: (FocusNode? focusNode) =>
                  CupertinoTextField.borderless(focusNode: focusNode)),
        ]);
  }

  Widget builderTextFieldWithDecoratorBoxBuilder(
          {required TextFieldWithDecoratedBuilder builder}) =>
      TextFieldWithDecoratorBox(
          builder: builder,
          disposeFocusNode: true,
          focusNode: FocusNode(),
          header: const Row(children: [Text(' header')]),
          footer: const Row(children: [Text(' footeßr')]),
          decoration: FlBoxDecoration(
            // border: OutlineDecoratorBorder( borderRadius: BorderRadius.circular(0)),
            padding: const EdgeInsets.symmetric(vertical: 10),
            // gradient: const LinearGradient(colors: Colors.accents),
            // fillColor: Colors.red.withOpacity(0.2),
            // borderType: BorderType.outline,
            // borderSide: const BorderSide(color: Colors.yellow),
            // borderRadius: BorderRadius.circular(6),
          ),
          suffixes: [
            const Text('inner').toDecoratedPendant(
                positioned: DecoratedPendantPosition.inner,
                maintainSize: true,
                mode: OverlayVisibilityMode.editing),
            const DecoratedPendant(
                mode: OverlayVisibilityMode.notEditing,
                positioned: DecoratedPendantPosition.outer,
                maintainSize: true,
                widget: Text('outer')),
          ],
          prefixes: const [
            DecoratedPendant(
                mode: OverlayVisibilityMode.editing,
                positioned: DecoratedPendantPosition.inner,
                maintainSize: true,
                widget: Text('inner')),
            DecoratedPendant(
                mode: OverlayVisibilityMode.notEditing,
                positioned: DecoratedPendantPosition.outer,
                maintainSize: true,
                widget: Text('outer')),
          ]);
}
