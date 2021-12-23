import 'dart:developer';

import 'package:flutter/widgets.dart';

class WidgetObserver extends StatefulWidget {
  final Function()? onInit;
  final Function()? onInactive;
  final Function()? onResume;
  final Function()? onDispose;
  final Widget child;

  WidgetObserver({
    required this.child,
    this.onInit,
    this.onInactive,
    this.onResume,
    this.onDispose,
    Key? key,
  }) : super(key: key);

  @override
  _WidgetObserverState createState() {
    //log("on: createState");
    return _WidgetObserverState();
  }
}

class _WidgetObserverState extends State<WidgetObserver>
    with WidgetsBindingObserver {
  _WidgetObserverState();

  @override
  void initState() {
    log("on: initState");
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    widget.onInit?.call();
  }

  @override
  void dispose() {
    log("on: disposeState");
    WidgetsBinding.instance?.removeObserver(this);
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //super.didChangeAppLifecycleState(state);
    //log("on: didChangeAppLifecycleState");
    switch (state) {
      case AppLifecycleState.inactive:
        log('inactive');
        widget.onInactive?.call();
        break;
      case AppLifecycleState.paused:
        log('paused');
        break;
      case AppLifecycleState.resumed:
        log('resumed');
        widget.onResume?.call();
        break;
      case AppLifecycleState.detached:
        log('detached');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
