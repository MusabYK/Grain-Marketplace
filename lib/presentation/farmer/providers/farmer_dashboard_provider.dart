import 'package:flutter/material.dart';
import 'dart:io';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/product/get_all_products.dart';
import '../../../domain/usecases/product/post_product.dart';
import '../../../domain/usecases/product/get_farmer_products.dart'; // New use case
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/product_datasource.dart';
import 'package:uuid/uuid.dart'; // Add uuid package for unique IDs

class FarmerDashboardProvider with ChangeNotifier {
  List<Product> _farmerProducts = [];
  List<Product> _allProducts =
      []; // For market information dissemination [cite: 26]
  bool _isLoading = false;
  String? _errorMessage;

  final GetAllProducts _getAllProducts;
  final PostProduct _postProduct;
  final GetFarmerProducts _getFarmerProducts;

  FarmerDashboardProvider({
    GetAllProducts? getAllProducts,
    PostProduct? postProduct,
    GetFarmerProducts? getFarmerProducts,
  }) : _getAllProducts =
           getAllProducts ??
           GetAllProducts(ProductRepositoryImpl(ProductDataSourceImpl())),
       _postProduct =
           postProduct ??
           PostProduct(ProductRepositoryImpl(ProductDataSourceImpl())),
       _getFarmerProducts =
           getFarmerProducts ??
           GetFarmerProducts(ProductRepositoryImpl(ProductDataSourceImpl()));

  List<Product> get farmerProducts => _farmerProducts;
  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFarmerProducts(String farmerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getFarmerProducts.call(farmerId);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (products) {
        _farmerProducts = products;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getAllProducts.call();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (products) {
        _allProducts = products;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createProduct({
    required String name,
    required String description,
    required double pricePerUnit,
    required String unit,
    required double quantityAvailable,
    required String farmerId,
    File? imageFile,
    String? location,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const uuid = Uuid();
    final newProductId = uuid.v4();

    final product = Product(
      id: newProductId,
      name: name,
      description: description,
      pricePerUnit: pricePerUnit,
      unit: unit,
      quantityAvailable: quantityAvailable,
      farmerId: farmerId,
      postedDate: DateTime.now(),
      location: location,
      status: 'available', // Default status
    );

    final result = await _postProduct.call(product, imageFile);
    _isLoading = false;
    notifyListeners();

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        return false;
      },
      (product) {
        // Optionally refresh farmer's products or add to list
        fetchFarmerProducts(farmerId); // Refresh after adding
        return true;
      },
    );
  }

  // Add methods for updateProduct, deleteProduct, etc.
}
