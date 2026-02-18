import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';

class AddSubscriptionSheet extends StatefulWidget {
  final VoidCallback onSubscriptionAdded;

  const AddSubscriptionSheet({super.key, required this.onSubscriptionAdded});

  @override
  State<AddSubscriptionSheet> createState() => _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends State<AddSubscriptionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _storageService = StorageService();

  String _currency = 'USD';
  String _category = 'media';
  String _cycle = 'monthly';
  DateTime _billingDate = DateTime.now();
  int _alertDays = 3;
  bool _notificationsEnabled = true;
  String _color = '#137fec';

  final List<Map<String, dynamic>> _quickPicks = [
    {'name': 'Netflix', 'color': '#E50914'},
    {'name': 'Spotify', 'color': '#1ED760'},
    {'name': 'Disney+', 'color': '#113CCF'},
    {'name': 'Apple', 'color': '#000000'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _selectQuickPick(Map<String, dynamic> quickPick) {
    setState(() {
      _nameController.text = quickPick['name'];
      _color = quickPick['color'];
    });
  }

  Future<void> _saveSubscription() async {
    if (!_formKey.currentState!.validate()) return;

    final subscription = Subscription(
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text),
      currency: _currency,
      category: _category,
      cycle: _cycle,
      billingDate: _billingDate,
      alertDays: _alertDays,
      notificationsEnabled: _notificationsEnabled,
      color: _color,
      iconName: 'subscriptions',
    );

    await _storageService.saveSubscription(subscription);

    if (mounted) {
      widget.onSubscriptionAdded();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Subscription',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Create a new tracking entry',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Color(0xFF9DABB9)),
                    ),
                  ),
                ],
              ),
            ),
            // Form content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildServiceNameField(),
                      const SizedBox(height: 32),
                      _buildAmountField(),
                      const SizedBox(height: 32),
                      _buildCategoryField(),
                      const SizedBox(height: 32),
                      _buildCycleField(),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(child: _buildBillingDateField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildAlertField()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildNotificationsToggle(),
                      const SizedBox(height: 32),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Service Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'REQUIRED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.4),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Netflix, Spotify, Adobe...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF9DABB9)),
            filled: true,
            fillColor: const Color(0xFF1C2128),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF137FEC)),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a service name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickPicks.map((pick) {
            return GestureDetector(
              onTap: () => _selectQuickPick(pick),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _parseColor(pick['color']),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pick['name'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Amount',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2128),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currency,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  dropdownColor: const Color(0xFF1C2128),
                  icon: const Icon(Icons.expand_more, color: Color(0xFF9DABB9)),
                  items: ['USD', 'EUR', 'GBP'].map((currency) {
                    String symbol;
                    switch (currency) {
                      case 'EUR':
                        symbol = '€';
                        break;
                      case 'GBP':
                        symbol = '£';
                        break;
                      default:
                        symbol = '\$';
                    }
                    return DropdownMenuItem(
                      value: currency,
                      child: Text('$symbol $currency'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _currency = value!;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  filled: true,
                  fillColor: const Color(0xFF1C2128).withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(12),
                    ),
                    borderSide: BorderSide(color: Color(0xFF137FEC)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid amount';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCategoryOption(
                'media',
                Icons.movie_outlined,
                'Media',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryOption(
                'health',
                Icons.fitness_center_outlined,
                'Health',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryOption(
                'utility',
                Icons.bolt_outlined,
                'Utility',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryOption(String value, IconData icon, String label) {
    final isSelected = _category == value;
    return GestureDetector(
      onTap: () => setState(() => _category = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF137FEC).withValues(alpha: 0.05)
              : const Color(0xFF1C2128),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF137FEC)
                : Colors.white.withValues(alpha: 0.05),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF137FEC)
                  : const Color(0xFF9DABB9),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? const Color(0xFF137FEC)
                    : const Color(0xFF9DABB9),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Renewal Cycle',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCycleOption(
                'weekly',
                Icons.calendar_view_week_outlined,
                'Weekly',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCycleOption(
                'monthly',
                Icons.calendar_month_outlined,
                'Monthly',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCycleOption(
                'yearly',
                Icons.calendar_today_outlined,
                'Yearly',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCycleOption(String value, IconData icon, String label) {
    final isSelected = _cycle == value;
    return GestureDetector(
      onTap: () => setState(() => _cycle = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF137FEC).withValues(alpha: 0.05)
              : const Color(0xFF1C2128),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF137FEC)
                : Colors.white.withValues(alpha: 0.05),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? const Color(0xFF137FEC)
                  : const Color(0xFF9DABB9),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? const Color(0xFF137FEC)
                    : const Color(0xFF9DABB9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Billing Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _billingDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFF137FEC),
                      surface: Color(0xFF1C2127),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() => _billingDate = date);
            }
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2128),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(_billingDate),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF9DABB9),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alert me',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2128),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _alertDays,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF137FEC),
              ),
              dropdownColor: const Color(0xFF1C2128),
              isExpanded: true,
              items: [1, 3, 5, 7, 14].map((days) {
                return DropdownMenuItem(
                  value: days,
                  child: Text('$days ${days == 1 ? "day" : "days"} before'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _alertDays = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_outlined, color: Color(0xFF137FEC)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Notifications',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Get reminded before renewal',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9DABB9)),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            activeTrackColor: const Color(0xFF137FEC),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Discard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9DABB9),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveSubscription,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF137FEC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
