import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';
import 'face_analysis_screen.dart';
import 'palm_analysis_screen.dart';
import 'saju_input_screen.dart';
import 'tarot_screen.dart';
import 'shop_screen.dart';
import 'advisors_screen.dart';
import 'my_reports_screen.dart';
import 'today_fortune_screen.dart';
import 'zodiac_screen.dart';
import 'mbti_screen.dart';
import 'signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _showChatbot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChatbotDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    final List<Widget> screens = [
      const HomePage(),
      const MyReportsScreen(),
      const ShopScreen(),
      const AdvisorsScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      floatingActionButton: _ChatbotFloatingButton(onTap: () => _showChatbot(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: localization.translate('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.article_outlined),
            selectedIcon: const Icon(Icons.article),
            label: localization.translate('my_reports'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_bag_outlined),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: localization.translate('shop'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: localization.translate('consultation'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // MZ 스타일 헤더
            SliverAppBar(
              expandedHeight: 140,
              floating: true,
              pinned: false,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF667EEA),
                        Color(0xFF764BA2),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 배경 패턴
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: CustomPaint(
                            painter: _StarPatternPainter(),
                          ),
                        ),
                      ),
                      // 타이틀 (왼쪽 정렬, 2줄, 30% 축소)
                      Positioned(
                        left: 16,
                        top: 0,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✨ 운세의 신',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Oracle AI',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localization.translate('global_service'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 언어 변경 아이콘 (오른쪽 상단)
                      Positioned(
                        top: 24,
                        right: 12,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showLanguageDialog(context),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.language,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      LocalizationService.supportedLanguages
                                          .firstWhere((l) => l['code'] == localization.currentLanguage)['flag']!,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 반응형 패딩
                  double horizontalPadding;
                  
                  if (constraints.maxWidth > 1200) {
                    horizontalPadding = 80;
                  } else if (constraints.maxWidth > 768) {
                    horizontalPadding = 40;
                  } else if (constraints.maxWidth > 600) {
                    horizontalPadding = 24;
                  } else {
                    horizontalPadding = 16;
                  }
                  
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      
                      // 프로모션 배너
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: _PromotionBanner(),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 회원가입 버튼
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: _SignupButton(),
                      ),
                  
                  const SizedBox(height: 24),
                  
                  // AI 분석 섹션
                  _SectionHeader(title: localization.translate('ai_analysis')),
                  const SizedBox(height: 12),
                  _FeatureGrid(
                    items: [
                      _FeatureItem(
                        title: localization.translate('face_reading'),
                        subtitle: localization.translate('face_reading_subtitle'),
                        icon: Icons.face_retouching_natural,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FaceAnalysisScreen()),
                        ),
                      ),
                      _FeatureItem(
                        title: localization.translate('palm_reading'),
                        subtitle: localization.translate('palm_reading_subtitle'),
                        icon: Icons.back_hand,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PalmAnalysisScreen()),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 데일리 운세 섹션
                  _SectionHeader(title: localization.translate('daily_fortune')),
                  const SizedBox(height: 12),
                  _FeatureGrid(
                    items: [
                      _FeatureItem(
                        title: localization.translate('today_fortune'),
                        subtitle: localization.translate('today_fortune_subtitle'),
                        icon: Icons.auto_awesome,
                        iconSize: 28,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD93D), Color(0xFFFF6B6B)],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TodayFortuneScreen()),
                          );
                        },
                      ),
                      _FeatureItem(
                        title: localization.translate('zodiac'),
                        subtitle: localization.translate('zodiac_subtitle'),
                        icon: Icons.star,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B95), Color(0xFFA855F7)],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ZodiacScreen()),
                          );
                        },
                      ),
                      _FeatureItem(
                        title: localization.translate('saju'),
                        subtitle: localization.translate('saju_subtitle'),
                        icon: Icons.calendar_today,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8008), Color(0xFFFFC837)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SajuInputScreen()),
                        ),
                      ),
                      _FeatureItem(
                        title: localization.translate('tarot'),
                        subtitle: localization.translate('tarot_subtitle'),
                        icon: Icons.style,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TarotScreen()),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 성격 분석 섹션
                  _SectionHeader(title: localization.translate('personality')),
                  const SizedBox(height: 12),
                  _FeatureGrid(
                    items: [
                      _FeatureItem(
                        title: localization.translate('mbti'),
                        subtitle: localization.translate('mbti_subtitle'),
                        icon: Icons.psychology,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MbtiScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                      // 안내 문구
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Container(
                          padding: EdgeInsets.all(constraints.maxWidth > 1200 ? 40 : 20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline, 
                                color: Colors.blue.shade700, 
                                size: constraints.maxWidth > 1200 ? 48 : 24,  // PC: 100% 확대
                              ),
                              SizedBox(width: constraints.maxWidth > 1200 ? 24 : 12),
                              Expanded(
                                child: Text(
                                  localization.translate('disclaimer'),
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth > 1200 ? 28 : 14,  // PC: 100% 확대
                                    color: Colors.blue.shade900,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 사업자 정보
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Container(
                          padding: EdgeInsets.all(constraints.maxWidth > 1200 ? 32 : 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '등록번호 : 572-68-00752   상호 : 캐쉬 아이큐(CASH IQ)   대표 : 박용균',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth > 1200 ? 24 : 12,
                                  color: Colors.grey.shade700,
                                  height: 1.6,
                                ),
                              ),
                              SizedBox(height: constraints.maxWidth > 1200 ? 8 : 4),
                              Text(
                                '사업장소재지 : 서울특별시 강남구 테헤란로82길 15, 614호(대치동)',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth > 1200 ? 24 : 12,
                                  color: Colors.grey.shade700,
                                  height: 1.6,
                                ),
                              ),
                              SizedBox(height: constraints.maxWidth > 1200 ? 8 : 4),
                              Text(
                                '업태: 정보통신업   종목: 소프트웨어 개발 및 공급업',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth > 1200 ? 24 : 12,
                                  color: Colors.grey.shade700,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showLanguageDialog(BuildContext context) {
    final localization = context.read<LocalizationService>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.language, color: Color(0xFF667EEA)),
            const SizedBox(width: 12),
            Text(localization.translate('language')),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LocalizationService.supportedLanguages.length,
            itemBuilder: (context, index) {
              final lang = LocalizationService.supportedLanguages[index];
              final isSelected = localization.currentLanguage == lang['code'];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF667EEA).withValues(alpha: 0.1) : null,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF667EEA) : Colors.grey.shade200,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  leading: Text(
                    lang['flag']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    lang['name']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF667EEA) : null,
                    ),
                  ),
                  trailing: isSelected 
                    ? const Icon(Icons.check_circle, color: Color(0xFF667EEA))
                    : null,
                  onTap: () {
                    localization.setLanguage(lang['code']!);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 반응형 패딩 및 폰트 크기
        double horizontalPadding;
        double fontSize;
        
        if (constraints.maxWidth > 1200) {
          horizontalPadding = 80;
          fontSize = 44;  // PC: 100% 확대 (22 → 44)
        } else if (constraints.maxWidth > 768) {
          horizontalPadding = 40;
          fontSize = 20;
        } else if (constraints.maxWidth > 600) {
          horizontalPadding = 24;
          fontSize = 18;
        } else {
          horizontalPadding = 16;
          fontSize = 18;
        }
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              Container(
                width: constraints.maxWidth > 1200 ? 10 : 5,  // PC: 100% 확대
                height: constraints.maxWidth > 1200 ? 56 : 28,  // PC: 100% 확대
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(constraints.maxWidth > 1200 ? 5 : 2.5),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final List<_FeatureItem> items;

  const _FeatureGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 반응형 디자인: 화면 크기에 따라 그리드 컬럼 수 조정
        int crossAxisCount;
        double childAspectRatio;
        double horizontalPadding;
        
        if (constraints.maxWidth > 1200) {
          // PC 환경 (대형 화면)
          crossAxisCount = 4;
          childAspectRatio = 1.1;
          horizontalPadding = 80;
        } else if (constraints.maxWidth > 768) {
          // 태블릿 환경
          crossAxisCount = 3;
          childAspectRatio = 1.15;
          horizontalPadding = 40;
        } else if (constraints.maxWidth > 600) {
          // 태블릿 세로 모드
          crossAxisCount = 2;
          childAspectRatio = 1.2;
          horizontalPadding = 24;
        } else {
          // 모바일 환경
          crossAxisCount = 2;
          childAspectRatio = 1.2;
          horizontalPadding = 16;
        }
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          ),
        );
      },
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;
  final double? iconSize;

  const _FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // PC 화면에서만 글자와 아이콘 크기 100% 확대
        final isPCScreen = MediaQuery.of(context).size.width > 1200;
        final double titleFontSize = isPCScreen ? 28 : 14;  // PC: 100% 확대 (14 → 28)
        final double subtitleFontSize = isPCScreen ? 24 : 12;  // PC: 100% 확대 (12 → 24)
        final double effectiveIconSize = isPCScreen ? (iconSize ?? 40) * 2 : (iconSize ?? 40);  // PC: 100% 확대
        
        return Container(
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isPCScreen ? 16 : 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: effectiveIconSize),
                    ),
                    SizedBox(height: isPCScreen ? 12 : 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isPCScreen ? 8 : 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: subtitleFontSize,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PromotionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    final isPCScreen = MediaQuery.of(context).size.width > 1200;
    
    // 요청사항: 1) 주황색 배너 높이 축소 (50%), 2) 흰색 사각형 왼쪽, 환불규정 오른쪽 배치
    final double titleFontSize = 18;  // 특별 프로모션 (축소)
    final double subtitleFontSize = 16;  // 48,000원으로 1년 (축소)
    final double promoTextFontSize = 13;  // 흰색 사각형 텍스트 (축소)
    final double refundTextSize = 11;  // 환불규정 텍스트 (축소)
    final double padding = 8.0;  // 배너 패딩 (축소)
    
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPromoDialog(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 왼쪽: 흰색 사각형 (2줄 텍스트)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localization.translate('promo_free_trial_line1'),
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: promoTextFontSize,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        localization.translate('promo_free_trial_line2'),
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: promoTextFontSize,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 12),
                
                // 중앙: 특별 프로모션 + 48,000원으로 1년
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localization.translate('promo_title'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        localization.translate('promo_subtitle'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 12),
                
                // 오른쪽: 환불규정 버튼
                TextButton(
                  onPressed: () => _showRefundPolicyDialog(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    localization.translate('refund_policy'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: refundTextSize,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRefundPolicyDialog(BuildContext context) {
    final localization = context.read<LocalizationService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isPCScreen = screenWidth > 1200;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          localization.translate('refund_policy_title'),
          style: TextStyle(
            fontSize: isPCScreen ? 24 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: isPCScreen ? 800 : screenWidth * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: SingleChildScrollView(
            child: Text(
              localization.translate('refund_policy_content'),
              style: TextStyle(
                fontSize: isPCScreen ? 16 : 14,
                height: 1.6,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isPCScreen ? 32 : 24,
                vertical: isPCScreen ? 16 : 12,
              ),
            ),
            child: Text(
              '닫기',
              style: TextStyle(
                fontSize: isPCScreen ? 18 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPromoDialog(BuildContext context) {
    final localization = context.read<LocalizationService>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localization.translate('promo_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    localization.translate('promo_highlight'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.translate('promo_subtitle'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localization.translate('promo_description'),
              style: const TextStyle(height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localization.translate('promo_button'))),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: Text(localization.translate('promo_button')),
          ),
        ],
      ),
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    final isPCScreen = MediaQuery.of(context).size.width > 1200;
    
    // PC 화면에서만 글자와 아이콘 크기 100% 확대
    final double titleFontSize = isPCScreen ? 36 : 18;
    final double subtitleFontSize = isPCScreen ? 28 : 14;
    final double iconSize = isPCScreen ? 80 : 40;
    final double arrowIconSize = isPCScreen ? 36 : 18;
    final double padding = isPCScreen ? 40.0 : 20.0;
    final double iconPadding = isPCScreen ? 24 : 12;
    final double spacing = isPCScreen ? 32 : 16;
    final double verticalSpacing = isPCScreen ? 8 : 4;
    
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupScreen()),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.translate('signup_cta_title'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: verticalSpacing),
                      Text(
                        localization.translate('signup_cta_subtitle'),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: arrowIconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StarPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 51) % size.height;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Chatbot Dialog Widget
class ChatbotDialog extends StatefulWidget {
  const ChatbotDialog({super.key});

  @override
  State<ChatbotDialog> createState() => _ChatbotDialogState();
}

class _ChatbotDialogState extends State<ChatbotDialog> {
  String? _selectedQuestion;

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.translate('chatbot'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localization.translate('chatbot_greeting'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _selectedQuestion == null
                ? _buildQuestionList()
                : _buildAnswer(_selectedQuestion!),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList() {
    final localization = context.watch<LocalizationService>();
    
    final List<String> questions = [
      'faq_q1', 'faq_q2', 'faq_q3', 'faq_q4', 'faq_q5',
      'faq_q6', 'faq_q7', 'faq_q8', 'faq_q9', 'faq_q10',
      'faq_q11', 'faq_q12', 'faq_q13', 'faq_q14', 'faq_q15',
    ];

    return Column(
      children: [
        // FAQ Title
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.help_outline, color: Color(0xFF667EEA), size: 24),
              const SizedBox(width: 8),
              Text(
                localization.translate('faq'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667EEA),
                ),
              ),
            ],
          ),
        ),
        
        // Question List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: questions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final questionKey = questions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF667EEA).withValues(alpha: 0.1),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFF667EEA),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  localization.translate(questionKey),
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF667EEA)),
                onTap: () {
                  setState(() {
                    _selectedQuestion = questionKey;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnswer(String questionKey) {
    final localization = context.watch<LocalizationService>();
    final answerKey = questionKey.replaceFirst('_q', '_a');
    
    return Column(
      children: [
        // Back Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedQuestion = null;
                  });
                },
                icon: const Icon(Icons.arrow_back, color: Color(0xFF667EEA)),
              ),
              Expanded(
                child: Text(
                  localization.translate('back_to_question_list'),
                  style: const TextStyle(
                    color: Color(0xFF667EEA),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Question and Answer
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.help, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          localization.translate(questionKey),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Answer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Color(0xFF667EEA), size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          localization.translate(answerKey),
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Chatbot Floating Button with Animated Tooltip
class _ChatbotFloatingButton extends StatefulWidget {
  final VoidCallback onTap;
  
  const _ChatbotFloatingButton({required this.onTap});

  @override
  State<_ChatbotFloatingButton> createState() => _ChatbotFloatingButtonState();
}

class _ChatbotFloatingButtonState extends State<_ChatbotFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Speech Bubble Tooltip
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main Bubble
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      localization.translate('chatbot_greeting'),
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // AI Badge (100% 확대)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // Floating Action Button
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FloatingActionButton.large(
                  onPressed: widget.onTap,
                  backgroundColor: const Color(0xFF667EEA),
                  elevation: 0,
                  child: const Icon(
                    Icons.chat_bubble,
                    color: Colors.white,
                    size: 56,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
