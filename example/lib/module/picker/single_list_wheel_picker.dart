part of 'picker_page.dart';

class _SingleListWheelPickerPage extends StatelessWidget {
  const _SingleListWheelPickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('SingleListWheelPicker'),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isScroll: true,
        children: [
          ElevatedText('show SingleListWheelPicker', onTap: pick),
          BackCard(SingleListWheelPicker(
              height: 210,
              onChanged: (int index) {
                log(index);
              },
              itemBuilder: (BuildContext context, int index) => Container(
                  alignment: Alignment.center,
                  child: Text(numberList[index],
                      style: context.textTheme.bodyLarge)),
              itemCount: numberList.length))
        ]);
  }

  Future<void> pick() async {
    final int? index = await SingleListWheelPicker(
            options: BasePickerOptions(),
            itemBuilder: (BuildContext context, int index) => Container(
                alignment: Alignment.center,
                child: Text(numberList[index],
                    style: context.textTheme.bodyLarge)),
            itemCount: numberList.length)
        .show();
    showToast(index == null ? 'null' : numberList[index].toString());
  }
}
