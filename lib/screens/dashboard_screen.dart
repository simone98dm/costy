import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';
import '../widgets/donut_chart.dart';
import '../widgets/subscription_card.dart';
import '../widgets/add_subscription_sheet.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/subscription_details_modal.dart';
import '../utils/animations.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  final bool isEmbedded;

  const DashboardScreen({super.key, this.isEmbedded = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final StorageService _storageService = StorageService();
  List<Subscription> _subscriptions = [];
  bool _isMonthly = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    setState(() => _isLoading = true);
    final subs = await _storageService.loadSubscriptions();
    setState(() {
      _subscriptions = subs;
      _isLoading = false;
    });
  }

  Future<void> _deleteSubscription(String id) async {
    await _storageService.deleteSubscription(id);
    await _loadSubscriptions();
  }

  Future<void> _toggleSubscriptionStatus(
    Subscription subscription,
    bool isActive,
  ) async {
    final updated = subscription.copyWith(isActive: isActive);
    await _storageService.updateSubscription(updated);
    await _loadSubscriptions();
  }

  void _showSubscriptionDetails(Subscription subscription) {
    SubscriptionDetailsModal.show(
      context: context,
      subscription: subscription,
      onDelete: () => _deleteSubscription(subscription.id),
      onToggleStatus: (isActive) =>
          _toggleSubscriptionStatus(subscription, isActive),
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
        child: AddSubscriptionSheet(onSubscriptionAdded: _loadSubscriptions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter for active subscriptions only
    final activeSubscriptions = _subscriptions
        .where((s) => s.isActive)
        .toList();
    final sortedSubscriptions = activeSubscriptions.toList()
      ..sort((a, b) => a.daysUntilRenewal.compareTo(b.daysUntilRenewal));

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Dashboard', style: AppTextStyles.h1)],
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              // Monthly/Yearly toggle
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardDark,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.medium,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildToggleButton('Monthly', _isMonthly),
                                      _buildToggleButton('Yearly', !_isMonthly),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Donut chart
                              if (activeSubscriptions.isEmpty)
                                _buildEmptyState()
                              else
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.scale(
                                        scale: 0.8 + (0.2 * value),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: DonutChart(
                                      subscriptions: activeSubscriptions,
                                      isMonthly: _isMonthly,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 32),
                              // Upcoming Renewals section
                              if (activeSubscriptions.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Upcoming Renewals',
                                        style: AppTextStyles.h3,
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'See all',
                                          style: AppTextStyles.labelBold
                                              .copyWith(
                                                color: AppColors.primary,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: sortedSubscriptions.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final subscription =
                                        sortedSubscriptions[index];
                                    return AnimatedListItem(
                                      index: index,
                                      delay: const Duration(milliseconds: 50),
                                      child: SubscriptionCard(
                                        subscription: subscription,
                                        onTap: () => _showSubscriptionDetails(
                                          subscription,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              const SizedBox(
                                height: 120,
                              ), // Bottom padding for nav bar
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
          // FAB with animation (only when not embedded)
          if (!widget.isEmbedded)
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
          // Bottom Navigation Bar (only when not embedded)
          if (!widget.isEmbedded)
            BottomNavBar(currentIndex: 0, onTap: (index) {}),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected) {
    return Expanded(
      child: BouncingWidget(
        onTap: () {
          setState(() {
            _isMonthly = label == 'Monthly';
          });
        },
        scaleFactor: 0.95,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceDark : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.small),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: AnimatedDefaultTextStyle(
            duration: AppDurations.fast,
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
            child: Text(label, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: AppColors.cardDark,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.subscriptions_outlined,
              size: 60,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('No Subscriptions Yet', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Tap the + button below to add your first subscription',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted,
          ),
        ],
      ),
    );
  }
}
