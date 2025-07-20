import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double pricePerUnit;
  final String unit; // e.g., 'kg', 'ton'
  final double quantityAvailable;
  final String farmerId;
  final String? imageUrl;
  final DateTime postedDate;
  final String? location;
  final String? status; // e.g., 'available', 'sold', 'negotiating'

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerUnit,
    required this.unit,
    required this.quantityAvailable,
    required this.farmerId,
    this.imageUrl,
    required this.postedDate,
    this.location,
    this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    pricePerUnit,
    unit,
    quantityAvailable,
    farmerId,
    imageUrl,
    postedDate,
    location,
    status,
  ];

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? pricePerUnit,
    String? unit,
    double? quantityAvailable,
    String? farmerId,
    String? imageUrl,
    DateTime? postedDate,
    String? location,
    String? status,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      unit: unit ?? this.unit,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      farmerId: farmerId ?? this.farmerId,
      imageUrl: imageUrl ?? this.imageUrl,
      postedDate: postedDate ?? this.postedDate,
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }
}
