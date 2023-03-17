part of 'picker_page.dart';

class _MultiListLinkagePicker extends StatelessWidget {
  const _MultiListLinkagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiListLinkagePicker'),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isScroll: true,
        children: [
          10.heightBox,
          ElevatedText('show MultiListLinkagePicker',
              onTap: () =>
                  multiListLinkagePicker(mapToLinkageEntry(areaDataMap))),
          10.heightBox,
          _addBackboard(MultiListLinkagePicker<String>(
              options: null,
              height: 300,
              onChanged: (List<int> index) {
                log('MultiListLinkagePicker onChanged= $index');
              },
              onValueChanged: (List<String> list) {
                log('MultiListLinkagePicker onValueChanged= $list');
              },
              entry: mapToLinkageEntry(areaDataMap))),
          20.heightBox,
          ElevatedText('show MultiListLinkagePicker',
              onTap: () => multiListLinkagePicker(multiListLinkage)),
          10.heightBox,
          _addBackboard(MultiListLinkagePicker<String>(
              options: null,
              height: 150,
              onChanged: (List<int> index) {
                log('MultiListLinkagePicker onChanged= $index');
              },
              onValueChanged: (List<String> list) {
                log('MultiListLinkagePicker onValueChanged= $list');
              },
              entry: multiListLinkage,
              addExpanded: true,
              horizontalScroll: false)),
        ]);
  }

  List<PickerListLinkageEntry<String>> get multiListLinkage =>
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

  List<PickerListLinkageEntry<String>> mapToLinkageEntry(
      Map<String, dynamic> map) {
    List<PickerListLinkageEntry<String>> buildEntry(Map<String, dynamic> map) =>
        map.builderEntry((entry) {
          final value = entry.value;
          List<PickerListLinkageEntry<String>> valueList = [];
          if (value is Map<String, dynamic>) {
            valueList = buildEntry(value);
          } else if (value is List) {
            valueList = value.builder((item) => PickerListLinkageEntry<String>(
                value: item, child: (selected) => buildChild(item, selected)));
          }
          return PickerListLinkageEntry<String>(
              value: entry.key,
              child: (selected) => buildChild(entry.key, selected),
              children: valueList);
        });
    return buildEntry(map);
  }

  Widget buildChild(String value, bool selected) => Universal(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: selected ? Colors.blue : null,
          border: const Border(right: BorderSide(color: Colors.blue))),
      child: Text(value,
          style:
              TextStyle(fontSize: 10, color: selected ? Colors.white : null)));

  Future<void> multiListLinkagePicker(
      List<PickerListLinkageEntry<String>> multiListLinkage) async {
    final List<int>? index = await MultiListLinkagePicker(
            entry: multiListLinkage, horizontalScroll: false)
        .show();
    List<PickerListLinkageEntry> resultList = multiListLinkage;
    String result = '';
    index?.builder((item) {
      result += resultList[item].value;
      resultList = resultList[item].children;
    });
    if (result.isNotEmpty) showToast(result);
  }
}
