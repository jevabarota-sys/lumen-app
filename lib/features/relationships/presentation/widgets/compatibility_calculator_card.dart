import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/compatibility_calculator.dart';

class CompatibilityCalculatorCard extends StatefulWidget {
  const CompatibilityCalculatorCard({super.key});

  @override
  State<CompatibilityCalculatorCard> createState() =>
      _CompatibilityCalculatorCardState();
}

class _CompatibilityCalculatorCardState
    extends State<CompatibilityCalculatorCard> {
  final _person1NameController = TextEditingController();
  final _person2NameController = TextEditingController();
  DateTime? _person1Birth;
  DateTime? _person2Birth;
  String _compatibilityType = 'romantic';
  Map<String, dynamic>? _result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: AppTheme.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Compatibility Calculator',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        'Discover your relationship compatibility',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.neutral,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Romantic'),
                    value: 'romantic',
                    groupValue: _compatibilityType,
                    onChanged: (value) {
                      setState(() {
                        _compatibilityType = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Friendship'),
                    value: 'friendship',
                    groupValue: _compatibilityType,
                    onChanged: (value) {
                      setState(() {
                        _compatibilityType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _person1NameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your full name',
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Your Birth Date',
                ),
                child: Text(
                  _person1Birth != null
                      ? '${_person1Birth!.day}/${_person1Birth!.month}/${_person1Birth!.year}'
                      : 'Select your birth date',
                  style: TextStyle(
                    color: _person1Birth != null ? null : AppTheme.neutral,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _person2NameController,
              decoration: const InputDecoration(
                labelText: 'Partner/Friend Name',
                hintText: 'Enter their full name',
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Their Birth Date',
                ),
                child: Text(
                  _person2Birth != null
                      ? '${_person2Birth!.day}/${_person2Birth!.month}/${_person2Birth!.year}'
                      : 'Select their birth date',
                  style: TextStyle(
                    color: _person2Birth != null ? null : AppTheme.neutral,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canCalculate() ? _calculateCompatibility : null,
                child: const Text('Calculate Compatibility'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              _buildResultSection(),
            ],
          ],
        ),
      ),
    );
  }

  bool _canCalculate() {
    return _person1NameController.text.isNotEmpty &&
        _person2NameController.text.isNotEmpty &&
        _person1Birth != null &&
        _person2Birth != null;
  }

  void _calculateCompatibility() {
    final result = _compatibilityType == 'romantic'
        ? CompatibilityCalculator.calculateRomanticCompatibility(
            _person1NameController.text,
            _person1Birth!,
            _person2NameController.text,
            _person2Birth!,
          )
        : CompatibilityCalculator.calculateFriendshipCompatibility(
            _person1NameController.text,
            _person1Birth!,
            _person2NameController.text,
            _person2Birth!,
          );

    setState(() {
      _result = result;
    });
  }

  Widget _buildResultSection() {
    final score = _result!['overallScore'] as int;
    final insights = _result!['insights'] as List<String>;
    final advice = _result!['advice'] as String;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Compatibility Results',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  '$score%',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                ),
                Text(
                  _getScoreDescription(score),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Insights:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          ...insights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        insight,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          Text(
            'Advice:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            advice,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  String _getScoreDescription(int score) {
    if (score >= 90) return 'Excellent Match';
    if (score >= 80) return 'Very Compatible';
    if (score >= 70) return 'Good Compatibility';
    if (score >= 60) return 'Fair Compatibility';
    return 'Challenging Match';
  }

  Future<void> _selectDate(BuildContext context, bool isPerson1) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isPerson1) {
          _person1Birth = picked;
        } else {
          _person2Birth = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _person1NameController.dispose();
    _person2NameController.dispose();
    super.dispose();
  }
}
