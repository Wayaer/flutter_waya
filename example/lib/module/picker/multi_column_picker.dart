part of 'picker_page.dart';

class _MultiColumnPicker extends StatelessWidget {
  _MultiColumnPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiColumnPicker'),
        padding: const EdgeInsets.all(20),
        isScroll: true,
        children: [
          const Partition('MultiColumnPicker'),
          ElevatedText('show MultiColumnPicker', onTap: multiColumnPicker),
          10.heightBox,
          _addBackboard(MultiColumnPicker(
              options: null,
              height: 210,
              onChanged: (List<int> index) {
                log(index);
              },
              entry: multiColumnListEntry,
              horizontalScroll: false)),
          const Partition('MultiColumnLinkagePicker'),
          ElevatedText('show MultiColumnLinkagePicker',
              onTap: multiColumnLinkagePicker),
          10.heightBox,
          _addBackboard(MultiColumnLinkagePicker(
              options: null,
              height: 210,
              onChanged: (List<int> index) {
                log(index);
              },
              entry: multiColumnLinkageList,
              horizontalScroll: true)),
        ]);
  }

  final List<String> letterList = ['A', 'B', 'C', 'D', 'E', 'F'];

  List<PickerEntry> get multiColumnListEntry => 5.generate((_) => PickerEntry(
      itemCount: letterList.length,
      itemBuilder: (_, int index) => Text(letterList[index])));

  Future<void> multiColumnPicker() async {
    final List<int>? index = await MultiColumnPicker(
            entry: multiColumnListEntry, horizontalScroll: true)
        .show();
    if (index != null) {
      String result =
          '${letterList[index.first]}-${letterList[index.last]}${letterList[index.last]}';
      if (result.isNotEmpty) showToast(result);
    }
  }

  List<PickerLinkageEntry> get multiColumnLinkageList => <PickerLinkageEntry>[
        const PickerLinkageEntry(text: Text('A1'), children: [
          PickerLinkageEntry(text: Text('A2')),
        ]),
        const PickerLinkageEntry(text: Text('B1'), children: [
          PickerLinkageEntry(text: Text('B2'), children: [
            PickerLinkageEntry(text: Text('B3')),
            PickerLinkageEntry(text: Text('B3')),
            PickerLinkageEntry(text: Text('B3')),
          ]),
          PickerLinkageEntry(text: Text('B2')),
        ]),
        const PickerLinkageEntry(text: Text('C1'), children: [
          PickerLinkageEntry(text: Text('C2'), children: [
            PickerLinkageEntry(text: Text('C3'), children: [
              PickerLinkageEntry(text: Text('C4'), children: [
                PickerLinkageEntry(text: Text('C5'), children: [
                  PickerLinkageEntry(text: Text('C6'), children: [
                    PickerLinkageEntry(text: Text('C7'), children: [
                      PickerLinkageEntry(text: Text('C8')),
                      PickerLinkageEntry(text: Text('C8')),
                      PickerLinkageEntry(text: Text('C8')),
                    ]),
                    PickerLinkageEntry(text: Text('C7')),
                    PickerLinkageEntry(text: Text('C7')),
                  ]),
                  PickerLinkageEntry(text: Text('C6')),
                  PickerLinkageEntry(text: Text('C6')),
                ]),
                PickerLinkageEntry(text: Text('C5')),
                PickerLinkageEntry(text: Text('C5')),
              ]),
              PickerLinkageEntry(text: Text('C4')),
              PickerLinkageEntry(text: Text('C4')),
            ]),
            PickerLinkageEntry(text: Text('C3')),
            PickerLinkageEntry(text: Text('C3')),
          ]),
          PickerLinkageEntry(text: Text('C2')),
          PickerLinkageEntry(text: Text('C2')),
        ]),
        const PickerLinkageEntry(text: Text('D1'), children: [])
      ];

  Future<void> multiColumnLinkagePicker() async {
    final List<int>? index = await MultiColumnLinkagePicker(
            entry: multiColumnLinkageList, horizontalScroll: false)
        .show();
    List<PickerLinkageEntry> resultList = multiColumnLinkageList;
    String result = '';
    index?.builder((item) {
      result += (resultList[item].text as Text).data!;
      resultList = resultList[item].children;
    });
    if (result.isNotEmpty) showToast(result);
  }
}
