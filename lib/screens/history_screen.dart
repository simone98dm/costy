import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';
import '../widgets/subscription_card.dart';
import '../widgets/subscription_details_modal.dart';
import '../utils/animations.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storageService = StorageService();
  List<Subscription> _subscriptions = [];
  bool _isLoading = true;
  String _filter = 'all'; // 'all', 'active', 'inactive'

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

  List<Subscription> get _filteredSubscriptions {
    switch (_filter) {
      case 'active':
        return _subscriptions.where((s) => s.isActive).toList();
      case 'inactive':
        return _subscriptions.where((s) => !s.isActive).toList();
      default:
        return _subscriptions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubs = _filteredSubscriptions;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('History', style: AppTextStyles.h1)],
              ),
            ),
            // Filter tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Row(
                  children: [
                    _buildFilterButton('All', 'all'),
                    _buildFilterButton('Active', 'active'),
                    _buildFilterButton('Inactive', 'inactive'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Subscription list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : filteredSubs.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filteredSubs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return AnimatedListItem(
                          index: index,
                          delay: const Duration(milliseconds: 30),
                          child: SubscriptionCard(
                            subscription: filteredSubs[index],
                            onTap: () =>
                                _showSubscriptionDetails(filteredSubs[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isSelected = _filter == value;
    final count = value == 'all'
        ? _subscriptions.length
        : value == 'active'
        ? _subscriptions.where((s) => s.isActive).length
        : _subscriptions.where((s) => !s.isActive).length;

    return Expanded(
      child: BouncingWidget(
        onTap: () {
          setState(() {
            _filter = value;
          });
        },
        scaleFactor: 0.95,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
          child: Column(
            children: [
              AnimatedDefaultTextStyle(
                duration: AppDurations.fast,
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
                child: Text(label, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 2),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textMuted.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    switch (_filter) {
      case 'active':
        message = 'No active subscriptions';
        break;
      case 'inactive':
        message = 'No inactive subscriptions';
        break;
      default:
        message = 'No subscriptions yet';
    }

    return Padding(
      padding: const EdgeInsets.all(48),
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
              _filter == 'active'
                  ? Icons.check_circle_outline
                  : _filter == 'inactive'
                  ? Icons.pause_circle_outline
                  : Icons.history_outlined,
              size: 60,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(message, style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _filter == 'all'
                ? 'Start adding subscriptions to track your spending'
                : 'Try changing the filter to see more subscriptions',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted,
          ),
        ],
      ),
    );
  }
}
