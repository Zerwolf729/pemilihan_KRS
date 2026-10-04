import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/course_data.dart';
import '../state/krs_state.dart';
import '../widgets/selected_course_card.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({
    super.key,
    required this.krsState,
    required this.onConfirm,
    required this.onBack,
  });

  final KrsState krsState;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.arrow_back,
                          size: 20, color: AppColors.darkText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review Pilihan',
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkText,
                        ),
                      ),
                      Text(
                        'Periksa sebelum konfirmasi',
                        style: TextStyle(
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$selectedCount Mata Kuliah • $totalCredits SKS',
                            style: const TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Wajib $requiredCredits SKS • Pilihan $electiveCredits SKS',
                            style: const TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...selected.map((c) => SelectedCourseCard(
                          course: c,
                          showRemoveButton: false,
                          showTerpilihLabel: false,
                          trailingCheck: true,
                          compact: true,
                        )),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _ConfirmationFooter(onConfirm: onConfirm),
          ],
        );
      },
    );
  }
}

class _ConfirmationFooter extends StatefulWidget {
  const _ConfirmationFooter({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  State<_ConfirmationFooter> createState() => _ConfirmationFooterState();
}

class _ConfirmationFooterState extends State<_ConfirmationFooter> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: _checked,
                onChanged: (val) => setState(() => _checked = val!),
                activeColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              const Expanded(
                child: Text(
                  'Saya sudah memeriksa dan menyetujui pilihan mata kuliah KRS Semester 5.',
                  style: TextStyle(
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
              onPressed: _checked ? widget.onConfirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                disabledBackgroundColor: AppColors.border,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Konfirmasi Pilihan',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}