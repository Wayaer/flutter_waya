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
        appBar: AppBarText('TextField Demo'),
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
                      InputDecoration? decoration) =>
                  TextField(
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: decoration,
                  )),
          const Partition('ExtendedTextField with TextFormField'),
          builderExtendedTextFieldBuilder(
              builder: (TextInputType keyboardType,
                      List<TextInputFormatter> inputFormatters,
                      InputDecoration? decoration) =>
                  TextFormField(
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: decoration,
                  )),
          const Partition('ExtendedTextField with CupertinoTextField'),
          builderExtendedTextFieldBuilder(
              builder: (TextInputType keyboardType,
                      List<TextInputFormatter> inputFormatters,
                      InputDecoration? decoration) =>
                  CupertinoTextField(
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      suffixMode: OverlayVisibilityMode.editing,
                      suffix: decoration?.suffix,
                      prefixMode: OverlayVisibilityMode.editing,
                      prefix: decoration?.prefix)),
          const Partition(
              'ExtendedTextField with CupertinoTextField.borderless'),
          builderExtendedTextFieldBuilder(
              builder: (TextInputType keyboardType,
                      List<TextInputFormatter> inputFormatters,
                      InputDecoration? decoration) =>
                  CupertinoTextField.borderless(
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      suffixMode: OverlayVisibilityMode.editing,
                      suffix: decoration?.suffix,
                      prefixMode: OverlayVisibilityMode.editing,
                      prefix: decoration?.prefix)),
          const Partition('WidgetDecorator'),
          WidgetDecorator(
              gradient: const LinearGradient(colors: Colors.accents),
              borderType: BorderType.outline,
              fillColor: Colors.amberAccent,
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

  Widget builderExtendedTextFieldBuilder(
          {required ExtendedTextFieldBuilder builder}) =>
      ExtendedTextField(
        builder: builder,
        decorator: WidgetDecoratorStyle(
            padding: const EdgeInsets.symmetric(vertical: 10),
            gradient: const LinearGradient(colors: Colors.accents),
            header: Row(children: const <Widget>[Text(' header')]),
            footer: Row(children: const <Widget>[Text(' footer')]),
            fillColor: Colors.blue.withOpacity(0.2),
            borderType: BorderType.outline,
            borderSide: const BorderSide(color: Colors.yellow),
            borderRadius: BorderRadius.circular(6)),
        suffixes: const [
          AccessoryEntry(mode: AccessoryMode.editing, widget: Text('editing')),
          AccessoryEntry(mode: AccessoryMode.inner, widget: Text('inner')),
          AccessoryEntry(mode: AccessoryMode.outer, widget: Text('outer')),
          AccessoryEntry(
              mode: AccessoryMode.outermost, widget: Text('outer\nmost')),
        ],
        prefixes: const [
          AccessoryEntry(mode: AccessoryMode.editing, widget: Text('editing')),
          AccessoryEntry(mode: AccessoryMode.inner, widget: Text('inner')),
          AccessoryEntry(mode: AccessoryMode.outer, widget: Text('outer')),
          AccessoryEntry(
              mode: AccessoryMode.outermost, widget: Text('outer\nmost')),
        ],
        hideCounter: true,
        decoration: InputDecoration(
            label: const Text('label'),
            // helperText: 'helperText',
            // errorText: 'errorText',
            suffixIcon: const Text(' icon '),
            prefixIcon: const Text(' icon '),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.withOpacity(0.5))),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54)),
            fillColor: Colors.blue.withOpacity(0.2),
            filled: true),
      );
}
