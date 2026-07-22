<a id="output-and-state-schema-reference"></a>
# Tham chiếu lược đồ trạng thái và đầu ra

> **Nguồn tiếng Anh chuẩn:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Đây là hợp đồng chuẩn cho các tệp hướng tới nhà điều hành được tạo. Chỉ riêng nó mới sở hữu các đường dẫn đầu ra chính xác, tên trường, giá trị được phép, yêu cầu dòng dõi và lược đồ tuyến đường. Hướng dẫn thủ tục liên kết đến đây thay vì xác định lại những thông tin thực tế đó.

Bằng chứng về thời gian chạy là có căn cứ; tên tệp, nhịp tim của bộ lập lịch, báo cáo đã dịch hoặc đối tượng hộp thư đi cục bộ không chứng minh được gì nhiều hơn các trường và dòng dõi của chính nó.

<a id="public-report-routes"></a>
## Các tuyến báo cáo công khai

Nhân viên báo cáo sở hữu năm tuyến đường dưới `runtime/final_logs/`:

| Tuyến đường | Hợp đồng | `full` yêu cầu | Ý nghĩa trống rỗng |
|---|---|---|---|
| `server_status` | Bộ lập lịch hiện tại, nhật ký hoạt động, trạng thái chờ quét và phạm vi nguồn. | Các sự kiện boot/epoch/poll dòng dõi, nhật ký hoạt động mới, accounting/history ghi và JSON/TXT. | Không được sử dụng cho chu kỳ hiện tại lành mạnh; dòng còn thiếu là `missing`. |
| `daily_rollup` | Các sự kiện day/window tính liên tục trên máy chủ, người chơi, trường hợp, quá trình quét và phạm vi phủ sóng. | Thiết bị đầu cuối kế toán lịch sử đủ để hoàn thành lộ trình và bằng chứng chu kỳ hiện tại. | Không có người chơi được giữ lại và không có trường hợp đánh giá nào. |
| `player_activity` | Các quan sát player/account hiện tại và lịch sử riêng biệt. | Bằng chứng chu kỳ hiện tại cộng với một hoặc nhiều hàng current/historical. | Không có hàng người chơi đủ điều kiện trong đầu vào giới hạn; không có chủ đề tổng hợp. |
| `case_review` | Các trường hợp được đặt tên được giữ lại và các ứng cử viên review/BAN-ELIGIBLE hiện tại. | Bằng chứng chu kỳ hiện tại cộng với một hoặc nhiều trường hợp được đặt tên cùng với tham chiếu nguồn. | Không có trường hợp nào được nêu tên đáp ứng tiêu chí đánh giá; không có trường hợp tổng hợp nào. |
| `critical_guard` | Lỗi lên lịch khởi động hiện tại, lỗi khởi động, thăm dò ý kiến ​​hoặc lỗi toàn vẹn bằng chứng. | Bằng chứng về chu kỳ hiện tại cộng với lỗi nghiêm trọng hiện tại. | Không có lỗi nghiêm trọng hiện tại; lỗi văn bản cũ không sở hữu tuyến đường này. |

Mọi tuyến đường được bật đều ghi `<route>_latest.json` và `<route>_latest.txt`. Cặp này chưa hoàn thành cho đến khi `runtime/final_logs/route_proof.json` ghi lại cùng một phiên bản, khởi động, kỷ nguyên, thăm dò ý kiến ​​và độ mới của nguồn.

<a id="report-json-schema"></a>
## Báo cáo JSON lược đồ

Tất cả các đường dẫn JSON sử dụng `schema="randomdayguard.report/v1"`.

| Trường | Loại | Ý nghĩa và bất biến |
|---|---|---|
| `schema` | chuỗi | Chính xác là `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | chuỗi | Dấu thời gian tạo và ngày báo cáo. |
| `version` | chuỗi | Runtime/package danh tính cho chu kỳ này. |
| `boot_id`, `epoch_id` | chuỗi | Kỷ nguyên khởi động quy trình hiện tại và tính liên tục của máy chủ. Cả hai đều được yêu cầu để hoàn thành. |
| `poll_id` | số nguyên | Số nhận dạng cuộc thăm dò tích cực hiện tại. Zero/missing không thể hoàn thành lộ trình. |
| `source_freshness` | đối tượng | `status`, `checked_ts`, trạng thái nhật ký hoạt động, dấu thời gian cuộc thăm dò cuối cùng và dấu thời gian cuộc thăm dò ý kiến hoàn thành lần cuối. |
| `current_cycle_proof_complete` | boolean | Chỉ đúng khi dòng dõi và bằng chứng active-log/current-poll mới đồng ý. |
| `route` | enum | Một trong năm tuyến trên. |
| `route_proof_status` | enum | `full`, `limited_expected_empty` hoặc `missing`. |
| `coverage_status` | enum | Chính xác là `complete`, `complete_with_gaps`, `partial` hoặc `unavailable`. |
| `completed`, `expected_empty` | boolean | `completed` chỉ sai với `missing`; `expected_empty` chỉ đúng với `limited_expected_empty`. |
| `observed` | mảng chuỗi | Cụ thể được giữ lại facts/counts/statuses. |
| `interpretation` | mảng chuỗi | Ý nghĩa thận trọng được hiệu chỉnh theo bằng chứng. |
| `unknown` | mảng chuỗi | Thiếu danh tính, lịch sử, nguồn hoặc bối cảnh. |
| `does_not_prove` | mảng chuỗi | Các kết luận mà bằng chứng không thể hỗ trợ. |
| `next_action` | chuỗi | Hành động được giới hạn an toàn nhất của người vận hành. |
| `source_references` | mảng chuỗi | Tham chiếu runtime/Saved duy nhất được sắp xếp. |
| `enforcement_authority` | boolean | Luôn sai. Báo cáo không bao giờ cho phép ghi. |
| `output_paths` | hai chuỗi | JSON và TXT được thêm trước khi ghi ghép nối. |

`coverage_status` chỉ dành cho tính toán cấp cao nhất. Bản ghi nguồn sở hữu riêng `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` và `error`. Bằng chứng định tuyến sở hữu riêng `full`, `limited_expected_empty` và `missing`; các giá trị không bao giờ vượt qua các ranh giới này.

Phần mở rộng tuyến đường:

- `server_status`: `scheduler_status`, `active_log_status` và `server_metrics`. Các số liệu ghi lại thời điểm bắt đầu kỷ nguyên hiện tại, dấu thời gian và ID cuộc thăm dò đã hoàn thành gần đây nhất, số lượng người chơi đang hoạt động, số lượng active/backup-log, quét các giá trị pending/progress và configured/usable/unavailable tính toán nhóm nguồn. Họ không phát minh ra thời gian hoạt động, số lần khởi động lại, dấu thời gian sao lưu hoặc thời gian ngừng hoạt động khi không có nguồn nào tiết lộ những thông tin đó.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players` và mảng tương thích `players`. Mỗi phiên trong cùng ngày sẽ giữ ID phiên, ID tài khoản, tên hiển thị khi biết, dấu thời gian join/leave dấu thời gian, cờ thoát sạch và vòng đời cũng như tài liệu tham khảo nguồn. Danh tính được giữ lại và sự hiện diện PlayerData vẫn là bối cảnh chứ không phải bằng chứng về hoạt động ngày nay.
- `case_review`: `cases`, `review_subjects`, `current_case_count` và `retained_case_count`. Đối tượng đánh giá hiện tại ghi lại case/account ID, tên hiển thị khi biết, trạng thái, điểm số, độ tin cậy nhận dạng, first/last quan sát, số lượng cảnh báo, lý do, cờ hiện đang hoạt động và tài liệu tham khảo nguồn. Các trường hợp được giữ lại không tự tạo ra chủ đề hiện tại.
- `critical_guard`: `critical_failure_present` và `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window` và `daily_metrics`. Các số liệu này ghi lại ngày báo cáo, người chơi đang hoạt động, tài khoản có hoạt động trong cùng ngày, tham gia, rời đi, thoát sạch và không sạch, trả về vòng đời, chủ đề đánh giá được đặt tên hiện tại, trường hợp được giữ lại, current/retained số lượng danh tính và mức độ bao phủ của nhóm nguồn.

<a id="translated-txt-schema"></a>
## Đã dịch TXT lược đồ

Tệp văn bản được ghép nối dẫn đầu với kết quả mà người vận hành có thể đọc được và di chuyển chi tiết dòng dõi đến cuối. Nó giữ nguyên thứ tự phần chính xác này:

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

Bản dịch chỉ sử dụng các trường báo cáo có cấu trúc và ánh xạ từ điển đã được phê duyệt. Báo cáo có cấu trúc không thể thêm người chơi, trường hợp, phân phối, quan hệ nhân quả, quyền sở hữu, ý định hoặc tính đủ điều kiện thực thi. Các chi tiết kỹ thuật vẫn có sẵn mà không thay thế kết quả có thể đọc được.

<a id="source-accounting-schema"></a>
## Lược đồ kế toán nguồn

`runtime/final_logs/source_accounting_latest.json` sử dụng `randomdayguard.source-accounting/v1` với lý do tạo reason/status, enablement/disabled, sự khác biệt current/historical, bảng kê khai tệp đã thay đổi, bản ghi nguồn, usable/unavailable danh sách lớp và yêu cầu bồi thường giới hạn.

Mỗi bản ghi nguồn chứa:

| Trường | Loại | Ý nghĩa |
|---|---|---|
| `source_class` | chuỗi | Một trong tám lớp bên dưới. |
| `scope` | `current` hoặc `historical` | Quyền sở hữu thời gian; phạm vi không bao giờ được hợp nhất một cách âm thầm. |
| `required` | boolean | Chỉ `active_log` là cần thiết để làm mới tuyến đường theo chu kỳ hiện tại. |
| `status` | enum | Kết quả nguồn được liệt kê bên dưới. |
| `terminal` | boolean | Chỉ sai cho `partial` và `deferred`. |
| `available`, `readable` | boolean | Chỉ đúng cho `available` và `expected_empty`. |
| `file_count` | số nguyên | Tài khoản bị giới hạn file/reference đếm. |
| `source_references` | mảng | Nguồn duy nhất được sắp xếp paths/references. |
| `detail` | chuỗi | Kết quả bị chặn hoặc chi tiết lỗi. |
| `does_not_prove` | chuỗi | Tính khả dụng không phải là ý định, quyền sở hữu, thiệt hại, sự trùng lặp hoặc bằng chứng thực thi. |

Các lớp nguồn:

| Lớp nguồn | Phạm vi | Nó đóng góp gì | Điều nó không thể chứng minh |
|---|---|---|---|
| `active_log` | hiện tại, bắt buộc | Nhật ký máy chủ đang hoạt động có thể đọc được và dòng thăm dò ý kiến ​​mới. | Toàn bộ lịch sử hoặc lỗi của người chơi. |
| `admin_ini` | hiện tại, tùy chọn | Cấu trúc hiện tại hợp lệ moderator/ban trạng thái hoặc sự vắng mặt dự kiến. | Siêu dữ liệu về hành vi của người chơi hoặc lý do hợp lệ. |
| `recent_backup_logs` | lịch sử | Có thể đọc được rotated/backup tham chiếu nhật ký. | Hiện tại hoặc trạng thái khởi động hiện tại. |
| `playerdata_filenames` | bối cảnh hiện tại | Giới hạn tham chiếu tên tệp có thể đọc được trong thư mục gốc đã lưu. | Quyền sở hữu tệp, sự hiện diện trực tiếp, nội dung nhận dạng hoặc hành vi sai trái. |
| `existing_cases` | lịch sử | Trường hợp có tên được giữ lại files/index các bản ghi được ghi lại trước đầu ra hiện tại. | Hoạt động hiện tại hoặc tính chính xác của các kết luận cũ. |
| `existing_reports` | lịch sử | Đã giữ lại final/forensic/warning tài liệu tham khảo báo cáo. | Thay thế nguồn có thẩm quyền. |
| `existing_evidence` | lịch sử | Tài liệu tham khảo bằng chứng được giữ lại. | Tính đầy đủ của các sự kiện mà máy chủ chưa bao giờ tiết lộ. |
| `world_save_scan` | lịch sử | Giới hạn hoàn toàn, một phần, bị trì hoãn hoặc không có sẵn scan/checkpoint trạng thái. | Hành động hoặc quyền sở hữu của một người chơi cụ thể. |

Giá trị trạng thái nguồn:

| Trạng thái | Thiết bị đầu cuối | Ý nghĩa và hành động của toán tử |
|---|---:|---|
| `available` | có | Có nguồn hữu ích có thể đọc được; xem lại tài liệu tham khảo của nó. |
| `expected_empty` | có | Nguồn tùy chọn đã được kiểm tra và hợp pháp absent/empty. Không phát minh ra dữ liệu. |
| `partial` | không | Giới hạn công việc hoặc khoảng không quảng cáo bị ràng buộc chưa đầy đủ; cho phép tiếp tục. |
| `deferred` | không | Công việc đang chờ xử lý có chủ ý; đợi nhân viên sở hữu. |
| `unavailable` | có | Source/path/tool vắng mặt hoặc không sử dụng được; chỉ sửa chữa nếu lộ trình cần thiết. |
| `malformed` | có | Xác thực cấu trúc nội dung không thành công; giữ nguyên nó và sửa chữa định dạng. |
| `permission_denied` | có | Quyền truy cập bị từ chối rõ ràng; khôi phục quyền truy cập đọc có đặc quyền tối thiểu. |
| `error` | có | Giới hạn cấp nguồn probe/read bị lỗi đột ngột; kiểm tra `detail` mà không làm lộ bí mật. |

Cấp cao nhất `coverage_status` chính xác là `complete`, `complete_with_gaps`, `partial` hoặc `unavailable`. Cấp nguồn bắt buộc `error`, `malformed` hoặc `permission_denied` cuộn lên cấp cao nhất `unavailable`; cấp nguồn `deferred` cuộn lên cấp cao nhất `partial`. Việc vô hiệu hóa tính toán nguồn vẫn ghi trạng thái không khả dụng và buộc mọi tuyến đến `missing`.

<a id="historical-status-schema"></a>
## Lược đồ trạng thái lịch sử

`runtime/final_logs/historical_backfill_latest.json` sử dụng `randomdayguard.history/v1`: `generated_ts`, tính toán `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, mảng tính toán nguồn, các lớp không khả dụng và `next_action`.

`runtime/history/public_accounts.tsv` giới hạn là lịch sử công khai lâu dài với tiêu đề này:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Các hàng được sắp xếp theo tài khoản ID, các trường là single-line/tab-safe và các tham chiếu là sorted/unique. Tệp này lưu giữ bối cảnh lịch sử trong quá trình khởi động lại trong im lặng; nó không bao giờ biến lịch sử thành sự hiện diện hiện tại.

<a id="route-proof-schema"></a>
## Lược đồ chứng minh định tuyến

`runtime/final_logs/route_proof.json` sử dụng `randomdayguard.route-proof/v1` và ghi lại dấu thời gian, phiên bản, khởi động, kỷ nguyên, thăm dò, làm mới nguồn, tính đầy đủ của chu trình hiện tại, các trạng thái được phép và một mảng `routes`.

Mỗi mục nhập tuyến đường chứa route/status, version/boot/epoch/poll, đối tượng làm mới nguồn, tính đầy đủ của chu trình hiện tại, đường dẫn đầu ra và nguồn tài liệu tham khảo. Bản ghi tuyến đường bị vô hiệu hóa `status="missing"` và `reason="route_disabled"`. Nếu việc ghi bằng chứng định tuyến không thành công, mọi tuyến đường sẽ được viết lại thành incomplete/missing trước khi bất kỳ ứng cử viên thông báo nào được chấp nhận.

<a id="notification-schemas"></a>
## Lược đồ thông báo

Chế độ công khai tùy chọn chỉ là hộp thư đi tệp cục bộ.

`runtime/notifications/pending/<route>_latest.json` sử dụng `randomdayguard.notification/v1` với dấu thời gian được tạo, version/boot/epoch/ poll/source độ mới, tuyến đường, `completed_output`, trạng thái chống định tuyến, đường dẫn báo cáo có cấu trúc và được dịch, tài liệu tham khảo nguồn, `delivery_backend="none"` và `delivery_attempted=false`. Đầu ra đủ điều kiện sử dụng `status="ready_for_local_consumer"`, `delivery_eligible=true` và `delivery_allowed=true`. Tuyến đường được định cấu hình nhưng missing/ineligible vẫn ghi một phong bì kiểm tra với `status="suppressed_current_cycle"`, cả hai cờ phân phối đều sai và `suppression_reason="route_or_completion_policy_blocked"`. Do đó, sự hiện diện của một tệp trong `pending/` bản thân nó không có nghĩa là được xếp hàng đợi hoặc đủ điều kiện.

`runtime/notifications/notification_status.json` sử dụng `randomdayguard.notification-status/v1` có cùng dòng, `generic_local_outbox_only=true`, `delivery_attempted=false` và mỗi hàng `queued`/`outcome` trên mỗi tuyến. `full` đủ điều kiện; dự kiến-trống chỉ đủ điều kiện khi `include_expected_empty=true`; `missing` không bao giờ đủ điều kiện. Khi ghi lỗi định tuyến, kết quả trạng thái là `route_proof_write_failed`; phong bì kiểm tra bị chặn vẫn có thể được viết nhưng nó không được chấp nhận đầu ra.

<a id="runtime-output-inventory"></a>
## Kiểm kê đầu ra trong thời gian chạy

Chỉ mục truy xuất nguồn gốc có một hàng máy cho mỗi đường dẫn hoặc lớp tệp động. Khoảng không quảng cáo có thể đọc được này nhóm các tệp theo mục đích của nhà điều hành.

| Đường dẫn hoặc mẫu | Producer/trigger | Chính sách và trạng thái hữu ích | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Mục nhập của trình tải. | Khởi động bị ghi đè identity/probe. | Thiếu không chứng minh được tải; kiểm tra UE4SS nhật ký và khả năng hỗ trợ. |
| `runtime/config_load_error.txt` | Lỗi tải cấu hình. | Chỉ có lỗi, giữ nguyên lý do giới hạn. | Khôi phục cấu hình công khai hợp lệ và khởi động lại. |
| `runtime/saved_path_probe.json` | Độ phân giải gốc đã lưu. | Candidate/readability kế toán. | Chỉ đặt `SavedRoot.txt` hoặc sửa chữa một ứng cử viên chung. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Vòng đời khởi nghiệp. | Lỗi khởi động mới nhất và lỗi khởi động hiện tại. | Chỉ khởi động phù hợp mới sở hữu trạng thái quan trọng hiện tại. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report tích hợp. | Mới nhất version/capability/handoff trạng thái. | Các yêu cầu hoàn thành chặn phiên bản hoặc khả năng. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Thăm dò ý kiến ​​finalizer/error. | Mới nhất poll/scheduler/in-flight trạng thái và lỗi khởi động hiện tại. | Sửa chữa lệnh gọi lại bị giới hạn và yêu cầu cuộc thăm dò đã hoàn thành mới hơn. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Trình ghi sự kiện. | Bị giới hạn append/rotation. | Giữ lại các byte trước đó; sửa chữadisk/retention trước khi dựa vào khoảng trống. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Nhật ký tail/registry. | Các giá trị bù đắp mới nhất và nhận dạng nhật ký chuẩn. | Xây dựng lại một cách cẩn thận; nhật ký sao lưu vẫn còn mang tính lịch sử. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle bộ chuẩn hóa. | Ngữ cảnh chỉ nối thêm. | Thiếu ngữ cảnh không thể chứng minh graceful/crash trạng thái. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Chủ sở hữu kỷ nguyên. | Kỷ nguyên máy chủ hiện tại và được giữ lại. | Bắt đầu một kỷ nguyên mới sau khi sửa chữa; đừng viết lại lịch sử cũ. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Chủ sở hữu phiên. | Current/historical sự kiện phiên và ảnh chụp nhanh. | Các hàng chưa được ánh xạ vẫn chưa được xác định; không có phát minh nhận dạng. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session mô-đun tổng hợp và báo cáo. | Ảnh chụp nhanh hiện tại cộng với lịch sử lâu dài. | Giữ các phạm vi riêng biệt và khôi phục dựa trên bằng chứng chứ không phải phỏng đoán. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state người viết. | Các ảnh chụp nhanh hiện tại bị ghi đè. | Stale/missing không xác định, dự kiến ​​sẽ trống. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly. | Các chỉ mục có thể xây dựng lại. | Xây dựng lại từ các sự kiện đáng tin cậy. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Nhân viên quét. | Đã bắt đầu, partial/deferred, điểm kiểm tra, hoàn thành hoặc lỗi. | Tiếp tục điểm kiểm tra; chỉ xây dựng lại khi có lý do được ghi lại. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Hợp tác cơ sở. | Mới nhất scan/baseline và liên kết tệp đã thay đổi. | Stale/incompatible các bảng kê khai yêu cầu xây dựng lại rõ ràng. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Quét đối tượng. | Partial/final bối cảnh lớp. | Số lượng không phải là bằng chứng về hành động của người chơi; tiếp tục hoặc quét lại. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | So sánh đối tượng. | Chỉ nối thêm new/delta một phần rồi cuối cùng. | Xem lại mapping/baseline trước khi suy luận. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Chỉ mục gốc đã lưu. | Filename/admin bối cảnh cấu trúc. | Tên tệp là yếu; trạng thái quản trị viên không đúng định dạng đóng lệnh ghi. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | Người viết trạng thái thế giới. | Boot/current/session ảnh chụp nhanh và khác biệt. | Chỉ ngữ cảnh; tạo lại sau khi scan/source sửa chữa. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence người viết. | Bổ sung giới hạn và per-player/session xem lại tệp. | Thiếu báo cáo không phải là thiếu bằng chứng sự kiện; kiểm tra bằng chứng nguồn. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review. | Đánh giá tài liệu được nêu tên và xếp hàng ứng cử viên. | Vụ việc membership/threshold không bao giờ vượt qua các cổng dành riêng cho tài khoản. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Tùy chọn Admin.ini giao dịch. | Sao lưu, sổ cái thành công hoặc failure/rollback được trích dẫn. | Bất kỳ backup/write/readback/rollback lỗi sẽ đóng việc thực thi; khôi phục bản sao lưu. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Trình ghi điểm đánh dấu tùy chọn. | Chỉ yêu cầu cục bộ. | Không chứng minh mức tiêu thụ hoặc khởi động lại. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Bản tổng hợp pháp y. | Chỉ mục đánh giá có thể xây dựng lại hiện tại và ngày tháng. | Xây dựng lại từ bằng chứng nguồn; đừng bao giờ coi phần tóm tắt là có căn cứ. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Nhân viên báo cáo công khai. | Lược đồ và quy tắc hoàn thành ở trên. | Sửa lỗi không khớp đầu tiên lineage/source/write; thiếu vẫn còn thiếu. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Hộp thư đi cục bộ tùy chọn. | Trạng thái phong bì địa phương đủ điều kiện hoặc bị loại bỏ rõ ràng. | Missing/ineligible có thể có các tệp bị chặn nhưng không bao giờ được xếp hàng đợi; kiểm tra cờ giao hàng và suy ra không có giao hàng bên ngoài. |

Overwrite/append/retention hành vi được kiểm soát bởi bộ phận sản xuất trong [`CONFIG_FIELD_CATALOG.md`](DANH_M%E1%BB%A4C_TR%C6%AF%E1%BB%9CNG_C%E1%BA%A4U_H%C3%8CNH.md). Các gói ZIP chỉ chứa `.gitkeep` phần giữ chỗ trong `runtime/`; bất kỳ evidence/output byte trong gói phát hành không được xác thực.

<a id="failure-and-recovery-matrix"></a>
## Ma trận lỗi và phục hồi

| Thất bại | Trạng thái bắt buộc | Khôi phục an toàn | Suy luận không hợp lệ |
|---|---|---|---|
| Dòng dõi hiện tại absent/stale | Tất cả các tuyến `missing`. | Khôi phục active-log/current-poll kiểm chứng và tái tạo. | Các tệp tuyến đường cũ hiện chưa được hoàn thiện. |
| Nguồn tùy chọn dự kiến ​​trống | Nguồn `expected_empty`; tuyến đường đủ điều kiện có thể là `limited_expected_empty`. | Không sửa chữa trừ khi nguồn tồn tại. | Trống không có sẵn và không chứng minh sự vắng mặt lịch sử. |
| Quét chưa hoàn tất | Nguồn `partial` hoặc `deferred`. | Cho phép sơ yếu lý lịch có giới hạn; giữ chính sách tuyến đường hiện tại rõ ràng. | Một phần không phải là tham nhũng. |
| Nguồn bắt buộc không có sẵn | `coverage_status=unavailable`; tuyến đường phụ thuộc `missing`. | Sửa chữa đã chọn Saved/log truy cập. | Các nguồn lành mạnh khác không thay thế nguồn được yêu cầu. |
| Lỗi thăm dò nguồn bắt buộc | Trạng thái nguồn `error` với giới hạn `detail`; `coverage_status=unavailable`; tuyến đường phụ thuộc `missing`. | Sửa chữa source/probe được đặt tên và tạo một chu kỳ mới hơn. | Lỗi nguồn không phải là giá trị phạm vi cấp cao nhất thứ năm. |
| Không thể ghi báo cáo được ghép nối | `coverage_status=unavailable`; tuyến hội tụ đến `missing`. | Sửa chữa hệ thống tệp và viết lại cả hai thành viên trong cặp cùng với bằng chứng. | Một tệp anh em chưa hoàn thành và lỗi ghi không phải là cấp cao nhất `error`. |
| Việc ghi chống định tuyến không thành công | Mọi tuyến đường được viết lại đều bị thiếu; không có hộp thư đi đủ điều kiện; các tuyến được định cấu hình có thể nhận được phong bì kiểm tra bị chặn. | Sửa chữa ghi theo lộ trình và tạo lại các đầu ra cùng chu kỳ. | Báo cáo có vẻ hợp lệ JSON hoặc phong bì bị chặn không phải là bằng chứng về lộ trình. |
| Ghi thông báo không thành công | Kết quả `local_outbox_write_failed`. | Sửa chữa gốc đầu ra cục bộ; tạo lại từ báo cáo đã hoàn thành. | Không có giao dịch bên ngoài nào xảy ra. |
| Admin.ini giao dịch không thành công | Việc thực thi bị chặn bằng backup/write/readback/rollback được trích dẫn. | Khôi phục bản sao lưu đã được xác minh; vẫn chỉ ở chế độ xem xét. | Một ngưỡng hoặc báo cáo không thể biện minh cho việc bỏ qua quá trình khôi phục. |

Xem [`EVIDENCE_BOUNDARY.md`](RANH_GI%E1%BB%9AI_B%E1%BA%B0NG_CH%E1%BB%A8NG.md), [`ARCHITECTURE.md`](KI%E1%BA%BEN_TR%C3%9AC.md) và [`SOURCE_MODULE_REFERENCE.md`](THAM_KH%E1%BA%A2O_M%C3%94-%C4%90UN_NGU%E1%BB%92N.md).
