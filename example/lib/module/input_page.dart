import 'package:app/main.dart';
import 'package:app/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// 输入与表单分类页。
///
/// 覆盖组件：
/// - [FlPINTextField] 验证码 / PIN 输入
/// - [FlDecoratorBox] / [FlDecoratorPendant] 输入框装饰器
/// - [FlBorderType] / [FlInputDecorationExtension.noneBorder] 边框扩展
/// - [FlTextInputLimitFormatter] / [FlNumberLimitFormatter] 输入限制
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController pinBuilderController = TextEditingController();
  final TextEditingController pinObscureController = TextEditingController();
  final TextEditingController decoratorController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final FocusNode decoratorFocus = FocusNode();
  final FocusNode searchFocus = FocusNode();
  final FocusNode bioFocus = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    pinBuilderController.dispose();
    pinObscureController.dispose();
    decoratorController.dispose();
    searchController.dispose();
    amountController.dispose();
    bioController.dispose();
    numberController.dispose();
    decoratorFocus.dispose();
    searchFocus.dispose();
    bioFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
      isScroll: true,
      appBar: AppBarText('输入与表单'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const Partition('FlPINTextField · 基础用法', marginTop: 0),
        // spaces 会在每个方框之间插入组件，null 表示占位
        FlPINTextField(
          controller: pinController,
          decoration: boxDecoration(Colors.grey),
          focusedDecoration: boxDecoration(Theme.of(context).colorScheme.primary),
          onTap: () => showToast('点击 FlPINTextField'),
          onChanged: (String value) => log('FlPINTextField onChanged:$value'),
          onDone: (String value) => showToast('输入完成：$value'),
          spaces: const [null, Icon(Icons.ac_unit), Icon(Icons.ac_unit), Icon(Icons.ac_unit)],
        ),
        16.heightBox,
        const Partition('FlPINTextField · 自定义 TextField / 隐藏文本'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlPINTextField(
              controller: pinBuilderController,
              maxLength: 4,
              decoration: boxDecoration(Colors.grey),
              focusedDecoration: boxDecoration(Theme.of(context).colorScheme.primary),
              // builder 可以替换内部 TextField 的实现
              builder: (FlPINTextFieldBuilderConfig config) => TextField(
                controller: config.controller,
                decoration: config.decoration,
                autofocus: config.autofocus,
                keyboardType: config.keyboardType,
                style: config.style,
                onTap: config.onTap,
                showCursor: config.showCursor,
                contextMenuBuilder: config.contextMenuBuilder,
                inputFormatters: config.inputFormatters,
              ),
            ),
            FlPINTextField(
              controller: pinObscureController,
              obscureText: true,
              inputLimitFormatter: FlTextInputLimitFormatter.number,
              decoration: boxDecoration(Colors.grey),
              focusedDecoration: boxDecoration(Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        const Partition('FlDecoratorBox · 焦点装饰'),
        // listenable 变化时自动重建；onFocus/onEditing/onValue 提供状态
        FlDecoratorBox<TextEditingValue>(
          listenable: Listenable.merge([decoratorFocus, decoratorController]),
          onFocus: () => decoratorFocus.hasFocus,
          onEditing: () => decoratorController.text.isNotEmpty,
          onValue: () => decoratorController.value,
          decoration: (Widget child, FlDecoratorBoxStatus<TextEditingValue> status) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              border: FlBorderType.outline.toBorder(
                BorderSide(
                  width: 2,
                  color: status.hasFocus
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
          spacing: const FlDecoratorBoxSpacing(outerRowSpacing: 10),
          prefixes: [const Icon(Icons.person_outline).toDecoratorPendant()],
          suffixes: [
            // needEditing 为 true 时，只有输入框有内容才显示
            const Icon(Icons.clear).toDecoratorPendant(needEditing: true),
          ],
          child: TextField(
            focusNode: decoratorFocus,
            controller: decoratorController,
            decoration: const InputDecoration(isDense: true, hintText: '请输入内容').noneBorder,
          ),
        ),
        const Partition('FlDecoratorPendant · inner / header / footer'),
        FlDecoratorBox<TextEditingValue>(
          decoration: (Widget child, _) => Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: FlBorderType.underline.toBorder(
                BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: child,
          ),
          spacing: const FlDecoratorBoxSpacing(innerColumnSpacing: 4, innerRowSpacing: 8, outerColumnSpacing: 4),
          direction: const FlDecoratorBoxHeadersFootersDirection(
            innerHeaders: Axis.horizontal,
            innerFooters: Axis.horizontal,
          ),
          headers: [
            FlDecoratorPendant<TextEditingValue>.builder(
              builder: (FlDecoratorBoxStatus<TextEditingValue> status) =>
                  Text('header(hasFocus:${status.hasFocus})', style: const TextStyle(fontSize: 10)),
            ),
          ],
          footers: [
            const Text(
              'footer',
              style: TextStyle(fontSize: 10),
            ).toDecoratorPendant(positioned: FlDecoratorPendantPosition.inner),
          ],
          suffixes: [const Icon(Icons.ac_unit).toDecoratorPendant(positioned: FlDecoratorPendantPosition.inner)],
          child: const TextField(decoration: InputDecoration(isDense: true, hintText: 'inner pendant')),
        ),
        const Partition('FlDecoratorBox · 搜索框（内层前后缀）'),
        FlDecoratorBox<TextEditingValue>(
          listenable: Listenable.merge([searchController, searchFocus]),
          onFocus: () => searchFocus.hasFocus,
          onEditing: () => searchController.text.isNotEmpty,
          spacing: const FlDecoratorBoxSpacing(innerRowSpacing: 8),
          decoration: (Widget child, FlDecoratorBoxStatus<TextEditingValue> status) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: status.hasFocus ? Theme.of(context).colorScheme.primary : Colors.transparent,
              ),
            ),
            child: child,
          ),
          prefixes: [
            const Icon(Icons.search, size: 20).toDecoratorPendant(positioned: FlDecoratorPendantPosition.inner),
          ],
          suffixes: [
            GestureDetector(
              onTap: searchController.clear,
              child: const Icon(Icons.cancel, size: 18),
            ).toDecoratorPendant(needEditing: true, positioned: FlDecoratorPendantPosition.inner),
            const Text('⌘K').toDecoratorPendant(positioned: FlDecoratorPendantPosition.inner),
          ],
          child: TextField(
            focusNode: searchFocus,
            controller: searchController,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(hintText: '搜索组件', isDense: true).noneBorder,
          ),
        ),
        const Partition('FlDecoratorBox · 金额输入（多挂件 + needValue）'),
        FlDecoratorBox<TextEditingValue>(
          listenable: amountController,
          onValue: () => amountController.value,
          spacing: const FlDecoratorBoxSpacing(innerRowSpacing: 8),
          decoration: (Widget child, FlDecoratorBoxStatus<TextEditingValue> status) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
          prefixes: [
            const Text('¥', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)).toDecoratorPendant(),
          ],
          suffixes: [
            const Text('元').toDecoratorPendant(),
            FlDecoratorPendant<TextEditingValue>.builder(
              maintainSize: true,
              needValue: (TextEditingValue? value) => (value?.text.length ?? 0) > 6,
              builder: (_) => const Icon(Icons.error_outline, size: 18, color: Colors.orange),
            ),
          ],
          child: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FlNumberLimitFormatter(6, 2)],
            decoration: const InputDecoration(hintText: '0.00', isDense: true).noneBorder,
          ),
        ),
        const Partition('FlDecoratorBox · 多行文本（外层头尾）'),
        FlDecoratorBox<TextEditingValue>(
          listenable: Listenable.merge([bioController, bioFocus]),
          onFocus: () => bioFocus.hasFocus,
          spacing: const FlDecoratorBoxSpacing(outerColumnSpacing: 6),
          decoration: (Widget child, FlDecoratorBoxStatus<TextEditingValue> status) => Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: FlBorderType.outline.toBorder(
                BorderSide(
                  width: 1,
                  color: status.hasFocus
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
          headers: [
            const Text('个人简介').toDecoratorPendant(positioned: FlDecoratorPendantPosition.outer),
            const Text('选填', style: TextStyle(fontSize: 12)).toDecoratorPendant(
              positioned: FlDecoratorPendantPosition.outer,
            ),
          ],
          footers: [
            FlDecoratorPendant<TextEditingValue>.builder(
              positioned: FlDecoratorPendantPosition.outer,
              builder: (_) => Text('${bioController.text.length}/80', style: const TextStyle(fontSize: 12)),
            ),
          ],
          child: TextField(
            controller: bioController,
            focusNode: bioFocus,
            maxLines: 3,
            maxLength: 80,
            decoration: const InputDecoration(hintText: '介绍一下自己', counterText: '').noneBorder,
          ),
        ),
        const Partition('输入限制 · FlTextInputLimitFormatter / FlNumberLimitFormatter'),
        TextField(
          controller: numberController,
          keyboardType: FlTextInputLimitFormatter.decimal.toKeyboardType(),
          // 允许数字和小数点
          inputFormatters: FlTextInputLimitFormatter.decimal.toTextInputFormatter(),
          decoration: InputDecoration(
            labelText: '数字 / 小数',
            // FlBorderType 可快速转换为 InputBorder
            border: FlBorderType.outline.toInputBorder(),
            enabledBorder: FlBorderType.outline.toInputBorder(),
            focusedBorder: FlBorderType.outline.toInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
          ),
        ),
        10.heightBox,
        TextField(
          // FlNumberLimitFormatter(整数位, 小数位)：精确限制位数
          inputFormatters: [FlNumberLimitFormatter(4, 2)],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: '最多 4 位整数 + 2 位小数').noneBorder,
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  BoxDecoration boxDecoration(Color color) => BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    border: Border.all(width: 2, color: color),
  );
}
