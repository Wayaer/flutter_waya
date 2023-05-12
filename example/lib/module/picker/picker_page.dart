import 'package:app/main.dart';
import 'package:app/module/picker/area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'date_time_picker.dart';

part 'area_picker.dart';

part 'multi_list_linkage_picker.dart';

part 'multi_list_wheel_picker.dart';

part 'multi_list_wheel_linkage_picker.dart';

part 'single_list_picker.dart';

part 'single_list_wheel_picker.dart';

Widget _addBackboard(Widget child) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
        boxShadow: getBoxShadow(), borderRadius: BorderRadius.circular(12)),
    child: child);

class PickerPage extends StatelessWidget {
  const PickerPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          appBar: AppBarText('Picker'),
          padding: const EdgeInsets.all(20),
          isScroll: true,
          children: [
            ElevatedText('AreaPicker', onTap: () {
              push(const _AreaPickerPage());
            }),
            10.heightBox,
            ElevatedText('DateTimePicker', onTap: () {
              push(_DateTimePickerPage());
            }),
            10.heightBox,
            ElevatedText('SingleListPicker', onTap: () {
              push(_SingleListPickerPage());
            }),
            10.heightBox,
            ElevatedText('SingleListWheelPicker', onTap: () {
              push(_SingleListWheelPickerPage());
            }),
            10.heightBox,
            ElevatedText('MultiListLinkagePicker', onTap: () {
              push(const _MultiListLinkagePicker());
            }),
            10.heightBox,
            ElevatedText('MultiListWheelPicker', onTap: () {
              push(_MultiListWheelPicker());
            }),
            10.heightBox,
            ElevatedText('MultiListWheelLinkagePicker', onTap: () {
              push(_MultiListWheelLinkagePicker());
            }),
            10.heightBox,
            ElevatedText('show CustomPicker', onTap: customPicker),
          ]);

  Future<void> customPicker() async {
    final String? data = await CustomPicker<String>(
        options: PickerOptions<String>(
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            verifyConfirm: (String? value) {
              log('verifyConfirm $value');
              return true;
            },
            verifyCancel: (String? value) {
              log('verifyCancel $value');
              return true;
            },
            title: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(6)),
                child: const BText('Title'))),
        content: Container(
            height: 300,
            alignment: Alignment.center,
            color: Colors.blue.withOpacity(0.2),
            child: const BText('showCustomPicker', color: Colors.black)),
        confirmTap: () {
          return 'Confirm';
        },
        cancelTap: () {
          return 'Cancel';
        }).show<
            String>(
        options: BottomSheetOptions(
            backgroundColor: Colors.transparent,
            barrierColor: Colors.red.withOpacity(0.3)));
    showToast(data.toString());
  }
}
