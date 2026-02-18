import 'package:uuid/uuid.dart';

class Subscription {
  final String id;
  final String name;
  final double amount;
  final String currency; // USD, EUR, GBP
  final String category; // media, health, utility
  final String cycle; // weekly, monthly, yearly
  final DateTime billingDate;
  final int alertDays;
  final bool notificationsEnabled;
  final String color; // hex string
  final String iconName;
  final bool isActive; // true = active, false = inactive

  Subscription({
    String? id,
    required this.name,
    required this.amount,
    this.currency = 'USD',
    this.category = 'media',
    this.cycle = 'monthly',
    required this.billingDate,
    this.alertDays = 3,
    this.notificationsEnabled = true,
    this.color = '#137fec',
    this.iconName = 'subscriptions',
    this.isActive = true,
  }) : id = id ?? const Uuid().v4();

  String get currencySymbol {
    switch (currency) {
      case 'EUR':
        return '\u20AC';
      case 'GBP':
        return '\u00A3';
      default:
        return '\$';
    }
  }

  String get cycleLabel {
    switch (cycle) {
      case 'weekly':
        return 'wk';
      case 'yearly':
        return 'yr';
      default:
        return 'mo';
    }
  }

  double get monthlyAmount {
    switch (cycle) {
      case 'weekly':
        return amount * 4.33;
      case 'yearly':
        return amount / 12;
      default:
        return amount;
    }
  }

  double get yearlyAmount {
    switch (cycle) {
      case 'weekly':
        return amount * 52;
      case 'monthly':
        return amount * 12;
      default:
        return amount;
    }
  }

  int get daysUntilRenewal {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime next = DateTime(
      billingDate.year,
      billingDate.month,
      billingDate.day,
    );

    switch (cycle) {
      case 'weekly':
        while (next.isBefore(today) || next.isAtSameMomentAs(today)) {
          next = next.add(const Duration(days: 7));
        }
        break;
      case 'yearly':
        while (next.isBefore(today) || next.isAtSameMomentAs(today)) {
          next = DateTime(next.year + 1, next.month, next.day);
        }
        break;
      default: // monthly
        while (next.isBefore(today) || next.isAtSameMomentAs(today)) {
          next = DateTime(next.year, next.month + 1, next.day);
        }
    }
    return next.difference(today).inDays;
  }

  DateTime get nextRenewalDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime next = DateTime(
      billingDate.year,
      billingDate.month,
      billingDate.day,
    );

    switch (cycle) {
      case 'weekly':
        while (next.isBefore(today) || next.isAtSameMomentAs(today)) {
          next = next.add(const Duration(days: 7));
        }
        break;
      case 'yearly':
        while (next.isBefore(today) || next.isAtSameMomentAs(today)) {
          next = DateTime(next.year + 1, next.month, next.day);
        }
        break;
      default:
        while (next.isBefore(today) || next.isAtSameMomentAs(today)) {
          next = DateTime(next.year, next.month + 1, next.day);
        }
    }
    return next;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'currency': currency,
    'category': category,
    'cycle': cycle,
    'billingDate': billingDate.toIso8601String(),
    'alertDays': alertDays,
    'notificationsEnabled': notificationsEnabled,
    'color': color,
    'iconName': iconName,
    'isActive': isActive,
  };

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json['id'] as String,
    name: json['name'] as String,
    amount: (json['amount'] as num).toDouble(),
    currency: json['currency'] as String? ?? 'USD',
    category: json['category'] as String? ?? 'media',
    cycle: json['cycle'] as String? ?? 'monthly',
    billingDate: DateTime.parse(json['billingDate'] as String),
    alertDays: json['alertDays'] as int? ?? 3,
    notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    color: json['color'] as String? ?? '#137fec',
    iconName: json['iconName'] as String? ?? 'subscriptions',
    isActive: json['isActive'] as bool? ?? true,
  );

  Subscription copyWith({
    String? name,
    double? amount,
    String? currency,
    String? category,
    String? cycle,
    DateTime? billingDate,
    int? alertDays,
    bool? notificationsEnabled,
    String? color,
    String? iconName,
    bool? isActive,
  }) => Subscription(
    id: id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    category: category ?? this.category,
    cycle: cycle ?? this.cycle,
    billingDate: billingDate ?? this.billingDate,
    alertDays: alertDays ?? this.alertDays,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    color: color ?? this.color,
    iconName: iconName ?? this.iconName,
    isActive: isActive ?? this.isActive,
  );
}
