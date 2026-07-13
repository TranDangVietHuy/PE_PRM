import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../viewmodels/user_view_model.dart';
import '../widgets/avatar_image.dart';
import 'user_detail_screen.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();

  UserModel? _editingUser;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Manager')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth >= constraints.maxHeight;

            // TODO: Landscape hiển thị form bên trái, danh sách 2 cột bên phải.
            // Portrait hiển thị form phía trên, danh sách 1 cột phía dưới.
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  _buildForm(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildUserList(
                      users: state.items,
                      isLandscape: isLandscape,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            key: const Key('input_fullname'),
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Họ và tên',
              hintText: 'Nhập họ và tên',
              border: OutlineInputBorder(),
            ),
            validator: _validateFullName,
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('input_email'),
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'example@gmail.com',
              border: OutlineInputBorder(),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('input_avatar'),
            controller: _avatarController,
            decoration: const InputDecoration(
              labelText: 'Avatar',
              hintText: defaultAvatarPath,
              border: OutlineInputBorder(),
            ),
            validator: _validateAvatar,
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  key: const Key('btn_add_user'),
                  onPressed: _handleSubmit,
                  child:
                      Text(_editingUser == null ? 'ADD USER' : 'UPDATE USER'),
                ),
              ),
              if (_editingUser != null) ...<Widget>[
                const SizedBox(width: 8),
                OutlinedButton(
                  key: const Key('btn_cancel_edit'),
                  onPressed: _cancelEdit,
                  child: const Text('CANCEL'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserList({
    required List<UserModel> users,
    required bool isLandscape,
  }) {
    // TODO: Portrait dùng 1 cột, landscape dùng 2 cột.
    // Lưu ý: kể cả users rỗng vẫn phải render widget Key('user_list').
    // Không thay bằng Center/Text riêng, vì testcase kiểm tra list rỗng không crash.
    return GridView.builder(
      key: const Key('user_list'),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape ? 2 : 1,
        mainAxisExtent: 104,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: Key('user_item_${user.id}'),
            onTap: () => _openDetail(user),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  AvatarImage(
                    key: Key('user_item_avatar_${user.id}'),
                    avatar: user.avatar,
                    radius: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: Key('user_item_edit_${user.id}'),
                    icon: const Icon(Icons.edit),
                    onPressed: () => _startEdit(user),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Sửa',
                  ),
                  IconButton(
                    key: Key('user_item_delete_${user.id}'),
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDelete(user),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Xoá',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _validateFullName(String? value) {
    // TODO: Bắt buộc nhập, tối thiểu 2 ký tự.
    // Message yêu cầu:
    // - Họ và tên không được để trống
    // - Họ và tên tối thiểu 2 ký tự
    final fullName = value?.trim() ?? '';

    if (fullName.isEmpty) {
      return 'Họ và tên không được để trống';
    }

    if (fullName.length < 2) {
      return 'Họ và tên tối thiểu 2 ký tự';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    // TODO: Bắt buộc nhập đúng định dạng email.
    // Message yêu cầu: Email không đúng định dạng
    final email = value?.trim() ?? '';
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Email không đúng định dạng';
    }

    return null;
  }

  String? _validateAvatar(String? value) {
    // TODO: Bắt buộc có avatar khi submit.
    // Có thể dùng defaultAvatarPath làm ảnh hiển thị mặc định khi avatar rỗng.
    // Message yêu cầu: Vui lòng chọn ảnh đại diện
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng chọn ảnh đại diện';
    }

    return null;
  }

  Future<void> _handleSubmit() async {
    // TODO:
    // 1. Validate form bằng _formKey.currentState!.validate().
    //    Nếu validate fail trong lúc đang sửa (_editingUser != null), hãy clear
    //    _fullNameController và _avatarController rồi setState().
    //    Lý do: testcase kiểm tra tên cũ chỉ xuất hiện 1 lần trong danh sách,
    //    không bị trùng với text đang prefill trong form edit.
    // 2. Nếu đang thêm mới, gọi ref.read(userViewModelProvider.notifier).addUser.
    // 3. Nếu đang sửa, gọi updateUser với dữ liệu mới.
    // 4. Sau khi lưu thành công: đặt _editingUser = null, reset form, clear cả 3 controller.
    if (!_formKey.currentState!.validate()) {
      if (_editingUser != null) {
        _fullNameController.clear();
        _avatarController.clear();
        setState(() {});
      }
      return;
    }

    final notifier = ref.read(userViewModelProvider.notifier);
    final editingUser = _editingUser;
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final avatar = _avatarController.text.trim();

    if (editingUser == null) {
      await notifier.addUser(
        fullName: fullName,
        email: email,
        avatar: avatar,
      );
    } else {
      await notifier.updateUser(
        editingUser.copyWith(
          fullName: fullName,
          email: email,
          avatar: avatar,
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      _editingUser = null;
      _formKey.currentState!.reset();
      _fullNameController.clear();
      _emailController.clear();
      _avatarController.clear();
    });
  }

  void _startEdit(UserModel user) {
    // TODO: Gán _editingUser và điền dữ liệu user vào 3 TextEditingController.
    setState(() {
      _editingUser = user;
      _fullNameController.text = user.fullName;
      _emailController.text = user.email;
      _avatarController.text = user.avatar;
    });
  }

  void _cancelEdit() {
    // TODO: Huỷ sửa, đặt _editingUser = null, reset form, clear cả 3 controller.
    // Sau khi huỷ, bản nháp đang gõ không được còn xuất hiện trên UI.
    setState(() {
      _editingUser = null;
      _formKey.currentState?.reset();
      _fullNameController.clear();
      _emailController.clear();
      _avatarController.clear();
    });
  }

  Future<void> _confirmDelete(UserModel user) async {
    // TODO: Hiển thị AlertDialog key delete_confirm_dialog.
    // Nút huỷ: Key('btn_cancel_delete'), text 'Huỷ'.
    // Nút xác nhận: Key('btn_confirm_delete'), text 'Xoá'.
    // Chỉ gọi deleteUser khi người dùng xác nhận.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const Key('delete_confirm_dialog'),
        title: const Text('Xác nhận xoá'),
        content: Text('Bạn có chắc muốn xoá ${user.fullName}?'),
        actions: <Widget>[
          TextButton(
            key: const Key('btn_cancel_delete'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Huỷ'),
          ),
          TextButton(
            key: const Key('btn_confirm_delete'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(userViewModelProvider.notifier).deleteUser(user.id);
    }
  }

  void _openDetail(UserModel user) {
    // TODO: Navigator.push sang UserDetailScreen(user: user).
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UserDetailScreen(user: user),
      ),
    );
  }
}
