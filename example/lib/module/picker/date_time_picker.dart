part of 'picker_page.dart';

class _DateTimePickerPage extends StatelessWidget {
  const _DateTimePickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('DateTimePicker'),
        padding: const EdgeInsets.all(20),
        isScroll: true,
        children: [
          ElevatedText('show DateTimePicker', onTap: pick),
          ElevatedText('show DateTimePicker with date',
              onTap: () => pick(const DateTimePickerUnit.date())),
          10.heightBox,
          _addBackboard(DateTimePicker(
              onChanged: (DateTime dateTime) {
                log(dateTime);
              },
              height: 210,
              unit: const DateTimePickerUnit.date(),
              options: null)),
          10.heightBox,
          _addBackboard(DateTimePicker(
              onChanged: (DateTime dateTime) {
                log(dateTime);
              },
              height: 210,
              unit: const DateTimePickerUnit.time(),
              options: null)),
          10.heightBox,
          _addBackboard(DateTimePicker(
              onChanged: (DateTime dateTime) {
                log(dateTime);
              },
              height: 210,
              options: null)),
        ]);
  }

  Future<void> pick([DateTimePickerUnit? unit]) async {
    await DateTimePicker(
            dual: true,
            unit: unit ?? const DateTimePickerUnit.all(),
            options: PickerOptions<DateTime>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                verifyConfirm: (DateTime? dateTime) {
                  showToast(dateTime?.format(DateTimeDist.yearSecond) ??
                      'verifyConfirm');
                  return true;
                },
                verifyCancel: (DateTime? dateTime) {
                  showToast(dateTime?.format(DateTimeDist.yearSecond) ??
                      'verifyCancel');
                  return true;
                }),
            startDate: DateTime(2020, 8, 9, 9, 9, 9),
            defaultDate: DateTime(2021, 9, 21, 8, 8, 8),
            endDate: DateTime(2022, 10, 20, 10, 10, 10))
        .show();
  }
}
