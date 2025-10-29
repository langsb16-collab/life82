import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

class ZodiacScreen extends StatefulWidget {
  const ZodiacScreen({super.key});

  @override
  State<ZodiacScreen> createState() => _ZodiacScreenState();
}

class _ZodiacScreenState extends State<ZodiacScreen> {
  String? _selectedZodiac;

  final List<Map<String, dynamic>> _zodiacSigns = [
    {'name': 'Aries', 'ko': '양자리', 'emoji': '♈', 'dates': 'Mar 21 - Apr 19', 'dates_ko': '3/21 - 4/19'},
    {'name': 'Taurus', 'ko': '황소자리', 'emoji': '♉', 'dates': 'Apr 20 - May 20', 'dates_ko': '4/20 - 5/20'},
    {'name': 'Gemini', 'ko': '쌍둥이자리', 'emoji': '♊', 'dates': 'May 21 - Jun 20', 'dates_ko': '5/21 - 6/20'},
    {'name': 'Cancer', 'ko': '게자리', 'emoji': '♋', 'dates': 'Jun 21 - Jul 22', 'dates_ko': '6/21 - 7/22'},
    {'name': 'Leo', 'ko': '사자자리', 'emoji': '♌', 'dates': 'Jul 23 - Aug 22', 'dates_ko': '7/23 - 8/22'},
    {'name': 'Virgo', 'ko': '처녀자리', 'emoji': '♍', 'dates': 'Aug 23 - Sep 22', 'dates_ko': '8/23 - 9/22'},
    {'name': 'Libra', 'ko': '천칭자리', 'emoji': '♎', 'dates': 'Sep 23 - Oct 22', 'dates_ko': '9/23 - 10/22'},
    {'name': 'Scorpio', 'ko': '전갈자리', 'emoji': '♏', 'dates': 'Oct 23 - Nov 21', 'dates_ko': '10/23 - 11/21'},
    {'name': 'Sagittarius', 'ko': '사수자리', 'emoji': '♐', 'dates': 'Nov 22 - Dec 21', 'dates_ko': '11/22 - 12/21'},
    {'name': 'Capricorn', 'ko': '염소자리', 'emoji': '♑', 'dates': 'Dec 22 - Jan 19', 'dates_ko': '12/22 - 1/19'},
    {'name': 'Aquarius', 'ko': '물병자리', 'emoji': '♒', 'dates': 'Jan 20 - Feb 18', 'dates_ko': '1/20 - 2/18'},
    {'name': 'Pisces', 'ko': '물고기자리', 'emoji': '♓', 'dates': 'Feb 19 - Mar 20', 'dates_ko': '2/19 - 3/20'},
  ];

  final Map<String, Map<String, String>> _zodiacFortunes = {
    'Aries': {
      'ko': '오늘은 새로운 도전을 시작하기 좋은 날입니다. 용기를 가지고 앞으로 나아가세요.',
      'en': 'Today is a great day to start new challenges. Move forward with courage.',
    },
    'Taurus': {
      'ko': '안정을 추구하는 하루가 될 것입니다. 차분하게 계획을 세우세요.',
      'en': 'It will be a day of seeking stability. Make plans calmly.',
    },
    'Gemini': {
      'ko': '소통이 활발한 하루입니다. 주변 사람들과 대화를 나누세요.',
      'en': 'Communication is active today. Have conversations with people around you.',
    },
    'Cancer': {
      'ko': '감정에 충실한 하루를 보내세요. 자신의 마음을 돌보는 시간을 가지세요.',
      'en': 'Be true to your emotions. Take time to care for your heart.',
    },
    'Leo': {
      'ko': '리더십을 발휘할 기회가 올 것입니다. 자신감을 가지세요.',
      'en': 'An opportunity to show leadership will come. Be confident.',
    },
    'Virgo': {
      'ko': '세심한 주의가 필요한 날입니다. 꼼꼼하게 확인하세요.',
      'en': 'A day that requires careful attention. Check thoroughly.',
    },
    'Libra': {
      'ko': '균형과 조화를 추구하세요. 중용의 미덕이 빛을 발할 것입니다.',
      'en': 'Seek balance and harmony. The virtue of moderation will shine.',
    },
    'Scorpio': {
      'ko': '집중력이 높아지는 날입니다. 중요한 일에 몰두하세요.',
      'en': 'Concentration increases today. Focus on important matters.',
    },
    'Sagittarius': {
      'ko': '모험심이 가득한 하루입니다. 새로운 경험을 즐기세요.',
      'en': 'A day full of adventure. Enjoy new experiences.',
    },
    'Capricorn': {
      'ko': '목표를 향해 꾸준히 나아가세요. 성실함이 보상받을 것입니다.',
      'en': 'Move steadily toward your goals. Diligence will be rewarded.',
    },
    'Aquarius': {
      'ko': '창의적인 아이디어가 떠오르는 날입니다. 독창성을 발휘하세요.',
      'en': 'Creative ideas come to mind. Show your originality.',
    },
    'Pisces': {
      'ko': '직관이 예리해지는 날입니다. 내면의 목소리에 귀 기울이세요.',
      'en': 'Intuition becomes sharp. Listen to your inner voice.',
    },
  };

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
            colors: [Color(0xFFFF6B95), Color(0xFFA855F7)],
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
                    const Expanded(
                      child: Text(
                        '⭐ Zodiac Fortune',
                        style: TextStyle(
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
                  child: _selectedZodiac == null
                      ? _buildZodiacSelection(isKorean)
                      : _buildZodiacDetail(isKorean),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZodiacSelection(bool isKorean) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                isKorean ? '당신의 별자리를 선택하세요' : 'Select Your Zodiac Sign',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isKorean ? '생일을 기준으로 별자리를 찾아보세요' : 'Find your zodiac based on your birthday',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _zodiacSigns.length,
            itemBuilder: (context, index) {
              final zodiac = _zodiacSigns[index];
              return _buildZodiacCard(zodiac, isKorean);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildZodiacCard(Map<String, dynamic> zodiac, bool isKorean) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedZodiac = zodiac['name'];
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF6B95).withValues(alpha: 0.1),
                const Color(0xFFA855F7).withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFF6B95).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                zodiac['emoji'],
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                isKorean ? zodiac['ko'] : zodiac['name'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                isKorean ? zodiac['dates_ko'] : zodiac['dates'],
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZodiacDetail(bool isKorean) {
    final zodiac = _zodiacSigns.firstWhere((z) => z['name'] == _selectedZodiac);
    final fortune = _zodiacFortunes[_selectedZodiac]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedZodiac = null;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: Text(isKorean ? '다시 선택' : 'Choose Again'),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Zodiac Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B95), Color(0xFFA855F7)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  zodiac['emoji'],
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 16),
                Text(
                  isKorean ? zodiac['ko'] : zodiac['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isKorean ? zodiac['dates_ko'] : zodiac['dates'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Today's Fortune
          _buildSection(
            title: isKorean ? '오늘의 운세' : 'Today\'s Fortune',
            icon: Icons.auto_awesome,
            child: Text(
              isKorean ? fortune['ko']! : fortune['en']!,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Personality Traits
          _buildSection(
            title: isKorean ? '성격 특징' : 'Personality Traits',
            icon: Icons.psychology,
            child: _buildTraits(zodiac['name'], isKorean),
          ),
          
          const SizedBox(height: 24),
          
          // Lucky Elements
          _buildSection(
            title: isKorean ? '행운의 요소' : 'Lucky Elements',
            icon: Icons.star,
            child: _buildLuckyElements(zodiac['name'], isKorean),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFA855F7)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTraits(String zodiacName, bool isKorean) {
    final traits = {
      'Aries': {
        'ko': ['열정적', '용감함', '리더십', '직선적'],
        'en': ['Passionate', 'Brave', 'Leadership', 'Straightforward'],
      },
      'Taurus': {
        'ko': ['안정적', '인내심', '실용적', '충실함'],
        'en': ['Stable', 'Patient', 'Practical', 'Loyal'],
      },
      'Gemini': {
        'ko': ['다재다능', '사교적', '호기심', '유연함'],
        'en': ['Versatile', 'Social', 'Curious', 'Flexible'],
      },
      'Cancer': {
        'ko': ['감성적', '보호본능', '직관적', '공감능력'],
        'en': ['Emotional', 'Protective', 'Intuitive', 'Empathetic'],
      },
      'Leo': {
        'ko': ['자신감', '관대함', '창의적', '카리스마'],
        'en': ['Confident', 'Generous', 'Creative', 'Charismatic'],
      },
      'Virgo': {
        'ko': ['완벽주의', '분석적', '실용적', '성실함'],
        'en': ['Perfectionist', 'Analytical', 'Practical', 'Diligent'],
      },
      'Libra': {
        'ko': ['균형감', '외교적', '우아함', '공정함'],
        'en': ['Balanced', 'Diplomatic', 'Elegant', 'Fair'],
      },
      'Scorpio': {
        'ko': ['열정적', '집중력', '신비로움', '결단력'],
        'en': ['Passionate', 'Focused', 'Mysterious', 'Decisive'],
      },
      'Sagittarius': {
        'ko': ['자유로움', '낙천적', '모험심', '솔직함'],
        'en': ['Free', 'Optimistic', 'Adventurous', 'Honest'],
      },
      'Capricorn': {
        'ko': ['책임감', '목표지향', '인내심', '현실적'],
        'en': ['Responsible', 'Goal-oriented', 'Patient', 'Realistic'],
      },
      'Aquarius': {
        'ko': ['독창적', '진보적', '인도주의', '자유로움'],
        'en': ['Original', 'Progressive', 'Humanitarian', 'Free'],
      },
      'Pisces': {
        'ko': ['직관적', '공감능력', '예술적', '상상력'],
        'en': ['Intuitive', 'Empathetic', 'Artistic', 'Imaginative'],
      },
    };

    final traitList = traits[zodiacName]![isKorean ? 'ko' : 'en']!;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: traitList.map((trait) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFA855F7).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFA855F7).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            trait,
            style: const TextStyle(
              color: Color(0xFFA855F7),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLuckyElements(String zodiacName, bool isKorean) {
    final elements = {
      'Aries': {'color': '빨강', 'color_en': 'Red', 'number': '9', 'day': '화요일', 'day_en': 'Tuesday'},
      'Taurus': {'color': '초록', 'color_en': 'Green', 'number': '6', 'day': '금요일', 'day_en': 'Friday'},
      'Gemini': {'color': '노랑', 'color_en': 'Yellow', 'number': '5', 'day': '수요일', 'day_en': 'Wednesday'},
      'Cancer': {'color': '은색', 'color_en': 'Silver', 'number': '2', 'day': '월요일', 'day_en': 'Monday'},
      'Leo': {'color': '금색', 'color_en': 'Gold', 'number': '1', 'day': '일요일', 'day_en': 'Sunday'},
      'Virgo': {'color': '베이지', 'color_en': 'Beige', 'number': '5', 'day': '수요일', 'day_en': 'Wednesday'},
      'Libra': {'color': '핑크', 'color_en': 'Pink', 'number': '6', 'day': '금요일', 'day_en': 'Friday'},
      'Scorpio': {'color': '검정', 'color_en': 'Black', 'number': '8', 'day': '화요일', 'day_en': 'Tuesday'},
      'Sagittarius': {'color': '보라', 'color_en': 'Purple', 'number': '3', 'day': '목요일', 'day_en': 'Thursday'},
      'Capricorn': {'color': '갈색', 'color_en': 'Brown', 'number': '8', 'day': '토요일', 'day_en': 'Saturday'},
      'Aquarius': {'color': '파랑', 'color_en': 'Blue', 'number': '4', 'day': '토요일', 'day_en': 'Saturday'},
      'Pisces': {'color': '민트', 'color_en': 'Mint', 'number': '7', 'day': '목요일', 'day_en': 'Thursday'},
    };

    final element = elements[zodiacName]!;

    return Column(
      children: [
        _buildLuckyItem(
          label: isKorean ? '행운의 색상' : 'Lucky Color',
          value: isKorean ? element['color']! : element['color_en']!,
          icon: Icons.palette,
        ),
        const SizedBox(height: 12),
        _buildLuckyItem(
          label: isKorean ? '행운의 숫자' : 'Lucky Number',
          value: element['number']!,
          icon: Icons.filter_9_plus,
        ),
        const SizedBox(height: 12),
        _buildLuckyItem(
          label: isKorean ? '행운의 요일' : 'Lucky Day',
          value: isKorean ? element['day']! : element['day_en']!,
          icon: Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildLuckyItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFA855F7), size: 20),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFA855F7),
          ),
        ),
      ],
    );
  }
}
