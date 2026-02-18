// Example of how to use the centralized theme system

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use AppColors for background
      backgroundColor: AppColors.bgDark,

      body: Column(
        children: [
          // Use AppTextStyles for typography
          Text('Header', style: AppTextStyles.h1),
          Text('Subheader', style: AppTextStyles.h2),
          Text('Body text', style: AppTextStyles.body),
          Text('Muted text', style: AppTextStyles.bodyMuted),

          // Use AppSpacing for consistent spacing
          SizedBox(height: AppSpacing.lg),

          // Use AppColors for custom containers
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: [
                // Primary color for buttons
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Primary Button'),
                ),

                SizedBox(height: AppSpacing.sm),

                // Error/Delete button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: const Text('Delete'),
                ),

                SizedBox(height: AppSpacing.sm),

                // Success/Active indicator
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Text(
                    'Active',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card with shadow
          Container(
            margin: EdgeInsets.all(AppSpacing.lg),
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.05),
              ),
              boxShadow: AppShadows.card,
            ),
            child: Text('Card with shadow', style: AppTextStyles.body),
          ),
        ],
      ),
    );
  }
}

/* 
MIGRATION GUIDE:
================

Replace hardcoded colors with AppColors:
----------------------------------------
Before: Color(0xFF101922)
After:  AppColors.bgDark

Before: Color(0xFF1C2127)
After:  AppColors.cardDark

Before: Color(0xFF1C2128)
After:  AppColors.inputDark

Before: Color(0xFF283039)
After:  AppColors.surfaceDark

Before: Color(0xFF137FEC)
After:  AppColors.primary

Before: Color(0xFF9DABB9)
After:  AppColors.textMuted

Before: Colors.white
After:  AppColors.textPrimary

Before: Color(0xFFFF3B30)
After:  AppColors.error

Before: Color(0xFF34C759)
After:  AppColors.success

Before: Colors.orange
After:  AppColors.warning


Replace hardcoded spacing:
--------------------------
Before: const SizedBox(height: 8)
After:  const SizedBox(height: AppSpacing.sm)

Before: const SizedBox(height: 16)
After:  const SizedBox(height: AppSpacing.lg)

Before: const SizedBox(height: 24)
After:  const SizedBox(height: AppSpacing.xl)


Replace hardcoded border radius:
---------------------------------
Before: BorderRadius.circular(12)
After:  BorderRadius.circular(AppRadius.medium)

Before: BorderRadius.circular(16)
After:  BorderRadius.circular(AppRadius.large)

Before: BorderRadius.circular(24)
After:  BorderRadius.circular(AppRadius.xlarge)


Use consistent text styles:
----------------------------
Before: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
After:  AppTextStyles.h1

Before: TextStyle(fontSize: 14, color: Color(0xFF9DABB9))
After:  AppTextStyles.bodyMuted


Use shadow presets:
--------------------
Before: BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: Offset(0, 2))
After:  ...boxShadow: AppShadows.card

Before: BoxShadow(color: Color(0xFF137FEC).withValues(alpha: 0.5), blurRadius: 25, ...)
After:  ...boxShadow: AppShadows.primaryGlow

*/
