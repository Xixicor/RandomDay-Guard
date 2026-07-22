<a id="adminini-enforcement"></a>
# Admin.ini thực thi

> **Nguồn tiếng Anh chuẩn:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


RandomDayGuard không thay đổi danh sách cấm máy chủ trong thiết lập mặc định của nó. Nó chỉ tạo báo cáo để quản trị viên xem xét. Trang này giải thích việc cập nhật danh sách cấm tự động tùy chọn dành cho những quản trị viên cố tình kích hoạt nó.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Guard kiểm tra những gì trước khi thay đổi danh sách cấm

Guard chỉ thêm lệnh cấm khi mọi câu trả lời bên dưới là **có**:

1. Bằng chứng hiện tại có xác định đủ độ tin cậy về một tài khoản cụ thể không?
2. Tài khoản đó không phải là người kiểm duyệt hay tài khoản mà quản trị viên đã đánh dấu là đáng tin cậy?
3. Tài khoản chưa có trong danh sách cấm phải không?
4. Tài khoản có đạt đến điểm hành động tự động đã định cấu hình không?
5. Guard có thể đọc `Admin.ini` và lưu một bản sao lưu giống hệt?
6. `Admin.ini` có giữ nguyên không thay đổi trong khi Guard chuẩn bị bản cập nhật không?
7. Sau khi lưu, tệp hoàn chỉnh có khớp chính xác với kết quả dự kiến không?

Nếu bất kỳ câu trả lời nào là **không** hoặc không thể kiểm tra được, Guard sẽ rời khỏi trạng thái `Admin.ini` và ghi lại lý do vào đó báo cáo. Nếu quá trình lưu bắt đầu nhưng lần kiểm tra cuối cùng không thành công, Guard sẽ khôi phục bản sao lưu đã được xác minh.

<a id="file-format"></a>
## Định dạng tệp

`Admin.ini` chỉ được nhận các dòng lệnh cấm rõ ràng:

```ini
BannedPlayer=<ID>
```

- Không có tên.
- Không có nhận xét.
- Không có lý do.
- Không có hậu tố.

<a id="safe-defaults"></a>
## Mặc định an toàn

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Nguồn ID cấm

Nguồn tốt nhất:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

Thời gian chạy chấp nhận ID đầy đủ bằng số hoặc biểu mẫu kết nối `<digits>_+_|<non-space token>` được ghi lại đầy đủ và lấy ID cấm bằng số từ đó. Tiền tố số tùy ý có hậu tố không xác định sẽ bị từ chối; chúng không bị cắt bớt thành ID lệnh cấm.

Đúng:

```ini
BannedPlayer=2535422284688820
```

Sai:

```ini
BannedPlayer=ExamplePlayer
```

Cũng sai:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Cài đặt chính xác Kiểm tra bảo vệ

Các cài đặt này thực hiện các bước kiểm tra được mô tả ở trên. Mọi điều kiện được liệt kê đều phải đúng:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

Nếu bất kỳ điều kiện nào sai hoặc không thể kiểm tra được, Guard sẽ giữ nguyên danh sách cấm và ghi lại những gì đã dừng danh sách đó.

<a id="transaction-safety"></a>
## An toàn giao dịch

Duy nhất `Admin.ini` thực hiện các bước sau theo thứ tự:

1. Đọc và xác thực cấu trúc các byte có thẩm quyền.
2. Lấy trạng thái người kiểm duyệt, trạng thái đáng tin cậy và trạng thái cấm hiện có từ cùng ảnh chụp nhanh đó.
3. Viết bản sao lưu duy nhất trong `runtime/backups/` và xác minh từng byte.
4. Đọc lại `Admin.ini` ngay trước khi thay thế và từ chối mọi thay đổi bên ngoài.
5. Viết ứng viên thông qua đường dẫn thay thế được kiểm soát đã định cấu hình.
6. Yêu cầu các byte đọc lại hoàn chỉnh bằng với các byte ứng cử viên hoàn chỉnh.
7. Khi đọc lại không thành công, chỉ khôi phục bản sao lưu đã được xác minh khi tệp hiện tại vẫn là ứng cử viên chính xác do Guard viết. Nếu người viết khác thay đổi nó, Guard sẽ từ chối khôi phục thay vì ghi đè lên các byte bên ngoài không xác định.

ID trùng lặp là bình thường: không có dòng thứ hai và bản sao lưu thứ hai được ghi. Tên sao lưu bao gồm dấu thời gian, dấu vân tay byte nguồn và ID sạch để các lần thử riêng biệt không thể chia sẻ tên tệp một giây cũ.

<a id="local-regression-proof"></a>
## Bằng chứng hồi quy cục bộ

`tests/lua/enforcement_runtime_test.lua` khởi động bộ tải được vận chuyển một lần rồi thực thi cục bộ thực của nó `append_ban()` đóng các tệp tổng hợp bị cô lập bên dưới kho lưu trữ `.tmp/`. Nó bao gồm việc chèn, trùng lặp idempotency, moderator/trusted từ chối, từ chối danh tính yếu và không đúng định dạng, xác minh sao lưu chính xác theo byte, từ chối sửa đổi đồng thời, khôi phục thành công sau khi đọc lại không thành công và từ chối ghi đè thay đổi bên ngoài sau khi ghi. Các trình bao bọc hệ thống tập tin của nó từ chối mọi đột biến bên ngoài gốc cố định; không có đường dẫn máy chủ thực hoặc `Admin.ini` được sử dụng.

Chạy qua `python tools/test_public_pipeline.py`. Thẻ cố định chỉ chứng minh hành vi giao dịch cục bộ. Nó không cho phép thực thi, ủy quyền viết sản phẩm hoặc chứng minh các quyền dành riêng cho máy chủ.

<a id="files-to-check"></a>
## Các tệp cần kiểm tra

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Khôi phục

1. Dừng máy chủ.
2. Khôi phục Admin.ini sao lưu từ `runtime/backups/`.
3. Xóa dòng `BannedPlayer=<ID>` không chính xác nếu cần.
4. Khởi động máy chủ.
5. Mở lại Admin.ini và xác nhận dòng này vẫn tồn tại hoặc đã bị xóa.
6. Giữ lại `enforced_bans.jsonl` để kiểm tra.

<a id="related-docs"></a>
## Tài liệu liên quan

* [`BAN_ID_MAPPING.md`](C%E1%BA%A4M_%C3%81NH_X%E1%BA%A0_ID.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
