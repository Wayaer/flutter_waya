part of 'picker_page.dart';

class _SingleListPickerPage extends StatelessWidget {
  const _SingleListPickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('SingleListPicker'),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isScroll: true,
        children: [
          ElevatedText('show SingleListPicker', onTap: singleListPicker),
          ElevatedText('show SingleListPicker with screen',
              onTap: () => singleListPickerWithScreen(context)),
          ElevatedText('show SingleListPicker custom',
              onTap: customSingleListPicker),
          BackCard(SingleListPicker(
              height: 210,
              onChanged: (List<int> index) {
                log(index);
              },
              itemCount: numberList.length,
              listBuilder: (int itemCount, IndexedWidgetBuilder itemBuilder) {
                return ScrollList.builder(
                    gridStyle: GridStyle.masonry,
                    maxCrossAxisExtent: 100,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemBuilder: itemBuilder,
                    itemCount: itemCount);
              },
              itemBuilder: (context, index, isSelect, changedFun) {
                return Universal(
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(color: isSelect ? Colors.blue : null),
                    direction: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    child: BText('第 $index 项'));
              })),
        ]);
  }

  Future<void> singleColumnPicker() async {
    final int? index = await SingleListWheelPicker(
            itemBuilder: (BuildContext context, int index) => Container(
                alignment: Alignment.center,
                child: Text(numberList[index],
                    style: context.textTheme.bodyLarge)),
            itemCount: numberList.length)
        .show();
    showToast(index == null ? 'null' : numberList[index].toString());
  }

  Future<void> customSingleListPicker() async {
    final list = 40.generate((index) => index.toString());
    final value = await SingleListPicker(
        itemCount: list.length,
        options: BasePickerOptions(),
        listBuilder: (int itemCount, IndexedWidgetBuilder itemBuilder) {
          return ScrollList.builder(
              gridStyle: GridStyle.masonry,
              maxCrossAxisExtent: 100,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemBuilder: itemBuilder,
              itemCount: itemCount);
        },
        itemBuilder: (context, index, isSelect, changedFun) {
          return Universal(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: isSelect ? Colors.blue : null),
              direction: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 6),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              child: BText('第 $index 项'));
        }).show();
    showToast(value.toString());
  }

  Future<void> singleListPicker() async {
    final list = 40.generate((index) => index.toString());
    final value = await SingleListPicker(
        itemCount: list.length,
        options: BasePickerOptions(),
        singleListPickerOptions: const SingleListPickerOptions(
            isCustomGestureTap: true, allowedMultipleChoice: false),
        itemBuilder: (context, index, isSelect, changedFun) {
          return Universal(
              direction: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BText('第 $index 项'),
                Checkbox(
                    value: isSelect,
                    onChanged: (value) {
                      changedFun.call(index);
                    })
              ]);
        }).show();
    showToast(value.toString());
  }

  Future<void> singleListPickerWithScreen(BuildContext context) async {
    final list = 40.generate((index) => index.toString());
    final type = ['筛选1', '筛选2', '筛选3'];
    SelectIndexedChangedFunction? change;
    List<String> screen = [];
    final value = await SingleListPicker(
        itemCount: list.length,
        options: BasePickerOptions<List<int>>().merge(PickerOptions(
            bottom: Universal(
          child: DropdownMenus<String, String>(
              onChanged: (String key, String? value) {
                showToast('$key : $value');
                if (value != null) {
                  screen = [list[type.indexOf(value) + 1]];
                  change?.call();
                } else {
                  screen.clear();
                }
              },
              backgroundColor: Colors.black12,
              menus: type.builder((item) => DropdownMenusKeyItem<String,
                      String>(
                  icon: const Icon(Icons.arrow_circle_up_rounded, size: 13),
                  value: item,
                  child: BText(item).marginAll(4),
                  items: type.builder((value) => DropdownMenusValueItem<String>(
                        value: value,
                        child: BText(value, style: context.textTheme.bodyLarge)
                            .paddingSymmetric(vertical: 10),
                      ))))),
        ))),
        singleListPickerOptions: const SingleListPickerOptions(
            isCustomGestureTap: true, allowedMultipleChoice: false),
        itemBuilder: (context, index, isSelect, changedFun) {
          change = changedFun;
          final entry = Universal(
              direction: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BText('第 $index 项'),
                Checkbox(
                    value: isSelect,
                    onChanged: (value) {
                      changedFun(index);
                    })
              ]);
          if (screen.isNotEmpty) {
            if (list[index] == screen.first) {
              return entry;
            }
            return const SizedBox();
          }
          return entry;
        }).show();
    showToast(value.toString());
  }
}
