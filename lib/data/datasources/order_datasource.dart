import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/failures.dart';
import '../models/order_model.dart';
import '../../core/constants/app_constants.dart';

abstract class OrderDataSource {
  Future<OrderModel> createOrder(OrderModel order);
  Future<List<OrderModel>> getOrdersForUser(
    String userId,
    String userType,
  ); // userType: 'buyer' or 'farmer'
  Future<OrderModel> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
}

class OrderDataSourceImpl implements OrderDataSource {
  final FirebaseFirestore _firestore;

  OrderDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(order.id)
          .set(order.toJson());
      return order;
    } catch (e) {
      throw ServerFailure('Failed to create order: $e');
    }
  }

  @override
  Future<List<OrderModel>> getOrdersForUser(
    String userId,
    String userType,
  ) async {
    try {
      QuerySnapshot querySnapshot;
      if (userType == 'buyer') {
        querySnapshot = await _firestore
            .collection(AppConstants.ordersCollection)
            .where('buyerId', isEqualTo: userId)
            .get();
      } else if (userType == 'farmer') {
        querySnapshot = await _firestore
            .collection(AppConstants.ordersCollection)
            .where('farmerId', isEqualTo: userId)
            .get();
      } else {
        throw ServerFailure('Invalid user type for fetching orders.');
      }
      return querySnapshot.docs
          .map(
            (doc) => OrderModel.fromJson(doc.data()! as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to fetch orders: $e');
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final docSnapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .get();
      if (!docSnapshot.exists) {
        throw ServerFailure('Order not found.');
      }
      return OrderModel.fromJson(docSnapshot.data()!);
    } catch (e) {
      throw ServerFailure('Failed to get order: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({'status': status});
    } catch (e) {
      throw ServerFailure('Failed to update order status: $e');
    }
  }
}
