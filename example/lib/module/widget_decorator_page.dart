import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class WidgetDecoratorPage extends StatefulWidget {
  const WidgetDecoratorPage({Key? key}) : super(key: key);

  @override
  State<WidgetDecoratorPage> createState() => _WidgetDecoratorPageState();
}

class _WidgetDecoratorPageState extends State<WidgetDecoratorPage> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('WidgetDecorator Demo'),
        padding: const EdgeInsets.all(20),
        children: [
          const Partition('PinBox'),
          const SizedBox(height: 20),
          PinBox(
              maxLength: 5,
              autoFocus: false,
              spaces: const <Widget?>[
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
              ],
              hasFocusPinDecoration: BoxDecoration(
                  color: Colors.purple,
                  border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.circular(4)),
              pinDecoration: BoxDecoration(
                  color: Colors.yellow,
                  border: Border.all(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(4)),
              textStyle: const TextStyle(color: Colors.white)),
          const Partition('WidgetDecoratorState'),
          WidgetDecoratorState(
              gradient: const LinearGradient(colors: Colors.accents),
              focusNode: focusNode,
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
                    positioned: DecoratorPositioned.inner,
                    mode: OverlayVisibilityMode.notEditing,
                    widget: Text(' notEditing')),
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
          const Partition('WidgetDecoratorState.builder'),
          WidgetDecoratorState.builder(
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
                    positioned: DecoratorPositioned.inner,
                    mode: OverlayVisibilityMode.notEditing,
                    widget: Text(' notEditing')),
                DecoratorEntry(
                    positioned: DecoratorPositioned.outer,
                    widget: Text('outer')),
              ],
              builder: (FocusNode focusNode) => CupertinoTextField.borderless(
                    placeholder: '这里是HintText',
                    decoration:
                        BoxDecoration(color: Colors.blueGrey.withOpacity(0.4)),
                    focusNode: focusNode,
                  )),
          const Partition('WidgetDecorator'),
          WidgetDecorator(
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
              header: Row(children: const <Widget>[Text('header')]),
              footer: Row(children: const <Widget>[Text('footer')]),
              child: CupertinoTextField.borderless(
                  prefixMode: OverlayVisibilityMode.always,
                  prefix: Container(color: Colors.green, width: 20, height: 20),
                  suffixMode: OverlayVisibilityMode.editing,
                  suffix:
                      Container(color: Colors.green, width: 20, height: 20))),
        ]);
  }

//   Widget builderExtendedTextFieldBuilder(
//           {required ExtendedTextFieldBuilder builder}) =>
//       ExtendedTextField(
//           builder: builder,
//           decorator: WidgetDecoratorStyle(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               gradient: const LinearGradient(colors: Colors.accents),
//               header: Row(children: const <Widget>[Text(' header')]),
//               footer: Row(children: const <Widget>[Text(' footer')]),
//               fillColor: Colors.blue.withOpacity(0.2),
//               borderType: BorderType.outline,
//               borderSide: const BorderSide(color: Colors.yellow),
//               borderRadius: BorderRadius.circular(6)),
//           suffixes: const [
//             DecoratorEntry(mode: DecoratorMode.inner, widget: Text('inner')),
//             DecoratorEntry(mode: DecoratorMode.outer, widget: Text('outer')),
//             DecoratorEntry(
//                 mode: DecoratorMode.outermost, widget: Text('outer\nmost')),
//           ],
//           prefixes: const [
//             DecoratorEntry(mode: DecoratorMode.inner, widget: Text('inner')),
//             DecoratorEntry(mode: DecoratorMode.outer, widget: Text('outer')),
//             DecoratorEntry(
//                 mode: DecoratorMode.outermost, widget: Text('outer\nmost')),
//           ]);
}
