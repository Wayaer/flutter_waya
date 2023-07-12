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
              onTap: () => pick(mapToLinkageEntry(areaDataMap))),
          BackCard(MultiListLinkagePicker<String>(
              height: 300,
              onChanged: (List<int> index) {
                log('MultiListLinkagePicker onChanged= $index');
              },
              onValueChanged: (List<String> list) {
                log('MultiListLinkagePicker onValueChanged= $list');
              },
              items: mapToLinkageEntry(areaDataMap))),
          20.heightBox,
          ElevatedText('show MultiListLinkagePicker',
              onTap: () => pick(mapToLinkageEntry(mapABC))),
          BackCard(MultiListLinkagePicker<String>(
              height: 300,
              onChanged: (List<int> index) {
                log('MultiListLinkagePicker onChanged= $index');
              },
              onValueChanged: (List<String> list) {
                log('MultiListLinkagePicker onValueChanged= $list');
              },
              items: mapToLinkageEntry(mapABC))),
        ]);
  }

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

  Future<void> pick(
      List<PickerListLinkageEntry<String>> multiListLinkage) async {
    final List<int>? index = await MultiListLinkagePicker(
            options: BasePickerOptions(), items: multiListLinkage)
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
