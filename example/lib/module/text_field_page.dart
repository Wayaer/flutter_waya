import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class TextFieldPage extends StatefulWidget {
  const TextFieldPage({super.key});

  @override
  State<TextFieldPage> createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('TextField'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('DecoratorBox with TextField'),
          DecoratorBox(
              decoration: BoxDecorative(
                borderType: BorderType.underline,
                borderRadius: BorderRadius.circular(4),
                fillColor: context.theme.primaryColor.withOpacity(0.2),
              ),
              child: TextField(
                decoration:
                    const InputDecoration(isDense: true).copyWithNoneBorder,
              )),
          10.heightBox,
          DecoratorBox(
              decoration: BoxDecorative(
                borderType: BorderType.outline,
                borderRadius: BorderRadius.circular(4),
                fillColor: context.theme.primaryColor.withOpacity(0.2),
              ),
              child: TextField(
                decoration:
                    const InputDecoration(isDense: true).copyWithNoneBorder,
              )),
          const Partition('PINTextField'),
          PINTextField(
              controller: controller,
              focusedDecoration: focusedDecoration,
              decoration: pinDecoration,
              onTap: () {
                showToast('点击 PINTextField');
              },
              spaces: const [
                null,
                Icon(Icons.ac_unit),
                Icon(Icons.ac_unit),
                Icon(Icons.ac_unit),
              ],
              onDone: (value) {
                log('PINTextField onDone:$value');
              },
              onChanged: (value) {
                log('PINTextField onChanged:$value');
              }),
          const Partition('PINTextField builder'),
          PINTextField(
              controller: controller1,
              focusedDecoration: focusedDecoration,
              decoration: pinDecoration,
              onChanged: (value) {
                log('PINTextField builder onChanged :$value');
              },
              onDone: (value) {
                log('PINTextField builder onDone:$value');
              },
              spaces: const [
                null,
                Icon(Icons.ac_unit),
                Icon(Icons.ac_unit),
                Icon(Icons.ac_unit),
              ],
              onTap: () {
                showToast('点击 PINTextField');
              },
              builder: (PINTextFieldBuilderConfig config) => TextField(
                  controller: config.controller,
                  decoration: config.decoration,
                  autofocus: config.autofocus,
                  obscureText: config.obscureText,
                  maxLines: config.maxLines,
                  minLines: config.minLines,
                  keyboardType: config.keyboardType,
                  style: config.style,
                  onTap: config.onTap,
                  showCursor: config.showCursor,
                  enableInteractiveSelection: config.enableInteractiveSelection,
                  contextMenuBuilder: config.contextMenuBuilder,
                  inputFormatters: config.inputFormatters)),
        ]);
  }

  BoxDecoration get focusedDecoration => BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: context.theme.primaryColor.withOpacity(0.2),
      border: Border.all(width: 2, color: context.theme.primaryColor));

  BoxDecoration get pinDecoration => BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(width: 2, color: Colors.grey));
}
