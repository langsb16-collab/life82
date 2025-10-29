import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'all';
  
  // 실제 판매 상품 목록
  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 'talisman_1',
      'category': 'talisman',
      'nameKo': '행운의 부적',
      'nameEn': 'Lucky Talisman',
      'nameZh': '幸运符',
      'nameJa': '幸運のお守り',
      'nameVi': 'Bùa may mắn',
      'nameAr': 'تعويذة الحظ',
      'price': 15000,
      'rating': 4.8,
      'reviewCount': 127,
      'icon': Icons.auto_awesome,
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
    },
    {
      'id': 'talisman_2',
      'category': 'talisman',
      'nameKo': '재물운 부적',
      'nameEn': 'Wealth Talisman',
      'nameZh': '财运符',
      'nameJa': '金運のお守り',
      'nameVi': 'Bùa tài lộc',
      'nameAr': 'تعويذة الثروة',
      'price': 20000,
      'rating': 4.9,
      'reviewCount': 93,
      'icon': Icons.attach_money,
      'gradient': [Color(0xFF11998E), Color(0xFF38EF7D)],
    },
    {
      'id': 'accessory_1',
      'category': 'accessory',
      'nameKo': '애정운 팔찌',
      'nameEn': 'Love Bracelet',
      'nameZh': '爱情手链',
      'nameJa': '恋愛運ブレスレット',
      'nameVi': 'Vòng tay tình yêu',
      'nameAr': 'سوار الحب',
      'price': 18000,
      'rating': 4.7,
      'reviewCount': 156,
      'icon': Icons.favorite,
      'gradient': [Color(0xFFFF6B95), Color(0xFFA855F7)],
    },
    {
      'id': 'accessory_2',
      'category': 'accessory',
      'nameKo': '건강운 목걸이',
      'nameEn': 'Health Necklace',
      'nameZh': '健康项链',
      'nameJa': '健康運ネックレス',
      'nameVi': 'Dây chuyền sức khỏe',
      'nameAr': 'قلادة الصحة',
      'price': 17000,
      'rating': 4.6,
      'reviewCount': 84,
      'icon': Icons.favorite_border,
      'gradient': [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
    {
      'id': 'service_1',
      'category': 'service',
      'nameKo': '프리미엄 사주 풀이',
      'nameEn': 'Premium Saju Reading',
      'nameZh': '高级八字解析',
      'nameJa': 'プレミアム四柱推命',
      'nameVi': 'Xem Tứ Trụ cao cấp',
      'nameAr': 'قراءة ساجو المتميزة',
      'price': 50000,
      'rating': 4.9,
      'reviewCount': 215,
      'icon': Icons.auto_stories,
      'gradient': [Color(0xFFFF8008), Color(0xFFFFC837)],
    },
    {
      'id': 'service_2',
      'category': 'service',
      'nameKo': '종합 운세 분석',
      'nameEn': 'Complete Fortune Analysis',
      'nameZh': '综合运势分析',
      'nameJa': '総合運勢分析',
      'nameVi': 'Phân tích vận mệnh toàn diện',
      'nameAr': 'تحليل الحظ الشامل',
      'price': 80000,
      'rating': 5.0,
      'reviewCount': 342,
      'icon': Icons.insights,
      'gradient': [Color(0xFF9D50BB), Color(0xFF6E48AA)],
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'all') return _allProducts;
    return _allProducts.where((p) => p['category'] == _selectedCategory).toList();
  }

  String _getProductName(Map<String, dynamic> product, String languageCode) {
    switch (languageCode) {
      case 'ko': return product['nameKo'];
      case 'en': return product['nameEn'];
      case 'zh': return product['nameZh'];
      case 'ja': return product['nameJa'];
      case 'vi': return product['nameVi'];
      case 'ar': return product['nameAr'];
      default: return product['nameKo'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('shop')),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localization.translate('cart_feature_coming')),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCategoryFilter(localization),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return _buildProductCard(context, product, localization);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(LocalizationService localization) {
    final categories = [
      {'id': 'all', 'labelKey': 'category_all'},
      {'id': 'talisman', 'labelKey': 'category_talisman'},
      {'id': 'accessory', 'labelKey': 'category_accessory'},
      {'id': 'service', 'labelKey': 'category_service'},
    ];
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(localization.translate(category['labelKey']!)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category['id']!;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product, LocalizationService localization) {
    final gradient = product['gradient'] as List<Color>;
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showProductDetail(context, product, localization),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                ),
                child: Center(
                  child: Icon(
                    product['icon'] as IconData,
                    size: 60,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getProductName(product, localization.currentLanguage),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₩${product['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${product['rating']} (${product['reviewCount']})',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, Map<String, dynamic> product, LocalizationService localization) {
    final gradient = product['gradient'] as List<Color>;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization.translate('product_detail'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        product['icon'] as IconData,
                        size: 100,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getProductName(product, localization.currentLanguage),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₩${product['price']}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${product['rating']} (${product['reviewCount']} ${localization.translate('reviews')})',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    localization.translate('product_description'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.translate('product_desc_${product['category']}'),
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${_getProductName(product, localization.currentLanguage)} ${localization.translate('added_to_cart')}'
                          ),
                          action: SnackBarAction(
                            label: localization.translate('view_cart'),
                            onPressed: () {
                              // TODO: 장바구니 화면으로 이동
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: Text(localization.translate('add_to_cart')),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
