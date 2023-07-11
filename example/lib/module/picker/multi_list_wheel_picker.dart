part of 'picker_page.dart';

class _MultiListWheelPicker extends StatelessWidget {
  _MultiListWheelPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiListWheelPicker'),
        padding: const EdgeInsets.all(10),
        isScroll: true,
        children: [
          ElevatedText('show MultiListWheelPicker',
              onTap: multiListWheelPicker),
          20.heightBox,
          Backboard(MultiListWheelPicker(
              options: null,
              height: 150,
              value: const [2, 3, 4, 6, 6],
              onChanged: (List<int> index) {
                log('MultiListWheelPicker onChanged= $index');
              },
              entry: multiListWheelList)),
        ]);
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
}
