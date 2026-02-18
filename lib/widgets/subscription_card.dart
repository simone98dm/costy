import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../utils/animations.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback? onTap;

  const SubscriptionCard({super.key, required this.subscription, this.onTap});

  @override
  Widget build(BuildContext context) {
    final daysLeft = subscription.daysUntilRenewal;
    final nextDate = subscription.nextRenewalDate;
    final dateFormat = DateFormat('MMM dd');

    return BouncingWidget(
      onTap: onTap,
      scaleFactor: 0.97,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2127),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _parseColor(subscription.color),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: _buildIcon()),
            ),
            const SizedBox(width: 16),
            // Subscription info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${subscription.currencySymbol}${subscription.amount.toStringAsFixed(2)} / ${subscription.cycleLabel}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9DABB9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Days left badge and date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getBadgeColor(daysLeft).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$daysLeft ${daysLeft == 1 ? "Day" : "Days"} Left',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getBadgeColor(daysLeft),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(nextDate),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9DABB9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Special handling for Netflix (show 'N' text)
    if (subscription.name.toLowerCase().contains('netflix')) {
      return const Text(
        'N',
        style: TextStyle(
          fontSize: 20,
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

    return Icon(iconData, size: 24, color: iconColor);
  }

  Color _getBadgeColor(int daysLeft) {
    if (daysLeft <= 3) {
      return const Color(0xFF137FEC); // Primary blue
    } else if (daysLeft <= 10) {
      return Colors.orange;
    } else {
      return const Color(0xFF9DABB9); // Muted
    }
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
