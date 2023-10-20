part of 'picker_page.dart';

class _AreaPickerPage extends StatelessWidget {
  const _AreaPickerPage();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('AreaPicker'),
        padding: const EdgeInsets.all(15),
        isScroll: true,
        children: [
          ElevatedText('show AreaPicker', onTap: pick),
          BackCard(
              buildMultiListWheelLinkagePicker(mapToLinkageItems(areaDataMap))),
        ]);
  }

  MultiListWheelLinkagePicker buildMultiListWheelLinkagePicker(
    List<PickerLinkageItem<String>> items, {
    PickerOptions<List<int>>? options,
  }) =>
      MultiListWheelLinkagePicker<String>(
          options: options,
          wheelOptions: const WheelOptions.cupertino(),
          height: 200,
          onChanged: (List<int> index) {
            'AreaPicker onChanged= $index'.log();
          },
          onValueChanged: (List<String> list) {
            'AreaPicker onValueChanged= $list'.log;
          },
          items: items,
          isScrollable: false);

  Future<void> pick() async {
    final items = mapToLinkageItems(areaDataMap);
    final position = await buildMultiListWheelLinkagePicker(items,
            options: BasePickerOptions())
        .show();
    if (position == null) return;
    List<String> value = [];
    List<PickerLinkageItem> resultList = items;
    position.builder((index) {
      if (index < resultList.length) {
        value.add(resultList[index].value);
        resultList = resultList[index].children;
      }
    });
    showToast(value.toString());
  }

  List<PickerLinkageItem<String>> mapToLinkageItems(Map<String, dynamic> map) {
    List<PickerLinkageItem<String>> buildEntry(Map<String, dynamic> map) =>
        map.builderEntry((entry) {
          final value = entry.value;
          List<PickerLinkageItem<String>> valueList = [];
          if (value is Map<String, dynamic>) {
            valueList = buildEntry(value);
          } else if (value is List) {
            valueList = value.builder((item) => PickerLinkageItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 10))));
          }
          return PickerLinkageItem<String>(
              value: entry.key,
              child: Text(entry.key, style: const TextStyle(fontSize: 10)),
              children: valueList);
        });
    return buildEntry(map);
  }
}
