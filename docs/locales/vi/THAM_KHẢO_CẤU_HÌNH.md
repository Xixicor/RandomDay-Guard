<a id="configuration-concepts"></a>
# Khái niệm cấu hình

> **Nguồn tiếng Anh chuẩn:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Phần giải thích này mô tả từng khu vực cấu hình chính kiểm soát những gì, khi nào nó chạy và cách nó tương tác với các cổng bằng chứng và an toàn. Nó không sở hữu danh mục trường chính xác hoặc quy trình hồ sơ.

Đối với các cài đặt trước theo định hướng nhiệm vụ và các bước thay đổi an toàn, hãy sử dụng [`CONFIG_PROFILES.md`](H%E1%BB%92_S%C6%A0_C%E1%BA%A4U_H%C3%8CNH.md). Đối với mọi trường nguồn chính xác, mặc định, loại, bất biến, hiệu ứng đầu ra và quy tắc khôi phục, hãy sử dụng [`CONFIG_FIELD_CATALOG.md`](DANH_M%E1%BB%A4C_TR%C6%AF%E1%BB%9CNG_C%E1%BA%A4U_H%C3%8CNH.md) được tạo; trình xác thực yêu cầu một hàng ở đó cho mỗi `config.lua` trường lá.

<a id="reading-this-page"></a>
## Đọc trang này

Mỗi vùng cấu hình trả lời:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## An toàn cấp cao nhất

| Tùy chọn | Mặc định | Ý nghĩa |
|---|---:|---|
| `enabled` | `true` | Công tắc chính cho bộ bảo vệ |
| `enforcement.review_only_mode` | `true` | Record/recommend chỉ |
| `enforcement.auto_ban` | `false` | Không tự động cấm theo mặc định |
| `enforcement.write_admin_ini` | `false` | Không viết Admin.ini theo mặc định |

Giữ an toàn những thông tin này cho đến khi chủ sở hữu máy chủ xem xét kết quả.

<a id="saved"></a>
## `saved`

Kiểm soát cách người bảo vệ tìm thấy máy chủ `Saved/` thư mục và họ tệp nào nó có thể quét.

Sử dụng khi:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Kiểm tra:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Quy tắc:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Kiểm soát việc đọc nhật ký trực tiếp.

Các tùy chọn hữu ích:

| Tùy chọn | Giá trị an toàn | Tại sao |
|---|---|---|
| `enabled` | `true` | Cần thiết để phòng thủ trực tiếp |
| `start_at_end_on_first_run` | `true` | Tránh ghi nhật ký cũ dưới dạng sự kiện trực tiếp |
| `tail_backup_logs` | `false` | Nhật ký sao lưu là lịch sử, không tồn tại |
| `max_lines_per_poll` | giới hạn | Giữ cho vòng thăm dò phản hồi nhanh |

Kiểm tra:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Kiểm soát việc bỏ phiếu và ngân sách.

Quy tắc sức khỏe chính:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Kiểm tra:

```text
runtime/current/poll_status.json
```

Nếu `poll_id` dừng, có thứ gì đó đang chặn vòng lặp.

<a id="source_accounting"></a>
## `source_accounting`

Kiểm soát phạm vi và mức độ bao phủ của nguồn bằng chứng rõ ràng.

| Khóa | Mặc định | Ý nghĩa |
|---|---:|---|
| `enabled` | `true` | Viết kế toán nguồn cho các báo cáo tuyến đường công cộng. |
| `require_terminal_status` | `true` | Yêu cầu mỗi nguồn hiển thị một thiết bị đầu cuối rõ ràng hoặc trạng thái chưa hoàn chỉnh. |
| `distinguish_current_from_historical` | `true` | Giữ riêng bằng chứng hiện tại và lịch sử. |
| `slow_world_scan_blocks_current_reports` | `false` | Cho phép các báo cáo hiện tại nêu rõ rằng quá trình quét thế giới bị giới hạn bị trì hoãn hoặc một phần. |
| `changed_file_manifest` | đường dẫn kê khai cơ sở | Tham chiếu được sử dụng cho giới hạn historical/world kế toán. |

Trạng thái nguồn là `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` hoặc `error`.

Cài đặt `source_accounting.enabled = false` không loại bỏ trạng thái đầu ra một cách âm thầm. Đường ống vẫn viết `runtime/final_logs/source_accounting_latest.json` với `enabled=false`, `status="unavailable"` và `disabled_reason="source_accounting_disabled"`. Nó cũng ghi lại bản ghi trạng thái lịch sử mà không có kế toán sẵn có. Vì hạch toán nguồn là một phần của hợp đồng báo cáo nên mọi tuyến đường đều không thể đóng thành `missing`; không có tuyến đường nào được coi là đã hoàn thành trong khi việc tính toán bị vô hiệu hóa.

<a id="reports"></a>
## `reports`

Kiểm soát quy trình báo cáo cục bộ chung.

Mặc định cho phép tất cả năm tuyến đường và ghi vào `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Mỗi tuyến phải viết đầu ra có cấu trúc và được dịch cùng với bằng chứng trong `route_proof.json`. Vô hiệu hóa một tuyến đường sẽ tạo ra `missing` bằng chứng thay vì giả vờ rằng nó đã hoàn thành.

<a id="notification"></a>
## `notification`

Hộp thư đi tệp cục bộ chung tùy chọn. Nó bị tắt theo mặc định và không gửi gì đến nhà cung cấp bên ngoài.

Mặc định:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Mọi tuyến thông báo đều bị tắt theo mặc định. Khi được kích hoạt có chủ ý, hộp thư đi chỉ có thể sử dụng báo cáo đã dịch hoàn chỉnh sau `route_proof.json` được viết. Bằng chứng và báo cáo địa phương vẫn có thẩm quyền. Việc phân phối dành riêng cho nhà cung cấp, điểm cuối phân phối, thông tin xác thực và cầu nối không nằm trong hợp đồng với cơ quan giám sát độc lập công khai.

<a id="scanning"></a>
## `scanning`

Kiểm soát quá trình quét đường cơ sở, điểm kiểm tra và làm mới tệp đã thay đổi.

Sử dụng khi:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Kiểm tra:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Cài đặt quan trọng:

```lua
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
```

<a id="forensic_rollup"></a>
## `forensic_rollup`

Kiểm soát gói tải lên nhanh chóng hàng ngày và nhật ký bằng ngôn ngữ đơn giản cuối cùng.

Kết quả:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Sử dụng khi:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Kiểm tra:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Quy tắc:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Kiểm soát số lượng sự kiện và tổng hợp mức độ quan trọng thấp.

Sử dụng khi:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Mẫu an toàn:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Kiểm soát thời gian lưu giữ tệp và thời điểm JSONL nhật ký xoay.

Sử dụng khi:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Các tùy chọn quan trọng:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Kiểm soát việc phát hiện cửa sổ cảnh báo.

Ví dụ:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Quy tắc:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Điều khiển lặp lại crash/reconnect đánh giá.

Mặc định an toàn:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Bộ đếm hữu ích:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Kiểm soát việc theo dõi làn sóng rời bỏ và tham gia.

Mặc định an toàn:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Sử dụng cho:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

Nhóm các tài khoản đang hoạt động trong các cửa sổ liên quan.

Quy tắc:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Mỗi tài khoản được thực thi vẫn cần có bằng chứng cụ thể cho từng tài khoản.

<a id="object_registry"></a>
## `object_registry`

Kiểm soát object/class trích xuất mã thông báo từ Bằng chứng đã lưu có thể đọc được.

Kết quả:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Quy tắc:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Kiểm soát boot/current/session ảnh chụp nhanh trạng thái thế giới.

Kết quả:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Sử dụng để đánh giá phiên và bối cảnh thế giới.

<a id="enforcement"></a>
## `enforcement`

Kiểm soát đề xuất và Admin.ini ghi.

Trước khi Guard có thể thêm lệnh cấm, mọi tuyên bố bên dưới đều phải đúng:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
account identity is mapped
not trusted
not moderator
threshold is met
```

Nếu một tuyên bố sai hoặc không thể kiểm tra được, Guard sẽ rời đi `Admin.ini` không thay đổi và ghi lại lý do.

<a id="admin_ini"></a>
## `admin_ini`

Kiểm soát việc ghi tệp an toàn.

Quy tắc:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Kiểm soát các tệp đánh dấu cục bộ tùy chọn mà quy trình do nhà điều hành khác sở hữu có thể kiểm tra. Nó không khởi động lại hoặc tắt máy chủ.

Mặc định:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Kết quả:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Không có bảng điều khiển lưu trữ, cầu nối nhà cung cấp hoặc tự động khởi động lại nào được đóng gói. Việc bật tính năng tạo điểm đánh dấu không chứng minh được rằng quy trình bên ngoài đã xử lý yêu cầu hoặc đã khởi động lại máy chủ.

<a id="related-docs"></a>
## Tài liệu liên quan

* [`CONFIG_PROFILES.md`](H%E1%BB%92_S%C6%A0_C%E1%BA%A4U_H%C3%8CNH.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md)
* [`ADMIN_INI_ENFORCEMENT.md`](TH%E1%BB%B0C_THI_INI_C%E1%BB%A6A_QU%E1%BA%A2N_TR%E1%BB%8A_VI%C3%8AN.md)
