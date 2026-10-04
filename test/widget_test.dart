import 'package:campus_app/features/krs/data/course_data.dart';
import 'package:campus_app/features/krs/models/course.dart';
import 'package:campus_app/features/krs/state/krs_state.dart';
import 'package:campus_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KrsState', () {
    late KrsState state;

    setUp(() => state = KrsState());
    tearDown(() => state.dispose());

    test('starts empty', () {
      expect(state.selectedCourseCount, 0);
      expect(state.totalCredits(CourseData.allCourses), 0);
      expect(state.requiredCredits(CourseData.allCourses), 0);
      expect(state.electiveCredits(CourseData.allCourses), 0);
    });

    test('toggle selects and deselects', () {
      state.toggleCourse('000800');
      expect(state.isSelected('000800'), isTrue);
      expect(state.totalCredits(CourseData.allCourses), 2);
      expect(state.requiredCredits(CourseData.allCourses), 2);

      state.toggleCourse('000800');
      expect(state.isSelected('000800'), isFalse);
      expect(state.totalCredits(CourseData.allCourses), 0);
    });

    test('splits wajib and elective credits correctly', () {
      state.selectCourse('000800'); // wajib 2 SKS
      state.selectCourse('110700'); // pilihan 3 SKS
      state.selectCourse('111100'); // pilihan 3 SKS

      expect(state.selectedCourseCount, 3);
      expect(state.requiredCredits(CourseData.allCourses), 2);
      expect(state.electiveCredits(CourseData.allCourses), 6);
      expect(state.totalCredits(CourseData.allCourses), 8);
    });

    test('full catalogue reaches 26 SKS target', () {
      for (final course in CourseData.allCourses) {
        state.selectCourse(course.code);
      }
      expect(state.totalCredits(CourseData.allCourses), 26);
      expect(state.requiredCredits(CourseData.allCourses), 2);
      expect(state.electiveCredits(CourseData.allCourses), 24);
    });

    test('removeCourse clears selection', () {
      state.selectCourse('111300');
      state.removeCourse('111300');
      expect(state.isSelected('111300'), isFalse);
    });

    test('selectCourse is idempotent', () {
      state.selectCourse('111300');
      state.selectCourse('111300');
      expect(state.selectedCourseCount, 1);
      expect(state.totalCredits(CourseData.allCourses), 3);
    });
  });

  group('CourseData', () {
    test('has 9 unique courses', () {
      expect(CourseData.allCourses.length, 9);
      final codes = CourseData.allCourses.map((c) => c.code).toSet();
      expect(codes.length, 9);
    });

    test('exactly one wajib course worth 2 SKS', () {
      final wajib = CourseData.allCourses
          .where((c) => c.type == CourseType.wajib)
          .toList();
      expect(wajib.length, 1);
      expect(wajib.first.credits, 2);
    });

    test('eight pilihan courses worth 24 SKS', () {
      final pilihan = CourseData.allCourses
          .where((c) => c.type == CourseType.pilihan)
          .toList();
      expect(pilihan.length, 8);
      expect(pilihan.fold(0, (s, c) => s + c.credits), 24);
    });
  });

  group('Widget smoke', () {
    testWidgets('home screen renders and navigates to course list', (tester) async {
      await tester.pumpWidget(const KrsApp());

      expect(find.text('KRS Semester 5'), findsOneWidget);
      expect(find.text('Belum ada mata kuliah dipilih'), findsOneWidget);

      await tester.tap(find.text('Mulai Pilih Mata Kuliah'));
      await tester.pumpAndSettle();

      expect(find.text('Mata Kuliah'), findsOneWidget);
      expect(find.text('9 mata kuliah tersedia'), findsOneWidget);
    });

    testWidgets('search filters course list', (tester) async {
      await tester.pumpWidget(const KrsApp());

      await tester.tap(find.text('Mulai Pilih Mata Kuliah'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Kriptografi');
      await tester.pumpAndSettle();

      expect(find.text('Kriptografi'), findsOneWidget);
      expect(find.text('Robotika'), findsNothing);
    });

    testWidgets('wajib filter shows only wajib course', (tester) async {
      await tester.pumpWidget(const KrsApp());

      await tester.tap(find.text('Mulai Pilih Mata Kuliah'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Wajib'));
      await tester.pumpAndSettle();

      expect(find.text('Penulisan dan Publikasi Ilmiah'), findsOneWidget);
      expect(find.text('Kriptografi'), findsNothing);
    });

    testWidgets('selecting a course updates home progress', (tester) async {
      await tester.pumpWidget(const KrsApp());

      await tester.tap(find.text('Mulai Pilih Mata Kuliah'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.text('2/26 SKS'), findsOneWidget);
      expect(find.text('Belum ada mata kuliah dipilih'), findsNothing);
    });

    testWidgets('confirmation button disabled until checkbox checked',
        (tester) async {
      await tester.pumpWidget(const KrsApp());

      // select all courses so review has content
      await tester.tap(find.text('Mulai Pilih Mata Kuliah'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Semua'));
      await tester.pumpAndSettle();

      for (final label in [
        'Pilih',
        'Pilih',
        'Pilih',
        'Pilih',
        'Pilih',
        'Pilih',
        'Pilih',
        'Pilih',
        'Pilih',
      ]) {
        await tester.tap(find.text(label).first);
        await tester.pumpAndSettle();
      }

      await tester.tap(find.text('Lihat Pilihan'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lanjutkan Review'));
      await tester.pumpAndSettle();

      expect(find.text('Review Pilihan'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('Konfirmasi Pilihan'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNull);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      final buttonAfter = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('Konfirmasi Pilihan'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(buttonAfter.onPressed, isNotNull);
    });
  });
}