<div align="center">

# 🛡️ PingMe Manager

**Ứng dụng Quản trị hệ thống PingMe dành cho Admin**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Dio](https://img.shields.io/badge/Dio-HTTP_Client-6C63FF?style=for-the-badge&logo=dart&logoColor=white)
![Socket.io](https://img.shields.io/badge/Socket.io-010101?style=for-the-badge&logo=socket.io&logoColor=white)
![Google Maps](https://img.shields.io/badge/Google_Maps-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white)
![WebRTC](https://img.shields.io/badge/WebRTC-333333?style=for-the-badge&logo=webrtc&logoColor=white)

> Ứng dụng **Flutter** dành riêng cho Quản trị viên (Admin), cung cấp toàn bộ công cụ giám sát, kiểm duyệt nội dung và quản lý người dùng cho hệ sinh thái PingMe.

</div>

---

## 🌟 1. Tính năng chính

Ứng dụng được thiết kế theo kiến trúc **Feature-based**, phân tách rõ ràng giữa UI, logic và dịch vụ:

### 🔐 Xác thực Quản trị viên (Auth)

- Đăng nhập bằng tài khoản Admin được cấp sẵn từ hệ thống.
- Xác thực **OTP 2 lớp qua Email** để bảo vệ quyền truy cập quản trị.
- Quản lý phiên làm việc bằng **JWT** lưu trữ an toàn với **Shared Preferences**.

### 📊 Bảng điều khiển (Home Dashboard)

- Xem thống kê tổng quan thời gian thực: tổng số người dùng, số kết nối online, số báo cáo chờ xử lý.
- Biểu đồ tăng trưởng người dùng và hoạt động theo ngày/tuần.
- Danh sách các sự kiện hệ thống mới nhất.

### 👥 Quản lý Người dùng (User Management)

- Tìm kiếm, lọc và xem danh sách toàn bộ người dùng trong hệ thống.
- Xem hồ sơ chi tiết, lịch sử hoạt động của từng tài khoản.
- **Khóa / Mở khóa** tài khoản vi phạm tiêu chuẩn cộng đồng.
- Thu hồi Vật phẩm bất hợp lệ của người dùng.

### 📸 Kiểm duyệt Nội dung (Moment Moderation)

- Xem và duyệt danh sách các bài đăng (Moments) bị báo cáo vi phạm.
- Xem chi tiết nội dung, ảnh/video và lý do báo cáo từ cộng đồng.
- **Xóa vĩnh viễn** bài đăng vi phạm (kèm xóa file trên Cloud).

### 💬 Giám sát Cuộc trò chuyện (Conversation Monitor)

- Xem danh sách và nội dung các cuộc trò chuyện khi cần kiểm tra vi phạm.
- Hỗ trợ xem tin nhắn văn bản và tệp đa phương tiện.

### 🗺️ Quản lý Bản đồ & Sự kiện (Map Management)

- Xem bản đồ toàn hệ thống với **Google Maps Flutter**.
- Tạo, chỉnh sửa và xóa các sự kiện/thử thách tại địa điểm thực tế.
- Quản lý phần thưởng Vật phẩm đính kèm với từng sự kiện.

### ⚙️ Cài đặt Hệ thống (Settings)

- Điều chỉnh cấu hình chung của hệ thống.
- Quản lý danh sách Vật phẩm (thêm, sửa, xóa).

---

## 🛠️ 2. Công nghệ sử dụng

| Hạng mục | Công nghệ |
|---|---|
| **Core Framework** | [Flutter](https://flutter.dev/) (SDK ^3.10.7) |
| **Ngôn ngữ** | Dart |
| **HTTP Client** | [Dio](https://pub.dev/packages/dio) ^5.4.0 |
| **Real-time** | socket_io_client ^3.1.4 |
| **Bản đồ** | google_maps_flutter + geolocator |
| **Gọi Video/Audio** | flutter_webrtc ^1.4.1 |
| **Media** | image_picker, wechat_assets_picker, video_player, audioplayers |
| **Lưu trữ cục bộ** | shared_preferences |
| **Định dạng & Tiện ích** | intl, uuid, vibration |

---

## 🚀 3. Cách cài đặt và chạy Project

### 📋 Yêu cầu hệ thống

- [Flutter SDK](https://docs.flutter.dev/get-started/install) phiên bản **^3.10.7**
- **Android Studio** (để chạy trên Emulator) hoặc thiết bị Android thật
- Máy chủ [PingMe Backend](https://github.com/chuonghoai/PingMe-Backend.git) đang chạy và có thể truy cập được

### 💻 Các bước thực hiện

**Bước 1: Clone project về máy**

```bash
git clone https://github.com/chuonghoai/PingMe-Manager.git
cd PingMe-Manager
```

**Bước 2: Cài đặt dependencies**

```bash
flutter pub get
```

**Bước 3: Cấu hình địa chỉ Backend**

Chỉnh sửa `baseUrl` trong file cấu hình mạng (xem hướng dẫn chi tiết ở mục 4).

**Bước 4: Khởi chạy ứng dụng**

```bash
# Chạy trên thiết bị/emulator đang kết nối
flutter run

# Chạy trên một thiết bị cụ thể (xem danh sách bằng flutter devices)
flutter run -d <device_id>

# Build APK để cài đặt thủ công
flutter build apk --release
```

**Bước 5: Kiểm tra kết nối**

Sau khi ứng dụng khởi động, đăng nhập bằng tài khoản Admin đã được cấu hình trong Backend (`ADMIN_MAIL` / `ADMIN_PASSWORD`).

---

## ⚙️ 4. Cấu hình kết nối Backend

Ứng dụng **không dùng file `.env`**. Địa chỉ máy chủ Backend được cấu hình trực tiếp trong file:

```
lib/core/network/api_client.dart
```

Mở file đó và sửa giá trị `baseUrl` ở **dòng 19** cho khớp với địa chỉ máy chủ của bạn:

```dart
// lib/core/network/api_client.dart — dòng 17 đến 26

ApiClient._internal() {
  BaseOptions options = BaseOptions(
    baseUrl: 'http://192.168.1.32:3000', // ← Sửa địa chỉ IP tại đây
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
```

**Giá trị cần thay đổi tùy môi trường:**

| Môi trường | Giá trị `baseUrl` |
|---|---|
| **Máy ảo Android (Emulator)** | `http://10.0.2.2:3000` |
| **Thiết bị Android thật (cùng mạng Wi-Fi)** | `http://<IP_LAN_máy_bạn>:3000` |
| **Production** | `https://your-domain.com` |

> **Lưu ý:** Xem địa chỉ IP LAN của máy tính bằng lệnh `ipconfig` (Windows). Đảm bảo thiết bị Android và máy tính đang kết nối **cùng một mạng Wi-Fi**.

---

## 🤝 5. Đóng góp (Contributing)

Mọi đóng góp để phát triển dự án luôn được trân trọng!

1. 🍴 **Fork** dự án
2. 🌿 Tạo nhánh tính năng: `git checkout -b feature/AwesomeFeature`
3. 💾 **Commit** thay đổi: `git commit -m 'Thêm tính năng AwesomeFeature'`
4. 🚀 **Push** lên nhánh: `git push origin feature/AwesomeFeature`
5. 📬 Mở **Pull Request** và mô tả chi tiết thay đổi của bạn

---

## 👨‍💻 6. Credits / Author

- **Dự án:** Ứng dụng Quản trị PingMe (Nhắn tin & Chia sẻ vị trí)
- **Phát triển bởi:**
  * **Trương Hoài Chương**
  * **Phạm Hoài Nam**
- **Môn học:** Lập trình di động nâng cao
- **Trường:** Đại học Công nghệ Kỹ thuật TP.HCM (HCMUTE)

---

<div align="center">
<i>Dự án này là mã nguồn mở và được tạo ra với mục đích học tập.</i>
</div>
