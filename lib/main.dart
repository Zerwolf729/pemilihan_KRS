import 'package:flutter/material.dart';
import 'package:campus_app/core/theme/app_colors.dart';
import 'package:campus_app/core/theme/app_theme.dart';
import 'features/krs/models/course.dart';
import 'features/krs/state/krs_state.dart';
import 'features/krs/screens/home_screen.dart';
import 'features/krs/screens/mata_kuliah_screen.dart';
import 'features/krs/screens/detail_screen.dart';
import 'features/krs/screens/selected_screen.dart';
import 'features/krs/screens/review_screen.dart';
import 'features/krs/screens/confirmation_screen.dart';

void main() {
  runApp(const KrsApp());
}

class KrsApp extends StatelessWidget {
  const KrsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRS Semester 5',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const KrsShell(),
    );
  }
}

class KrsShell extends StatefulWidget {
  const KrsShell({super.key});

  @override
  State<KrsShell> createState() => _KrsShellState();
}

class _KrsShellState extends State<KrsShell> {
  int _bottomNavIndex = 0; // 0: Home, 1: Mata Kuliah, 2: Dipilih

  // Navigation stack for non-bottom-nav screens
  // null = showing bottom nav root screens
  // otherwise holds current screen identifier and data
  String? _currentSubScreen; // 'detail', 'review', 'confirmation'
  Course? _selectedCourseForDetail;

  final KrsState _krsState = KrsState();

  @override
  void dispose() {
    _krsState.dispose();
    super.dispose();
  }

  bool get _showBottomNav => _currentSubScreen == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            _buildBody(),
          ],
        ),
      ),
      bottomNavigationBar: _showBottomNav
          ? Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: BottomNavigationBar(
                currentIndex: _bottomNavIndex,
                onTap: (index) {
                  setState(() {
                    _bottomNavIndex = index;
                    _currentSubScreen = null;
                  });
                },
                backgroundColor: AppColors.surface,
                selectedItemColor: AppColors.primaryBlue,
                unselectedItemColor: AppColors.mutedText,
                selectedLabelStyle: const TextStyle(
                  fontFamily: 'Work Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Work Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_outlined),
                    activeIcon: Icon(Icons.menu_book),
                    label: 'Mata Kuliah',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.checklist_outlined),
                    activeIcon: Icon(Icons.checklist),
                    label: 'Dipilih',
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_currentSubScreen == 'detail' && _selectedCourseForDetail != null) {
      return DetailScreen(
        krsState: _krsState,
        course: _selectedCourseForDetail!,
        onBack: () => setState(() {
          _currentSubScreen = null;
          _bottomNavIndex = 1;
        }),
      );
    }
    if (_currentSubScreen == 'review') {
      return ReviewScreen(
        krsState: _krsState,
        onConfirm: () => setState(() => _currentSubScreen = 'confirmation'),
        onBack: () => setState(() {
          _currentSubScreen = null;
          _bottomNavIndex = 2;
        }),
      );
    }
    if (_currentSubScreen == 'confirmation') {
      return ConfirmationScreen(
        krsState: _krsState,
        onHome: () => setState(() {
          _currentSubScreen = null;
          _bottomNavIndex = 0;
        }),
        onLihatKRS: () => setState(() {
          _currentSubScreen = null;
          _bottomNavIndex = 2;
        }),
      );
    }

    // Root bottom nav tabs
    switch (_bottomNavIndex) {
      case 0:
        return HomeScreen(
          krsState: _krsState,
          onMulaiPilih: () => setState(() => _bottomNavIndex = 1),
        );
      case 1:
        return MataKuliahScreen(
          krsState: _krsState,
          onCourseTap: (course) => setState(() {
            _selectedCourseForDetail = course;
            _currentSubScreen = 'detail';
          }),
          onLihatPilihan: () => setState(() => _bottomNavIndex = 2),
        );
      case 2:
        return SelectedScreen(
          krsState: _krsState,
          onLanjutkanReview: () => setState(() => _currentSubScreen = 'review'),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}