part of 'picker_page.dart';

class _MultiListLinkagePicker extends StatelessWidget {
  const _MultiListLinkagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiListLinkagePicker'),
        padding: const EdgeInsets.all(15),
        isScroll: true,
        children: [
          ElevatedText('show MultiListLinkagePicker with area',
              onTap: () => pick(mapToLinkageItems(areaDataMap))),
          BackCard(buildMultiListLinkagePicker(mapToLinkageItems(areaDataMap))),
          20.heightBox,
          ElevatedText('show MultiListLinkagePicker with custom',
              onTap: () => pick(mapToLinkageItems(mapABC))),
          BackCard(buildMultiListLinkagePicker(mapToLinkageItems(mapABC))),
        ]);
  }

  Future<void> pick(List<PickerListLinkageItem<String>> items) async {
    final List<int>? index =
        await buildMultiListLinkagePicker(items, options: BasePickerOptions())
            .show();
    List<PickerListLinkageItem> resultList = items;
    List<String> result = [];
    index?.builder((item) {
      result.add(resultList[item].value);
      resultList = resultList[item].children;
    });
    if (result.isNotEmpty) showToast(result.toString());
  }

  MultiListLinkagePicker<String> buildMultiListLinkagePicker(
          List<PickerListLinkageItem<String>> items,
          {PickerOptions<List<int>>? options}) =>
      MultiListLinkagePicker<String>(
          options: options,
          height: 300,
          onChanged: (List<int> index) {
            'MultiListLinkagePicker onChanged= $index'.log();
          },
          onValueChanged: (List<String> list) {
            'MultiListLinkagePicker onValueChanged= $list'.log();
          },
          items: items);

  List<PickerListLinkageItem<String>> mapToLinkageItems(
      Map<String, dynamic> map) {
    List<PickerListLinkageItem<String>> buildEntry(Map<String, dynamic> map) =>
        map.builderEntry((entry) {
          final value = entry.value;
          List<PickerListLinkageItem<String>> valueList = [];
          if (value is Map<String, dynamic>) {
            valueList = buildEntry(value);
          } else if (value is List) {
            valueList = value.builder((item) => PickerListLinkageItem<String>(
                value: item, child: (selected) => buildChild(item, selected)));
          }
          return PickerListLinkageItem<String>(
              value: entry.key,
              child: (selected) => buildChild(entry.key, selected),
              children: valueList);
        });
    return buildEntry(map);
  }

  Widget buildChild(String value, bool selected) {
    final color =
        GlobalWayUI().navigatorKey.currentState?.context.theme.primaryColor ??
            Colors.blue;
    return Universal(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: selected ? color : null,
            border: Border(right: BorderSide(color: color))),
        child: Text(value,
            style: TextStyle(
                fontSize: 10, color: selected ? Colors.white : null)));
  }
}
