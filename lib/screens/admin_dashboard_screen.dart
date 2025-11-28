import 'package:flutter/material.dart';
import 'admin_users_screen.dart';
import 'admin_advisors_screen.dart';
import 'admin_faq_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _DashboardHome(),
    const AdminUsersScreen(),
    const AdminAdvisorsScreen(),
    const AdminFaqScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자 페이지'),
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('로그아웃'),
                    ),
                  ],
                ),
              );
            },
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: Row(
        children: [
          // 사이드바 (PC/태블릿)
          if (MediaQuery.of(context).size.width >= 768)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.grey.shade50,
              selectedIconTheme: const IconThemeData(
                color: Color(0xFF667EEA),
              ),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xFF667EEA),
                fontWeight: FontWeight.bold,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  label: Text('대시보드'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people),
                  label: Text('회원 관리'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.support_agent),
                  label: Text('상담사 관리'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.chat),
                  label: Text('FAQ 관리'),
                ),
              ],
            ),
          
          // 메인 콘텐츠
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      // 하단 네비게이션 (모바일)
      bottomNavigationBar: MediaQuery.of(context).size.width < 768
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard),
                  label: '대시보드',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people),
                  label: '회원',
                ),
                NavigationDestination(
                  icon: Icon(Icons.support_agent),
                  label: '상담사',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat),
                  label: 'FAQ',
                ),
              ],
            )
          : null,
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '관리자 대시보드',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '시스템 관리 및 통계',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          
          // 통계 카드
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900 ? 4 : constraints.maxWidth > 600 ? 2 : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: const [
                  _StatCard(
                    title: '총 회원',
                    value: '0',
                    icon: Icons.people,
                    color: Color(0xFF667EEA),
                  ),
                  _StatCard(
                    title: '상담사',
                    value: '0',
                    icon: Icons.support_agent,
                    color: Color(0xFF11998E),
                  ),
                  _StatCard(
                    title: 'FAQ',
                    value: '15',
                    icon: Icons.chat,
                    color: Color(0xFFFF6B6B),
                  ),
                  _StatCard(
                    title: '분석 결과',
                    value: '0',
                    icon: Icons.analytics,
                    color: Color(0xFFFFA500),
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // 빠른 작업
          const Text(
            '빠른 작업',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QuickActionButton(
                icon: Icons.person_add,
                label: '회원 등록',
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.support_agent,
                label: '상담사 교체',
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.add_comment,
                label: 'FAQ 추가',
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.settings,
                label: '설정',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF667EEA)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
