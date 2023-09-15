part of 'picker_page.dart';

class _MultiListWheelPicker extends StatelessWidget {
  const _MultiListWheelPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('MultiListWheelPicker'),
        padding: const EdgeInsets.all(15),
        isScroll: true,
        children: [
          ElevatedText('show MultiListWheelPicker', onTap: pick),
          20.heightBox,
          BackCard(buildMultiListWheelPicker()),
        ]);
  }

  Future<void> pick() async {
    final List<int>? index = await buildMultiListWheelPicker(
            options: BasePickerOptions(), isScrollable: true)
        .show();
    if (index != null) {
      List<String> result = [];
      for (var element in index) {
        result.add(letterList[element]);
      }
      if (result.isNotEmpty) showToast(result.toString());
    }
  }

  MultiListWheelPicker buildMultiListWheelPicker(
          {PickerOptions<List<int>>? options, bool isScrollable = false}) =>
      MultiListWheelPicker(
          height: 200,
          options: options,
          wheelOptions: const WheelOptions.cupertino(),
          value: const [2, 3, 4, 6, 6],
          onChanged: (List<int> index) {
            'MultiListWheelPicker onChanged= $index'.log();
          },
          items: multiListWheelList);

  List<PickerItem> get multiListWheelList => 5.generate((_) => PickerItem(
      itemCount: letterList.length,
      itemBuilder: (_, int index) => Center(
          child:
              Text(letterList[index], style: const TextStyle(fontSize: 16)))));
}
