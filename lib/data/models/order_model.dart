import '../../domain/entities/order.dart'; // Import the domain entity

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.productId,
    required super.buyerId,
    required super.farmerId,
    required super.quantity,
    required super.price,
    required super.orderDate,
    super.status, // e.g., 'pending', 'confirmed', 'shipped', 'delivered', 'cancelled'
    super.deliveryAddress,
    super.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      productId: json['productId'],
      buyerId: json['buyerId'],
      farmerId: json['farmerId'],
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
      deliveryAddress: json['deliveryAddress'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'buyerId': buyerId,
      'farmerId': farmerId,
      'quantity': quantity,
      'price': price,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
    };
  }

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      productId: order.productId,
      buyerId: order.buyerId,
      farmerId: order.farmerId,
      quantity: order.quantity,
      price: order.price,
      orderDate: order.orderDate,
      status: order.status,
      deliveryAddress: order.deliveryAddress,
      notes: order.notes,
    );
  }
}
