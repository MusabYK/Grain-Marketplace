import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.email,
    required super.userType, // 'farmer', 'buyer'
    super.name,
    super.phone,
    super.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      userType: json['userType'],
      name: json['name'],
      phone: json['phone'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userType': userType,
      'name': name,
      'phone': phone,
      'location': location,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      userType: user.userType,
      name: user.name,
      phone: user.phone,
      location: user.location,
    );
  }
}
