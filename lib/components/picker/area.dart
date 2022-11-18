part of 'picker.dart';

extension ExtensionAreaPicker on AreaPicker {
  Future<String?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<String?>(options: options);
}

/// 省市区三级联动
class AreaPicker extends PickerStatefulWidget<String> {
  AreaPicker({
    super.key,
    this.defaultProvince,
    this.defaultCity,
    this.defaultDistrict,
    PickerOptions<String>? options,
    PickerWheelOptions? wheelOptions,
  }) : super(
            options: options ?? PickerOptions<String>(),
            wheelOptions: wheelOptions ?? GlobalOptions().pickerWheelOptions);

  /// 默认选择的省
  final String? defaultProvince;

  /// 默认选择的市
  final String? defaultCity;

  /// 默认选择的区
  final String? defaultDistrict;

  @override
  State<AreaPicker> createState() => _AreaPickerState();
}

class _AreaPickerState extends State<AreaPicker> {
  List<String> province = <String>[];
  List<String> city = <String>[];
  List<String> district = <String>[];

  /// List<String> street = <String>[];
  late Map<String, dynamic> areaData = area;

  int provinceIndex = 0;
  int cityIndex = 0;
  int districtIndex = 0;
  int streetIndex = 0;

  late FixedExtentScrollController controllerProvince,
      controllerCity,
      controllerDistrict;

  late StateSetter cityState;
  late StateSetter districtState;
  late PickerWheelOptions wheelOptions;

  @override
  void initState() {
    super.initState();
    wheelOptions = GlobalOptions().pickerWheelOptions;

    /// 省
    province = areaData.keys.toList();
    if (province.contains(widget.defaultProvince)) {
      provinceIndex = province.indexOf(widget.defaultProvince!);
    }
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;

    /// 市
    city = provinceData.keys.toList() as List<String>;
    if (city.contains(widget.defaultCity)) {
      cityIndex = city.indexOf(widget.defaultCity!);
    }
    final Map<dynamic, dynamic> cityData =
        provinceData[city[cityIndex]] as Map<dynamic, dynamic>;

    /// 区
    district = cityData.keys.toList() as List<String>;
    if (district.contains(widget.defaultDistrict)) {
      districtIndex = district.indexOf(widget.defaultDistrict!);
    }

    ///  var districtData = cityData[districtIndex];

    /// 街道
    ///  street = districtData[districtIndex];

    controllerProvince =
        FixedExtentScrollController(initialItem: provinceIndex);
    controllerCity = FixedExtentScrollController(initialItem: cityIndex);
    controllerDistrict =
        FixedExtentScrollController(initialItem: districtIndex);
  }

  /// 点击确定返回选择的地区
  String confirmTapVoid() =>
      '${province[provinceIndex]} ${city[cityIndex]} ${district[districtIndex]}';

  void refreshCity() {
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;
    city = provinceData.keys.toList() as List<String>;
    cityState(() {});
    final Map<dynamic, dynamic> cityData =
        provinceData[city[city.length < cityIndex ? 0 : cityIndex]]
            as Map<dynamic, dynamic>;
    district = cityData.keys.toList() as List<String>;
    districtState(() {});
    controllerCity.jumpTo(0);
    controllerDistrict.jumpTo(0);
  }

  void refreshDistrict() {
    final Map<dynamic, dynamic> cityData = areaData[province[provinceIndex]]
        [city[cityIndex]] as Map<dynamic, dynamic>;
    district = cityData.keys.toList() as List<String>;
    districtState(() {});
    controllerDistrict.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: wheelItem(province, controller: controllerProvince,
              onChanged: (int newIndex) {
        provinceIndex = newIndex;
        refreshCity();
      })),
      Expanded(child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        cityState = setState;
        return wheelItem(city,
            childDelegateType: ListWheelChildDelegateType.list,
            controller: controllerCity, onChanged: (int newIndex) {
          cityIndex = newIndex;
          refreshDistrict();
        });
      })),
      Expanded(child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        districtState = setState;
        return wheelItem(district,
            childDelegateType: ListWheelChildDelegateType.list,
            controller: controllerDistrict,
            onChanged: (int newIndex) => districtIndex = newIndex);
      })),
    ]);
    return PickerSubject<String>(
        options: widget.options,
        confirmTap: confirmTapVoid,
        child: SizedBox(
            width: double.infinity, height: kPickerDefaultHeight, child: row));
  }

  Widget wheelItem(List<String> list,
          {FixedExtentScrollController? controller,
          ListWheelChildDelegateType childDelegateType =
              ListWheelChildDelegateType.builder,
          ValueChanged<int>? onChanged}) =>
      _PickerListWheel(
          controller: controller,
          wheel: wheelOptions,
          childDelegateType: childDelegateType,
          itemBuilder: (BuildContext context, int index) => item(list[index]),
          onChanged: onChanged,
          itemCount: list.length,
          children: list.builder((String value) => item(value)));

  Widget item(String value) => Center(
      child: BText(value,
          fontSize: 12,
          overflow: TextOverflow.ellipsis,
          style: widget.options.contentStyle ?? context.textTheme.bodyText1));

  void jumpToIndex(int index, FixedExtentScrollController controller,
          {Duration? duration}) =>
      controller.jumpToItem(index);

  @override
  void dispose() {
    super.dispose();
    controllerProvince.dispose();
    controllerCity.dispose();
    controllerDistrict.dispose();
  }
}
