import 'package:dartz/dartz.dart' hide Order;
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';
import '../../../core/errors/failures.dart';

class GetUserOrders {
  final OrderRepository repository;

  GetUserOrders(this.repository);

  Future<Either<Failure, List<Order>>> call(String userId, String userType) {
    return repository.getOrdersForUser(userId, userType);
  }
}
