import 'package:dartz/dartz.dart' hide Order;
import '../entities/order.dart';
import '../../core/errors/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(Order order);
  Future<Either<Failure, List<Order>>> getOrdersForUser(
    String userId,
    String userType,
  );
  Future<Either<Failure, Order>> getOrderById(String orderId);
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    String status,
  );
}
