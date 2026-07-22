<a id="operations-playbook"></a>
# Sách hướng dẫn vận hành

> **Nguồn tiếng Anh chuẩn:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Đây là thứ tự đọc thông thường cho RandomDayGuard. Bạn không cần biết JSON, Git, tổng kiểm tra hoặc các công cụ dòng lệnh để đánh giá một máy chủ hoạt động tốt.

<a id="daily-operator-flow"></a>
## Luồng toán tử hàng ngày

1. Mở `runtime/final_logs/server_status_latest.txt`. Nó cho bạn biết liệu Guard có đang theo dõi quá trình chạy của máy chủ hiện tại hay không, chu kỳ cuối cùng của nó hoàn thành khi nào, có bao nhiêu người chơi được kết nối và liệu nguồn hoặc quá trình quét có chưa hoàn tất hay không.
2. Mở `runtime/final_logs/daily_rollup_latest.txt` một lần mỗi ngày. Nó tóm tắt các phiên trong cùng ngày, các lần thoát, công việc được đặt tên, kiểm kê danh tính và phạm vi nguồn mà không lặp lại từng bản ghi riêng lẻ.
3. Mở `runtime/final_logs/player_activity_latest.txt` chỉ khi máy chủ có phiên tham gia, rời khỏi hoặc hoạt động trong ngày.
4. Mở `runtime/final_logs/case_review_latest.txt` chỉ khi nó đặt tên cho chủ đề hiện tại. Báo cáo cung cấp tài khoản, trạng thái đánh giá, điểm số, nguồn nhận dạng và các hồ sơ sẽ mở tiếp theo.
5. Mở `runtime/final_logs/critical_guard_latest.txt` chỉ khi Guard báo cáo lỗi trong quá trình khởi động, chu trình giám sát hoặc ghi báo cáo của chính nó.

Nếu tuyến đường không có gì để báo cáo, Guard sẽ ghi lại kết quả dự kiến ​​trống. Đó là kiểm tra đầy đủ chứ không phải báo cáo thiếu.

<a id="what-to-read-inside-a-report"></a>
## Nội dung cần đọc trong báo cáo

Đọc các phần này theo thứ tự:

1. **Tóm tắt** - nội dung của báo cáo này.
2. **Những gì Guard quan sát được** - dấu thời gian thực tế, số lượng, tài khoản, phiên hoặc giá trị trạng thái được thu thập cho tuyến này.
3. **Ý nghĩa của nó** - cách diễn giải bằng ngôn ngữ đơn giản của những điều khoản đó record.
4. **Những điều còn chưa biết** - giới hạn nguồn hoặc số lần quét ảnh hưởng đến kết quả.
5. **Bước tiếp theo được đề xuất** - giám sát, xem xét chủ đề được đặt tên hay sửa chữa Guard.
6. **Ranh giới bằng chứng** - giới hạn phạm vi của báo cáo.

Bản ghi kỹ thuật và tài liệu tham khảo nguồn xuất hiện ở cuối dành cho độc giả cần kiểm tra bằng chứng có cấu trúc chính xác.

<a id="when-a-report-is-missing"></a>
## Khi thiếu báo cáo

Mở `runtime/final_logs/route_proof.json` chỉ khi không có báo cáo có thể đọc được hoặc cho biết thiếu bằng chứng hiện tại. Mỗi tuyến đường có một trong các kết quả sau:

| Kết quả | Ý nghĩa |
|---|---|
| `full` | Guard đã hoàn thành tuyến đường với bằng chứng hiện tại thuộc sở hữu của tuyến đường. |
| `limited_expected_empty` | Guard đã hoàn thành lộ trình và không tìm thấy sự kiện đủ điều kiện nào hoặc ghi lại giới hạn trưởng thành được đặt tên. |
| `missing` | Việc kiểm tra nguồn, dòng dõi hoặc ghi báo cáo ghép nối bắt buộc chưa hoàn thành. |

Đối với tuyến đường bị thiếu, hãy làm theo nguồn được đặt tên hoặc ghi lỗi vào báo cáo. Trước tiên, đừng thay đổi các tuyến đường hoặc cài đặt thông báo không liên quan.

<a id="after-a-crash-or-restart"></a>
## Sau sự cố hoặc khởi động lại

1. Đọc Trạng thái Máy chủ để biết dấu thời gian chạy máy chủ mới và chu kỳ giám sát đã hoàn thành mới nhất.
2. Đọc Critical Guard để biết lỗi khởi động hoặc thăm dò ý kiến ​​hiện tại.
3. Chỉ đọc Hoạt động của người chơi nếu phiên cùng ngày đã tham gia, rời đi hoặc quay lại sau khi thay đổi vòng đời.
4. Bảo toàn bản ghi nguồn được trích dẫn trước khi thay đổi cấu hình.

<a id="before-enabling-optional-adminini-writes"></a>
## Trước khi bật tùy chọn Admin.ini ghi

Gói mặc định theo dõi và báo cáo mà không thay đổi `Admin.ini`. Người vận hành nâng cao có thể kích hoạt đường dẫn thực thi tùy chọn sau khi kiểm tra đường dẫn đó dựa trên bản sao của tệp. Sau đó, Guard yêu cầu ID tài khoản bằng số rõ ràng, bảo vệ các tài khoản đáng tin cậy, tạo và xác minh bản sao lưu, từ chối các thay đổi đồng thời, đọc lại tệp đã lưu và khôi phục bản sao lưu nếu xác minh không thành công. Xem [`ADMIN_INI_ENFORCEMENT.md`](TH%E1%BB%B0C_THI_INI_C%E1%BB%A6A_QU%E1%BA%A2N_TR%E1%BB%8A_VI%C3%8AN.md) để biết quy trình kiểm tra và thiết lập hoàn chỉnh.

<a id="related-guides"></a>
## Hướng dẫn liên quan

- [`START_HERE.md`](B%E1%BA%AET_%C4%90%E1%BA%A6U_T%E1%BA%A0I_%C4%90%C3%82Y.md)
- [`REPORT_EXAMPLES.md`](V%C3%8D_D%E1%BB%A4_V%E1%BB%80_B%C3%81O_C%C3%81O.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
- [`TROUBLESHOOTING.md`](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md)
