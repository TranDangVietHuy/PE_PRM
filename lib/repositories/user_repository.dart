import '../models/user.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();

  Future<void> addUser(UserModel user);

  Future<void> updateUser(UserModel user);

  Future<void> deleteUser(int id);
}
