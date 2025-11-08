import 'package:lab_3/domain/user.dart';

abstract class AuthRepository {

  Future<void> register(User user);

  Future<User> login(String email, String password);

  Future<void> logout();

  Future<User?> current();

  Future<User> update(User user);
}
