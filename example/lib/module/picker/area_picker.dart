part of 'picker_page.dart';

class _AreaPickerPage extends StatelessWidget {
  const _AreaPickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('AreaPicker'),
        padding: const EdgeInsets.all(10),
        isScroll: true,
        children: [
          ElevatedText('show AreaPicker', onTap: pick),
          Backboard(MultiListWheelLinkagePicker<String>(
              options: null,
              wheelOptions: const WheelOptions.cupertino(),
              height: 210,
              onChanged: (List<int> index) {
                log('AreaPicker onChanged= $index');
              },
              onValueChanged: (List<String> list) {
                log('AreaPicker onValueChanged= $list');
              },
              entry: mapToLinkageEntry(areaDataMap))),
        ]);
  }

  Future<void> pick() async {
    final entry = mapToLinkageEntry(areaDataMap);
    final position = await MultiListWheelLinkagePicker<String>(
            height: 200,
            onChanged: (List<int> index) {
              log('AreaPicker onChanged= $index');
            },
            onValueChanged: (List<String> list) {
              log('AreaPicker onValueChanged= $list');
            },
            entry: entry,
            isScrollable: false)
        .show();
    if (position == null) return;
    List<String> value = [];
    List<PickerLinkageEntry> resultList = entry;
    position.builder((index) {
      if (index < resultList.length) {
        value.add(resultList[index].value);
        resultList = resultList[index].children;
      }
    });
    showToast(value.toString());
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
                child: Text(item, style: const TextStyle(fontSize: 10))));
          }
          return PickerLinkageEntry<String>(
              value: entry.key,
              child: Text(entry.key, style: const TextStyle(fontSize: 10)),
              children: valueList);
        });
    return buildEntry(map);
  }
}
