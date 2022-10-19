import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/flutter_waya.dart';

class TextFieldPage extends StatelessWidget {
  const TextFieldPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('TextField'),
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
          const Partition('ExtendedTextField with TextField'),
          builderExtendedTextFieldBuilder(
              builder: (TextInputType keyboardType,
                      List<TextInputFormatter> inputFormatters,
                      Widget? suffix,
                      Widget? prefix) =>
                  TextField(
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(suffix: suffix, prefix: prefix),
                  )),
          const Partition('ExtendedTextField with TextFormField'),
          builderExtendedTextFieldBuilder(
              builder: (TextInputType keyboardType,
                      List<TextInputFormatter> inputFormatters,
                      Widget? suffix,
                      Widget? prefix) =>
                  TextFormField(
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(suffix: suffix, prefix: prefix),
                  )),
          const Partition('ExtendedTextField with CupertinoTextField'),
          builderExtendedTextFieldBuilder(
              builder: (TextInputType keyboardType,
                      List<TextInputFormatter> inputFormatters,
                      Widget? suffix,
                      Widget? prefix) =>
                  CupertinoTextField(
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      suffixMode: OverlayVisibilityMode.editing,
                      suffix: suffix,
                      prefixMode: OverlayVisibilityMode.editing,
                      prefix: prefix)),
          const Partition(
              'ExtendedTextField with CupertinoTextField.borderless'),
          builderExtendedTextFieldBuilder(
              builder: (TextInputType keyboardType,
                      List<TextInputFormatter> inputFormatters,
                      Widget? suffix,
                      Widget? prefix) =>
                  CupertinoTextField.borderless(
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      suffixMode: OverlayVisibilityMode.editing,
                      suffix: suffix,
                      prefixMode: OverlayVisibilityMode.editing,
                      prefix: prefix)),
        ]);
  }

  Widget builderExtendedTextFieldBuilder(
          {required ExtendedTextFieldBuilder builder}) =>
      ExtendedTextField(
          builder: builder,
          decorator: DecoratorBoxStyle(
              padding: const EdgeInsets.symmetric(vertical: 10),
              gradient: const LinearGradient(colors: Colors.accents),
              header: Row(children: const <Widget>[Text(' header')]),
              footer: Row(children: const <Widget>[Text(' footer')]),
              fillColor: Colors.blue.withOpacity(0.2),
              borderType: BorderType.outline,
              borderSide: const BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.circular(6)),
          suffixes: [
            ...const Text('inner')
                .toDecoratorEntry(positioned: DecoratorPositioned.inner)
                .convertToList(),
            const DecoratorEntry(
                mode: OverlayVisibilityMode.always,
                positioned: DecoratorPositioned.outer,
                widget: Text('outer')),
            const DecoratorEntry(
                mode: OverlayVisibilityMode.always,
                positioned: DecoratorPositioned.outermost,
                widget: Text('outer\nmost')),
          ],
          prefixes: const [
            DecoratorEntry(
                mode: OverlayVisibilityMode.always,
                positioned: DecoratorPositioned.inner,
                widget: Text('inner')),
            DecoratorEntry(
                mode: OverlayVisibilityMode.always,
                positioned: DecoratorPositioned.outer,
                widget: Text('outer')),
            DecoratorEntry(
                mode: OverlayVisibilityMode.always,
                positioned: DecoratorPositioned.outermost,
                widget: Text('outer\nmost')),
          ]);
}
