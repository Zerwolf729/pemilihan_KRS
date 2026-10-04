import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/course_data.dart';
import '../state/krs_state.dart';
import '../widgets/selected_course_card.dart';
import '../widgets/ta_badge.dart';

class SelectedScreen extends StatelessWidget {
  const SelectedScreen({
    super.key,
    required this.krsState,
    required this.onLanjutkanReview,
  });

  final KrsState krsState;
  final VoidCallback onLanjutkanReview;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: krsState,
      builder: (context, _) {
        final catalogue = CourseData.allCourses;
        final selected = krsState.selectedCourses(catalogue);
        final selectedCount = selected.length;
        final totalCredits = krsState.totalCredits(catalogue);
        final requiredCredits = krsState.requiredCredits(catalogue);
        final electiveCredits = krsState.electiveCredits(catalogue);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mata Kuliah Dipilih',
                            style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$selectedCount mata kuliah dipilih',
                            style: const TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 13,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const TaBadge(),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.selectedBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SummaryItem(
                            label: 'Wajib', value: '$requiredCredits'),
                        Container(
                            width: 1,
                            height: 28,
                            color: AppColors.selectedBorder),
                        _SummaryItem(
                            label: 'Pilihan', value: '$electiveCredits'),
                        Container(
                            width: 1,
                            height: 28,
                            color: AppColors.selectedBorder),
                        _SummaryItem(
                            label: 'Total', value: '$totalCredits'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: selected.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                color: AppColors.secondaryBackground,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.playlist_add_check,
                                size: 32,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada mata kuliah dipilih',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Work Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Pilih mata kuliah dari halaman Mata Kuliah untuk menambahkan ke daftar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Work Sans',
                                fontSize: 13,
                                color: AppColors.secondaryText,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      itemCount: selected.length,
                      itemBuilder: (context, index) {
                        final course = selected[index];
                        return SelectedCourseCard(
                          course: course,
                          onRemove: () => krsState.removeCourse(course.code),
                        );
                      },
                    ),
            ),
            if (selectedCount > 0)
              Container(
                padding:
                    const EdgeInsets.fromLTRB(16, 8, 16, 12),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 16, color: AppColors.success),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            totalCredits >= KrsState.maxTotalCredits
                                ? 'Beban studi sudah mencapai target ${KrsState.maxTotalCredits} SKS.'
                                : 'Beban studi belum mencapai target ${KrsState.maxTotalCredits} SKS.',
                            style: const TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: onLanjutkanReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lanjutkan Review',
                              style: TextStyle(
                                fontFamily: 'Work Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}