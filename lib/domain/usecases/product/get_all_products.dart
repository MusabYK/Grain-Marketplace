import 'package:dartz/dartz.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';
import '../../../core/errors/failures.dart';

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getProducts();
  }
}
