enum SystemHealthState { normal, warning, critical }

extension SystemHealthStateExtension on SystemHealthState {
  String toDisplayString() {
    switch (this) {
      case SystemHealthState.normal:
        return 'NORMAL';
      case SystemHealthState.warning:
        return 'THROTTLED';
      case SystemHealthState.critical:
        return 'CRITICAL';
    }
  }
}
