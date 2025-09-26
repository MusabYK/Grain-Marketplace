import 'package:flutter/material.dart';
import 'dart:io';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/product/get_all_products.dart';
import '../../../domain/usecases/product/post_product.dart';
import '../../../domain/usecases/product/get_farmer_products.dart';
import '../../../domain/usecases/product/update_product.dart'; // Import new use case
import '../../../domain/usecases/product/delete_product.dart'; // Import new use case
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/product_datasource.dart';
import 'package:uuid/uuid.dart';

class FarmerDashboardProvider with ChangeNotifier {
  List<Product> _farmerProducts = [];
  List<Product> _allProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  final GetAllProducts _getAllProducts;
  final PostProduct _postProduct;
  final GetFarmerProducts _getFarmerProducts;
  final UpdateProduct _updateProduct; // Declare the new use case
  final DeleteProduct _deleteProduct; // Declare the new use case

  FarmerDashboardProvider({
    GetAllProducts? getAllProducts,
    PostProduct? postProduct,
    GetFarmerProducts? getFarmerProducts,
    UpdateProduct? updateProduct,
    DeleteProduct? deleteProduct,
  }) : _getAllProducts =
           getAllProducts ??
           GetAllProducts(ProductRepositoryImpl(ProductDataSourceImpl())),
       _postProduct =
           postProduct ??
           PostProduct(ProductRepositoryImpl(ProductDataSourceImpl())),
       _getFarmerProducts =
           getFarmerProducts ??
           GetFarmerProducts(ProductRepositoryImpl(ProductDataSourceImpl())),
       _updateProduct =
           updateProduct ??
           UpdateProduct(ProductRepositoryImpl(ProductDataSourceImpl())),
       _deleteProduct =
           deleteProduct ??
           DeleteProduct(ProductRepositoryImpl(ProductDataSourceImpl()));

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
    String? phone,
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
      phone: phone,
      postedDate: DateTime.now(),
      location: location,
      status: 'available',
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
        fetchFarmerProducts(farmerId);
        return true;
      },
    );
  }

  /// Updates an existing product.
  Future<bool> updateProduct(Product updatedProduct, File? imageFile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _updateProduct.call(updatedProduct, imageFile);
    _isLoading = false;
    notifyListeners();

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        return false;
      },
      (_) {
        // Find the index of the updated product and replace it
        final index = _farmerProducts.indexWhere(
          (p) => p.id == updatedProduct.id,
        );
        if (index != -1) {
          _farmerProducts[index] = updatedProduct;
        }
        notifyListeners();
        return true;
      },
    );
  }

  /// Deletes a product by its ID.
  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _deleteProduct.call(productId);
    _isLoading = false;
    notifyListeners();

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        return false;
      },
      (_) {
        // Remove the deleted product from the list
        _farmerProducts.removeWhere((p) => p.id == productId);
        notifyListeners();
        return true;
      },
    );
  }
}
