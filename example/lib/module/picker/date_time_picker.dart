part of 'picker_page.dart';

class _DateTimePickerPage extends StatelessWidget {
  _DateTimePickerPage({Key? key}) : super(key: key);
  final DateTime defaultDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('DateTimePicker'),
        padding: const EdgeInsets.all(15),
        isScroll: true,
        children: [
          ElevatedText('show DateTimePicker', onTap: pick),
          ElevatedText('show DateTimePicker with date',
              onTap: () => pick(const DateTimePickerUnit.yd())),
          BackCard(buildDateTimePicker(DateTimePickerUnit.all(
              builder: (value) => Text(
                    value ?? '',
                    style: const TextStyle(fontSize: 9),
                  )))),
          BackCard(buildDateTimePicker(
              const DateTimePickerUnit.yd(year: '年', month: '', day: ''))),
          BackCard(buildDateTimePicker(const DateTimePickerUnit.dh())),
        ]);
  }

  DateTimePicker buildDateTimePicker(DateTimePickerUnit unit,
          {PickerOptions<DateTime>? options}) =>
      DateTimePicker(
          options: options,
          startDate: defaultDate.subtract(const Duration(days: 365)),
          defaultDate: defaultDate,
          endDate: defaultDate.add(const Duration(days: 365)),
          onChanged: (DateTime dateTime) {
            log(dateTime);
          },
          height: 200,
          unit: unit);

  Future<void> pick([DateTimePickerUnit? unit]) async {
    await buildDateTimePicker(unit ?? const DateTimePickerUnit.all(),
        options: BasePickerOptions<DateTime>().merge(PickerOptions<DateTime>(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            verifyConfirm: (DateTime? dateTime) {
              showToast(
                  dateTime?.format(DateTimeDist.yearSecond) ?? 'verifyConfirm');
              return true;
            },
            verifyCancel: (DateTime? dateTime) {
              showToast(
                  dateTime?.format(DateTimeDist.yearSecond) ?? 'verifyCancel');
              return true;
            }))).show();
  }
}
