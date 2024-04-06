import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          const Partition('TextFieldWithFlDecoratedBox with TextField'),
          builderTextFieldWithFlDecoratedBoxBuilder(
              builder: (FocusNode? focusNode) =>
                  TextField(focusNode: focusNode)),
          const Partition('TextFieldWithFlDecoratedBox with TextFormField'),
          builderTextFieldWithFlDecoratedBoxBuilder(
              builder: (FocusNode? focusNode) =>
                  TextFormField(focusNode: focusNode)),
          const Partition(
              'TextFieldWithFlDecoratedBox with CupertinoTextField'),
          builderTextFieldWithFlDecoratedBoxBuilder(
              builder: (FocusNode? focusNode) =>
                  CupertinoTextField(focusNode: focusNode)),
          const Partition(
              'TextFieldWithFlDecoratedBox with CupertinoTextField.borderless'),
          builderTextFieldWithFlDecoratedBoxBuilder(
              builder: (FocusNode? focusNode) =>
                  CupertinoTextField.borderless(focusNode: focusNode)),
        ]);
  }

  Widget builderTextFieldWithFlDecoratedBoxBuilder(
          {required TextFieldWithDecoratedBuilder builder}) =>
      TextFieldWithFlDecoratedBox(
          builder: builder,
          disposeFocusNode: true,
          focusNode: FocusNode(),
          header: const Row(children: [Text(' header')]),
          footer: const Row(children: [Text(' footer')]),
          decoration: FlBoxDecoration(
              padding: const EdgeInsets.symmetric(vertical: 10),
              gradient: const LinearGradient(colors: Colors.accents),
              fillColor: Colors.blue.withOpacity(0.2),
              borderType: BorderType.outline,
              borderSide: const BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.circular(6)),
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
