Các trường hợp app "resume":

1. User mở app từ đầu (cold start)
   Phone → tap icon app → app khởi động

2. User quay lại app từ background  
   Đang dùng app → bấm home → làm việc khác → quay lại app

3. User quay lại app sau khi bị kill
   App bị hệ thống kill → user mở lại

KHÔNG tính là resume:
   × Chuyển màn hình trong app (push/pop route)
   × Mở keyboard, dialog, bottom sheet
   × Tắt/bật màn hình (chỉ tạm thời)