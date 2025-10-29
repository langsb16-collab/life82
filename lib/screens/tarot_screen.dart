import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../services/analysis_service.dart';
import '../services/storage_service.dart';
import '../services/localization_service.dart';
import 'analysis_result_screen.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  final TextEditingController _questionController = TextEditingController();
  int _cardCount = 3;
  bool _isReading = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _performReading() async {
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<LocalizationService>().translate('enter_question'))),
      );
      return;
    }

    try {
      setState(() {
        _isReading = true;
      });

      final reading = await AnalysisService.performTarotReading(
        userId: 'demo_user',
        question: _questionController.text,
        cardCount: _cardCount,
      );

      await StorageService.saveAnalysis('tarot', reading.toJson());

      if (!mounted) return;

      setState(() {
        _isReading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisResultScreen(
            title: context.read<LocalizationService>().translate('tarot_title'),
            analysis: reading.analysis,
            confidence: 0.90,
            details: {
              '질문': reading.question,
              '선택된 카드': reading.cards.map((c) => '${c.nameKo} ${c.isReversed ? '(역방향)' : '(정방향)'}').join(', '),
            },
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error performing tarot reading: $e');
      }
      if (!mounted) return;
      
      setState(() {
        _isReading = false;
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
        title: Text(localization.translate('tarot_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.purple.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.style,
                          size: 80,
                          color: Colors.purple.shade700,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localization.translate('tarot_reading'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localization.translate('tarot_reading_desc'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  localization.translate('question'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: localization.translate('question_placeholder'),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.question_answer),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Text(
                  localization.translate('card_count'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _CardCountOption(
                        count: 1,
                        label: localization.translate('one_card'),
                        isSelected: _cardCount == 1,
                        onTap: () {
                          setState(() {
                            _cardCount = 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CardCountOption(
                        count: 3,
                        label: localization.translate('three_cards'),
                        isSelected: _cardCount == 3,
                        onTap: () {
                          setState(() {
                            _cardCount = 3;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CardCountOption(
                        count: 5,
                        label: localization.translate('five_cards'),
                        isSelected: _cardCount == 5,
                        onTap: () {
                          setState(() {
                            _cardCount = 5;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (_isReading)
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(localization.translate('drawing_cards')),
                      ],
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _performReading,
                    icon: const Icon(Icons.auto_fix_high),
                    label: Text(localization.translate('start_reading')),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.purple.shade700, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            localization.translate('tarot_guide'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• ${localization.translate('one_card')}: ${localization.translate('one_card_desc')}\n'
                        '• ${localization.translate('three_cards')}: ${localization.translate('three_cards_desc')}\n'
                        '• ${localization.translate('five_cards')}: ${localization.translate('five_cards_desc')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardCountOption extends StatelessWidget {
  final int count;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CardCountOption({
    required this.count,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
