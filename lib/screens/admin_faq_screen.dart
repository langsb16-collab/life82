import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AdminFaqScreen extends StatefulWidget {
  const AdminFaqScreen({super.key});

  @override
  State<AdminFaqScreen> createState() => _AdminFaqScreenState();
}

class _AdminFaqScreenState extends State<AdminFaqScreen> {
  List<Map<String, dynamic>> _faqs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final faqsJson = prefs.getString('admin_faqs');
    
    if (faqsJson != null) {
      final List<dynamic> decoded = jsonDecode(faqsJson);
      setState(() {
        _faqs = decoded.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } else {
      // 기본 FAQ 데이터 (현재 하드코딩된 15개)
      setState(() {
        _faqs = _getDefaultFaqs();
        _isLoading = false;
      });
      await _saveFaqs();
    }
  }

  Future<void> _saveFaqs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_faqs', jsonEncode(_faqs));
  }

  List<Map<String, dynamic>> _getDefaultFaqs() {
    return [
      {
        'question_ko': '어떤 분석 기능을 제공하나요?',
        'answer_ko': 'AI 기반 얼굴 관상, 손금 분석, 사주팔자, 타로 카드 리딩 서비스를 제공합니다. 각 분석은 전문 알고리즘으로 처리되어 상세한 결과를 제공합니다.',
        'question_en': 'What analysis features do you offer?',
        'answer_en': 'We provide AI-based face reading, palm reading, Saju (Four Pillars), and Tarot card reading services.',
        'question_zh': '提供哪些分析功能？',
        'answer_zh': '我们提供基于AI的面相分析、手相分析、四柱命理和塔罗牌解读服务。',
        'question_ja': 'どんな分析機能がありますか？',
        'answer_ja': 'AI基盤の人相分析、手相分析、四柱推命、タロットカード占いサービスを提供しています。',
      },
      {
        'question_ko': '프리미엄 서비스는 무엇인가요?',
        'answer_ko': '월 단위 프리미엄 보고서, 할인 혜택, 우선 상담, 알림 서비스 등 다양한 혜택을 제공합니다.',
        'question_en': 'What is the premium service?',
        'answer_en': 'Monthly premium reports, discounts, priority consultation, and notification services.',
        'question_zh': '高级服务是什么？',
        'answer_zh': '提供月度高级报告、折扣优惠、优先咨询和通知服务等各种福利。',
        'question_ja': 'プレミアムサービスとは？',
        'answer_ja': '月間プレミアムレポート、割引特典、優先相談、通知サービスなど様々な特典を提供します。',
      },
      {
        'question_ko': '데이터는 안전하게 보관되나요?',
        'answer_ko': '업로드된 사진은 암호화되어 저장되며, 분석 후 30-90일 이내 자동 삭제됩니다.',
        'question_en': 'Is my data stored securely?',
        'answer_en': 'Uploaded photos are encrypted and automatically deleted within 30-90 days after analysis.',
        'question_zh': '数据安全保管吗？',
        'answer_zh': '上传的照片经过加密存储，分析后30-90天内自动删除。',
        'question_ja': 'データは安全に保管されますか？',
        'answer_ja': 'アップロードされた写真は暗号化されて保存され、分析後30-90日以内に自動削除されます。',
      },
    ];
  }

  Future<void> _addFaq() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const _FaqDialog(),
    );

    if (result != null) {
      setState(() {
        _faqs.add(result);
      });
      await _saveFaqs();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('FAQ가 추가되었습니다')),
        );
      }
    }
  }

  Future<void> _editFaq(int index) async {
    final faq = _faqs[index];
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _FaqDialog(initialData: faq),
    );

    if (result != null) {
      setState(() {
        _faqs[index] = result;
      });
      await _saveFaqs();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('FAQ가 수정되었습니다')),
        );
      }
    }
  }

  Future<void> _deleteFaq(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FAQ 삭제'),
        content: const Text('정말로 이 FAQ를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _faqs.removeAt(index);
      });
      await _saveFaqs();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('FAQ가 삭제되었습니다')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FAQ 관리',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '자동응답봇 질문/답변 추가, 편집, 삭제 (총 ${_faqs.length}개)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addFaq,
                  icon: const Icon(Icons.add),
                  label: const Text('FAQ 추가'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // FAQ 목록
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _faqs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              '등록된 FAQ가 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _addFaq,
                              icon: const Icon(Icons.add),
                              label: const Text('FAQ 추가하기'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _faqs.length,
                        itemBuilder: (context, index) {
                          final faq = _faqs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ExpansionTile(
                              title: Text(
                                faq['question_ko'] ?? '질문 없음',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    '영어: ${faq['question_en'] ?? '-'}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    onPressed: () => _editFaq(index),
                                    tooltip: '편집',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    color: Colors.red,
                                    onPressed: () => _deleteFaq(index),
                                    tooltip: '삭제',
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildAnswerSection('한국어 답변', faq['answer_ko']),
                                      const Divider(),
                                      _buildAnswerSection('영어 답변', faq['answer_en']),
                                      const Divider(),
                                      _buildAnswerSection('중국어 답변', faq['answer_zh']),
                                      const Divider(),
                                      _buildAnswerSection('일본어 답변', faq['answer_ja']),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection(String label, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content ?? '-',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _FaqDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const _FaqDialog({this.initialData});

  @override
  State<_FaqDialog> createState() => _FaqDialogState();
}

class _FaqDialogState extends State<_FaqDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionKoController;
  late final TextEditingController _answerKoController;
  late final TextEditingController _questionEnController;
  late final TextEditingController _answerEnController;
  late final TextEditingController _questionZhController;
  late final TextEditingController _answerZhController;
  late final TextEditingController _questionJaController;
  late final TextEditingController _answerJaController;

  @override
  void initState() {
    super.initState();
    _questionKoController = TextEditingController(text: widget.initialData?['question_ko']);
    _answerKoController = TextEditingController(text: widget.initialData?['answer_ko']);
    _questionEnController = TextEditingController(text: widget.initialData?['question_en']);
    _answerEnController = TextEditingController(text: widget.initialData?['answer_en']);
    _questionZhController = TextEditingController(text: widget.initialData?['question_zh']);
    _answerZhController = TextEditingController(text: widget.initialData?['answer_zh']);
    _questionJaController = TextEditingController(text: widget.initialData?['question_ja']);
    _answerJaController = TextEditingController(text: widget.initialData?['answer_ja']);
  }

  @override
  void dispose() {
    _questionKoController.dispose();
    _answerKoController.dispose();
    _questionEnController.dispose();
    _answerEnController.dispose();
    _questionZhController.dispose();
    _answerZhController.dispose();
    _questionJaController.dispose();
    _answerJaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialData == null ? 'FAQ 추가' : 'FAQ 편집'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('한국어', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionKoController,
                decoration: const InputDecoration(
                  labelText: '질문',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? '질문을 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _answerKoController,
                decoration: const InputDecoration(
                  labelText: '답변',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? '답변을 입력하세요' : null,
              ),
              
              const SizedBox(height: 24),
              const Text('English', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionEnController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _answerEnController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 24),
              const Text('中文', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionZhController,
                decoration: const InputDecoration(
                  labelText: '问题',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _answerZhController,
                decoration: const InputDecoration(
                  labelText: '答案',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 24),
              const Text('日本語', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionJaController,
                decoration: const InputDecoration(
                  labelText: '質問',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _answerJaController,
                decoration: const InputDecoration(
                  labelText: '回答',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'question_ko': _questionKoController.text.trim(),
                'answer_ko': _answerKoController.text.trim(),
                'question_en': _questionEnController.text.trim(),
                'answer_en': _answerEnController.text.trim(),
                'question_zh': _questionZhController.text.trim(),
                'answer_zh': _answerZhController.text.trim(),
                'question_ja': _questionJaController.text.trim(),
                'answer_ja': _answerJaController.text.trim(),
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
            foregroundColor: Colors.white,
          ),
          child: const Text('저장'),
        ),
      ],
    );
  }
}
