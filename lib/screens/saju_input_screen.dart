import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../services/analysis_service.dart';
import '../services/storage_service.dart';
import '../services/localization_service.dart';
import 'analysis_result_screen.dart';

class SajuInputScreen extends StatefulWidget {
  const SajuInputScreen({super.key});

  @override
  State<SajuInputScreen> createState() => _SajuInputScreenState();
}

class _SajuInputScreenState extends State<SajuInputScreen> {
  DateTime _birthDate = DateTime(1990, 1, 1);
  TimeOfDay _birthTime = const TimeOfDay(hour: 12, minute: 0);
  String _gender = '남성';
  bool _isAnalyzing = false;

  Future<void> _analyze() async {
    try {
      setState(() {
        _isAnalyzing = true;
      });

      final birthTimeStr = '${_birthTime.hour.toString().padLeft(2, '0')}:${_birthTime.minute.toString().padLeft(2, '0')}';

      final analysis = await AnalysisService.analyzeSaju(
        userId: 'demo_user',
        birthDate: _birthDate,
        birthTime: birthTimeStr,
        gender: _gender,
      );

      await StorageService.saveAnalysis('saju', analysis.toJson());

      if (!mounted) return;

      setState(() {
        _isAnalyzing = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisResultScreen(
            title: context.read<LocalizationService>().translate('saju_title'),
            analysis: analysis.analysis,
            confidence: 0.95,
            details: {
              ...analysis.pillars,
              '오행': analysis.elements,
              '영역별 운세': analysis.categoryAnalysis,
            },
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error analyzing saju: $e');
      }
      if (!mounted) return;
      
      setState(() {
        _isAnalyzing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.read<LocalizationService>().translate('error_occurred')}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('saju_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.orange.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 80,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localization.translate('saju_title'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localization.translate('saju_desc'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  localization.translate('birth_date'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.cake),
                    title: Text(
                      '${_birthDate.year}년 ${_birthDate.month}월 ${_birthDate.day}일',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _birthDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _birthDate = picked;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  localization.translate('birth_time'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      '${_birthTime.hour.toString().padLeft(2, '0')}:${_birthTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _birthTime,
                      );
                      if (picked != null) {
                        setState(() {
                          _birthTime = picked;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  localization.translate('gender'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: _gender == '남성' ? Theme.of(context).colorScheme.primaryContainer : null,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _gender = '남성';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.male,
                                  size: 40,
                                  color: _gender == '남성' ? Theme.of(context).colorScheme.primary : Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  localization.translate('male'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _gender == '남성' ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        color: _gender == '여성' ? Theme.of(context).colorScheme.primaryContainer : null,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _gender = '여성';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.female,
                                  size: 40,
                                  color: _gender == '여성' ? Theme.of(context).colorScheme.primary : Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  localization.translate('female'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _gender == '여성' ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (_isAnalyzing)
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(localization.translate('analyzing')),
                      ],
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: _analyze,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(localization.translate('analyze_saju')),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
