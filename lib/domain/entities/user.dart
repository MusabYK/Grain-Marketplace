import 'package:equatable/equatable.dart'; // Add equatable package for value equality

class User extends Equatable {
  final String uid;
  final String email;
  final String userType; // 'farmer' or 'buyer'
  final String? name;
  final String? phone;
  final String? location;

  const User({
    required this.uid,
    required this.email,
    required this.userType,
    this.name,
    this.phone,
    this.location,
  });

  @override
  List<Object?> get props => [uid, email, userType, name, phone, location];

  User copyWith({
    String? uid,
    String? email,
    String? userType,
    String? name,
    String? phone,
    String? location,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location ?? this.location,
    );
  }
}
