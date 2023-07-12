part of 'picker_page.dart';

class _MultiListWheelPicker extends StatelessWidget {
  const _MultiListWheelPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiListWheelPicker'),
        padding: const EdgeInsets.all(10),
        isScroll: true,
        children: [
          ElevatedText('show MultiListWheelPicker', onTap: pick),
          20.heightBox,
          BackCard(MultiListWheelPicker(
              height: 150,
              value: const [2, 3, 4, 6, 6],
              onChanged: (List<int> index) {
                log('MultiListWheelPicker onChanged= $index');
              },
              items: multiListWheelList)),
        ]);
  }

  List<PickerItem> get multiListWheelList => 5.generate((_) => PickerItem(
      itemCount: letterList.length,
      itemBuilder: (_, int index) => Text(letterList[index])));

  Future<void> pick() async {
    final List<int>? index = await MultiListWheelPicker(
            options: BasePickerOptions(),
            items: multiListWheelList,
            isScrollable: true)
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
