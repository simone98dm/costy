import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../utils/animations.dart';
import 'delete_confirmation_dialog.dart';

class SubscriptionDetailsModal extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onDelete;
  final Function(bool) onToggleStatus;

  const SubscriptionDetailsModal({
    super.key,
    required this.subscription,
    required this.onDelete,
    required this.onToggleStatus,
  });

  static Future<void> show({
    required BuildContext context,
    required Subscription subscription,
    required VoidCallback onDelete,
    required Function(bool) onToggleStatus,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SubscriptionDetailsModal(
        subscription: subscription,
        onDelete: onDelete,
        onToggleStatus: onToggleStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value * 50),
          child: Opacity(opacity: 1 - value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        decoration: const BoxDecoration(
          color: Color(0xFF1C2127),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _parseColor(subscription.color),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: _buildIcon()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subscription.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: subscription.isActive
                                    ? const Color(
                                        0xFF34C759,
                                      ).withValues(alpha: 0.15)
                                    : const Color(
                                        0xFF9DABB9,
                                      ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                subscription.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: subscription.isActive
                                      ? const Color(0xFF34C759)
                                      : const Color(0xFF9DABB9),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getCategoryLabel(subscription.category),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9DABB9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  BouncingWidget(
                    onTap: () => Navigator.pop(context),
                    scaleFactor: 0.9,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF9DABB9),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cost info
                    _buildDetailSection('Cost Information', [
                      _buildDetailRow(
                        'Amount',
                        '${subscription.currencySymbol}${subscription.amount.toStringAsFixed(2)} / ${_getCycleLabel(subscription.cycle)}',
                      ),
                      _buildDetailRow(
                        'Monthly equivalent',
                        '${subscription.currencySymbol}${subscription.monthlyAmount.toStringAsFixed(2)} / mo',
                      ),
                      _buildDetailRow(
                        'Yearly equivalent',
                        '${subscription.currencySymbol}${subscription.yearlyAmount.toStringAsFixed(2)} / yr',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    // Billing info
                    _buildDetailSection('Billing Information', [
                      _buildDetailRow(
                        'Billing date',
                        dateFormat.format(subscription.billingDate),
                      ),
                      _buildDetailRow(
                        'Next renewal',
                        dateFormat.format(subscription.nextRenewalDate),
                      ),
                      _buildDetailRow(
                        'Days until renewal',
                        '${subscription.daysUntilRenewal} days',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    // Notifications
                    _buildDetailSection('Notifications', [
                      _buildDetailRow(
                        'Alert',
                        '${subscription.alertDays} days before renewal',
                      ),
                      _buildDetailRow(
                        'Enabled',
                        subscription.notificationsEnabled ? 'Yes' : 'No',
                      ),
                    ]),
                    const SizedBox(height: 32),
                    // Action buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Toggle status button
                        BouncingWidget(
                          onTap: () {
                            onToggleStatus(!subscription.isActive);
                            Navigator.pop(context);
                          },
                          scaleFactor: 0.97,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: subscription.isActive
                                  ? const Color(
                                      0xFF9DABB9,
                                    ).withValues(alpha: 0.15)
                                  : const Color(
                                      0xFF34C759,
                                    ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: subscription.isActive
                                    ? const Color(
                                        0xFF9DABB9,
                                      ).withValues(alpha: 0.3)
                                    : const Color(
                                        0xFF34C759,
                                      ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  subscription.isActive
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline,
                                  color: subscription.isActive
                                      ? const Color(0xFF9DABB9)
                                      : const Color(0xFF34C759),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  subscription.isActive
                                      ? 'Mark as Inactive'
                                      : 'Mark as Active',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: subscription.isActive
                                        ? const Color(0xFF9DABB9)
                                        : const Color(0xFF34C759),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Delete button
                        BouncingWidget(
                          onTap: () async {
                            Navigator.pop(context);
                            final result = await DeleteConfirmationDialog.show(
                              context: context,
                              subscriptionName: subscription.name,
                            );
                            if (result == true) {
                              onDelete();
                            }
                          },
                          scaleFactor: 0.97,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFF3B30,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFFFF3B30,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFFFF3B30),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Delete Subscription',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF3B30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9DABB9),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF283039),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF9DABB9)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    // Special handling for Netflix (show 'N' text)
    if (subscription.name.toLowerCase().contains('netflix')) {
      return const Text(
        'N',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Color(0xFFE50914),
        ),
      );
    }

    // For other subscriptions, show an icon
    IconData iconData;
    Color iconColor = Colors.white;

    switch (subscription.category.toLowerCase()) {
      case 'media':
        iconData = Icons.movie_outlined;
        break;
      case 'health':
        iconData = Icons.fitness_center_outlined;
        break;
      case 'utility':
        iconData = Icons.bolt_outlined;
        break;
      default:
        iconData = Icons.subscriptions_outlined;
    }

    // Special icon colors for known services
    if (subscription.name.toLowerCase().contains('spotify')) {
      iconData = Icons.graphic_eq_outlined;
      iconColor = Colors.black;
    } else if (subscription.name.toLowerCase().contains('adobe')) {
      iconData = Icons.design_services_outlined;
      iconColor = const Color(0xFF31A8FF);
    }

    return Icon(iconData, size: 28, color: iconColor);
  }

  String _getCategoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'media':
        return 'Media & Entertainment';
      case 'health':
        return 'Health & Fitness';
      case 'utility':
        return 'Utility';
      default:
        return category;
    }
  }

  String _getCycleLabel(String cycle) {
    switch (cycle.toLowerCase()) {
      case 'weekly':
        return 'week';
      case 'yearly':
        return 'year';
      default:
        return 'month';
    }
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
