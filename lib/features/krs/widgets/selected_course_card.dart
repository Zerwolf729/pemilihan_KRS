import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/course.dart';

class SelectedCourseCard extends StatelessWidget {
  const SelectedCourseCard({
    super.key,
    required this.course,
    this.onRemove,
    this.showTerpilihLabel = true,
    this.showRemoveButton = true,
    this.trailingCheck = true,
    this.compact = false,
  });

  final Course course;
  final VoidCallback? onRemove;
  final bool showTerpilihLabel;
  final bool showRemoveButton;
  final bool trailingCheck;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (trailingCheck) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.successBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 18,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: compact ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${course.code} • ${course.credits} SKS • ${course.type.label}',
                  style: const TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
                if (showTerpilihLabel) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Terpilih',
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showRemoveButton) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onRemove,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(Icons.close, size: 18, color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }
}