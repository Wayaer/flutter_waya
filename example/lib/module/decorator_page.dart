import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter_waya/flutter_waya.dart';

class DecoratorBoxPage extends StatelessWidget {
  const DecoratorBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    BoxDecorative buildDecoration(bool hasFocus, bool isEditing) =>
        BoxDecorative(
            fillColor: context.theme.primaryColor.withValues(alpha: 0.2),
            borderType: BorderType.outline,
            borderSide: hasFocus
                ? BorderSide(color: context.theme.colorScheme.primary, width: 2)
                : BorderSide(
                    color: context.theme.colorScheme.primaryContainer,
                    width: 2),
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10));
    return ExtendedScaffold(
        isScroll: true,
        appBar: AppBarText('DecoratorBox'),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Partition('DecoratorBox hasFocus(true)', marginTop: 0),
          DecoratorBox(
              hasFocus: true, decoration: buildDecoration, child: TextField()),
          const Partition('DecoratorBox hasFocus(false)', marginTop: 0),
          DecoratorBox(
              hasFocus: false, decoration: buildDecoration, child: TextField()),
          _DecoratorBoxStatePage(),
          _DecoratorBoxStatePage(needEditing: true),
          _DecoratorBoxStatePage(needEditing: false),
          _DecoratorBoxStatePage(needFocus: true),
          _DecoratorBoxStatePage(needFocus: false),
          _DecoratorBoxStatePage(needFocus: true, needEditing: true),
          _DecoratorBoxStatePage(needFocus: true, needEditing: false),
          _DecoratorBoxStatePage(needFocus: false, needEditing: true),
          _DecoratorBoxStatePage(needFocus: false, needEditing: false),
        ]);
  }
}

class _DecoratorBoxStatePage extends StatefulWidget {
  const _DecoratorBoxStatePage({this.needFocus, this.needEditing});

  final bool? needFocus;
  final bool? needEditing;

  @override
  State<_DecoratorBoxStatePage> createState() => _DecoratorBoxStatePageState();
}

class _DecoratorBoxStatePageState extends State<_DecoratorBoxStatePage> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Universal(children: [
      Partition(
          'DecoratorBoxState \nneedFocus(${widget.needFocus}) needEditing(${widget.needEditing})'),
      DecoratorBoxState(
          listenable: Listenable.merge([focusNode, controller]),
          onFocus: () => focusNode.hasFocus,
          onEditing: () => controller.text.isNotEmpty,
          decoration: buildDecoration,
          footers: buildPendants,
          headers: buildPendants,
          prefixes: buildPendants,
          suffixes: buildPendants,
          child: TextField(focusNode: focusNode, controller: controller)),
    ]);
  }

  BoxDecorative buildDecoration(bool hasFocus, bool isEditing) => BoxDecorative(
      fillColor: context.theme.primaryColor.withValues(alpha: 0.2),
      borderType: BorderType.outline,
      borderSide: hasFocus
          ? BorderSide(color: context.theme.colorScheme.primary, width: 2)
          : BorderSide(
              color: context.theme.colorScheme.primaryContainer, width: 2),
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10));

  List<DecoratorPendant> get buildPendants =>
      DecoratorPendantPosition.values.builder((positioned) => DecoratorPendant(
          needFocus: widget.needFocus,
          needEditing: widget.needEditing,
          maintainSize: false,
          child: Text(positioned.name),
          positioned: positioned));

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    controller.dispose();
  }
}
