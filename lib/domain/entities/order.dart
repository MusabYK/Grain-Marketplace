import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String id;
  final String productId;
  final String buyerId;
  final String farmerId;
  final double quantity;
  final double price; // Total price or price per unit at the time of order
  final DateTime orderDate;
  final String?
  status; // e.g., 'pending', 'confirmed', 'shipped', 'delivered', 'cancelled'
  final String? deliveryAddress;
  final String? notes;

  const Order({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.farmerId,
    required this.quantity,
    required this.price,
    required this.orderDate,
    this.status,
    this.deliveryAddress,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    buyerId,
    farmerId,
    quantity,
    price,
    orderDate,
    status,
    deliveryAddress,
    notes,
  ];

  Order copyWith({
    String? id,
    String? productId,
    String? buyerId,
    String? farmerId,
    double? quantity,
    double? price,
    DateTime? orderDate,
    String? status,
    String? deliveryAddress,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      buyerId: buyerId ?? this.buyerId,
      farmerId: farmerId ?? this.farmerId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
    );
  }
}
