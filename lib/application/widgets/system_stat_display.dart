// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

import 'package:flutter/material.dart';
import 'package:yolo/domain/entities/system_health_state.dart';

/// A widget that displays detection statistics (count and FPS)
class SystemStatDisplay extends StatelessWidget {
  const SystemStatDisplay({super.key, required this.systemStatus});

  final SystemHealthState systemStatus;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SYSTEM: ${systemStatus.toDisplayString()}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
