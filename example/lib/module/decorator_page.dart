import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class DecoratorBoxPage extends StatefulWidget {
  const DecoratorBoxPage({Key? key}) : super(key: key);

  @override
  State<DecoratorBoxPage> createState() => _DecoratorBoxPageState();
}

class _DecoratorBoxPageState extends ExtendedState<DecoratorBoxPage> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('DecoratorBox'),
        padding: const EdgeInsets.all(20),
        children: [
          const Partition('DecoratorBoxState'),
          DecoratorBoxState(
              gradient: const LinearGradient(colors: Colors.accents),
              focusNode: focusNode,
              borderType: BorderType.outline,
              padding: const EdgeInsets.all(2),
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Colors.black, width: 1),
              focusBorderSide: const BorderSide(color: Colors.red, width: 1),
              fillColor: Colors.blue.withOpacity(0.2),
              constraints: const BoxConstraints(minHeight: 45),
              suffixes: const [
                DecoratorEntry(
                    positioned: DecoratorPositioned.inner,
                    mode: OverlayVisibilityMode.editing,
                    widget: Text('editing ')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.inner,
                    mode: OverlayVisibilityMode.notEditing,
                    widget: Text('notEditing ')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.inner,
                    widget: Text('inner')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.outer,
                    widget: Text('outer')),
              ],
              prefixes: const [
                DecoratorEntry(
                    positioned: DecoratorPositioned.inner,
                    widget: Text('inner')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.outer,
                    widget: Text('outer')),
              ],
              child: CupertinoTextField.borderless(
                placeholder: '这里是HintText',
                decoration:
                    BoxDecoration(color: Colors.blueGrey.withOpacity(0.4)),
                focusNode: focusNode,
              )),
          const Partition('DecoratorBoxState.builder'),
          DecoratorBoxState.builder(
              gradient: const LinearGradient(colors: Colors.accents),
              padding: const EdgeInsets.all(2),
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Colors.black, width: 1),
              focusBorderSide: const BorderSide(color: Colors.red, width: 1),
              fillColor: Colors.blue.withOpacity(0.2),
              constraints: const BoxConstraints(minHeight: 45),
              suffixes: const [
                DecoratorEntry(
                    positioned: DecoratorPositioned.inner,
                    mode: OverlayVisibilityMode.editing,
                    widget: Text('editing ')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.inner,
                    mode: OverlayVisibilityMode.notEditing,
                    widget: Text('notEditing ')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.inner,
                    widget: Text('inner')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.outer,
                    widget: Text('outer')),
              ],
              prefixes: const [
                DecoratorEntry(
                    positioned: DecoratorPositioned.inner,
                    widget: Text('inner')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.outer,
                    widget: Text('outer')),
              ],
              builder: (FocusNode focusNode) => CupertinoTextField.borderless(
                    placeholder: '这里是HintText',
                    autofocus: true,
                    decoration:
                        BoxDecoration(color: Colors.blueGrey.withOpacity(0.4)),
                    focusNode: focusNode,
                  )),
          const Partition('DecoratorBox'),
          DecoratorBox(
              gradient: const LinearGradient(colors: Colors.accents),
              borderType: BorderType.outline,
              fillColor: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Colors.black),
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              extraPrefix: const Text('extra'),
              extraSuffix: const Text('extra'),
              prefix: const Text('prefix'),
              suffix: const Text('suffix'),
              header: Row(children: const [Text('header')]),
              footer: Row(children: const [Text('footer')]),
              child: CupertinoTextField.borderless(
                  prefixMode: OverlayVisibilityMode.always,
                  prefix: Container(color: Colors.green, width: 20, height: 20),
                  suffixMode: OverlayVisibilityMode.editing,
                  suffix:
                      Container(color: Colors.green, width: 20, height: 20))),
        ]);
  }
}
