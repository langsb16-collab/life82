import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';
import 'dart:math';

class TodayFortuneScreen extends StatefulWidget {
  const TodayFortuneScreen({super.key});

  @override
  State<TodayFortuneScreen> createState() => _TodayFortuneScreenState();
}

class _TodayFortuneScreenState extends State<TodayFortuneScreen> {
  final Random _random = Random();
  late Map<String, dynamic> _todayFortune;

  @override
  void initState() {
    super.initState();
    _generateTodayFortune();
  }

  void _generateTodayFortune() {
    final localization = context.read<LocalizationService>();
    final isKorean = localization.currentLanguage == 'ko';
    
    _todayFortune = {
      'overall': _random.nextInt(100) + 1,
      'love': _random.nextInt(100) + 1,
      'money': _random.nextInt(100) + 1,
      'health': _random.nextInt(100) + 1,
      'work': _random.nextInt(100) + 1,
      'luckyNumber': _random.nextInt(100),
      'luckyColor': _getLuckyColor(),
      'luckyItem': isKorean ? _getKoreanLuckyItem() : _getEnglishLuckyItem(),
      'advice': isKorean ? _getKoreanAdvice() : _getEnglishAdvice(),
    };
  }

  Color _getLuckyColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.yellow,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  String _getKoreanLuckyItem() {
    final items = ['커피', '음악', '꽃', '책', '향초', '티셔츠', '모자', '선글라스'];
    return items[_random.nextInt(items.length)];
  }

  String _getEnglishLuckyItem() {
    final items = ['Coffee', 'Music', 'Flower', 'Book', 'Candle', 'T-shirt', 'Hat', 'Sunglasses'];
    return items[_random.nextInt(items.length)];
  }

  String _getKoreanAdvice() {
    final advices = [
      '오늘은 새로운 도전을 시작하기 좋은 날입니다.',
      '주변 사람들과의 소통을 늘려보세요.',
      '건강에 신경 쓰는 하루를 보내세요.',
      '긍정적인 마음가짐이 행운을 불러옵니다.',
      '작은 변화가 큰 행운을 가져다줄 수 있어요.',
    ];
    return advices[_random.nextInt(advices.length)];
  }

  String _getEnglishAdvice() {
    final advices = [
      'Today is a great day to start something new.',
      'Increase communication with people around you.',
      'Focus on your health today.',
      'A positive mindset brings good fortune.',
      'Small changes can bring great luck.',
    ];
    return advices[_random.nextInt(advices.length)];
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    final isKorean = localization.currentLanguage == 'ko';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD93D), Color(0xFFFF6B6B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        localization.translate('today_fortune_title'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD93D).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${DateTime.now().year}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().day.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B6B),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Overall Fortune
                        _buildFortuneCard(
                          title: localization.translate('overall_fortune'),
                          score: _todayFortune['overall'],
                          icon: Icons.star,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD93D), Color(0xFFFF6B6B)],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Fortune Categories
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallFortuneCard(
                                title: isKorean ? '연애운' : 'Love',
                                score: _todayFortune['love'],
                                icon: Icons.favorite,
                                color: Colors.pink,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSmallFortuneCard(
                                title: isKorean ? '금전운' : 'Money',
                                score: _todayFortune['money'],
                                icon: Icons.attach_money,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallFortuneCard(
                                title: isKorean ? '건강운' : 'Health',
                                score: _todayFortune['health'],
                                icon: Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSmallFortuneCard(
                                title: isKorean ? '직장운' : 'Work',
                                score: _todayFortune['work'],
                                icon: Icons.work,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Lucky Info
                        _buildLuckySection(
                          title: isKorean ? '🍀 오늘의 행운' : '🍀 Today\'s Luck',
                          children: [
                            _buildLuckyItem(
                              label: isKorean ? '행운의 숫자' : 'Lucky Number',
                              value: _todayFortune['luckyNumber'].toString(),
                              icon: Icons.filter_9_plus,
                            ),
                            const SizedBox(height: 16),
                            _buildLuckyColorItem(
                              label: isKorean ? '행운의 색상' : 'Lucky Color',
                              color: _todayFortune['luckyColor'],
                            ),
                            const SizedBox(height: 16),
                            _buildLuckyItem(
                              label: isKorean ? '행운의 아이템' : 'Lucky Item',
                              value: _todayFortune['luckyItem'],
                              icon: Icons.shopping_bag,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Advice
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade50,
                                Colors.blue.shade50,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.purple.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lightbulb, color: Colors.orange.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    isKorean ? '오늘의 조언' : 'Today\'s Advice',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _todayFortune['advice'],
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Refresh Button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _generateTodayFortune();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(isKorean ? '다시 보기' : 'Refresh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD93D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFortuneCard({
    required String title,
    required int score,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      ' / 100',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildScoreIndicator(score),
        ],
      ),
    );
  }

  Widget _buildSmallFortuneCard({
    required String title,
    required int score,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator(int score) {
    String emoji;
    if (score >= 80) {
      emoji = '😄';
    } else if (score >= 60) {
      emoji = '🙂';
    } else if (score >= 40) {
      emoji = '😐';
    } else {
      emoji = '😔';
    }
    
    return Text(
      emoji,
      style: const TextStyle(fontSize: 32),
    );
  }

  Widget _buildLuckySection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLuckyItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade700),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
          ),
        ),
      ],
    );
  }

  Widget _buildLuckyColorItem({
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(Icons.palette, color: Colors.green.shade700),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade700,
          ),
        ),
        Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
      ],
    );
  }
}
