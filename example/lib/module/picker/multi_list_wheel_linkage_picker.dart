part of 'picker_page.dart';

class _MultiListWheelLinkagePicker extends StatelessWidget {
  _MultiListWheelLinkagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiListWheelLinkagePicker'),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isScroll: true,
        children: [
          const Partition('MultiListWheelLinkagePicker'),
          ElevatedText('show MultiListWheelLinkagePicker with area',
              onTap: () =>
                  multiListWheelLinkagePicker(mapToLinkageEntry(areaDataMap))),
          20.heightBox,
          ElevatedText('show MultiListWheelLinkagePicker',
              onTap: () =>
                  multiListWheelLinkagePicker(multiListWheelLinkageList)),
          Backboard(MultiListWheelLinkagePicker<String>(
              options: null,
              height: 150,
              // onChanged: (List<int> index) {
              //   log('MultiListWheelLinkagePicker onChanged= $index');
              // },
              // onValueChanged: (List<String> list) {
              //   log('MultiListWheelLinkagePicker onValueChanged= $list');
              // },
              entry: multiListWheelLinkageList,
              isScrollable: true)),
        ]);
  }

  List<PickerLinkageEntry<String>> mapToLinkageEntry(Map<String, dynamic> map) {
    List<PickerLinkageEntry<String>> buildEntry(Map<String, dynamic> map) =>
        map.builderEntry((entry) {
          final value = entry.value;
          List<PickerLinkageEntry<String>> valueList = [];
          if (value is Map<String, dynamic>) {
            valueList = buildEntry(value);
          } else if (value is List) {
            valueList = value.builder((item) => PickerLinkageEntry<String>(
                value: item,
                child: Text(item,
                    maxLines: 1, style: const TextStyle(fontSize: 10))));
          }
          return PickerLinkageEntry<String>(
              value: entry.key,
              child: Text(entry.key,
                  maxLines: 1, style: const TextStyle(fontSize: 10)),
              children: valueList);
        });
    return buildEntry(map);
  }

  final List<String> letterList = ['A', 'B', 'C', 'D', 'E', 'F'];

  List<PickerEntry> get multiListWheelList => 5.generate((_) => PickerEntry(
      itemCount: letterList.length,
      itemBuilder: (_, int index) => Text(letterList[index])));

  Future<void> multiListWheelPicker() async {
    final List<int>? index = await MultiListWheelPicker(
            entry: multiListWheelList, isScrollable: true)
        .show();
    if (index != null) {
      String result = '';
      for (var element in index) {
        result += letterList[element];
      }
      if (result.isNotEmpty) showToast(result);
    }
  }

  List<PickerLinkageEntry<String>> get multiListWheelLinkageList =>
      mapToLinkageEntry({
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
      });

  Future<void> multiListWheelLinkagePicker<T>(
      List<PickerLinkageEntry<T>> entry) async {
    final List<int>? index =
        await MultiListWheelLinkagePicker(entry: entry, isScrollable: false)
            .show();
    List<PickerLinkageEntry> resultList = entry;
    String result = '';
    index?.builder((item) {
      result += resultList[item].value;
      resultList = resultList[item].children;
    });
    if (result.isNotEmpty) showToast(result);
  }
}
