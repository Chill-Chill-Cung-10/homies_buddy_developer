Hãy giúp tôi finish các task dưới đây:
1. [x] Hãy kết nối logic và API của daily notes, khi thực hiện đăng daily notes, đồng thời thêm three_dots icon button ở mỗi bài đăng, và thêm 2 chức năng delete notes và sửa notes. Cuối cùng, in ra các logs đối với mỗi API xử lý để xem tín hiệu thành công hay lỗi từ Firebase và Supabase 
2. [x] Đối với mỗi một selectedDate ở trong calendar_item, thì các notes trong daily notes sẽ được load chỉ riêng ngày hôm đó, hãy sử dụng lazy loading để tối ưu performance trong mỗi lần mà người dùng thay đổi selectedDate,và nếu nó ở quá khứ hoặc tương lai, thì chức năng đăng notes sẽ bị block, user không thể đăng notes. 
3. [x] Hãy giúp tôi thêm điều kiện vào calendar item, nếu như ngày được chọn là ngày hôm nay thì Header của calendar item không hiện là ví dụ Apr 1 2026, mà hiện là Today. Đồng thời hãy thêm một text button với label là Today ở góc dưới cùng bên phải của grid. Chức năng của nó là khi ấn vào nó, thì selectedDay sẽ được reset về ngày hiện tại
4. [x] Đối với calendar, thì sau 24h mỗi ngày, daily notes sẽ lại được reset về blank, tức là báo hiệu rằng ngày mới đã đến
5. [x] Háy giúp tôi gọi các RPC sau khi app resume, sau đó cập nhật state từ các kết quả RPC, đăng ký observer với main.dart, follow những yêu cầu:
YÊU CẦU:
main.dart (app-level)
  ✅ Bắt được mọi lần resume kể cả cold start
  ✅ Không bị mất khi navigate giữa các màn hình
  ✅ Chỉ đăng ký 1 lần duy nhất
  ⚠️  Cần chắc chắn user đã login trước khi gọi RPC

6. [x] In ra logs toàn bộ của các state có được ở trong kết quả RPC để có thể kiểm soát
7. [x] Handle lỗi RPC (no internet, timeout) bằng notification tới người dùng
