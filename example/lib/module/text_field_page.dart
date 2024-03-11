import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          const Partition('PinBox'),
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
                  color: context.theme.disabledColor,
                  border: Border.all(color: context.theme.primaryColor),
                  borderRadius: BorderRadius.circular(4)),
              pinDecoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  border: Border.all(color: context.theme.disabledColor),
                  borderRadius: BorderRadius.circular(4))),
          const Partition('PinBox builder'),
          PinBox(
              builder: (PinTextFieldBuilderConfig builderConfig) => TextField(
                  focusNode: builderConfig.focusNode,
                  decoration: builderConfig.decoration,
                  autofocus: builderConfig.autofocus,
                  maxLines: builderConfig.maxLines,
                  minLines: builderConfig.minLines,
                  onChanged: builderConfig.onChanged,
                  keyboardType: builderConfig.keyboardType,
                  maxLength: builderConfig.maxLength,
                  style: builderConfig.style,
                  showCursor: builderConfig.showCursor,
                  inputFormatters: builderConfig.inputFormatters),
              maxLength: 5,
              obscureText: true,
              autoFocus: false,
              textBuilder: (_) => _.isEmpty
                  ? const Icon(Icons.ac_unit, size: 14)
                  : const Text('Hide'),
              spaces: const <Widget?>[
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
                Icon(Icons.ac_unit, size: 12),
              ],
              hasFocusPinDecoration: BoxDecoration(
                  color: context.theme.disabledColor,
                  border: Border.all(color: context.theme.primaryColor),
                  borderRadius: BorderRadius.circular(4)),
              pinDecoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  border: Border.all(color: context.theme.disabledColor),
                  borderRadius: BorderRadius.circular(4)),
              textStyle: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
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
              header: const Row(children: [Text(' header')]),
              footer: const Row(children: [Text(' footer')]),
              fillColor: Colors.blue.withOpacity(0.2),
              borderType: BorderType.outline,
              borderSide: const BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.circular(6)),
          suffixes: [
            ...const Text('inner')
                .toDecoratorEntry(positioned: DecoratorPositioned.inner)
                .toList,
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
