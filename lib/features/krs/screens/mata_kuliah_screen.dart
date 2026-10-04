import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/course_data.dart';
import '../models/course.dart';
import '../state/krs_state.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/ta_badge.dart';

class MataKuliahScreen extends StatefulWidget {
  const MataKuliahScreen({
    super.key,
    required this.krsState,
    required this.onCourseTap,
    required this.onLihatPilihan,
  });

  final KrsState krsState;
  final ValueChanged<Course> onCourseTap;
  final VoidCallback onLihatPilihan;

  @override
  State<MataKuliahScreen> createState() => _MataKuliahScreenState();
}

class _MataKuliahScreenState extends State<MataKuliahScreen> {
  String _searchQuery = '';
  CourseType? _selectedFilter; // null = Semua
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Course> _filteredCourses(List<Course> catalogue) {
    return catalogue.where((c) {
      if (_selectedFilter != null && c.type != _selectedFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = c.name.toLowerCase().contains(query);
        final matchCode = c.code.toLowerCase().contains(query);
        if (!matchName && !matchCode) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.krsState,
      builder: (context, _) {
        final catalogue = CourseData.allCourses;
        final filtered = _filteredCourses(catalogue);
        final selectedCount = widget.krsState.selectedCourseCount;
        final totalCredits = widget.krsState.totalCredits(catalogue);

        return Stack(
          children: [
            Column(
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
                                'Mata Kuliah',
                                style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${catalogue.length} mata kuliah tersedia',
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
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: const TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            color: AppColors.darkText,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Cari kode atau mata kuliah',
                            hintStyle: const TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 14,
                              color: AppColors.mutedText,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.mutedText,
                              size: 20,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : const Icon(
                                    Icons.tune,
                                    color: AppColors.mutedText,
                                    size: 20,
                                  ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          FilterChipWidget(
                            label: 'Semua',
                            isSelected: _selectedFilter == null,
                            onTap: () => setState(() => _selectedFilter = null),
                          ),
                          const SizedBox(width: 8),
                          FilterChipWidget(
                            label: 'Wajib',
                            isSelected: _selectedFilter == CourseType.wajib,
                            onTap: () => setState(
                                () => _selectedFilter = CourseType.wajib),
                          ),
                          const SizedBox(width: 8),
                          FilterChipWidget(
                            label: 'Pilihan',
                            isSelected: _selectedFilter == CourseType.pilihan,
                            onTap: () => setState(
                                () => _selectedFilter = CourseType.pilihan),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada mata kuliah ditemukan',
                            style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 14,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            selectedCount > 0 ? 90 : 16,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final course = filtered[index];
                            final isSel =
                                widget.krsState.isSelected(course.code);
                            return CourseCard(
                              course: course,
                              isSelected: isSel,
                              onTap: () => widget.onCourseTap(course),
                              onActionPressed: () =>
                                  widget.krsState.toggleCourse(course.code),
                            );
                          },
                        ),
                ),
              ],
            ),
            if (selectedCount > 0)
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Pilihan sementara',
                            style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$selectedCount mata kuliah • $totalCredits SKS',
                            style: const TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: widget.onLihatPilihan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Lihat Pilihan',
                          style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}