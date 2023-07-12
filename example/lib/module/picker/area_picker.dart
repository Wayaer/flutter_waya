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
          BackCard(MultiListWheelLinkagePicker<String>(
              wheelOptions: const WheelOptions.cupertino(),
              height: 210,
              onChanged: (List<int> index) {
                log('AreaPicker onChanged= $index');
              },
              onValueChanged: (List<String> list) {
                log('AreaPicker onValueChanged= $list');
              },
              items: mapToLinkageEntry(areaDataMap))),
        ]);
  }

  Future<void> pick() async {
    final items = mapToLinkageEntry(areaDataMap);
    final position = await MultiListWheelLinkagePicker<String>(
            options: BasePickerOptions(),
            height: 200,
            onChanged: (List<int> index) {
              log('AreaPicker onChanged= $index');
            },
            onValueChanged: (List<String> list) {
              log('AreaPicker onValueChanged= $list');
            },
            items: items,
            isScrollable: false)
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

  List<PickerLinkageItem<String>> mapToLinkageEntry(Map<String, dynamic> map) {
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
