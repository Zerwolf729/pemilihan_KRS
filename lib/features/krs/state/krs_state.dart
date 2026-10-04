import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../data/course_data.dart';

/// Single source of truth for course selection.
///
/// All totals are derived from [CourseData.allCourses] so no screen ever
/// hardcodes a calculated value such as `26 SKS`.
class KrsState extends ChangeNotifier {
  final Set<String> _selectedCodes = {};

  static const int maxTotalCredits = 26;
  static const int maxWajibCredits = 2;
  static const int maxPilihanCredits = 24;

  Course? _byCode(String code) {
    for (final c in CourseData.allCourses) {
      if (c.code == code) return c;
    }
    return null;
  }

  bool isSelected(String code) => _selectedCodes.contains(code);

  /// True when [code] can still be added without breaking the per-type caps.
  bool canSelect(String code) {
    if (_selectedCodes.contains(code)) return true;
    final course = _byCode(code);
    if (course == null) return false;
    final current = course.type == CourseType.wajib
        ? requiredCredits(CourseData.allCourses)
        : electiveCredits(CourseData.allCourses);
    final cap =
        course.type == CourseType.wajib ? maxWajibCredits : maxPilihanCredits;
    return current + course.credits <= cap;
  }

  void toggleCourse(String code) {
    if (_selectedCodes.contains(code)) {
      _selectedCodes.remove(code);
      notifyListeners();
      return;
    }
    if (!canSelect(code)) return;
    _selectedCodes.add(code);
    notifyListeners();
  }

  void selectCourse(String code) {
    if (!canSelect(code)) return;
    if (_selectedCodes.add(code)) {
      notifyListeners();
    }
  }

  void removeCourse(String code) {
    if (_selectedCodes.remove(code)) {
      notifyListeners();
    }
  }

  bool get hasSelection => _selectedCodes.isNotEmpty;
  int get selectedCourseCount => _selectedCodes.length;

  List<Course> _fromCatalogue(List<Course> catalogue) {
    return catalogue.where((c) => _selectedCodes.contains(c.code)).toList();
  }

  int totalCredits(List<Course> catalogue) =>
      _fromCatalogue(catalogue).fold(0, (sum, c) => sum + c.credits);

  int requiredCredits(List<Course> catalogue) => _fromCatalogue(catalogue)
      .where((c) => c.type == CourseType.wajib)
      .fold(0, (sum, c) => sum + c.credits);

  int electiveCredits(List<Course> catalogue) => _fromCatalogue(catalogue)
      .where((c) => c.type == CourseType.pilihan)
      .fold(0, (sum, c) => sum + c.credits);

  List<Course> selectedCourses(List<Course> catalogue) =>
      _fromCatalogue(catalogue);

  double progress(List<Course> catalogue) =>
      totalCredits(catalogue) / maxTotalCredits;

  bool isTargetReached(List<Course> catalogue) =>
      totalCredits(catalogue) >= maxTotalCredits;
}
