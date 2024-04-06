import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter_waya/flutter_waya.dart';

import '../main.dart';

class FlDecoratedBoxPage extends StatefulWidget {
  const FlDecoratedBoxPage({super.key});

  @override
  State<FlDecoratedBoxPage> createState() => _FlDecoratedBoxPageState();
}

class _FlDecoratedBoxPageState extends ExtendedState<FlDecoratedBoxPage> {
  FocusNode focusNode = FocusNode();
  FocusNode focusNode1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('DecoratorBox'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('DecoratorBoxState'),
          FlDecoratedBoxState(
              focusNode: focusNode,
              decoration: FlBoxDecoration(
                  gradient: const LinearGradient(colors: Colors.accents),
                  borderType: BorderType.outline,
                  padding: const EdgeInsets.all(2),
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  fillColor: Colors.blue.withOpacity(0.2),
                  constraints: const BoxConstraints(minHeight: 45)),
              focusBorderSide: const BorderSide(color: Colors.red, width: 1),
              prefixes: const [
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.outer,
                    widget: Text('outer')),
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.inner,
                    mode: OverlayVisibilityMode.editing,
                    widget: Text('inner')),
              ],
              suffixes: const [
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.inner,
                    mode: OverlayVisibilityMode.editing,
                    widget: Text('editing')),
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.inner,
                    mode: OverlayVisibilityMode.notEditing,
                    widget: Text('notEditing')),
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.outer,
                    mode: OverlayVisibilityMode.notEditing,
                    maintainSize: true,
                    widget: Text('maintainSize')),
              ],
              child: CupertinoTextField.borderless(
                placeholder: 'HintText',
                decoration:
                    BoxDecoration(color: Colors.blueGrey.withOpacity(0.4)),
                focusNode: focusNode,
              )),
          const Partition('DecoratorBoxState.builder'),
          FlDecoratedBoxState.builder(
              focusNode: FocusNode(),
              decoration: FlBoxDecoration(
                  gradient: const LinearGradient(colors: Colors.accents),
                  padding: const EdgeInsets.all(2),
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  fillColor: Colors.blue.withOpacity(0.2),
                  constraints: const BoxConstraints(minHeight: 45)),
              focusBorderSide: const BorderSide(color: Colors.red, width: 1),
              prefixes: const [
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.outer,
                    widget: Text('outer')),
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.inner,
                    mode: OverlayVisibilityMode.editing,
                    widget: Text('inner')),
              ],
              suffixes: const [
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.inner,
                    mode: OverlayVisibilityMode.editing,
                    widget: Text('editing')),
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.inner,
                    mode: OverlayVisibilityMode.notEditing,
                    widget: Text('notEditing')),
                DecoratedPendant(
                    positioned: DecoratedPendantPosition.outer,
                    maintainSize: true,
                    mode: OverlayVisibilityMode.editing,
                    widget: Text('maintainSize')),
              ],
              builder: (FocusNode focusNode) => CupertinoTextField.borderless(
                    placeholder: 'HintText',
                    autofocus: true,
                    decoration:
                        BoxDecoration(color: Colors.blueGrey.withOpacity(0.4)),
                    focusNode: focusNode,
                  )),
          const Partition('DecoratorBox'),
          FlDecoratedBox(
              decoration: FlBoxDecoration(
                  gradient: const LinearGradient(colors: Colors.accents),
                  borderType: BorderType.outline,
                  fillColor: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.black),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
              extraPrefix: const Text('extra'),
              extraSuffix: const Text('extra'),
              prefix: const Text('prefix'),
              suffix: const Text('suffix'),
              header: const Row(children: [Text('header')]),
              footer: const Row(children: [Text('footer')]),
              child: CupertinoTextField.borderless(
                  prefixMode: OverlayVisibilityMode.always,
                  prefix: Container(color: Colors.green, width: 20, height: 20),
                  suffixMode: OverlayVisibilityMode.editing,
                  suffix:
                      Container(color: Colors.green, width: 20, height: 20))),
        ]);
  }
}
