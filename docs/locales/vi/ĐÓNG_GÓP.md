<a id="contributing"></a>
# Đóng góp

> **Nguồn tiếng Anh chuẩn:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


RandomDayGuard chấp nhận các cải tiến tập trung, có thể tái tạo đối với trình phân tích cú pháp, tài liệu, kiểm tra và xác thực an toàn công cộng. Giữ mọi thay đổi trong giới hạn hợp đồng dự án công cộng và duy trì hành vi xem xét trước: Guard phải để `Admin.ini` không thay đổi khi không thể xác nhận kiểm tra an toàn bắt buộc.

<a id="prepare-a-safe-workspace"></a>
## Chuẩn bị không gian làm việc an toàn

1. Phân nhánh hoặc sao chép kho lưu trữ và tạo một nhánh tập trung.
2. Cài đặt trình thông dịch Python 3 được hỗ trợ. Cài đặt trình biên dịch Lua khi bạn thay đổi Lua `luac -p` có thể kiểm tra cú pháp.
3. Đọc [trang chủ tài liệu](T%C3%80I_LI%E1%BB%86U.md), [kiến trúc](KI%E1%BA%BEN_TR%C3%9AC.md) và [ranh giới bằng chứng](RANH_GI%E1%BB%9AI_B%E1%BA%B0NG_CH%E1%BB%A8NG.md) cho khu vực bạn sẽ thay đổi.
4. Kiểm tra `git status` trước khi chỉnh sửa và giữ lại tác phẩm không liên quan.
5. Chỉ sử dụng đồ đạc tổng hợp hoặc đã khử trùng.

Không bao giờ gửi nhật ký máy chủ riêng, thư mục đã lưu, mã nhận dạng người chơi, `Admin.ini`, điểm cuối thông báo riêng tư, thông tin xác thực, đường dẫn riêng tư, đầu ra thời gian chạy hoặc bằng chứng trực tiếp được sao chép.

<a id="make-a-focused-change"></a>
## Thực hiện thay đổi tập trung

- Tuân theo cách đặt tên, định dạng, kiểm tra an toàn và quyền sở hữu mô-đun hiện có.
- Giữ một chủ sở hữu tài liệu chuẩn cho mỗi tài liệu quy trình hoặc thông tin chính xác.
- Cập nhật tài liệu và ví dụ của người dùng khi hành vi hoặc kết quả công khai thay đổi.
- Thêm kiểm tra hồi quy để sửa lỗi khi thực tế.
- Không làm yếu đi xác nhận tài khoản, bảo vệ tài khoản đáng tin cậy, xác minh bản sao lưu, phát hiện thay đổi bên ngoài, so sánh tệp đã lưu, khôi phục hoặc mặc định chỉ dành cho đánh giá để vượt qua kiểm tra.

<a id="run-the-relevant-checks"></a>
## Chạy các kiểm tra liên quan

Đối với các thay đổi chỉ dành cho tài liệu, hãy chạy:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

Đối với các thay đổi về nguồn, cấu hình, cách đóng gói hoặc thử nghiệm, hãy chạy cả các bước kiểm tra hiện hành từ [Đánh giá xác thực và phát hành](X%C3%81C_TH%E1%BB%B0C_V%C3%80_PH%C3%81T_H%C3%80NH.md), bao gồm kiểm tra cú pháp Lua, xác thực kho lưu trữ, kiểm tra đường dẫn công cộng và bộ kiểm thử đơn vị đầy đủ. Báo cáo mọi séc bị bỏ qua hoặc không có sẵn; đừng miêu tả nó là đã đậu.

<a id="submit-the-change-for-review"></a>
## Gửi thay đổi để xem xét

Chỉ mở yêu cầu kéo tập trung sau khi xem xét toàn bộ sự khác biệt. Bao gồm:

- vấn đề và hành vi dự kiến;
- các tệp chính xác và hợp đồng công khai đã thay đổi;
- các lệnh chạy và kết quả của chúng;
- tác động đến quyền riêng tư, khả năng tương thích và việc thực thi; và
- các hạn chế còn lại hoặc công việc tiếp theo.

Không bao gồm bằng chứng thời gian chạy đã tạo hoặc phát hành các bản lưu trữ trừ khi thay đổi yêu cầu và xác thực chúng một cách rõ ràng. Nội dung đóng góp không cho phép phát hành, triển khai, kiểm tra máy chủ trực tiếp, hành động thực thi hoặc xuất bản trên trang web của bên thứ ba.

Báo cáo lỗ hổng thông qua [con đường bảo mật riêng tư](B%E1%BA%A2O_M%E1%BA%ACT.md), không phải vấn đề công khai hay yêu cầu kéo thông thường.
