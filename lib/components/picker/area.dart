part of 'picker.dart';

extension ExtensionAreaPicker on AreaPicker {
  Future<List<String>?> show({BottomSheetOptions? options}) =>
      popupBottomSheet<List<String>?>(options: options);
}

typedef AreaPickerChanged = void Function(List<String> value);

/// 省市区三级联动
class AreaPicker extends PickerStatefulWidget<List<String>> {
  AreaPicker({
    super.key,
    this.province,
    this.city,
    this.district,
    this.contentStyle,
    this.enableCity = true,
    this.enableDistrict = true,
    super.options = const PickerOptions<List<String>>(),
    PickerWheelOptions? wheelOptions,
    this.onChanged,
    this.height = kPickerDefaultHeight,
    this.width = double.infinity,
  })  : assert(enableDistrict == enableCity || enableCity,
            'To enable district, city must be enabled first'),
        super(wheelOptions: wheelOptions ?? GlobalOptions().pickerWheelOptions);

  /// 默认选择的省
  final String? province;

  /// 默认选择的市
  final String? city;

  final bool enableCity;

  /// 默认选择的区
  final String? district;

  /// 是否开启区
  final bool enableDistrict;

  /// 内容字体样式
  final TextStyle? contentStyle;

  /// onChanged
  final AreaPickerChanged? onChanged;

  /// height
  final double height;

  /// width
  final double width;

  @override
  State<AreaPicker> createState() => _AreaPickerState();
}

class _AreaPickerState extends State<AreaPicker> {
  List<String> province = <String>[];
  List<String> city = <String>[];
  List<String> district = <String>[];

  /// List<String> street = <String>[];
  Map<String, dynamic> areaData = areaDataMap;

  int provinceIndex = 0;
  int cityIndex = 0;
  int districtIndex = 0;
  int streetIndex = 0;

  FixedExtentScrollController? controllerProvince,
      controllerCity,
      controllerDistrict;

  StateSetter? cityState;
  StateSetter? districtState;
  late PickerWheelOptions wheelOptions;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    wheelOptions = GlobalOptions().pickerWheelOptions;

    /// 省
    province = areaData.keys.toList();
    if (province.contains(widget.province)) {
      provinceIndex = province.indexOf(widget.province!);
    }
    controllerProvince =
        FixedExtentScrollController(initialItem: provinceIndex);
    if (widget.enableCity) {
      final Map<dynamic, dynamic> provinceData =
          areaData[province[provinceIndex]] as Map<dynamic, dynamic>;

      /// 市
      city = provinceData.keys.toList() as List<String>;
      if (city.contains(widget.city)) {
        cityIndex = city.indexOf(widget.city!);
      }
      controllerCity = FixedExtentScrollController(initialItem: cityIndex);
      if (widget.enableDistrict) {
        final Map<dynamic, dynamic> cityData =
            provinceData[city[cityIndex]] as Map<dynamic, dynamic>;

        /// 区
        district = cityData.keys.toList() as List<String>;
        if (district.contains(widget.district)) {
          districtIndex = district.indexOf(widget.district!);
        }
        controllerDistrict =
            FixedExtentScrollController(initialItem: districtIndex);
      }
    }
    onChanged();

    ///  var districtData = cityData[districtIndex];

    /// 街道
    ///  street = districtData[districtIndex];
  }

  void refreshCity() {
    final Map<dynamic, dynamic> provinceData =
        areaData[province[provinceIndex]] as Map<dynamic, dynamic>;
    city = provinceData.keys.toList() as List<String>;
    cityState?.call(() {});
    final Map<dynamic, dynamic> cityData =
        provinceData[city[city.length < cityIndex ? 0 : cityIndex]]
            as Map<dynamic, dynamic>;
    district = cityData.keys.toList() as List<String>;
    districtState?.call(() {});
    controllerCity?.jumpTo(0);
    controllerDistrict?.jumpTo(0);
  }

  void refreshDistrict() {
    final Map<dynamic, dynamic> cityData = areaData[province[provinceIndex]]
        [city[cityIndex]] as Map<dynamic, dynamic>;
    district = cityData.keys.toList() as List<String>;
    districtState?.call(() {});
    controllerDistrict?.jumpTo(0);
  }

  @override
  void didUpdateWidget(covariant AreaPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialize();
    setState(() {});
  }

  String lastArea = '';

  void onChanged() {
    final current = confirmTap();
    if (current.toString() != lastArea) {
      lastArea = current.toString();
      widget.onChanged?.call(current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rowChildren = [
      wheelItem(province, controller: controllerProvince,
          onChanged: (int newIndex) {
        provinceIndex = newIndex;
        if (widget.enableCity) refreshCity();
        onChanged();
      }).expandedNull,
    ];

    if (widget.enableCity) {
      rowChildren.add(StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        cityState = setState;
        return wheelItem(city,
            childDelegateType: ListWheelChildDelegateType.list,
            controller: controllerCity, onChanged: (int newIndex) {
          cityIndex = newIndex;
          if (widget.enableDistrict) refreshDistrict();
          onChanged();
        });
      }).expandedNull);
      if (widget.enableDistrict) {
        rowChildren.add(StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          districtState = setState;
          return wheelItem(district,
              childDelegateType: ListWheelChildDelegateType.list,
              controller: controllerDistrict, onChanged: (int newIndex) {
            districtIndex = newIndex;
            onChanged();
          });
        }).expandedNull);
      }
    }

    final area = Universal(
        direction: Axis.horizontal,
        width: widget.width,
        height: widget.height,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren);
    if (widget.options == null) return area;
    return PickerSubject<List<String>>(
        options: widget.options!, confirmTap: confirmTap, child: area);
  }

  /// 点击确定返回选择的地区
  List<String> confirmTap() => [
        province[provinceIndex],
        if (widget.enableCity) ...[
          city[cityIndex],
          if (widget.enableDistrict) district[districtIndex]
        ]
      ];

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
          style: widget.contentStyle ?? context.textTheme.bodyLarge));

  void jumpToIndex(int index, FixedExtentScrollController controller,
          {Duration? duration}) =>
      controller.jumpToItem(index);

  @override
  void dispose() {
    controllerProvince?.dispose();
    controllerCity?.dispose();
    controllerDistrict?.dispose();
    super.dispose();
  }
}
