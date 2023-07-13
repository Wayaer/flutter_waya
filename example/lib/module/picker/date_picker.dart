part of 'picker_page.dart';

class _DatePickerPage extends StatelessWidget {
  _DatePickerPage({Key? key}) : super(key: key);
  final DateTime defaultDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('DatePicker'),
        padding: const EdgeInsets.all(15),
        isScroll: true,
        children: [
          ElevatedText('show DatePicker', onTap: pick),
          ElevatedText('show DatePicker with mouth',
              onTap: () => pick(const DatePickerUnit.md())),
          BackCard(buildDatePicker(
              const DatePickerUnit.yd(year: '年', day: '日', month: '月'))),
          BackCard(
              buildDatePicker(const DatePickerUnit.md(month: '月', day: '日'))),
          BackCard(
              buildDatePicker(const DatePickerUnit.ym(year: '年', month: '月'))),
        ]);
  }

  DatePicker buildDatePicker(
    DatePickerUnit unit, {
    PickerOptions<DateTime>? options,
    WheelOptions? wheelOptions,
  }) =>
      DatePicker(
          height: 200,
          startDate: defaultDate.subtract(const Duration(days: 600)),
          defaultDate: defaultDate,
          endDate: defaultDate,
          options: options,
          onChanged: (DateTime dateTime) {
            log(dateTime);
          },
          itemBuilder: (String text) =>
              Text(text, style: const TextStyle(fontSize: 16)),
          unit: unit);

  Future<void> pick([DatePickerUnit? unit]) async {
    await buildDatePicker(unit ?? const DatePickerUnit.yd(),
        wheelOptions: const WheelOptions.cupertino(
            selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: Colors.transparent)),
        options: BasePickerOptions<DateTime>().merge(PickerOptions<DateTime>(
            background: Center(
                child: Container(
                    width: double.infinity,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            verifyConfirm: (DateTime? dateTime) {
              showToast(
                  dateTime?.format(DateTimeDist.yearDay) ?? 'verifyConfirm');
              return true;
            },
            verifyCancel: (DateTime? dateTime) {
              showToast(
                  dateTime?.format(DateTimeDist.yearDay) ?? 'verifyCancel');
              return true;
            }))).show();
  }
}
