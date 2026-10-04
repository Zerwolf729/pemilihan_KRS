import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../features/krs/models/course.dart';

/// Small pill badge. Variants cover the status colours used across the app so
/// no screen invents its own chip styling.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
  });

  final String label;
  final BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
      BadgeVariant.wajib => (AppColors.successBackground, AppColors.success),
      BadgeVariant.pilihan => (AppColors.secondaryBackground, AppColors.secondaryText),
      BadgeVariant.primary => (AppColors.selectedBackground, AppColors.primaryBlue),
      BadgeVariant.success => (AppColors.successBackground, AppColors.success),
      BadgeVariant.neutral => (AppColors.secondaryBackground, AppColors.secondaryText),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Work Sans',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}

enum BadgeVariant { wajib, pilihan, primary, success, neutral }

/// Convenience wrapper so callers pass a [CourseType] instead of a variant.
class CourseTypeBadge extends StatelessWidget {
  const CourseTypeBadge({super.key, required this.type});

  final CourseType type;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: type.label,
      variant: type == CourseType.wajib
          ? BadgeVariant.wajib
          : BadgeVariant.pilihan,
    );
  }
}
