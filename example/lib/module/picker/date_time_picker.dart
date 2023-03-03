part of 'picker_page.dart';

class _DateTimePickerPage extends StatelessWidget {
  _DateTimePickerPage({Key? key}) : super(key: key);
  final DateTime defaultDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('DateTimePicker'),
        padding: const EdgeInsets.all(10),
        isScroll: true,
        children: [
          ElevatedText('show DateTimePicker', onTap: pick),
          ElevatedText('show DateTimePicker with date',
              onTap: () => pick(const DateTimePickerUnit.date())),
          10.heightBox,
          _addBackboard(DateTimePicker(
              startDate: defaultDate.subtract(const Duration(days: 365)),
              defaultDate: defaultDate,
              endDate: defaultDate.add(const Duration(days: 365)),
              onChanged: (DateTime dateTime) {
                log(dateTime);
              },
              height: 210,
              unit: const DateTimePickerUnit.date(),
              options: null)),
          10.heightBox,
          _addBackboard(DateTimePicker(
              startDate: defaultDate,
              defaultDate: defaultDate,
              endDate: defaultDate,
              onChanged: (DateTime dateTime) {
                log(dateTime);
              },
              height: 210,
              unit: const DateTimePickerUnit.time(),
              options: null)),
          10.heightBox,
          _addBackboard(DateTimePicker(
              startDate: defaultDate.subtract(const Duration(days: 365)),
              defaultDate: defaultDate,
              endDate: defaultDate.add(const Duration(days: 365)),
              wheelOptions: GlobalOptions()
                  .pickerWheelOptions
                  .copyWith(isCupertino: false, squeeze: 0.8),
              contentStyle: const TextStyle(fontSize: 13),
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
            startDate: defaultDate.subtract(const Duration(days: 365)),
            defaultDate: defaultDate,
            endDate: defaultDate.add(const Duration(days: 365)))
        .show();
  }
}
