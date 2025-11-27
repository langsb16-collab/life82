import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final faceAnalyses = StorageService.getAnalysisByType('face');
    final palmAnalyses = StorageService.getAnalysisByType('palm');
    final sajuAnalyses = StorageService.getAnalysisByType('saju');
    final tarotReadings = StorageService.getAnalysisByType('tarot');
    final enneagramResults = StorageService.getAnalysisByType('enneagram');

    final allReports = [
      ...faceAnalyses.map((a) => {'type': '얼굴 관상', 'icon': Icons.face, 'data': a}),
      ...palmAnalyses.map((a) => {'type': '손금', 'icon': Icons.back_hand, 'data': a}),
      ...sajuAnalyses.map((a) => {'type': '사주팔자', 'icon': Icons.calendar_today, 'data': a}),
      ...tarotReadings.map((a) => {'type': '타로', 'icon': Icons.style, 'data': a}),
      ...enneagramResults.map((a) => {'type': '애니어그램', 'icon': Icons.filter_9_plus, 'data': a}),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 리포트'),
      ),
      body: SafeArea(
        child: allReports.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '아직 분석 결과가 없습니다',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '홈 화면에서 분석을 시작해보세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allReports.length,
                itemBuilder: (context, index) {
                  final report = allReports[allReports.length - 1 - index];
                  final data = report['data'] as Map<String, dynamic>;
                  final createdAt = DateTime.parse(data['createdAt'] as String);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(report['icon'] as IconData),
                      ),
                      title: Text(
                        report['type'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')} '
                        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showReportDetail(context, report);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showReportDetail(BuildContext context, Map<String, dynamic> report) {
    final data = report['data'] as Map<String, dynamic>;
    final reportType = report['type'] as String;
    
    // 애니어그램 결과인 경우 특별 처리
    if (reportType == '애니어그램') {
      _showEnneagramDetail(context, data);
      return;
    }
    
    final analysis = data['analysis'] as String;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(report['icon'] as IconData, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${report['type']} 분석 결과',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Text(
                      analysis,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEnneagramDetail(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.filter_9_plus, size: 32, color: Color(0xFF667EEA)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        '애니어그램 결과',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 유형 헤더
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '유형 ${data['dominantType']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['typeName'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data['center'] as String,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '🪽 ${data['wingType']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // 핵심 특징
                        _buildEnneagramInfoCard(
                          '핵심 특징',
                          data['core'] as String,
                          Icons.star,
                        ),
                        const SizedBox(height: 16),
                        
                        // 강점
                        _buildEnneagramInfoCard(
                          '강점',
                          data['strengths'] as String,
                          Icons.thumb_up,
                        ),
                        const SizedBox(height: 16),
                        
                        // 성장 과제
                        _buildEnneagramInfoCard(
                          '성장 과제',
                          data['growth'] as String,
                          Icons.trending_up,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnneagramInfoCard(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF667EEA).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF667EEA), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667EEA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
