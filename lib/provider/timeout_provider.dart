import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';

// application timeout (in seconds)
const int appTimeout = 10;

class TimeoutProvider extends ValueNotifier<bool> {
  TimeoutProvider() : super(false);

  final Duration _duration = const Duration(seconds: appTimeout);
  Timer? _timer;
  VoidCallback? _listener;

  bool get exceeded => value;

  bool get hasListener => _listener != null;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void start() {
    if (!(_timer?.isActive == true)) {
      log('TimeoutProvider:start:${DateTime.now().toIso8601String()}');
      _initializeTimer();
    }
  }

  void stop() {
    if (_timer?.isActive == true) {
      log('TimeoutProvider:stop:${DateTime.now().toIso8601String()}');
      value = false;
      _timer?.cancel();
    }
  }

  void reset() {
    if (_timer?.isActive == true) {
      log('TimeoutProvider:reset:${DateTime.now().toIso8601String()}');
      _timer?.cancel();
      _initializeTimer();
    }
  }

  void addTimeoutListener(VoidCallback listener) {
    _listener = listener;
  }

  void removeTimeoutListener() => _listener = null;

  void _initializeTimer() {
    value = false;
    _timer = Timer.periodic(_duration, _handleTimerExceeded);
  }

  void _handleTimerExceeded(_) {
    log('TimeoutProvider:handleTimerExceeded');
    if (!exceeded) {
      value = true;
      _listener?.call();
    }
  }
}
