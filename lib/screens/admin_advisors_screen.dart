import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AdminAdvisorsScreen extends StatefulWidget {
  const AdminAdvisorsScreen({super.key});

  @override
  State<AdminAdvisorsScreen> createState() => _AdminAdvisorsScreenState();
}

class _AdminAdvisorsScreenState extends State<AdminAdvisorsScreen> {
  List<Map<String, dynamic>> _advisors = [];

  @override
  void initState() {
    super.initState();
    _loadAdvisors();
  }

  void _loadAdvisors() {
    setState(() {
      _advisors = StorageService.getAdvisors();
    });
  }

  Future<void> _addAdvisor() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const _AdvisorDialog(),
    );

    if (result != null) {
      final newAdvisor = {
        'name': result['name']!,
        'specialization': result['specialization']!,
        'experience': result['experience']!,
        'image': result['image'] ?? 'https://via.placeholder.com/150',
      };
      
      final updatedAdvisors = [..._advisors, newAdvisor];
      await StorageService.saveAdvisors(updatedAdvisors);
      _loadAdvisors();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상담사가 추가되었습니다')),
        );
      }
    }
  }

  Future<void> _editAdvisor(int index) async {
    final advisor = _advisors[index];
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AdvisorDialog(
        initialName: advisor['name'] as String?,
        initialSpecialization: advisor['specialization'] as String?,
        initialExperience: advisor['experience'] as String?,
        initialImage: advisor['image'] as String?,
      ),
    );

    if (result != null) {
      final updatedAdvisors = [..._advisors];
      updatedAdvisors[index] = {
        'name': result['name']!,
        'specialization': result['specialization']!,
        'experience': result['experience']!,
        'image': result['image'] ?? advisor['image'],
      };
      
      await StorageService.saveAdvisors(updatedAdvisors);
      _loadAdvisors();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상담사 정보가 수정되었습니다')),
        );
      }
    }
  }

  Future<void> _deleteAdvisor(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('상담사 삭제'),
        content: const Text('정말로 이 상담사를 삭제하시겠습니까?'),
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
      final updatedAdvisors = [..._advisors];
      updatedAdvisors.removeAt(index);
      await StorageService.saveAdvisors(updatedAdvisors);
      _loadAdvisors();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상담사가 삭제되었습니다')),
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상담사 관리',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '상담사 추가, 교체, 삭제',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addAdvisor,
                  icon: const Icon(Icons.add),
                  label: const Text('상담사 추가'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF11998E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // 상담사 목록
          Expanded(
            child: _advisors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.support_agent, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          '등록된 상담사가 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _addAdvisor,
                          icon: const Icon(Icons.add),
                          label: const Text('상담사 추가하기'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _advisors.length,
                    itemBuilder: (context, index) {
                      final advisor = _advisors[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      advisor['image'] as String? ?? 'https://via.placeholder.com/150',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          advisor['name'] as String? ?? '이름 없음',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          advisor['specialization'] as String? ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '경력: ${advisor['experience'] ?? '-'}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _editAdvisor(index),
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text('편집'),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _deleteAdvisor(index),
                                    icon: const Icon(Icons.delete, size: 18),
                                    label: const Text('삭제'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AdvisorDialog extends StatefulWidget {
  final String? initialName;
  final String? initialSpecialization;
  final String? initialExperience;
  final String? initialImage;

  const _AdvisorDialog({
    this.initialName,
    this.initialSpecialization,
    this.initialExperience,
    this.initialImage,
  });

  @override
  State<_AdvisorDialog> createState() => _AdvisorDialogState();
}

class _AdvisorDialogState extends State<_AdvisorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _specializationController;
  late final TextEditingController _experienceController;
  late final TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _specializationController = TextEditingController(text: widget.initialSpecialization);
    _experienceController = TextEditingController(text: widget.initialExperience);
    _imageController = TextEditingController(text: widget.initialImage);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? '상담사 추가' : '상담사 편집'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(
                  labelText: '전문 분야',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전문 분야를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: '경력',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '경력을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: '이미지 URL (선택)',
                  border: OutlineInputBorder(),
                ),
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
                'name': _nameController.text.trim(),
                'specialization': _specializationController.text.trim(),
                'experience': _experienceController.text.trim(),
                'image': _imageController.text.trim(),
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF11998E),
            foregroundColor: Colors.white,
          ),
          child: const Text('저장'),
        ),
      ],
    );
  }
}
