<a id="worked-operation-examples"></a>
# Các ví dụ về hoạt động đã thực hiện

> **Nguồn tiếng Anh chuẩn:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Những ví dụ này sử dụng các giá trị được phát minh để giải thích các chuyển đổi trạng thái dự kiến; chúng không phải là khả năng tương thích trực tiếp hoặc bằng chứng về người chơi.

<a id="successful-current-cycle"></a>
## Chu kỳ hiện tại thành công

Đầu vào: nhật ký hoạt động có thể đọc được, version/boot/epoch, `poll_id=41`, đã hoàn thành cuộc thăm dò hiện tại, các gốc accounting/history/report có thể ghi, không chặn chính sách quét chậm.

Dự kiến:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Mỗi tuyến được kích hoạt đều có JSON/TXT và cùng một dòng trong `route_proof.json`. Trạng thái tuyến đường phụ thuộc vào chủ đề của chính nó chứ không phụ thuộc vào thông báo thành công chung chung.

<a id="expected-empty-player-and-case-routes"></a>
## Các tuyến trường hợp và trình phát dự kiến ​​trống

Đầu vào: bằng chứng chu kỳ hiện tại đã hoàn tất; không có hàng người chơi hiện tại hoặc được giữ lại; không có trường hợp nào được giữ lại và không có tài khoản REVIEW/BAN-ELIGIBLE hiện tại.

Dự kiến:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Các báo cáo đã dịch nói rằng không có chủ đề giới hạn đủ điều kiện nào được quan sát thấy. Họ cũng nói rằng điều này không chứng tỏ rằng không có ai từng kết nối hoặc không thiếu bối cảnh nào. Không có phần giữ chỗ player/case nào được tạo.

<a id="partial-bounded-scan"></a>
## Quét giới hạn một phần

Đầu vào: tồn tại log/poll; `scan_checkpoint.json` hoặc `scan_progress.json` mới; quá trình quét không đầy đủ; mặc định `slow_world_scan_blocks_current_reports=false`.

Dự kiến:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Chỉ đặt `slow_world_scan_blocks_current_reports=true` mặc định khi người vận hành muốn nguồn chậm tùy chọn đó chặn các báo cáo hiện tại. Quá trình khôi phục nhằm cho phép nhân viên quét tiếp tục mà không xóa điểm kiểm tra.

<a id="missing-current-cycle-proof"></a>
## Thiếu bằng chứng về chu kỳ hiện tại

Đầu vào: không có nhật ký hoạt động, `poll_id=0` hoặc boot/epoch/last-poll thiếu dòng.

Dự kiến:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

Phong bì bị chặn là một bản ghi kiểm tra, không phải là một bản phân phối được xếp hàng đợi. Nhật ký cuối cùng cũ chỉ còn mang tính lịch sử. Sửa trường lineage/source bị thiếu đầu tiên và tạo một chu trình mới hơn.

<a id="malformed-optional-adminini-source"></a>
## Nguồn Admin.ini tùy chọn không đúng định dạng

Đầu vào: `Admin.ini` tồn tại nhưng không xác thực được cấu trúc rõ ràng.

Dự kiến:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Bảo toàn tệp và khôi phục định dạng sạch đã xem xét. Giữ văn bản giải thích trong bằng chứng thời gian chạy; mỗi `Admin.ini` lệnh cấm chỉ còn lại `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Lỗi thăm dò nhật ký hoạt động bắt buộc

Đầu vào: đầu dò nhật ký hoạt động bắt buộc được giới hạn không thành công do lỗi đọc đã được lọc.

Dự kiến:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` vẫn còn trên hàng nguồn với chi tiết được giới hạn của nó. Báo cáo cấp cao nhất sử dụng `unavailable` và bằng chứng về lộ trình vẫn còn `missing` cho đến khi chu kỳ hiện tại mới hơn chứng minh nguồn được yêu cầu.

<a id="incompatible-or-stale-baseline"></a>
## Đường cơ sở không tương thích hoặc cũ

Đầu vào: đã thay đổi package/source danh tính hoặc stale/incompatible bảng kê khai cơ sở.

Dự kiến: trạng thái xác thực hoặc thời gian chạy ghi lại sự không tương thích; trạng thái quét không yêu cầu tái sử dụng đã hoàn thành. Lưu giữ bằng chứng trước đó, bắt đầu xây dựng lại đường cơ sở rõ ràng và chờ bằng chứng cuối cùng mới. Việc xây dựng lại bắt buộc mà không có lý do được ghi lại không phải là khôi phục mặc định.

<a id="paired-report-write-failure"></a>
## Lỗi ghi báo cáo được ghép nối

Đầu vào: JSON ghi thành công nhưng TXT ghi không thành công hoặc ngược lại.

Dự kiến:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

Người viết nỗ lực hết sức để viết lại cả hai anh chị em để hội tụ về lỗi. Một anh chị em thành công không thể vẫn là một tuyên bố thành công. Chi tiết ghi giới hạn không tạo ra giá trị phạm vi cấp cao thứ năm.

<a id="route-proof-write-failure"></a>
## Lỗi ghi chống định tuyến

Đầu vào: cặp tuyến đã được ghi nhưng `route_proof.json` không thể thay thế.

Dự kiến: tất cả báo cáo đều được viết lại `missing`, tất cả kết quả thông báo là `route_proof_write_failed` và không có phong bì nào được chấp nhận. Tuyến được định cấu hình có thể có phong bì kiểm tra `suppressed_current_cycle` với cờ phân phối sai. Sửa chữa gốc đầu ra và tạo lại cùng một chu kỳ hiện tại.

<a id="review-only-enforcement-example"></a>
## Ví dụ thực thi chỉ dành cho đánh giá

Cấu hình:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Dự kiến: điểm số, trường hợp và đề xuất có thể được viết; `Admin.ini` không thay đổi. Đây là mặc định công khai.

<a id="approved-write-success-example"></a>
## Ví dụ về ghi thành công đã được phê duyệt

Chỉ có thử nghiệm được phê duyệt riêng mới có thể đặt cả ba công tắc ghi. Nó cũng phải chứng minh danh tính số rõ ràng, trust/moderator loại trừ, đủ điều kiện ngưỡng, Admin.ini path/parse hợp lệ, sao lưu thành công, ghi thành công, bình đẳng đọc lại và bằng chứng cụ thể cho tài khoản.

Dự kiến:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

Ví dụ thành công không cho phép thực thi tự động đối với các tài khoản khác.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback lỗi khi khôi phục

Đầu vào: mọi cổng ghi trước đều đã vượt qua; ghi thay thế hoặc đọc lại không thành công; `rollback_on_readback_failure=true` và bản sao lưu đã được xác minh có sẵn.

Dự kiến: bằng chứng lỗi ghi lại giai đoạn và `rollback_success`; các byte Admin.ini ban đầu được khôi phục và tài khoản không được báo cáo là đã thực thi thành công. Nếu khôi phục cũng không thành công, hãy dừng ghi, bảo toàn cả files/evidence và khôi phục thủ công từ bản sao lưu.

<a id="local-outbox-example"></a>
## Ví dụ về hộp thư đi cục bộ

Đầu vào: thông báo được bật ở chế độ `local_file_outbox`, tuyến đã bật, bằng chứng tuyến đã hoàn thành và `full` hoặc được cho phép rõ ràng là trống.

Đường bao dự kiến:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

Dành cho missing/ineligible đầu ra, thay vào đó, cùng một đường dẫn có thể chứa `status=suppressed_current_cycle`, `completed_output=false` và `delivery_eligible=false`. Một trong hai tệp chỉ chứng minh ghi cục bộ. Không có nhà cung cấp, vận chuyển, giao hàng hoặc biên nhận đọc nào được đóng gói hoặc suy ra.

Xem [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md), [`CONFIG_FIELD_CATALOG.md`](DANH_M%E1%BB%A4C_TR%C6%AF%E1%BB%9CNG_C%E1%BA%A4U_H%C3%8CNH.md) và [`TROUBLESHOOTING.md`](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md).
