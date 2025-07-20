import 'package:flutter/material.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/product/get_all_products.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/product_datasource.dart';

class BuyerDashboardProvider with ChangeNotifier {
  List<Product> _availableProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  final GetAllProducts _getAllProducts;

  BuyerDashboardProvider({GetAllProducts? getAllProducts})
    : _getAllProducts =
          getAllProducts ??
          GetAllProducts(ProductRepositoryImpl(ProductDataSourceImpl()));

  List<Product> get availableProducts => _availableProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAvailableProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getAllProducts.call();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (products) {
        _availableProducts = products
            .where((p) => p.status == 'available')
            .toList();
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  // Add methods for searching, filtering, placing orders, etc.
}
