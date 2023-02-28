part of 'picker_page.dart';

class _AreaPickerPage extends StatelessWidget {
  const _AreaPickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('AreaPicker'),
        padding: const EdgeInsets.all(10),
        isScroll: true,
        children: [
          ElevatedText('show AreaPicker', onTap: pick),
          10.heightBox,
          _addBackboard(AreaPicker(
              options: null,
              height: 210,
              onChanged: (List<String> list) {
                log(list.toString());
              })),
          10.heightBox,
          _addBackboard(AreaPicker(
              enableDistrict: false,
              options: null,
              height: 210,
              onChanged: (List<String> list) {
                log(list.toString());
              })),
          10.heightBox,
          _addBackboard(AreaPicker(
              enableCity: false,
              enableDistrict: false,
              options: null,
              height: 210,
              onChanged: (List<String> list) {
                log(list.toString());
              })),
        ]);
  }

  Future<void> pick() async {
    await AreaPicker(
        province: '四川省',
        city: '绵阳市',
        options: PickerOptions(verifyConfirm: (List<String>? list) {
          showToast(list.toString());
          return true;
        }, verifyCancel: (List<String>? list) {
          showToast(list.toString());
          return true;
        })).show();
  }
}
