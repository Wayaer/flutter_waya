part of 'picker_page.dart';

class _MultiListWheelLinkagePicker extends StatelessWidget {
  const _MultiListWheelLinkagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiListWheelLinkagePicker'),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isScroll: true,
        children: [
          const Partition('MultiListWheelLinkagePicker'),
          ElevatedText('show MultiListWheelLinkagePicker with area',
              onTap: () => pick(mapToLinkageEntry(areaDataMap))),
          20.heightBox,
          ElevatedText('show MultiListWheelLinkagePicker',
              onTap: () => pick(mapToLinkageEntry(mapABC))),
          BackCard(MultiListWheelLinkagePicker<String>(
              height: 150,
              onChanged: (List<int> index) {
                log('MultiListWheelLinkagePicker onChanged= $index');
              },
              onValueChanged: (List<String> list) {
                log('MultiListWheelLinkagePicker onValueChanged= $list');
              },
              items: mapToLinkageEntry(mapABC),
              isScrollable: true)),
        ]);
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

  Future<void> pick<T>(List<PickerLinkageItem<T>> items) async {
    final List<int>? index = await MultiListWheelLinkagePicker(
            options: BasePickerOptions(), items: items, isScrollable: false)
        .show();
    List<PickerLinkageItem> resultList = items;
    String result = '';
    index?.builder((item) {
      result += resultList[item].value;
      resultList = resultList[item].children;
    });
    if (result.isNotEmpty) showToast(result);
  }
}
