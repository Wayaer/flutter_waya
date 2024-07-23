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
    return Theme(
      data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide:
                BorderSide(width: 2, color: context.theme.primaryColor)),
      )),
      child: ExtendedScaffold(
          isScroll: true,
          appBar: AppBarText('TextField'),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const Partition('PINTextField'),
            PINTextField(
              controller: controller,
              focusedDecoration: focusedDecoration,
              decoration: pinDecoration,
            ),
            const Partition('PINTextField builder'),
            PINTextField(
                controller: controller1,
                focusedDecoration: focusedDecoration,
                decoration: pinDecoration,
                builder: (PINTextFieldBuilderConfig config) =>
                    TextField(controller: controller1)),
          ]),
    );
  }

  BoxDecoration get focusedDecoration => BoxDecoration(
      border: Border.all(width: 1, color: context.theme.primaryColor));

  BoxDecoration get pinDecoration =>
      BoxDecoration(border: Border.all(width: 1, color: Colors.grey));
}
