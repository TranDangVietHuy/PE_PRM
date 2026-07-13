# User Manager PE - Starter

Đây là bộ khung cho đề "Ứng dụng quản lý người dùng".

Yêu cầu chính:
- Hoàn thiện model `UserModel` và `copyWith`.
- Hoàn thiện repository lưu dữ liệu tạm trong bộ nhớ.
- Hoàn thiện `UserViewModel` theo MVVM + Riverpod.
- Hoàn thiện validate form, thêm/sửa/xoá người dùng, điều hướng sang màn hình chi tiết.
- Hoàn thiện responsive: phone 1 cột, tablet/landscape 2 cột.

Ảnh mặc định:
- File `assets/default_avatar.jpg` đã được thêm sẵn.
- Có thể dùng hằng `defaultAvatarPath` trong `lib/widgets/avatar_image.dart` làm avatar mặc định.
- `AvatarImage` đã có fallback an toàn cho môi trường chấm tự động. Không dùng `Image.network`
  hoặc `AssetImage(path)` trực tiếp với giá trị người dùng nhập nếu chưa có `errorBuilder`/fallback.

Lưu ý khi dùng AI hỗ trợ:
- Giữ nguyên các `Key(...)` và text validate bắt buộc trong code.
- Widget `Key('user_list')` phải luôn render, kể cả khi danh sách rỗng.
- Không phụ thuộc vào network image hoặc asset ngoài `lib` khi chạy testcase.
- Không đổi item mẫu về `ListTile(trailing: Row(...IconButton...))`.
  Với GridView trong widget test, layout này dễ làm icon Edit/Delete không nhận tap.
  Giữ dạng `Card > InkWell > Padding > Row` trong starter.
- Ở `UserDetailScreen`, không gộp label và value vào cùng một `Text`.
  Phải có `Text(user.fullName, key: Key('detail_fullname'))` và
  `Text(user.email, key: Key('detail_email'))` hoặc tương đương hiển thị đúng text value.
- Khi submit edit bị validate fail, tránh để tên cũ vừa nằm trong form vừa nằm trong list,
  vì testcase kiểm tra tên cũ chỉ xuất hiện một lần trong danh sách.

Các vị trí cần làm đã được đánh dấu bằng `TODO`.
