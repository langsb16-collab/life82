import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/face_analysis.dart';
import '../models/palm_analysis.dart';
import '../models/saju_analysis.dart';
import '../models/tarot_reading.dart';

class AnalysisService {
  static const _uuid = Uuid();
  static final _random = Random();

  // 얼굴 관상 분석 (AI 시뮬레이션)
  static Future<FaceAnalysis> analyzeFace(String userId, String imageUrl, String languageCode) async {
    // AI 분석 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    final faceShapes = _getFaceShapesByLanguage(languageCode);
    final sizes = _getSizesByLanguage(languageCode);
    final noseShapes = _getNoseShapesByLanguage(languageCode);

    final features = {
      'faceShape': faceShapes[_random.nextInt(faceShapes.length)],
      'eyeSize': sizes[_random.nextInt(sizes.length)],
      'noseShape': noseShapes[_random.nextInt(noseShapes.length)],
      'mouthSize': sizes[_random.nextInt(sizes.length)],
      'foreheadSize': sizes[_random.nextInt(sizes.length)],
    };

    final analysisTexts = _generateFaceAnalysisText(features, languageCode);

    return FaceAnalysis(
      id: _uuid.v4(),
      userId: userId,
      imageUrl: imageUrl,
      features: features,
      analysis: analysisTexts.join('\n\n'),
      confidence: 0.75 + _random.nextDouble() * 0.2,
      createdAt: DateTime.now(),
    );
  }

  // 손금 분석 (AI 시뮬레이션)
  static Future<PalmAnalysis> analyzePalm(String userId, String imageUrl, String languageCode) async {
    await Future.delayed(const Duration(seconds: 2));

    final lines = {
      'lifeLine': {'length': 'long', 'depth': 'deep', 'clarity': 'clear'},
      'headLine': {'length': 'medium', 'depth': 'medium', 'clarity': 'clear'},
      'heartLine': {'length': 'long', 'depth': 'deep', 'clarity': 'clear'},
      'fateLine': {'length': 'medium', 'depth': 'medium', 'clarity': 'faint'},
    };

    final analysisTexts = _generatePalmAnalysisText(languageCode);

    return PalmAnalysis(
      id: _uuid.v4(),
      userId: userId,
      imageUrl: imageUrl,
      lines: lines,
      analysis: analysisTexts.join('\n\n'),
      confidence: 0.70 + _random.nextDouble() * 0.25,
      createdAt: DateTime.now(),
    );
  }

  // 사주팔자 분석
  static Future<SajuAnalysis> analyzeSaju({
    required String userId,
    required DateTime birthDate,
    required String birthTime,
    required String gender,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final heavenlyStems = ['갑', '을', '병', '정', '무', '기', '경', '신', '임', '계'];
    final earthlyBranches = ['자', '축', '인', '묘', '진', '사', '오', '미', '신', '유', '술', '해'];

    final pillars = {
      'year': {
        'stem': heavenlyStems[_random.nextInt(10)],
        'branch': earthlyBranches[_random.nextInt(12)],
      },
      'month': {
        'stem': heavenlyStems[_random.nextInt(10)],
        'branch': earthlyBranches[_random.nextInt(12)],
      },
      'day': {
        'stem': heavenlyStems[_random.nextInt(10)],
        'branch': earthlyBranches[_random.nextInt(12)],
      },
      'hour': {
        'stem': heavenlyStems[_random.nextInt(10)],
        'branch': earthlyBranches[_random.nextInt(12)],
      },
    };

    final elementAnalysis = {
      '목': _random.nextInt(30) + 10,
      '화': _random.nextInt(30) + 10,
      '토': _random.nextInt(30) + 10,
      '금': _random.nextInt(30) + 10,
      '수': _random.nextInt(30) + 10,
    };

    final categoryAnalysis = {
      '재물운': '재물운이 좋은 편이며, 특히 중년 이후 경제적 안정을 이룰 수 있습니다. 투자보다는 저축을 통한 재물 축적이 유리합니다.',
      '애정운': '애정운이 원만하며 좋은 인연을 만날 가능성이 높습니다. 성실하고 진지한 태도로 관계를 유지하면 행복한 결혼 생활을 누릴 수 있습니다.',
      '건강운': '전반적으로 건강한 편이나 소화기와 호흡기 관리가 필요합니다. 규칙적인 운동과 식습관 관리로 건강을 유지할 수 있습니다.',
      '직업운': '창의적이고 전문적인 분야에서 능력을 발휘할 수 있습니다. 꾸준한 노력과 자기개발로 원하는 목표를 달성할 수 있습니다.',
      '학업운': '학업 능력이 우수하며 집중력이 좋습니다. 특히 인문학이나 예술 분야에서 두각을 나타낼 수 있습니다.',
    };

    final overallAnalysis = '''
생년월일: ${birthDate.year}년 ${birthDate.month}월 ${birthDate.day}일
출생시간: $birthTime
성별: $gender

사주팔자 분석 결과:

년주: ${pillars['year']!['stem']}${pillars['year']!['branch']}
월주: ${pillars['month']!['stem']}${pillars['month']!['branch']}
일주: ${pillars['day']!['stem']}${pillars['day']!['branch']}
시주: ${pillars['hour']!['stem']}${pillars['hour']!['branch']}

오행 분석:
목(木): ${elementAnalysis['목']}%
화(火): ${elementAnalysis['화']}%
토(土): ${elementAnalysis['토']}%
금(金): ${elementAnalysis['금']}%
수(水): ${elementAnalysis['수']}%

전체적인 운세:
귀하의 사주는 균형잡힌 오행 구조를 가지고 있습니다. 
타고난 재능과 노력이 조화를 이루어 성공적인 인생을 살아갈 수 있습니다.
인내심과 꾸준함이 돋보이며, 중년 이후 더욱 안정적이고 풍요로운 삶을 누릴 수 있습니다.

※ 본 분석 결과는 참고용이며, 개인의 노력과 선택이 더욱 중요합니다.
''';

    return SajuAnalysis(
      id: _uuid.v4(),
      userId: userId,
      birthDate: birthDate,
      birthTime: birthTime,
      gender: gender,
      pillars: pillars,
      elements: elementAnalysis,
      analysis: overallAnalysis,
      categoryAnalysis: categoryAnalysis,
      createdAt: DateTime.now(),
    );
  }

  // 타로 카드 리딩
  static Future<TarotReading> performTarotReading({
    required String userId,
    required String question,
    int cardCount = 3,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final tarotCards = _getTarotCards();
    final shuffled = List<TarotCard>.from(tarotCards)..shuffle(_random);
    final selectedCards = shuffled.take(cardCount).toList();

    // 각 카드를 정/역방향 랜덤 설정
    for (int i = 0; i < selectedCards.length; i++) {
      selectedCards[i] = TarotCard(
        id: selectedCards[i].id,
        name: selectedCards[i].name,
        nameKo: selectedCards[i].nameKo,
        description: selectedCards[i].description,
        imageUrl: selectedCards[i].imageUrl,
        isReversed: _random.nextBool(),
      );
    }

    final analysis = _generateTarotAnalysis(selectedCards, question);

    return TarotReading(
      id: _uuid.v4(),
      userId: userId,
      spreadType: cardCount == 1 ? 'single' : cardCount == 3 ? 'three_card' : 'custom',
      cards: selectedCards,
      question: question,
      analysis: analysis,
      createdAt: DateTime.now(),
    );
  }

  static List<TarotCard> _getTarotCards() {
    return [
      TarotCard(
        id: '0',
        name: 'The Fool',
        nameKo: '광대',
        description: '새로운 시작, 순수함, 모험',
        imageUrl: 'assets/tarot/fool.png',
      ),
      TarotCard(
        id: '1',
        name: 'The Magician',
        nameKo: '마법사',
        description: '창조력, 능력, 의지력',
        imageUrl: 'assets/tarot/magician.png',
      ),
      TarotCard(
        id: '2',
        name: 'The High Priestess',
        nameKo: '여사제',
        description: '직관, 무의식, 신비',
        imageUrl: 'assets/tarot/high_priestess.png',
      ),
      TarotCard(
        id: '3',
        name: 'The Empress',
        nameKo: '여제',
        description: '풍요, 모성, 창조',
        imageUrl: 'assets/tarot/empress.png',
      ),
      TarotCard(
        id: '4',
        name: 'The Emperor',
        nameKo: '황제',
        description: '권위, 구조, 리더십',
        imageUrl: 'assets/tarot/emperor.png',
      ),
      TarotCard(
        id: '5',
        name: 'The Hierophant',
        nameKo: '교황',
        description: '전통, 교육, 영적 지도',
        imageUrl: 'assets/tarot/hierophant.png',
      ),
      TarotCard(
        id: '6',
        name: 'The Lovers',
        nameKo: '연인',
        description: '사랑, 선택, 조화',
        imageUrl: 'assets/tarot/lovers.png',
      ),
      TarotCard(
        id: '7',
        name: 'The Chariot',
        nameKo: '전차',
        description: '의지, 승리, 결단',
        imageUrl: 'assets/tarot/chariot.png',
      ),
      TarotCard(
        id: '8',
        name: 'Strength',
        nameKo: '힘',
        description: '용기, 인내, 자제력',
        imageUrl: 'assets/tarot/strength.png',
      ),
      TarotCard(
        id: '9',
        name: 'The Hermit',
        nameKo: '은둔자',
        description: '성찰, 내면, 지혜',
        imageUrl: 'assets/tarot/hermit.png',
      ),
      TarotCard(
        id: '10',
        name: 'Wheel of Fortune',
        nameKo: '운명의 수레바퀴',
        description: '변화, 운명, 기회',
        imageUrl: 'assets/tarot/wheel.png',
      ),
      TarotCard(
        id: '11',
        name: 'Justice',
        nameKo: '정의',
        description: '공정, 진실, 균형',
        imageUrl: 'assets/tarot/justice.png',
      ),
      TarotCard(
        id: '12',
        name: 'The Hanged Man',
        nameKo: '매달린 사람',
        description: '희생, 관점 전환, 깨달음',
        imageUrl: 'assets/tarot/hanged_man.png',
      ),
      TarotCard(
        id: '13',
        name: 'Death',
        nameKo: '죽음',
        description: '변화, 종료, 새로운 시작',
        imageUrl: 'assets/tarot/death.png',
      ),
      TarotCard(
        id: '14',
        name: 'Temperance',
        nameKo: '절제',
        description: '균형, 조화, 인내',
        imageUrl: 'assets/tarot/temperance.png',
      ),
      TarotCard(
        id: '15',
        name: 'The Devil',
        nameKo: '악마',
        description: '유혹, 속박, 집착',
        imageUrl: 'assets/tarot/devil.png',
      ),
      TarotCard(
        id: '16',
        name: 'The Tower',
        nameKo: '탑',
        description: '붕괴, 혼란, 깨달음',
        imageUrl: 'assets/tarot/tower.png',
      ),
      TarotCard(
        id: '17',
        name: 'The Star',
        nameKo: '별',
        description: '희망, 영감, 치유',
        imageUrl: 'assets/tarot/star.png',
      ),
      TarotCard(
        id: '18',
        name: 'The Moon',
        nameKo: '달',
        description: '불안, 환상, 직관',
        imageUrl: 'assets/tarot/moon.png',
      ),
      TarotCard(
        id: '19',
        name: 'The Sun',
        nameKo: '태양',
        description: '성공, 기쁨, 활력',
        imageUrl: 'assets/tarot/sun.png',
      ),
      TarotCard(
        id: '20',
        name: 'Judgement',
        nameKo: '심판',
        description: '결정, 각성, 부활',
        imageUrl: 'assets/tarot/judgement.png',
      ),
      TarotCard(
        id: '21',
        name: 'The World',
        nameKo: '세계',
        description: '완성, 성취, 통합',
        imageUrl: 'assets/tarot/world.png',
      ),
    ];
  }

  static String _generateTarotAnalysis(List<TarotCard> cards, String question) {
    final buffer = StringBuffer();
    buffer.writeln('질문: $question\n');
    buffer.writeln('타로 카드 해석:\n');

    for (int i = 0; i < cards.length; i++) {
      final card = cards[i];
      final position = i == 0 ? '과거' : i == 1 ? '현재' : '미래';
      final direction = card.isReversed ? '(역방향)' : '(정방향)';
      
      buffer.writeln('${i + 1}. $position: ${card.nameKo} $direction');
      buffer.writeln('   ${card.description}');
      
      if (card.isReversed) {
        buffer.writeln('   역방향으로 나타나 ${card.description}의 반대 의미나 지연, 내면의 문제를 나타냅니다.');
      } else {
        buffer.writeln('   정방향으로 나타나 긍정적인 에너지와 ${card.description}을(를) 의미합니다.');
      }
      buffer.writeln();
    }

    buffer.writeln('종합 해석:');
    if (cards.length == 3) {
      buffer.writeln('과거에는 ${cards[0].nameKo}의 영향을 받았으며, ');
      buffer.writeln('현재는 ${cards[1].nameKo}의 에너지 속에 있습니다. ');
      buffer.writeln('미래에는 ${cards[2].nameKo}가 나타나 새로운 국면을 맞이하게 됩니다.');
    }
    buffer.writeln('\n전체적으로 긍정적인 에너지가 흐르고 있으며, ');
    buffer.writeln('현재의 노력이 좋은 결과로 이어질 것입니다.');
    buffer.writeln('\n※ 타로 해석은 참고용이며, 최종 선택과 행동은 본인의 의지에 달려있습니다.');

    return buffer.toString();
  }

  // 다국어 지원 헬퍼 함수들
  static List<String> _getFaceShapesByLanguage(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return ['계란형', '둥근형', '각진형', '긴형'];
      case 'en':
        return ['Oval', 'Round', 'Square', 'Long'];
      case 'zh':
        return ['鹅蛋脸', '圆脸', '方脸', '长脸'];
      case 'ja':
        return ['卵型', '丸型', '角型', '長型'];
      case 'vi':
        return ['Hình trứng', 'Tròn', 'Vuông', 'Dài'];
      case 'ar':
        return ['بيضاوي', 'دائري', 'مربع', 'طويل'];
      default:
        return ['Oval', 'Round', 'Square', 'Long'];
    }
  }

  static List<String> _getSizesByLanguage(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return ['크다', '중간', '작다'];
      case 'en':
        return ['Large', 'Medium', 'Small'];
      case 'zh':
        return ['大', '中等', '小'];
      case 'ja':
        return ['大きい', '中間', '小さい'];
      case 'vi':
        return ['Lớn', 'Trung bình', 'Nhỏ'];
      case 'ar':
        return ['كبير', 'متوسط', 'صغير'];
      default:
        return ['Large', 'Medium', 'Small'];
    }
  }

  static List<String> _getNoseShapesByLanguage(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return ['높은 콧날', '부드러운 콧날', '넓은 콧날'];
      case 'en':
        return ['High bridge', 'Soft bridge', 'Wide bridge'];
      case 'zh':
        return ['高鼻梁', '柔和鼻梁', '宽鼻梁'];
      case 'ja':
        return ['高い鼻筋', '柔らかい鼻筋', '広い鼻筋'];
      case 'vi':
        return ['Sống mũi cao', 'Sống mũi mềm', 'Sống mũi rộng'];
      case 'ar':
        return ['جسر أنف عالي', 'جسر أنف ناعم', 'جسر أنف عريض'];
      default:
        return ['High bridge', 'Soft bridge', 'Wide bridge'];
    }
  }

  static List<String> _generateFaceAnalysisText(Map<String, dynamic> features, String languageCode) {
    switch (languageCode) {
      case 'ko':
        return [
          '귀하의 얼굴형은 ${features['faceShape']}으로 리더십과 결단력이 뛰어납니다.',
          '눈의 크기가 ${features['eyeSize']}으로 통찰력과 관찰력이 우수합니다.',
          '${features['noseShape']}을 가지고 있어 재물운이 좋고 성공 가능성이 높습니다.',
          '입의 크기가 ${features['mouthSize']}으로 대인관계와 소통 능력이 뛰어납니다.',
          '이마가 ${features['foreheadSize']}으로 지혜와 사고력이 뛰어나며 학문적 성취가 기대됩니다.',
          '전반적으로 균형잡힌 얼굴 구조로 건강과 장수의 상을 가지고 있습니다.',
        ];
      case 'en':
        return [
          'Your face shape is ${features['faceShape']}, indicating excellent leadership and decisiveness.',
          'Your eye size is ${features['eyeSize']}, showing superior insight and observation skills.',
          'You have ${features['noseShape']}, suggesting good fortune and high success potential.',
          'Your mouth size is ${features['mouthSize']}, indicating excellent interpersonal and communication skills.',
          'Your forehead is ${features['foreheadSize']}, showing exceptional wisdom and academic achievement potential.',
          'Overall, you have a well-balanced facial structure indicating health and longevity.',
        ];
      case 'zh':
        return [
          '您的脸型是${features['faceShape']}，表明领导力和决断力出色。',
          '您的眼睛${features['eyeSize']}，显示卓越的洞察力和观察力。',
          '您有${features['noseShape']}，暗示财运好，成功潜力高。',
          '您的嘴巴${features['mouthSize']}，表明人际关系和沟通能力出色。',
          '您的额头${features['foreheadSize']}，显示智慧和思考力优秀，学术成就可期。',
          '总体来说，面部结构均衡，有健康长寿之相。',
        ];
      case 'ja':
        return [
          'あなたの顔の形は${features['faceShape']}で、リーダーシップと決断力に優れています。',
          '目の大きさは${features['eyeSize']}で、洞察力と観察力が優れています。',
          '${features['noseShape']}を持っていて、財運が良く成功の可能性が高いです。',
          '口の大きさが${features['mouthSize']}で、対人関係とコミュニケーション能力に優れています。',
          '額が${features['foreheadSize']}で、知恵と思考力に優れ、学問的成就が期待されます。',
          '全体的にバランスの取れた顔の構造で、健康と長寿の相を持っています。',
        ];
      case 'vi':
        return [
          'Khuôn mặt của bạn là ${features['faceShape']}, cho thấy khả năng lãnh đạo và quyết đoán xuất sắc.',
          'Kích thước mắt của bạn là ${features['eyeSize']}, cho thấy khả năng quan sát và sáng suốt vượt trội.',
          'Bạn có ${features['noseShape']}, gợi ý vận may về tài chính tốt và tiềm năng thành công cao.',
          'Kích thước miệng của bạn là ${features['mouthSize']}, cho thấy kỹ năng giao tiếp xuất sắc.',
          'Trán của bạn ${features['foreheadSize']}, cho thấy trí tuệ và tư duy xuất sắc, tiềm năng thành tựu học thuật.',
          'Nhìn chung, cấu trúc khuôn mặt cân đối, có tướng sống lâu và khỏe mạnh.',
        ];
      case 'ar':
        return [
          'شكل وجهك هو ${features['faceShape']}، مما يشير إلى قيادة وحزم ممتازين.',
          'حجم عينيك ${features['eyeSize']}، يظهر بصيرة ومهارات ملاحظة متفوقة.',
          'لديك ${features['noseShape']}، مما يشير إلى حظ جيد وإمكانية نجاح عالية.',
          'حجم فمك ${features['mouthSize']}، يشير إلى مهارات اتصال وعلاقات شخصية ممتازة.',
          'جبهتك ${features['foreheadSize']}، تظهر حكمة وقدرة تفكير استثنائية، إمكانية إنجاز أكاديمي.',
          'بشكل عام، لديك بنية وجه متوازنة تشير إلى الصحة وطول العمر.',
        ];
      default:
        return [
          'Your face shape is ${features['faceShape']}, indicating excellent leadership and decisiveness.',
          'Your eye size is ${features['eyeSize']}, showing superior insight and observation skills.',
          'You have ${features['noseShape']}, suggesting good fortune and high success potential.',
          'Your mouth size is ${features['mouthSize']}, indicating excellent interpersonal and communication skills.',
          'Your forehead is ${features['foreheadSize']}, showing exceptional wisdom and academic achievement potential.',
          'Overall, you have a well-balanced facial structure indicating health and longevity.',
        ];
    }
  }

  static List<String> _generatePalmAnalysisText(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return [
          '생명선이 길고 깊어 건강하고 장수할 상입니다. 체력이 좋고 생명력이 강합니다.',
          '지능선이 명확하게 나타나 있어 판단력과 지적 능력이 뛰어납니다.',
          '감정선이 길고 깊어 애정운이 좋으며 깊은 사랑을 나눌 수 있습니다.',
          '운명선이 보이며 자신의 길을 찾아 성공할 가능성이 높습니다.',
          '재물선이 나타나 있어 경제적으로 안정되고 부를 축적할 수 있습니다.',
          '전반적으로 균형잡힌 손금으로 행운과 성공의 가능성이 높습니다.',
        ];
      case 'en':
        return [
          'Your life line is long and deep, indicating good health and longevity. Strong vitality and physical strength.',
          'Your head line is clear, showing excellent judgment and intellectual abilities.',
          'Your heart line is long and deep, indicating good romance and ability to share deep love.',
          'Your fate line is visible, showing high potential to find your path and succeed.',
          'Your wealth line is present, indicating financial stability and ability to accumulate wealth.',
          'Overall, well-balanced palm lines indicating high potential for luck and success.',
        ];
      case 'zh':
        return [
          '生命线长而深，表示健康长寿。体力好，生命力强。',
          '智慧线清晰，显示判断力和智力能力出色。',
          '感情线长而深，表示爱情运好，能够分享深厚的爱。',
          '命运线可见，显示找到自己道路并成功的可能性高。',
          '财富线出现，表示财务稳定，能够积累财富。',
          '总体而言，手纹平衡，幸运和成功的可能性高。',
        ];
      case 'ja':
        return [
          '生命線が長く深いため、健康で長寿の相です。体力が良く、生命力が強いです。',
          '知能線が明確に表れており、判断力と知的能力に優れています。',
          '感情線が長く深く、恋愛運が良く、深い愛を分かち合えます。',
          '運命線が見え、自分の道を見つけて成功する可能性が高いです。',
          '財運線が表れており、経済的に安定し、富を蓄積できます。',
          '全体的にバランスの取れた手相で、幸運と成功の可能性が高いです。',
        ];
      case 'vi':
        return [
          'Đường sự sống của bạn dài và sâu, cho thấy sức khỏe tốt và sống lâu. Sức sống mạnh mẽ.',
          'Đường trí tuệ rõ ràng, cho thấy khả năng phán đoán và trí tuệ xuất sắc.',
          'Đường tình cảm dài và sâu, cho thấy vận may trong tình yêu và khả năng chia sẻ tình yêu sâu sắc.',
          'Đường số mệnh hiện rõ, cho thấy khả năng cao tìm thấy con đường và thành công.',
          'Đường tài lộc xuất hiện, cho thấy sự ổn định tài chính và khả năng tích lũy của cải.',
          'Nhìn chung, các đường chỉ tay cân đối, tiềm năng may mắn và thành công cao.',
        ];
      case 'ar':
        return [
          'خط حياتك طويل وعميق، يشير إلى صحة جيدة وطول عمر. حيوية قوية وقوة بدنية.',
          'خط رأسك واضح، يظهر حكماً وقدرات فكرية ممتازة.',
          'خط قلبك طويل وعميق، يشير إلى حظ جيد في الحب وقدرة على مشاركة حب عميق.',
          'خط مصيرك مرئي، يظهر إمكانية عالية لإيجاد طريقك والنجاح.',
          'خط ثروتك موجود، يشير إلى استقرار مالي وقدرة على تراكم الثروة.',
          'بشكل عام، خطوط كف متوازنة تشير إلى إمكانية عالية للحظ والنجاح.',
        ];
      default:
        return [
          'Your life line is long and deep, indicating good health and longevity. Strong vitality and physical strength.',
          'Your head line is clear, showing excellent judgment and intellectual abilities.',
          'Your heart line is long and deep, indicating good romance and ability to share deep love.',
          'Your fate line is visible, showing high potential to find your path and succeed.',
          'Your wealth line is present, indicating financial stability and ability to accumulate wealth.',
          'Overall, well-balanced palm lines indicating high potential for luck and success.',
        ];
    }
  }
}
