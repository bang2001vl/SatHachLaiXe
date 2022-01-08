import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:sathachlaixe/singleston/connect.dart';

class WidgetObserver extends StatefulWidget {
  final Function()? onInit;
  final Function()? onInactive;
  final Function()? onResume;
  final Function()? onDispose;
  final Function(bool isonline)? onConnectivityChanged;
  final Widget child;

  WidgetObserver({
    required this.child,
    this.onInit,
    this.onInactive,
    this.onResume,
    this.onDispose,
    this.onConnectivityChanged,
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
    MyConnectivity.instance.myStream.listen((isOnline) {
      widget.onConnectivityChanged?.call(isOnline);
    });
  }

  @override
  void dispose() {
    log("on: disposeState");
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //super.didChangeAppLifecycleState(state);
    //log("on: didChangeAppLifecycleState");
    switch (state) {
      case AppLifecycleState.inactive:
        log('on: inactive');
        widget.onInactive?.call();
        break;
      case AppLifecycleState.paused:
        log('on: paused');
        break;
      case AppLifecycleState.resumed:
        log('on: resumed');
        widget.onResume?.call();
        break;
      case AppLifecycleState.detached:
        log('on: detached');
        widget.onDispose?.call();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
