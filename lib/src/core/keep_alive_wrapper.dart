import 'package:flutter/material.dart';
import 'package:flutter_waya/src/core/extended_state.dart';

/// 自动保持存活的 State 基类，用于列表或 PageView 中的子项。
abstract class FlAutomaticKeepAliveClientMixinState<T extends StatefulWidget> extends FlExtendedState<T>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}

/// 让任意子组件在可滚动列表中保持存活、不被销毁的包装器。
class FlAutomaticKeepAliveClientWrapper extends StatefulWidget {
  const FlAutomaticKeepAliveClientWrapper({super.key, required this.child});

  /// 需要保持存活的子组件。
  final Widget child;

  @override
  State<FlAutomaticKeepAliveClientWrapper> createState() => _AutomaticKeepAliveClientWrapperState();
}

class _AutomaticKeepAliveClientWrapperState
    extends FlAutomaticKeepAliveClientMixinState<FlAutomaticKeepAliveClientWrapper> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
