import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/add_subscription_sheet.dart';
import '../utils/animations.dart';
import '../theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 0;
  final PageController _pageController = PageController();
  int _refreshKey = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: AppDurations.normal,
      curve: Curves.easeInOutCubic,
    );
  }

  void _showAddSubscriptionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: AppDurations.slow,
      )..forward(),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddSubscriptionSheet(
          onSubscriptionAdded: () {
            // Force rebuild of pages
            setState(() {
              _refreshKey++;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Page view for different screens
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentNavIndex = index;
              });
            },
            children: [
              DashboardScreen(
                key: ValueKey('dashboard_$_refreshKey'),
                isEmbedded: true,
              ),
              HistoryScreen(key: ValueKey('history_$_refreshKey')),
              const _PlaceholderScreen(title: 'Insights'),
              const _PlaceholderScreen(title: 'Settings'),
            ],
          ),
          // FAB (only show on dashboard)
          if (_currentNavIndex == 0)
            Positioned(
              bottom: 112,
              right: AppSpacing.xl,
              child: PulsingWidget(
                minScale: 1.0,
                maxScale: 1.05,
                duration: const Duration(milliseconds: 2000),
                child: BouncingWidget(
                  onTap: _showAddSubscriptionSheet,
                  scaleFactor: 0.9,
                  child: Container(
                    width: AppConstants.fabSize,
                    height: AppConstants.fabSize,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.primaryGlow,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          // Bottom Navigation Bar
          BottomNavBar(currentIndex: _currentNavIndex, onTap: _onNavTap),
        ],
      ),
    );
  }
}

// Placeholder screen for Insights and Settings
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.cardDark,
                shape: BoxShape.circle,
              ),
              child: Icon(
                title == 'Insights'
                    ? Icons.bar_chart_outlined
                    : Icons.settings_outlined,
                size: 60,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(title, style: AppTextStyles.h1),
            const SizedBox(height: AppSpacing.sm),
            const Text('Coming soon', style: AppTextStyles.bodyMuted),
          ],
        ),
      ),
    );
  }
}
