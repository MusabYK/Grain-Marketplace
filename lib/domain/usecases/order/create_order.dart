import 'package:dartz/dartz.dart' hide Order;
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';
import '../../../core/errors/failures.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<Either<Failure, Order>> call(Order order) {
    return repository.createOrder(order);
  }
}
