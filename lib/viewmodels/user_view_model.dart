import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user.dart';
import '../repositories/in_memory_user_repository.dart';
import '../repositories/user_repository.dart';

part 'user_view_model.g.dart';

class UserState {
  final List<UserModel> items;
  final bool isLoading;

  const UserState({
    this.items = const <UserModel>[],
    this.isLoading = false,
  });

  UserState copyWith({
    List<UserModel>? items,
    bool? isLoading,
  }) {
    return UserState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class UserViewModel extends _$UserViewModel {
  @override
  UserState build() {
    loadUsers();
    return const UserState(isLoading: true);
  }

  UserRepository get repository => ref.read(userRepositoryProvider);

  Future<void> loadUsers() async {
    final users = await repository.getUsers();
    state = UserState(
      items: users,
      isLoading: false,
    );
  }

  Future<void> addUser({
    required String fullName,
    required String email,
    required String avatar,
  }) async {
    // TODO:
    // 1. Tính id mới = danh sách rỗng ? 1 : max(id hiện có) + 1.
    // 2. Tạo UserModel mới.
    // 3. Gọi repository.addUser.
    // 4. Cập nhật state để UI render lại.

    final users = state.items;
    int newId = 1;

    if (users.isNotEmpty) {
      int maxId = users.first.id;

      for (final user in users) {
        if (user.id > maxId) {
          maxId = user.id;
        }
      }

      newId = maxId + 1;
    }

    final newUser =
        UserModel(id: newId, fullName: fullName, email: email, avatar: avatar);

    await repository.addUser(newUser);

    state = UserState(
      items: <UserModel>[...state.items, newUser],
      isLoading: false,
    );
  }

  Future<void> updateUser(UserModel user) async {
    await repository.updateUser(user);

    final updatedUsers = List<UserModel>.from(state.items);
    final index = updatedUsers.indexWhere((item) => item.id == user.id);

    if (index != -1) {
      updatedUsers[index] = user;
      state = UserState(
        items: updatedUsers,
        isLoading: false,
      );
    }
  }

  Future<void> deleteUser(int id) async {
    await repository.deleteUser(id);

    final updatedUsers = state.items.where((user) => user.id != id).toList();

    state = UserState(
      items: updatedUsers,
      isLoading: false,
    );
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return InMemoryUserRepository();
}
