import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, User>> call(
    String email,
    String password,
    String userType,
    String name,
    String phone,
  ) {
    return repository.registerWithEmailAndPassword(
      email,
      password,
      userType,
      name,
      phone,
    );
  }
}
