import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource productDataSource;

  ProductRepositoryImpl(this.productDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await productDataSource.getProducts();
      return Right(products);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String productId) async {
    try {
      final product = await productDataSource.getProductById(productId);
      return Right(product);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Product>> addProduct(
    Product product,
    File? imageFile,
  ) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final addedProduct = await productDataSource.addProduct(
        productModel,
        imageFile,
      );
      return Right(addedProduct);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
    Product product,
    File? imageFile,
  ) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      await productDataSource.updateProduct(productModel, imageFile);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await productDataSource.deleteProduct(productId);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getFarmerProducts(
    String farmerId,
  ) async {
    try {
      final products = await productDataSource.getFarmerProducts(farmerId);
      return Right(products);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
