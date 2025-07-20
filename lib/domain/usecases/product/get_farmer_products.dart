import 'package:dartz/dartz.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';
import '../../../core/errors/failures.dart';

class GetFarmerProducts {
  final ProductRepository repository;

  GetFarmerProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(String farmerId) {
    return repository.getFarmerProducts(farmerId);
  }
}
