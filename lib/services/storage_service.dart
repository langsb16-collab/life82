import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

class StorageService {
  static const String _userBox = 'user_box';
  static const String _analysisBox = 'analysis_box';
  static const String _productsBox = 'products_box';
  static const String _advisorsBox = 'advisors_box';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(_userBox);
    await Hive.openBox(_analysisBox);
    await Hive.openBox(_productsBox);
    await Hive.openBox(_advisorsBox);
  }

  // User data
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final box = Hive.box(_userBox);
    await box.put('current_user', jsonEncode(userData));
  }

  static Map<String, dynamic>? getUser() {
    final box = Hive.box(_userBox);
    final data = box.get('current_user');
    return data != null ? jsonDecode(data as String) as Map<String, dynamic> : null;
  }

  // Analysis data
  static Future<void> saveAnalysis(String type, Map<String, dynamic> data) async {
    final box = Hive.box(_analysisBox);
    final key = '${type}_${DateTime.now().millisecondsSinceEpoch}';
    await box.put(key, jsonEncode(data));
  }

  static List<Map<String, dynamic>> getAnalysisByType(String type) {
    final box = Hive.box(_analysisBox);
    final results = <Map<String, dynamic>>[];
    
    for (var key in box.keys) {
      if (key.toString().startsWith(type)) {
        final data = box.get(key);
        if (data != null) {
          results.add(jsonDecode(data as String) as Map<String, dynamic>);
        }
      }
    }
    
    return results;
  }

  static Map<String, dynamic>? getLatestAnalysis(String type) {
    final analyses = getAnalysisByType(type);
    return analyses.isNotEmpty ? analyses.last : null;
  }

  // Products
  static Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    final box = Hive.box(_productsBox);
    await box.put('products', jsonEncode(products));
  }

  static List<Map<String, dynamic>> getProducts() {
    final box = Hive.box(_productsBox);
    final data = box.get('products');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data as String) as List;
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Advisors
  static Future<void> saveAdvisors(List<Map<String, dynamic>> advisors) async {
    final box = Hive.box(_advisorsBox);
    await box.put('advisors', jsonEncode(advisors));
  }

  static List<Map<String, dynamic>> getAdvisors() {
    final box = Hive.box(_advisorsBox);
    final data = box.get('advisors');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data as String) as List;
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Clear all data
  static Future<void> clearAll() async {
    await Hive.box(_userBox).clear();
    await Hive.box(_analysisBox).clear();
    await Hive.box(_productsBox).clear();
    await Hive.box(_advisorsBox).clear();
  }
}
