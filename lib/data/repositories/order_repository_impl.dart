import 'package:dartz/dartz.dart' hide Order;
import '../../core/errors/failures.dart';
import '../../domain/entities/order.dart'; // Import domain entity
import '../../domain/repositories/order_repository.dart'; // Import abstract repository
import '../datasources/order_datasource.dart';
import '../models/order_model.dart'; // Import data model

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource orderDataSource;

  OrderRepositoryImpl(this.orderDataSource);

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      final createdOrder = await orderDataSource.createOrder(orderModel);
      return Right(createdOrder);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getOrdersForUser(
    String userId,
    String userType,
  ) async {
    try {
      final orders = await orderDataSource.getOrdersForUser(userId, userType);
      return Right(orders);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final order = await orderDataSource.getOrderById(orderId);
      return Right(order);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      await orderDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
