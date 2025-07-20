import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';
import '../../../core/errors/failures.dart';

class PostProduct {
  final ProductRepository repository;

  PostProduct(this.repository);

  Future<Either<Failure, Product>> call(Product product, File? imageFile) {
    return repository.addProduct(product, imageFile);
  }
}
