import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/analysis_service.dart';
import '../services/storage_service.dart';
import '../services/localization_service.dart';
import 'analysis_result_screen.dart';

class PalmAnalysisScreen extends StatefulWidget {
  const PalmAnalysisScreen({super.key});

  @override
  State<PalmAnalysisScreen> createState() => _PalmAnalysisScreenState();
}

class _PalmAnalysisScreenState extends State<PalmAnalysisScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _captureAndAnalyze() async {
    try {
      final XFile? image = kIsWeb
          ? await _picker.pickImage(source: ImageSource.gallery)
          : await _picker.pickImage(source: ImageSource.camera);

      if (image == null) return;

      setState(() {
        _isAnalyzing = true;
      });

      final localization = context.read<LocalizationService>();
      final analysis = await AnalysisService.analyzePalm(
        'demo_user',
        image.path,
        localization.currentLanguage,
      );

      await StorageService.saveAnalysis('palm', analysis.toJson());

      if (!mounted) return;

      setState(() {
        _isAnalyzing = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisResultScreen(
            title: localization.translate('palm_reading_title'),
            analysis: analysis.analysis,
            confidence: analysis.confidence,
            details: analysis.lines,
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error analyzing palm: $e');
      }
      if (!mounted) return;
      
      setState(() {
        _isAnalyzing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.read<LocalizationService>().translate('error_occurred')}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('palm_reading_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.back_hand,
                          size: 100,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localization.translate('palm_reading_title'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localization.translate('palm_reading_desc'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _PalmGuideSection(localization: localization),
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

class _PalmGuideSection extends StatelessWidget {
  final LocalizationService localization;
  
  const _PalmGuideSection({required this.localization});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('palm_guide'),
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
          icon: Icons.back_hand,
          title: localization.translate('open_palm'),
          description: localization.translate('open_palm_desc'),
        ),
        _GuideItem(
          icon: Icons.crop_free,
          title: localization.translate('close_distance'),
          description: localization.translate('close_distance_desc'),
        ),
        _GuideItem(
          icon: Icons.straighten,
          title: localization.translate('clear_lines'),
          description: localization.translate('clear_lines_desc'),
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
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
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
