part of 'picker_page.dart';

class _DatePickerPage extends StatelessWidget {
  _DatePickerPage({Key? key}) : super(key: key);
  final DateTime defaultDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('DatePicker'),
        padding: const EdgeInsets.all(10),
        isScroll: true,
        children: [
          ElevatedText('show DatePicker', onTap: pick),
          ElevatedText('show DatePicker with mouth',
              onTap: () => pick(const DatePickerUnit.md())),
          buildDatePicker(const DatePickerUnit.yd()),
          buildDatePicker(const DatePickerUnit.ym()),
          buildDatePicker(const DatePickerUnit.md()),
        ]);
  }

  Widget buildDatePicker(DatePickerUnit unit) => Backboard(DatePicker(
      startDate: defaultDate.subtract(const Duration(days: 60)),
      defaultDate: defaultDate,
      endDate: defaultDate,
      onChanged: (DateTime dateTime) {
        log(dateTime);
      },
      unit: unit,
      height: 210,
      options: null));

  Future<void> pick([DatePickerUnit? unit]) async {
    await DatePicker(
            dual: true,
            unit: unit ?? const DatePickerUnit.yd(),
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
