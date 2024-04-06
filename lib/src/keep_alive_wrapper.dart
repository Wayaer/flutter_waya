import 'package:flutter/material.dart';
import 'package:flutter_waya/src/extended_state.dart';

class FlAutomaticKeepAliveWrapper extends StatefulWidget {
  const FlAutomaticKeepAliveWrapper(this.child, {super.key});

  final Widget child;

  @override
  State<FlAutomaticKeepAliveWrapper> createState() =>
      _FlAutomaticKeepAliveWrapperState();
}

class _FlAutomaticKeepAliveWrapperState
    extends FlAutomaticKeepAliveWrapperState<FlAutomaticKeepAliveWrapper> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

abstract class FlAutomaticKeepAliveWrapperState<T extends StatefulWidget>
    extends ExtendedState<T> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}
