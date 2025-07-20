import 'package:dartz/dartz.dart';
import 'dart:io';
import '../entities/product.dart';
import '../../core/errors/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String productId);
  Future<Either<Failure, Product>> addProduct(Product product, File? imageFile);
  Future<Either<Failure, void>> updateProduct(Product product, File? imageFile);
  Future<Either<Failure, void>> deleteProduct(String productId);
  Future<Either<Failure, List<Product>>> getFarmerProducts(String farmerId);
}
