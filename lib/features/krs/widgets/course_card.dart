import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.isSelected,
    required this.onTap,
    required this.onActionPressed,
  });

  final Course course;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedBackground : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.selectedBorder : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      course.code,
                      style: const TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const Text(
                      ' • ',
                      style: TextStyle(color: AppColors.mutedText),
                    ),
                    Text(
                      '${course.credits} SKS',
                      style: const TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: course.type == CourseType.wajib
                            ? AppColors.successBackground
                            : AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course.type.label,
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: course.type == CourseType.wajib
                              ? AppColors.success
                              : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onActionPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppColors.surface
                          : AppColors.primaryBlue,
                      foregroundColor: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.surface,
                      elevation: 0,
                      side: isSelected
                          ? const BorderSide(
                              color: AppColors.primaryBlue, width: 1)
                          : BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isSelected ? 'Terpilih' : 'Pilih',
                      style: const TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              course.name,
              style: const TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.subdirectory_arrow_right,
                  size: 14,
                  color: AppColors.mutedText,
                ),
                const SizedBox(width: 4),
                Text(
                  'Prasyarat: ${course.prerequisite}',
                  style: const TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}