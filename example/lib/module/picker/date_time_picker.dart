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
              onTap: () => pick(const DateTimePickerUnit.yd())),
          buildDateTimePicker(const DateTimePickerUnit.all()),
          buildDateTimePicker(const DateTimePickerUnit.ydm()),
          buildDateTimePicker(const DateTimePickerUnit.yh()),
          buildDateTimePicker(const DateTimePickerUnit.yd()),
          buildDateTimePicker(const DateTimePickerUnit.ym()),
          buildDateTimePicker(const DateTimePickerUnit.mhs()),
          buildDateTimePicker(const DateTimePickerUnit.mm()),
          buildDateTimePicker(const DateTimePickerUnit.mh()),
          buildDateTimePicker(const DateTimePickerUnit.md()),
          buildDateTimePicker(const DateTimePickerUnit.ds()),
          buildDateTimePicker(const DateTimePickerUnit.dm()),
          buildDateTimePicker(const DateTimePickerUnit.dh()),
          buildDateTimePicker(const DateTimePickerUnit.hs()),
          buildDateTimePicker(const DateTimePickerUnit.hm()),
          buildDateTimePicker(const DateTimePickerUnit.ms()),
        ]);
  }

  Widget buildDateTimePicker(DateTimePickerUnit unit) =>
      Backboard(DateTimePicker(
          startDate: defaultDate.subtract(const Duration(days: 365)),
          defaultDate: defaultDate,
          endDate: defaultDate,
          onChanged: (DateTime dateTime) {
            log(dateTime);
          },
          height: 210,
          unit: unit,
          options: null));

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
