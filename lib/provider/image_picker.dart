import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ImagePickerProvider extends ChangeNotifier {
  DateTime? _warrantyStartDate;

  DateTime? get warrantyStartDate => _warrantyStartDate;
  final ImagePicker _picker = ImagePicker();
  File? _receiptImage; // For receipt image

  File? get receiptImage => _receiptImage;
  File? _selectedImage;
  List<File?> _selectedImages = [null, null, null];

  File? get selectedImage => _selectedImage;
  List<File?> get selectedImages => _selectedImages;

  void updateSelectedImage(File image) {
    _selectedImage = image;
    notifyListeners();
  }

  Future<void> pickImageFromCamera() async {
    final imgXFile = await _picker.pickImage(source: ImageSource.camera);
    if (imgXFile != null) {
      _selectedImage = File(imgXFile.path);
    }

    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    final imgXFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imgXFile != null) {
      _selectedImage = File(imgXFile.path);
    }

    notifyListeners();
  }

  void reset() {
    _selectedImage = null;
    _selectedImages = [];
    notifyListeners();
  }

  void resetreceipt() {
    _receiptImage = null;

    notifyListeners();
  }

  void updateReceiptImage(File image) {
    _receiptImage = image;
    notifyListeners();
  }

  // Existing methods for picking images...

  Future<void> pickReceiptImageFromCamera() async {
    final imgXFile = await _picker.pickImage(source: ImageSource.camera);
    if (imgXFile != null) {
      _receiptImage = File(imgXFile.path);
    }

    notifyListeners();
  }

  Future<void> pickReceiptImageFromGallery() async {
    final imgXFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imgXFile != null) {
      _receiptImage = File(imgXFile.path);
    }

    notifyListeners();
  }

  Future<void> selectdate(
      BuildContext context, TextEditingController dateController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _warrantyStartDate) {
      _warrantyStartDate = picked;
      dateController.text =
          DateFormat('yyyy-MM-dd').format(_warrantyStartDate!);
      notifyListeners(); // Notify listeners to rebuild UI with the new date
    }
  }
}
