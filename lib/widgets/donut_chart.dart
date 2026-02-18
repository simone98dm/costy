import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/subscription.dart';

class DonutChart extends StatelessWidget {
  final List<Subscription> subscriptions;
  final bool isMonthly;

  const DonutChart({
    super.key,
    required this.subscriptions,
    required this.isMonthly,
  });

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();
    
    return Column(
      children: [
        SizedBox(
          width: 256,
          height: 256,
          child: CustomPaint(
            painter: _DonutChartPainter(
              subscriptions: subscriptions,
              isMonthly: isMonthly,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total spent',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9DABB9),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: subscriptions.take(4).map((sub) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _parseColor(sub.color),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  sub.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9DABB9),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  double _calculateTotal() {
    return subscriptions.fold(0.0, (sum, sub) {
      return sum + (isMonthly ? sub.monthlyAmount : sub.yearlyAmount);
    });
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<Subscription> subscriptions;
  final bool isMonthly;

  _DonutChartPainter({
    required this.subscriptions,
    required this.isMonthly,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = 20.0;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = const Color(0xFF283039)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    if (subscriptions.isEmpty) return;

    // Calculate total amount
    final total = subscriptions.fold(0.0, (sum, sub) {
      return sum + (isMonthly ? sub.monthlyAmount : sub.yearlyAmount);
    });

    if (total == 0) return;

    // Draw subscription arcs
    double startAngle = -math.pi / 2; // Start from top

    for (final sub in subscriptions) {
      final amount = isMonthly ? sub.monthlyAmount : sub.yearlyAmount;
      final sweepAngle = (amount / total) * 2 * math.pi;

      final paint = Paint()
        ..color = _parseColor(sub.color)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_DonutChartPainter oldDelegate) {
    return oldDelegate.subscriptions != subscriptions ||
        oldDelegate.isMonthly != isMonthly;
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
