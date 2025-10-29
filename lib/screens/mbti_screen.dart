import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

class MbtiScreen extends StatefulWidget {
  const MbtiScreen({super.key});

  @override
  State<MbtiScreen> createState() => _MbtiScreenState();
}

class _MbtiScreenState extends State<MbtiScreen> {
  String? _selectedMbti;

  final List<Map<String, dynamic>> _mbtiTypes = [
    // Analysts
    {'type': 'INTJ', 'ko': '전략가', 'en': 'Architect', 'category': 'Analysts', 'emoji': '🏗️'},
    {'type': 'INTP', 'ko': '논리술사', 'en': 'Logician', 'category': 'Analysts', 'emoji': '🧪'},
    {'type': 'ENTJ', 'ko': '통솔자', 'en': 'Commander', 'category': 'Analysts', 'emoji': '👑'},
    {'type': 'ENTP', 'ko': '변론가', 'en': 'Debater', 'category': 'Analysts', 'emoji': '💬'},
    
    // Diplomats
    {'type': 'INFJ', 'ko': '옹호자', 'en': 'Advocate', 'category': 'Diplomats', 'emoji': '🌟'},
    {'type': 'INFP', 'ko': '중재자', 'en': 'Mediator', 'category': 'Diplomats', 'emoji': '🕊️'},
    {'type': 'ENFJ', 'ko': '선도자', 'en': 'Protagonist', 'category': 'Diplomats', 'emoji': '🎭'},
    {'type': 'ENFP', 'ko': '활동가', 'en': 'Campaigner', 'category': 'Diplomats', 'emoji': '🎨'},
    
    // Sentinels
    {'type': 'ISTJ', 'ko': '현실주의자', 'en': 'Logistician', 'category': 'Sentinels', 'emoji': '📋'},
    {'type': 'ISFJ', 'ko': '수호자', 'en': 'Defender', 'category': 'Sentinels', 'emoji': '🛡️'},
    {'type': 'ESTJ', 'ko': '경영자', 'en': 'Executive', 'category': 'Sentinels', 'emoji': '💼'},
    {'type': 'ESFJ', 'ko': '집정관', 'en': 'Consul', 'category': 'Sentinels', 'emoji': '🤝'},
    
    // Explorers
    {'type': 'ISTP', 'ko': '장인', 'en': 'Virtuoso', 'category': 'Explorers', 'emoji': '🔧'},
    {'type': 'ISFP', 'ko': '모험가', 'en': 'Adventurer', 'category': 'Explorers', 'emoji': '🎪'},
    {'type': 'ESTP', 'ko': '사업가', 'en': 'Entrepreneur', 'category': 'Explorers', 'emoji': '🚀'},
    {'type': 'ESFP', 'ko': '연예인', 'en': 'Entertainer', 'category': 'Explorers', 'emoji': '🎬'},
  ];

  final Map<String, Map<String, dynamic>> _mbtiDetails = {
    'INTJ': {
      'traits_ko': ['독립적', '전략적', '논리적', '통찰력'],
      'traits_en': ['Independent', 'Strategic', 'Logical', 'Insightful'],
      'description_ko': '상상력이 풍부하고 전략적인 사고를 가진 계획가입니다.',
      'description_en': 'Imaginative and strategic thinkers with a plan for everything.',
      'strength_ko': '장기적인 비전을 가지고 체계적으로 목표를 달성합니다.',
      'strength_en': 'Achieves goals systematically with long-term vision.',
    },
    'INTP': {
      'traits_ko': ['분석적', '호기심', '객관적', '논리적'],
      'traits_en': ['Analytical', 'Curious', 'Objective', 'Logical'],
      'description_ko': '혁신적인 발명가로 지식에 대한 끝없는 갈증을 가지고 있습니다.',
      'description_en': 'Innovative inventors with an unquenchable thirst for knowledge.',
      'strength_ko': '복잡한 문제를 논리적으로 분석하고 해결합니다.',
      'strength_en': 'Analyzes and solves complex problems logically.',
    },
    'ENTJ': {
      'traits_ko': ['리더십', '결단력', '전략적', '효율적'],
      'traits_en': ['Leadership', 'Decisive', 'Strategic', 'Efficient'],
      'description_ko': '대담하고 상상력이 풍부하며 강한 의지를 가진 지도자입니다.',
      'description_en': 'Bold, imaginative, and strong-willed leaders.',
      'strength_ko': '조직을 이끌고 목표를 달성하는 능력이 뛰어납니다.',
      'strength_en': 'Excels at leading organizations and achieving goals.',
    },
    'ENTP': {
      'traits_ko': ['창의적', '토론적', '독립적', '열정적'],
      'traits_en': ['Creative', 'Debative', 'Independent', 'Enthusiastic'],
      'description_ko': '영리하고 호기심 많은 사색가입니다.',
      'description_en': 'Smart and curious thinkers who cannot resist an intellectual challenge.',
      'strength_ko': '혁신적인 아이디어를 제시하고 토론을 즐깁니다.',
      'strength_en': 'Presents innovative ideas and enjoys debates.',
    },
    'INFJ': {
      'traits_ko': ['이상주의', '공감능력', '통찰력', '헌신적'],
      'traits_en': ['Idealistic', 'Empathetic', 'Insightful', 'Dedicated'],
      'description_ko': '조용하고 신비로우며 영감을 주는 이상주의자입니다.',
      'description_en': 'Quiet and mystical, yet very inspiring and tireless idealists.',
      'strength_ko': '깊은 통찰력으로 타인을 이해하고 도와줍니다.',
      'strength_en': 'Understands and helps others with deep insight.',
    },
    'INFP': {
      'traits_ko': ['이상주의', '충실함', '공감능력', '창의적'],
      'traits_en': ['Idealistic', 'Loyal', 'Empathetic', 'Creative'],
      'description_ko': '시적이고 친절하며 이타적인 사람들입니다.',
      'description_en': 'Poetic, kind, and altruistic people.',
      'strength_ko': '자신의 가치관에 충실하고 창의적입니다.',
      'strength_en': 'True to values and highly creative.',
    },
    'ENFJ': {
      'traits_ko': ['카리스마', '공감능력', '이타적', '설득력'],
      'traits_en': ['Charismatic', 'Empathetic', 'Altruistic', 'Persuasive'],
      'description_ko': '카리스마 있고 영감을 주는 지도자입니다.',
      'description_en': 'Charismatic and inspiring leaders.',
      'strength_ko': '타인을 동기부여하고 이끄는 능력이 뛰어납니다.',
      'strength_en': 'Excels at motivating and leading others.',
    },
    'ENFP': {
      'traits_ko': ['열정적', '창의적', '사교적', '긍정적'],
      'traits_en': ['Enthusiastic', 'Creative', 'Social', 'Positive'],
      'description_ko': '열정적이고 창의적인 자유로운 영혼입니다.',
      'description_en': 'Enthusiastic, creative, and free spirits.',
      'strength_ko': '새로운 아이디어와 관계를 만드는데 탁월합니다.',
      'strength_en': 'Excels at creating new ideas and relationships.',
    },
    'ISTJ': {
      'traits_ko': ['책임감', '현실적', '조직적', '신뢰성'],
      'traits_en': ['Responsible', 'Realistic', 'Organized', 'Reliable'],
      'description_ko': '실용적이고 사실적인 사람들입니다.',
      'description_en': 'Practical and fact-minded individuals.',
      'strength_ko': '체계적이고 신뢰할 수 있는 업무 처리를 합니다.',
      'strength_en': 'Handles tasks systematically and reliably.',
    },
    'ISFJ': {
      'traits_ko': ['헌신적', '성실함', '보호적', '실용적'],
      'traits_en': ['Dedicated', 'Conscientious', 'Protective', 'Practical'],
      'description_ko': '헌신적이고 따뜻한 보호자입니다.',
      'description_en': 'Very dedicated and warm protectors.',
      'strength_ko': '타인을 배려하고 안정적인 환경을 만듭니다.',
      'strength_en': 'Cares for others and creates stable environments.',
    },
    'ESTJ': {
      'traits_ko': ['조직력', '결단력', '현실적', '책임감'],
      'traits_en': ['Organized', 'Decisive', 'Realistic', 'Responsible'],
      'description_ko': '뛰어난 관리 능력을 가진 사람들입니다.',
      'description_en': 'Excellent administrators.',
      'strength_ko': '효율적으로 조직을 관리하고 운영합니다.',
      'strength_en': 'Manages and operates organizations efficiently.',
    },
    'ESFJ': {
      'traits_ko': ['사교적', '협조적', '배려심', '조화로움'],
      'traits_en': ['Social', 'Cooperative', 'Caring', 'Harmonious'],
      'description_ko': '배려심 깊고 사교적인 사람들입니다.',
      'description_en': 'Extraordinarily caring and social people.',
      'strength_ko': '팀워크를 중시하고 조화로운 분위기를 만듭니다.',
      'strength_en': 'Values teamwork and creates harmonious atmosphere.',
    },
    'ISTP': {
      'traits_ko': ['실용적', '독립적', '분석적', '융통성'],
      'traits_en': ['Practical', 'Independent', 'Analytical', 'Flexible'],
      'description_ko': '대담하고 실용적인 실험가들입니다.',
      'description_en': 'Bold and practical experimenters.',
      'strength_ko': '문제를 즉흥적으로 해결하는 능력이 뛰어납니다.',
      'strength_en': 'Excels at solving problems spontaneously.',
    },
    'ISFP': {
      'traits_ko': ['예술적', '유연함', '호기심', '자유로움'],
      'traits_en': ['Artistic', 'Flexible', 'Curious', 'Free'],
      'description_ko': '유연하고 매력적인 예술가들입니다.',
      'description_en': 'Flexible and charming artists.',
      'strength_ko': '예술적 감각과 유연한 사고방식을 가지고 있습니다.',
      'strength_en': 'Has artistic sense and flexible thinking.',
    },
    'ESTP': {
      'traits_ko': ['활동적', '관찰력', '사교적', '실용적'],
      'traits_en': ['Active', 'Observant', 'Social', 'Practical'],
      'description_ko': '영리하고 에너지 넘치는 활동가들입니다.',
      'description_en': 'Smart and energetic activists.',
      'strength_ko': '현실적이고 즉각적인 문제 해결을 잘합니다.',
      'strength_en': 'Good at realistic and immediate problem-solving.',
    },
    'ESFP': {
      'traits_ko': ['외향적', '열정적', '친근함', '자발적'],
      'traits_en': ['Outgoing', 'Enthusiastic', 'Friendly', 'Spontaneous'],
      'description_ko': '자발적이고 열정적인 연예인들입니다.',
      'description_en': 'Spontaneous and enthusiastic entertainers.',
      'strength_ko': '주변을 밝게 하고 즐거운 분위기를 만듭니다.',
      'strength_en': 'Brightens surroundings and creates joyful atmosphere.',
    },
  };

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Analysts':
        return const Color(0xFF9B59B6);
      case 'Diplomats':
        return const Color(0xFF3498DB);
      case 'Sentinels':
        return const Color(0xFF1ABC9C);
      case 'Explorers':
        return const Color(0xFFF39C12);
      default:
        return Colors.grey;
    }
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
            colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
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
                        '🧠 MBTI Analysis',
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
                  child: _selectedMbti == null
                      ? _buildMbtiSelection(isKorean)
                      : _buildMbtiDetail(isKorean),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMbtiSelection(bool isKorean) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                isKorean ? '당신의 MBTI를 선택하세요' : 'Select Your MBTI Type',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isKorean ? '16가지 성격 유형 중 하나를 선택하세요' : 'Choose from 16 personality types',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategorySection('Analysts', isKorean ? '분석가형' : 'Analysts', isKorean),
              const SizedBox(height: 24),
              _buildCategorySection('Diplomats', isKorean ? '외교관형' : 'Diplomats', isKorean),
              const SizedBox(height: 24),
              _buildCategorySection('Sentinels', isKorean ? '관리자형' : 'Sentinels', isKorean),
              const SizedBox(height: 24),
              _buildCategorySection('Explorers', isKorean ? '탐험가형' : 'Explorers', isKorean),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(String category, String title, bool isKorean) {
    final types = _mbtiTypes.where((type) => type['category'] == category).toList();
    final color = _getCategoryColor(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: types.length,
          itemBuilder: (context, index) {
            return _buildMbtiCard(types[index], color, isKorean);
          },
        ),
      ],
    );
  }

  Widget _buildMbtiCard(Map<String, dynamic> mbti, Color color, bool isKorean) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMbti = mbti['type'];
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mbti['emoji'],
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                mbti['type'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isKorean ? mbti['ko'] : mbti['en'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMbtiDetail(bool isKorean) {
    final mbti = _mbtiTypes.firstWhere((m) => m['type'] == _selectedMbti);
    final details = _mbtiDetails[_selectedMbti]!;
    final color = _getCategoryColor(mbti['category']);

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
                  _selectedMbti = null;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: Text(isKorean ? '다시 선택' : 'Choose Again'),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // MBTI Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: color,
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
                  mbti['emoji'],
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedMbti!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isKorean ? mbti['ko'] : mbti['en'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Description
          _buildSection(
            title: isKorean ? '성격 설명' : 'Description',
            icon: Icons.description,
            color: color,
            child: Text(
              isKorean ? details['description_ko'] : details['description_en'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Personality Traits
          _buildSection(
            title: isKorean ? '성격 특징' : 'Traits',
            icon: Icons.star,
            color: color,
            child: _buildTraits(details, color, isKorean),
          ),
          
          const SizedBox(height: 24),
          
          // Strengths
          _buildSection(
            title: isKorean ? '강점' : 'Strengths',
            icon: Icons.thumb_up,
            color: color,
            child: Text(
              isKorean ? details['strength_ko'] : details['strength_en'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Career Suggestions
          _buildSection(
            title: isKorean ? '추천 직업' : 'Career Suggestions',
            icon: Icons.work,
            color: color,
            child: _buildCareerSuggestions(_selectedMbti!, isKorean),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
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
              Icon(icon, color: color),
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

  Widget _buildTraits(Map<String, dynamic> details, Color color, bool isKorean) {
    final traits = details[isKorean ? 'traits_ko' : 'traits_en'] as List;
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: traits.map((trait) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            trait,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCareerSuggestions(String mbtiType, bool isKorean) {
    final careers = {
      'INTJ': {
        'ko': ['과학자', '엔지니어', '전략 컨설턴트', 'IT 전문가'],
        'en': ['Scientist', 'Engineer', 'Strategy Consultant', 'IT Professional'],
      },
      'INTP': {
        'ko': ['연구원', '프로그래머', '분석가', '교수'],
        'en': ['Researcher', 'Programmer', 'Analyst', 'Professor'],
      },
      'ENTJ': {
        'ko': ['경영자', 'CEO', '변호사', '컨설턴트'],
        'en': ['Executive', 'CEO', 'Lawyer', 'Consultant'],
      },
      'ENTP': {
        'ko': ['기업가', '마케터', '변호사', '발명가'],
        'en': ['Entrepreneur', 'Marketer', 'Lawyer', 'Inventor'],
      },
      'INFJ': {
        'ko': ['상담사', '작가', '심리학자', '교사'],
        'en': ['Counselor', 'Writer', 'Psychologist', 'Teacher'],
      },
      'INFP': {
        'ko': ['작가', '예술가', '상담사', '사회복지사'],
        'en': ['Writer', 'Artist', 'Counselor', 'Social Worker'],
      },
      'ENFJ': {
        'ko': ['교사', '인사담당자', '코치', '홍보전문가'],
        'en': ['Teacher', 'HR Manager', 'Coach', 'PR Specialist'],
      },
      'ENFP': {
        'ko': ['기획자', '홍보전문가', '배우', '상담사'],
        'en': ['Planner', 'PR Specialist', 'Actor', 'Counselor'],
      },
      'ISTJ': {
        'ko': ['회계사', '감사', '관리자', '의사'],
        'en': ['Accountant', 'Auditor', 'Manager', 'Doctor'],
      },
      'ISFJ': {
        'ko': ['간호사', '교사', '사서', '상담사'],
        'en': ['Nurse', 'Teacher', 'Librarian', 'Counselor'],
      },
      'ESTJ': {
        'ko': ['경영자', '관리자', '판사', '은행원'],
        'en': ['Executive', 'Manager', 'Judge', 'Banker'],
      },
      'ESFJ': {
        'ko': ['간호사', '교사', '영업관리자', '이벤트플래너'],
        'en': ['Nurse', 'Teacher', 'Sales Manager', 'Event Planner'],
      },
      'ISTP': {
        'ko': ['엔지니어', '기술자', '조종사', '정비사'],
        'en': ['Engineer', 'Technician', 'Pilot', 'Mechanic'],
      },
      'ISFP': {
        'ko': ['예술가', '디자이너', '요리사', '수의사'],
        'en': ['Artist', 'Designer', 'Chef', 'Veterinarian'],
      },
      'ESTP': {
        'ko': ['영업직', '기업가', '소방관', '운동선수'],
        'en': ['Sales', 'Entrepreneur', 'Firefighter', 'Athlete'],
      },
      'ESFP': {
        'ko': ['연예인', '이벤트플래너', '교사', '패션디자이너'],
        'en': ['Entertainer', 'Event Planner', 'Teacher', 'Fashion Designer'],
      },
    };

    final careerList = careers[mbtiType]![isKorean ? 'ko' : 'en']!;
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: careerList.map((career) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            career,
            style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
