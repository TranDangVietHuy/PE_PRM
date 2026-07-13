import '../models/user.dart';
import 'user_repository.dart';

class InMemoryUserRepository implements UserRepository {
  final List<UserModel> _users = <UserModel>[
    const UserModel(
      id: 1,
      fullName: 'Nguyễn Văn An',
      email: 'an.nguyen@gmail.com',
      avatar: 'assets/im1.jpg',
    ),
    const UserModel(
      id: 2,
      fullName: 'Trần Thị Bình',
      email: 'bình.tran@gmailcom',
      avatar: 'assets/im2.jpg',
    ),
    const UserModel(
      id: 3,
      fullName: 'Lê Minh Cường',
      email: 'cuong.le@gmail.com',
      avatar: 'assets/im3.jpg',
    ),
  ];

  @override
  Future<List<UserModel>> getUsers() async {
    // TODO: Trả về bản sao danh sách user trong bộ nhớ.
    return List<UserModel>.from(_users);
  }

  @override
  Future<void> addUser(UserModel user) async {
    // TODO: Thêm user vào _users.
    _users.add(user);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    // TODO: Tìm user cùng id và cập nhật thông tin.
    final index = _users.indexWhere((item) => item.id == user.id);

  if (index != -1) {
    _users[index] = user;
  }
  }

  @override
  Future<void> deleteUser(int id) async {
    // TODO: Xoá user theo id.
    _users.removeWhere((user) => user.id == id);
  }
}
