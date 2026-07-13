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
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth >= constraints.maxHeight;
            final isTablet = constraints.maxWidth >= 600;

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  _buildForm(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildUserList(
                      users: state.items,
                      crossAxisCount: isTablet ? 2 : (isLandscape ? 2 : 1),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      Text(_editingUser == null ? 'ADD USER' : 'UPDATE USER'),
                ),
              ),
              if (_editingUser != null) ...<Widget>[
                const SizedBox(width: 8),
                OutlinedButton(
                  key: const Key('btn_cancel_edit'),
                  onPressed: _cancelEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB45309),
                    side: const BorderSide(color: Color(0xFFB45309)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
    required int crossAxisCount,
  }) {
    return GridView.builder(
      key: const Key('user_list'),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: const Color(0xFFD1D5DB),
                        ),
                        const SizedBox(height: 4),
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
    final email = value?.trim() ?? '';
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Email không đúng định dạng';
    }

    return null;
  }

  String? _validateAvatar(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng chọn ảnh đại diện';
    }

    return null;
  }

  Future<void> _handleSubmit() async {
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
    setState(() {
      _editingUser = user;
      _fullNameController.text = user.fullName;
      _emailController.text = user.email;
      _avatarController.text = user.avatar;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingUser = null;
      _formKey.currentState?.reset();
      _fullNameController.clear();
      _emailController.clear();
      _avatarController.clear();
    });
  }

  Future<void> _confirmDelete(UserModel user) async {
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
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UserDetailScreen(user: user),
      ),
    );
  }
}
