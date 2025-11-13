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
              expandedHeight: 100,
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
                      // 타이틀
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                localization.translate('app_title'),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localization.translate('global_service'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
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
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.language,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      LocalizationService.supportedLanguages
                                          .firstWhere((l) => l['code'] == localization.currentLanguage)['flag']!,
                                      style: const TextStyle(fontSize: 14),
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
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  
                  // 프로모션 배너
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _PromotionBanner(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 회원가입 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              localization.translate('disclaimer'),
                              style: TextStyle(
                                fontSize: 12,
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
                ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final List<_FeatureItem> items;

  const _FeatureGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      ),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: iconSize ?? 28),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 10,
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
  }
}

class _PromotionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.translate('promo_title'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              localization.translate('promo_free_trial_line1'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            Text(
                              localization.translate('promo_free_trial_line2'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localization.translate('promo_subtitle'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
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
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.translate('signup_cta_title'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localization.translate('signup_cta_subtitle'),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
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
