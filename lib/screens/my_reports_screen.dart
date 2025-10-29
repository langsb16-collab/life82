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

    final allReports = [
      ...faceAnalyses.map((a) => {'type': '얼굴 관상', 'icon': Icons.face, 'data': a}),
      ...palmAnalyses.map((a) => {'type': '손금', 'icon': Icons.back_hand, 'data': a}),
      ...sajuAnalyses.map((a) => {'type': '사주팔자', 'icon': Icons.calendar_today, 'data': a}),
      ...tarotReadings.map((a) => {'type': '타로', 'icon': Icons.style, 'data': a}),
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
}
