import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

class EnneagramScreen extends StatefulWidget {
  const EnneagramScreen({super.key});

  @override
  State<EnneagramScreen> createState() => _EnneagramScreenState();
}

class _EnneagramScreenState extends State<EnneagramScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _answers = {}; // 질문 번호 -> 답변 (1-5)
  
  // 90개 질문 (각 유형당 10개)
  final List<Map<String, dynamic>> _questions = [
    // 1번 유형 (완벽주의자) - 10문항
    {'text': '나는 항상 옳은 일을 하려고 노력한다', 'type': 1},
    {'text': '나는 실수를 용납하기 어렵다', 'type': 1},
    {'text': '나는 규칙과 원칙을 중요하게 생각한다', 'type': 1},
    {'text': '나는 비판적인 편이다', 'type': 1},
    {'text': '나는 완벽을 추구한다', 'type': 1},
    {'text': '나는 다른 사람들이 옳지 않은 일을 할 때 화가 난다', 'type': 1},
    {'text': '나는 세부 사항에 신경을 많이 쓴다', 'type': 1},
    {'text': '나는 도덕적으로 올바르게 살려고 노력한다', 'type': 1},
    {'text': '나는 불공정함을 참지 못한다', 'type': 1},
    {'text': '나는 자신에게 엄격한 편이다', 'type': 1},
    
    // 2번 유형 (조력자) - 10문항
    {'text': '나는 다른 사람을 돕는 것을 좋아한다', 'type': 2},
    {'text': '나는 사람들의 필요를 잘 알아챈다', 'type': 2},
    {'text': '나는 사랑받고 싶은 욕구가 강하다', 'type': 2},
    {'text': '나는 다른 사람의 인정을 받고 싶어한다', 'type': 2},
    {'text': '나는 관계를 매우 중요하게 생각한다', 'type': 2},
    {'text': '나는 다른 사람들이 나를 필요로 할 때 기쁘다', 'type': 2},
    {'text': '나는 내 욕구보다 타인의 욕구를 먼저 생각한다', 'type': 2},
    {'text': '나는 거절하는 것이 어렵다', 'type': 2},
    {'text': '나는 다른 사람들에게 관대하다', 'type': 2},
    {'text': '나는 사람들과 친밀한 관계를 맺고 싶어한다', 'type': 2},
    
    // 3번 유형 (성취자) - 10문항
    {'text': '나는 성공하는 것을 중요하게 생각한다', 'type': 3},
    {'text': '나는 경쟁에서 이기는 것을 좋아한다', 'type': 3},
    {'text': '나는 목표 지향적이다', 'type': 3},
    {'text': '나는 효율성을 추구한다', 'type': 3},
    {'text': '나는 다른 사람들에게 좋은 이미지를 보이고 싶어한다', 'type': 3},
    {'text': '나는 인정받는 것을 좋아한다', 'type': 3},
    {'text': '나는 일 중심적이다', 'type': 3},
    {'text': '나는 실패를 두려워한다', 'type': 3},
    {'text': '나는 자신감이 있다', 'type': 3},
    {'text': '나는 성과를 중시한다', 'type': 3},
    
    // 4번 유형 (예술가) - 10문항
    {'text': '나는 독특하고 특별하다고 느끼고 싶다', 'type': 4},
    {'text': '나는 감정이 풍부하다', 'type': 4},
    {'text': '나는 자주 우울하거나 슬픔을 느낀다', 'type': 4},
    {'text': '나는 평범한 것을 싫어한다', 'type': 4},
    {'text': '나는 예술적 감성을 가지고 있다', 'type': 4},
    {'text': '나는 다른 사람들이 나를 이해하지 못한다고 느낀다', 'type': 4},
    {'text': '나는 감정에 집중하는 편이다', 'type': 4},
    {'text': '나는 내면의 세계가 풍부하다', 'type': 4},
    {'text': '나는 창의적이다', 'type': 4},
    {'text': '나는 자신의 정체성을 찾는 것에 관심이 많다', 'type': 4},
    
    // 5번 유형 (관찰자) - 10문항
    {'text': '나는 지식을 쌓는 것을 좋아한다', 'type': 5},
    {'text': '나는 혼자 있는 시간이 필요하다', 'type': 5},
    {'text': '나는 관찰하는 것을 좋아한다', 'type': 5},
    {'text': '나는 감정 표현을 잘 하지 않는다', 'type': 5},
    {'text': '나는 분석적이다', 'type': 5},
    {'text': '나는 에너지를 아끼는 편이다', 'type': 5},
    {'text': '나는 사생활을 중요하게 생각한다', 'type': 5},
    {'text': '나는 독립적이다', 'type': 5},
    {'text': '나는 복잡한 문제를 푸는 것을 좋아한다', 'type': 5},
    {'text': '나는 전문성을 중시한다', 'type': 5},
    
    // 6번 유형 (충성가) - 10문항
    {'text': '나는 안전을 중요하게 생각한다', 'type': 6},
    {'text': '나는 의심이 많은 편이다', 'type': 6},
    {'text': '나는 충성심이 강하다', 'type': 6},
    {'text': '나는 불안을 자주 느낀다', 'type': 6},
    {'text': '나는 규칙과 권위를 존중한다', 'type': 6},
    {'text': '나는 최악의 상황을 대비한다', 'type': 6},
    {'text': '나는 책임감이 강하다', 'type': 6},
    {'text': '나는 신뢰할 수 있는 사람이 되고 싶다', 'type': 6},
    {'text': '나는 위험을 회피하는 편이다', 'type': 6},
    {'text': '나는 안정감을 추구한다', 'type': 6},
    
    // 7번 유형 (열정가) - 10문항
    {'text': '나는 즐거움을 추구한다', 'type': 7},
    {'text': '나는 새로운 경험을 좋아한다', 'type': 7},
    {'text': '나는 낙천적이다', 'type': 7},
    {'text': '나는 부정적인 감정을 피하려 한다', 'type': 7},
    {'text': '나는 모험을 좋아한다', 'type': 7},
    {'text': '나는 다양한 활동을 즐긴다', 'type': 7},
    {'text': '나는 계획보다는 즉흥적이다', 'type': 7},
    {'text': '나는 에너지가 넘친다', 'type': 7},
    {'text': '나는 제한받는 것을 싫어한다', 'type': 7},
    {'text': '나는 미래에 대해 낙관적이다', 'type': 7},
    
    // 8번 유형 (도전자) - 10문항
    {'text': '나는 강하고 힘 있는 사람이 되고 싶다', 'type': 8},
    {'text': '나는 솔직하고 직설적이다', 'type': 8},
    {'text': '나는 통제력을 갖고 싶어한다', 'type': 8},
    {'text': '나는 약점을 드러내기 싫어한다', 'type': 8},
    {'text': '나는 불의에 맞서 싸운다', 'type': 8},
    {'text': '나는 주도권을 잡고 싶어한다', 'type': 8},
    {'text': '나는 보호자 역할을 한다', 'type': 8},
    {'text': '나는 강렬한 편이다', 'type': 8},
    {'text': '나는 약자를 돕는다', 'type': 8},
    {'text': '나는 두려움 없이 도전한다', 'type': 8},
    
    // 9번 유형 (평화주의자) - 10문항
    {'text': '나는 평화를 중요하게 생각한다', 'type': 9},
    {'text': '나는 갈등을 피하려 한다', 'type': 9},
    {'text': '나는 다른 사람들과 조화롭게 지내고 싶다', 'type': 9},
    {'text': '나는 결정하는 것을 어려워한다', 'type': 9},
    {'text': '나는 느긋한 편이다', 'type': 9},
    {'text': '나는 다른 사람들의 의견을 잘 수용한다', 'type': 9},
    {'text': '나는 안정적인 일상을 좋아한다', 'type': 9},
    {'text': '나는 변화에 저항하는 편이다', 'type': 9},
    {'text': '나는 소극적이다', 'type': 9},
    {'text': '나는 타협을 잘 한다', 'type': 9},
  ];

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    if (_currentQuestionIndex >= _questions.length) {
      return _buildResultScreen();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('애니어그램 성격 테스트'),
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
            ),
            
            // Progress Text
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '질문 ${_currentQuestionIndex + 1} / ${_questions.length}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        _questions[_currentQuestionIndex]['text'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Answer Options
                    _buildAnswerButton('전혀 그렇지 않다', 1),
                    const SizedBox(height: 12),
                    _buildAnswerButton('그렇지 않다', 2),
                    const SizedBox(height: 12),
                    _buildAnswerButton('보통이다', 3),
                    const SizedBox(height: 12),
                    _buildAnswerButton('그렇다', 4),
                    const SizedBox(height: 12),
                    _buildAnswerButton('매우 그렇다', 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String text, int score) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _answerQuestion(score),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF667EEA),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF667EEA).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _answerQuestion(int score) {
    setState(() {
      _answers[_currentQuestionIndex] = score;
      _currentQuestionIndex++;
    });
  }

  Widget _buildResultScreen() {
    // 각 유형별 점수 계산
    final Map<int, int> typeScores = {};
    for (int i = 1; i <= 9; i++) {
      typeScores[i] = 0;
    }
    
    _answers.forEach((index, score) {
      final type = _questions[index]['type'];
      typeScores[type] = (typeScores[type] ?? 0) + score;
    });
    
    // 가장 높은 점수의 유형 찾기
    int dominantType = 1;
    int maxScore = 0;
    typeScores.forEach((type, score) {
      if (score > maxScore) {
        maxScore = score;
        dominantType = type;
      }
    });
    
    final typeInfo = _getTypeInfo(dominantType);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('애니어그램 결과'),
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Result Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '유형 $dominantType',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      typeInfo['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      typeInfo['center']!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Core Characteristics
              _buildInfoCard(
                '핵심 특징',
                typeInfo['core']!,
                Icons.star,
              ),
              
              const SizedBox(height: 16),
              
              // Strengths
              _buildInfoCard(
                '강점',
                typeInfo['strengths']!,
                Icons.thumb_up,
              ),
              
              const SizedBox(height: 16),
              
              // Growth Areas
              _buildInfoCard(
                '성장 과제',
                typeInfo['growth']!,
                Icons.trending_up,
              ),
              
              const SizedBox(height: 32),
              
              // Restart Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentQuestionIndex = 0;
                      _answers.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '다시 테스트하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF667EEA).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF667EEA), size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667EEA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getTypeInfo(int type) {
    final typeData = {
      1: {
        'name': '완벽주의자',
        'center': '장 중심 (본능)',
        'core': '원칙과 정의를 중시하며, 완벽을 추구합니다. 옳고 그름에 대한 명확한 기준을 가지고 있으며, 자신과 타인에게 높은 기준을 적용합니다.',
        'strengths': '책임감이 강하고, 정직하며, 일관성이 있습니다. 윤리적이고 도덕적인 삶을 추구하며, 개선과 발전을 위해 노력합니다.',
        'growth': '완벽주의를 내려놓고 실수를 받아들이는 법을 배워야 합니다. 비판적인 태도를 완화하고, 유연성을 키우는 것이 필요합니다.',
      },
      2: {
        'name': '조력자',
        'center': '가슴 중심 (감정)',
        'core': '다른 사람을 돕고 사랑받고 싶어하는 욕구가 강합니다. 관계 중심적이며, 타인의 필요를 잘 알아차립니다.',
        'strengths': '따뜻하고 친절하며, 공감 능력이 뛰어납니다. 사람들과의 관계를 소중히 여기고, 헌신적입니다.',
        'growth': '자신의 욕구도 중요하게 여기고, 건강한 경계를 설정하는 법을 배워야 합니다. 거절하는 법을 익히는 것이 필요합니다.',
      },
      3: {
        'name': '성취자',
        'center': '가슴 중심 (감정)',
        'core': '성공과 성취를 중시하며, 목표 지향적입니다. 효율성과 생산성을 추구하고, 긍정적인 이미지를 유지하려 합니다.',
        'strengths': '자신감이 있고, 적응력이 뛰어나며, 동기부여가 강합니다. 목표 달성 능력이 탁월합니다.',
        'growth': '성과보다는 진정한 자아를 발견하는 것이 중요합니다. 실패를 두려워하지 않고, 자신의 감정을 솔직하게 표현하는 법을 배워야 합니다.',
      },
      4: {
        'name': '예술가',
        'center': '가슴 중심 (감정)',
        'core': '독특함과 특별함을 추구하며, 감정이 풍부합니다. 자신의 정체성을 찾는 것에 관심이 많고, 창의적입니다.',
        'strengths': '창의적이고, 감수성이 뛰어나며, 진정성을 중시합니다. 깊이 있는 감정을 표현할 수 있습니다.',
        'growth': '부정적인 감정에 집착하지 않고, 현재에 충실하는 법을 배워야 합니다. 부러움과 질투를 극복하는 것이 필요합니다.',
      },
      5: {
        'name': '관찰자',
        'center': '머리 중심 (사고)',
        'core': '지식과 통찰을 추구하며, 관찰과 분석을 중시합니다. 독립적이고, 사생활을 중요하게 여깁니다.',
        'strengths': '지적 호기심이 강하고, 분석적이며, 객관적입니다. 복잡한 문제를 해결하는 능력이 뛰어납니다.',
        'growth': '고립되지 않고 사람들과 연결되는 법을 배워야 합니다. 감정을 표현하고, 실제 행동으로 옮기는 것이 필요합니다.',
      },
      6: {
        'name': '충성가',
        'center': '머리 중심 (사고)',
        'core': '안전과 안정을 추구하며, 충성심이 강합니다. 의심이 많고, 최악의 상황을 대비합니다.',
        'strengths': '책임감이 강하고, 신뢰할 수 있으며, 충실합니다. 문제를 예측하고 대비하는 능력이 있습니다.',
        'growth': '불안을 줄이고, 자신을 신뢰하는 법을 배워야 합니다. 과도한 걱정을 내려놓고, 현재에 집중하는 것이 필요합니다.',
      },
      7: {
        'name': '열정가',
        'center': '머리 중심 (사고)',
        'core': '즐거움과 새로운 경험을 추구하며, 낙천적입니다. 부정적인 감정을 피하고, 자유를 중시합니다.',
        'strengths': '에너지가 넘치고, 창의적이며, 긍정적입니다. 새로운 기회를 잘 포착하고, 열정적입니다.',
        'growth': '부정적인 감정도 받아들이고, 한 가지에 집중하는 법을 배워야 합니다. 깊이를 추구하고, 인내심을 키우는 것이 필요합니다.',
      },
      8: {
        'name': '도전자',
        'center': '장 중심 (본능)',
        'core': '힘과 통제를 추구하며, 강인함을 중시합니다. 솔직하고 직설적이며, 불의에 맞서 싸웁니다.',
        'strengths': '결단력이 있고, 자신감이 넘치며, 보호적입니다. 리더십이 강하고, 약자를 돕습니다.',
        'growth': '취약함을 드러내는 법을 배우고, 타인을 통제하지 않는 것이 필요합니다. 부드러움과 배려를 키우는 것이 중요합니다.',
      },
      9: {
        'name': '평화주의자',
        'center': '장 중심 (본능)',
        'core': '평화와 조화를 추구하며, 갈등을 피합니다. 느긋하고, 다른 사람들과 조화롭게 지내고 싶어합니다.',
        'strengths': '평화롭고, 수용적이며, 안정적입니다. 중재 능력이 뛰어나고, 타협을 잘 합니다.',
        'growth': '자신의 의견을 명확히 표현하고, 갈등을 회피하지 않는 법을 배워야 합니다. 우선순위를 정하고, 결단력을 키우는 것이 필요합니다.',
      },
    };
    
    return typeData[type]!;
  }
}
