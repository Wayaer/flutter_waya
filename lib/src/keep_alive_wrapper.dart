import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

abstract class AutomaticKeepAliveClientMixinState<T extends StatefulWidget>
    extends ExtendedState<T> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}

class AutomaticKeepAliveClientWrapper extends StatefulWidget {
  const AutomaticKeepAliveClientWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<AutomaticKeepAliveClientWrapper> createState() =>
      _AutomaticKeepAliveClientWrapperState();
}

class _AutomaticKeepAliveClientWrapperState
    extends AutomaticKeepAliveClientMixinState<
        AutomaticKeepAliveClientWrapper> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
