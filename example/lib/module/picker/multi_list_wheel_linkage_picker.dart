part of 'picker_page.dart';

class _MultiListWheelLinkagePicker extends StatelessWidget {
  const _MultiListWheelLinkagePicker();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiListWheelLinkagePicker'),
        padding: const EdgeInsets.all(15),
        isScroll: true,
        children: [
          ElevatedText('show MultiListWheelLinkagePicker with area',
              onTap: () => pick(mapToLinkageItems(areaDataMap))),
          BackCard(buildMultiListWheelLinkagePicker(
              mapToLinkageItems(areaDataMap),
              isScrollable: true)),
          20.heightBox,
          ElevatedText('show MultiListWheelLinkagePicker custom',
              onTap: () => pick(mapToLinkageItems(mapABC))),
          BackCard(buildMultiListWheelLinkagePicker(mapToLinkageItems(mapABC),
              isScrollable: true)),
        ]);
  }

  Future<void> pick(List<PickerLinkageItem<String>> items) async {
    final List<int>? index = await buildMultiListWheelLinkagePicker(items,
            options: BasePickerOptions(), isScrollable: false)
        .show();
    List<PickerLinkageItem> resultList = items;
    List<String> result = [];
    index?.builder((item) {
      result.add(resultList[item].value);
      resultList = resultList[item].children;
    });
    if (result.isNotEmpty) showToast(result.toString());
  }

  MultiListWheelLinkagePicker<String> buildMultiListWheelLinkagePicker(
          List<PickerLinkageItem<String>> items,
          {PickerOptions<List<int>>? options,
          bool isScrollable = false}) =>
      MultiListWheelLinkagePicker<String>(
          height: 200,
          options: options,
          onChanged: (List<int> index) {
            'MultiListWheelLinkagePicker onChanged= $index'.log();
          },
          onValueChanged: (List<String> list) {
            'MultiListWheelLinkagePicker onValueChanged= $list'.log();
          },
          items: items,
          isScrollable: isScrollable);

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
                child: Text(item,
                    maxLines: 1, style: const TextStyle(fontSize: 10))));
          }
          return PickerLinkageItem<String>(
              value: entry.key,
              child: Text(entry.key,
                  maxLines: 1, style: const TextStyle(fontSize: 10)),
              children: valueList);
        });
    return buildEntry(map);
  }
}
