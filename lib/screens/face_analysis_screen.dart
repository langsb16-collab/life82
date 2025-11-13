import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/analysis_service.dart';
import '../services/storage_service.dart';
import '../services/localization_service.dart';
import 'analysis_result_screen.dart';

class FaceAnalysisScreen extends StatefulWidget {
  const FaceAnalysisScreen({super.key});

  @override
  State<FaceAnalysisScreen> createState() => _FaceAnalysisScreenState();
}

class _FaceAnalysisScreenState extends State<FaceAnalysisScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _captureAndAnalyze() async {
    try {
      // 웹에서는 카메라 대신 파일 선택 사용
      final XFile? image = kIsWeb
          ? await _picker.pickImage(source: ImageSource.gallery)
          : await _picker.pickImage(source: ImageSource.camera);

      if (image == null) return;

      setState(() {
        _isAnalyzing = true;
      });

      // 분석 수행
      final localization = context.read<LocalizationService>();
      final analysis = await AnalysisService.analyzeFace(
        'demo_user',
        image.path,
        localization.currentLanguage,
      );

      // 분석 결과 저장
      await StorageService.saveAnalysis('face', analysis.toJson());

      if (!mounted) return;

      setState(() {
        _isAnalyzing = false;
      });

      // 결과 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisResultScreen(
            title: localization.translate('face_analysis_title'),
            analysis: analysis.analysis,
            confidence: analysis.confidence,
            details: analysis.features,
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error analyzing face: $e');
      }
      if (!mounted) return;
      
      setState(() {
        _isAnalyzing = false;
      });

      final localization = context.read<LocalizationService>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localization.translate('error_occurred')}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('face_analysis_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.face,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localization.translate('face_analysis_title'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localization.translate('face_analysis_desc'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _GuideSection(localization: localization),
                const SizedBox(height: 32),
                if (_isAnalyzing)
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(localization.translate('analyzing')),
                      ],
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _captureAndAnalyze,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(localization.translate('take_photo')),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          localization.translate('privacy_notice'),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade900,
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
      ),
    );
  }
}

class _GuideSection extends StatelessWidget {
  final LocalizationService localization;
  
  const _GuideSection({required this.localization});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('photo_guide'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _GuideItem(
          icon: Icons.light_mode,
          title: localization.translate('bright_light'),
          description: localization.translate('bright_light_desc'),
        ),
        _GuideItem(
          icon: Icons.face,
          title: localization.translate('front_view'),
          description: localization.translate('front_view_desc'),
        ),
        _GuideItem(
          icon: Icons.photo_camera,
          title: localization.translate('close_distance'),
          description: localization.translate('close_distance_desc'),
        ),
        _GuideItem(
          icon: Icons.mood,
          title: localization.translate('natural_expression'),
          description: localization.translate('natural_expression_desc'),
        ),
      ],
    );
  }
}

class _GuideItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _GuideItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
