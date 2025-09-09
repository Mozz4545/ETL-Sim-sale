import 'dart:async';
import 'package:flutter/material.dart';

class SessionTimeoutWrapper extends StatefulWidget {
  final Widget child;
  const SessionTimeoutWrapper({required this.child, Key? key})
    : super(key: key);

  @override
  State<SessionTimeoutWrapper> createState() => _SessionTimeoutWrapperState();
}

class _SessionTimeoutWrapperState extends State<SessionTimeoutWrapper> {
  Timer? _sessionTimer;
  static const sessionTimeout = Duration(minutes: 60);

  void _resetSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(sessionTimeout, () {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _resetSessionTimer();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetSessionTimer,
      onPanDown: (_) => _resetSessionTimer(),
      child: widget.child,
    );
  }
}
// ...existing code...
// Wrap your MaterialApp with SessionTimeoutWrapper in main.dart or here if needed.
