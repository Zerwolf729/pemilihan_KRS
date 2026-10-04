import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TaBadge extends StatelessWidget {
  const TaBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.selectedBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'TA 2026',
        style: TextStyle(
          fontFamily: 'Work Sans',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}