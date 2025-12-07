import 'package:app/main.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class DecoratorBoxPage extends StatelessWidget {
  const DecoratorBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildDecoration(
            Widget child, DecoratorBoxStatus<TextEditingValue> status) =>
        Container(
            decoration: BoxDecoration(
                color: context.theme.primaryColor.withValues(alpha: 0.2),
                border: BorderType.outline.toBorder(status.hasFocus
                    ? BorderSide(
                        color: context.theme.colorScheme.primary, width: 2)
                    : BorderSide(
                        color: context.theme.colorScheme.primaryContainer,
                        width: 2)),
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: child);
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('DecoratorBox'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('DecoratorBox hasFocus(true)', marginTop: 0),
          DecoratorBox(
              onFocus: () => true,
              decoration: buildDecoration,
              child: TextField()),
          const Partition('DecoratorBox hasFocus(false)', marginTop: 0),
          DecoratorBox(
              onFocus: () => false,
              decoration: buildDecoration,
              child: TextField()),
          _DecoratorBoxPage(),
          _DecoratorBoxPage(needEditing: true),
          _DecoratorBoxPage(needEditing: false),
          _DecoratorBoxPage(needFocus: true),
          _DecoratorBoxPage(needFocus: false),
          _DecoratorBoxPage(needFocus: true, needEditing: true),
          _DecoratorBoxPage(needFocus: true, needEditing: false),
          _DecoratorBoxPage(needFocus: false, needEditing: true),
          _DecoratorBoxPage(needFocus: false, needEditing: false),
        ]);
  }
}

class _DecoratorBoxPage extends StatefulWidget {
  const _DecoratorBoxPage({this.needFocus, this.needEditing});

  final bool? needFocus;
  final bool? needEditing;

  @override
  State<_DecoratorBoxPage> createState() => _DecoratorBoxPageState();
}

class _DecoratorBoxPageState extends State<_DecoratorBoxPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Universal(children: [
      Partition(
          'DecoratorBox \nneedFocus(${widget.needFocus}) needEditing(${widget.needEditing})'),
      DecoratorBox<TextEditingValue>(
          listenable: Listenable.merge([focusNode, controller]),
          onFocus: () => focusNode.hasFocus,
          onEditing: () => controller.text.isNotEmpty,
          onValue: () => controller.value,
          decoration: buildDecoration,
          direction: DecoratorBoxHeadersFootersDirection(
            innerHeaders: Axis.horizontal,
            innerFooters: Axis.horizontal,
            outerHeaders: Axis.horizontal,
            outerFooters: Axis.horizontal,
          ),
          spacing: DecoratorBoxSpacing(innerColumnSpacing: 4, innerRowSpacing: 4, outerColumnSpacing: 4, outerRowSpacing: 4),
          footers: buildPendants,
          headers: buildPendants,
          prefixes: buildPendants,
          suffixes: buildPendants,
          child: TextField(focusNode: focusNode, controller: controller)),
    ]);
  }

  Widget buildDecoration(
          Widget child, DecoratorBoxStatus<TextEditingValue> status) =>
      Container(
          decoration: BoxDecoration(
              color: context.theme.primaryColor.withValues(alpha: 0.2),
              border: BorderType.outline.toBorder(status.hasFocus
                  ? BorderSide(
                      color: context.theme.colorScheme.primary,
                      width:
                          (status.value?.text.contains('1') ?? false) ? 4 : 2)
                  : BorderSide(
                      color: context.theme.colorScheme.primaryContainer,
                      width: 2)),
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: child);

  List<DecoratorPendant<TextEditingValue>> get buildPendants {
    List<DecoratorPendant<TextEditingValue>> pendants = [];
    DecoratorPendantPosition.values.builder((positioned) {
      pendants.add(DecoratorPendant<TextEditingValue>(
          needFocus: widget.needFocus,
          needEditing: widget.needEditing,
          maintainSize: false,
          child: Text('${positioned.name.substring(0, 2)}0', style: TextStyle(fontSize: 10)),
          positioned: positioned));
      pendants.add(DecoratorPendant<TextEditingValue>(
          needFocus: widget.needFocus,
          needEditing: widget.needEditing,
          maintainSize: false,
          child: Text('${positioned.name.substring(0, 2)}1', style: TextStyle(fontSize: 10)),
          positioned: positioned));
    });

    return pendants;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    controller.dispose();
  }
}
