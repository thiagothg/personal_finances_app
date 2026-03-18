// lib/src/core/theme/color_extensions.dart
import 'package:flutter/material.dart';

@immutable
class ExtraColors extends ThemeExtension<ExtraColors> {
  final Color success;
  final Color warning;

  const ExtraColors({required this.success, required this.warning});

  @override
  ExtraColors copyWith({Color? success, Color? warning}) {
    return ExtraColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  ExtraColors lerp(ThemeExtension<ExtraColors>? other, double t) {
    if (other is! ExtraColors) return this;
    return ExtraColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
