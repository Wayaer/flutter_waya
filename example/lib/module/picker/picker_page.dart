import 'package:app/main.dart';
import 'package:app/module/picker/area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

part 'date_time_picker.dart';

part 'date_picker.dart';

part 'area_picker.dart';

part 'multi_list_linkage_picker.dart';

part 'multi_list_wheel_picker.dart';

part 'multi_list_wheel_linkage_picker.dart';

part 'single_list_picker.dart';

part 'single_list_wheel_picker.dart';

final numberList = ['一', '二', '三', '四', '五', '六', '七', '八', '十'];

final List<String> letterList = ['A', 'B', 'C', 'D', 'E', 'F'];

final Map<String, dynamic> mapABC = {
  'A1': ['A2'],
  'B1': {
    'B2': [
      'B3',
      'B3',
      'B3',
    ],
    'B2-1': {
      'B3': [
        'B4',
        'B4',
        'B4',
      ]
    }
  },
  'C1': {
    'C2': {
      'C3': {
        'C4': {
          'C5': [
            'C6',
            'C6',
            'C6',
            'C6',
            'C6',
          ]
        }
      }
    },
    'C21': [
      'C3',
      'C3',
      'C3',
    ],
    'C22': [
      'C3',
      'C3',
      'C3',
    ]
  }
};

class BackCard extends Card {
  const BackCard(
    Widget child, {
    super.key,
    super.margin = const EdgeInsets.only(top: 10),
  }) : super(child: child);
}

class BasePickerOptions<T> extends PickerOptions<T> {
  BasePickerOptions(
      {super.cancel = const BText('取消'),
      super.title = const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [BText('选择器')]),
      super.confirm = const BText('确定'),
      super.top,
      super.decoration,
      super.bottom =
          const Divider(thickness: 0.5, height: 0.5, color: Colors.black12),
      super.padding = const EdgeInsets.symmetric(horizontal: 10),
      super.contentPadding,
      super.background,
      super.backgroundColor,
      super.verifyConfirm,
      super.verifyCancel,
      super.bottomNavigationBar = const BText('bottomNavigationBar')});
}

class PickerPage extends StatelessWidget {
  const PickerPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          appBar: AppBarText('Picker'),
          padding: const EdgeInsets.all(20),
          isScroll: true,
          children: [
            ElevatedText('DatePicker', onTap: () {
              push(_DatePickerPage());
            }),
            10.heightBox,
            ElevatedText('DateTimePicker', onTap: () {
              push(_DateTimePickerPage());
            }),
            10.heightBox,
            ElevatedText('AreaPicker', onTap: () {
              push(const _AreaPickerPage());
            }),
            10.heightBox,
            ElevatedText('MultiListLinkagePicker', onTap: () {
              push(const _MultiListLinkagePicker());
            }),
            10.heightBox,
            ElevatedText('MultiListWheelPicker', onTap: () {
              push(const _MultiListWheelPicker());
            }),
            10.heightBox,
            ElevatedText('MultiListWheelLinkagePicker', onTap: () {
              push(const _MultiListWheelLinkagePicker());
            }),
            10.heightBox,
            ElevatedText('SingleListPicker', onTap: () {
              push(const _SingleListPickerPage());
            }),
            10.heightBox,
            ElevatedText('SingleListWheelPicker', onTap: () {
              push(const _SingleListWheelPickerPage());
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
