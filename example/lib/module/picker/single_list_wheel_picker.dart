part of 'picker_page.dart';

class _SingleListWheelPickerPage extends StatelessWidget {
  const _SingleListWheelPickerPage();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('SingleListWheelPicker'),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isScroll: true,
        children: [
          ElevatedText('show SingleListWheelPicker', onTap: pick),
          BackCard(buildSingleListWheelPicker())
        ]);
  }

  SingleListWheelPicker buildSingleListWheelPicker(
          {PickerOptions<int>? options}) =>
      SingleListWheelPicker(
          options: options,
          itemBuilder: (BuildContext context, int index) => Center(
              child:
                  Text(numberList[index], style: context.textTheme.bodyLarge)),
          itemCount: numberList.length);

  Future<void> pick() async {
    final int? index =
        await buildSingleListWheelPicker(options: BasePickerOptions()).show();
    if (index != null) showToast(numberList[index].toString());
  }
}
