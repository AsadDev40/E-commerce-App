import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  String? _selectedValue;
  String? _selectedCondition;
  final List<CategoryModel> _categories = [];

  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  CategoryProvider() {
    fetchCategories();
  }

  List<CategoryModel> get categories => _categories;

  List<String> get categoryNames =>
      _categories.map((category) => category.categoryName).toList();

  String? get selectedValue => _selectedValue;

  String? get selectedCondition => _selectedCondition;

  void updateSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  void updateConditionValue(String value) {
    _selectedCondition = value;
    notifyListeners();
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final querySnapshot = await categoryCollection.get();
    _categories.clear();
    for (var doc in querySnapshot.docs) {
      _categories
          .add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
    }
    notifyListeners();
    return _categories;
  }

  Future<void> addCategory(CategoryModel category) async {
    DocumentReference docRef = await categoryCollection.add(category.toJson());
    String categoryId = docRef.id;
    await categoryCollection.doc(categoryId).update({'categoryid': categoryId});
    fetchCategories();
  }

  Future<void> updateCategory(CategoryModel category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .update(category.toJson());
      fetchCategories();
    } catch (e) {
      rethrow;
    }
  }

  // Method to delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await categoryCollection.doc(categoryId).delete();
      _categories.removeWhere((category) => category.categoryId == categoryId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> fetchCategoriesByType(String type) async {
    final querySnapshot =
        await categoryCollection.where('type', isEqualTo: type).get();
    List<CategoryModel> filteredCategories = [];
    for (var doc in querySnapshot.docs) {
      filteredCategories
          .add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
    }
    return filteredCategories;
  }
}
