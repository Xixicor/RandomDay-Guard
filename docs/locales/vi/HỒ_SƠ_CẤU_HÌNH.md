<a id="configuration-profiles"></a>
# Hồ sơ cấu hình

> **Nguồn tiếng Anh chuẩn:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Hãy sử dụng hướng dẫn cách thực hiện này để chọn và áp dụng cấu hình cấu hình thực tế. Để biết giải thích về cách các nhóm cài đặt tương tác, hãy đọc [`CONFIG_REFERENCE.md`](THAM_KH%E1%BA%A2O_C%E1%BA%A4U_H%C3%8CNH.md). Đối với các trường, mặc định, loại và bất biến chính xác, hãy sử dụng [`CONFIG_FIELD_CATALOG.md`](DANH_M%E1%BB%A4C_TR%C6%AF%E1%BB%9CNG_C%E1%BA%A4U_H%C3%8CNH.md).

Mỗi khối Lua bên dưới là một tập hợp các mục nhập cấp cao nhất có thể thay thế các mục nhập phù hợp bên trong `return { ... }` được vận chuyển.

<a id="profile-chooser"></a>
## Trình chọn hồ sơ

| Tình huống | Sử dụng hồ sơ này |
|---|---|
| Trước tiên, hãy sử dụng hồ sơ này cài đặt | Cài đặt an toàn lần đầu |
| Máy chủ không ổn định và thường xuyên gặp sự cố | Bằng chứng hiện tại không quét chậm |
| Bạn muốn object/world bối cảnh | Cơ sở đầy đủ |
| Bạn muốn xem lại nhật ký cũ | Chèn lấp pháp y |
| Bạn muốn đề xuất nhưng không viết được | Thử nghiệm thực thi |
| Bạn đã sẵn sàng để người bảo vệ viết lệnh cấm | Đã bật thực thi |
| Đĩa bị giới hạn | Tăng trưởng đĩa thấp |
| Bạn đã hoàn thành đường cơ sở rõ ràng | Thiết lập sao lưu cố định |

<a id="safe-first-install"></a>
## Cài đặt an toàn lần đầu

Hãy sử dụng tính năng này trước trên máy chủ trực tiếp.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
},

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Việc này có tác dụng gì:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Bằng chứng hiện tại không quét chậm

Sử dụng tính năng này nếu máy chủ không ổn định và bạn cần crash/reconnect bằng chứng trước khi quét kỹ.

```lua
log_tail = {
    enabled = true,
},

scanning = {
    full_scan_on_start = false,
},

enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Việc này có tác dụng gì:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Cơ sở đầy đủ

Sử dụng tính năng này sau khi máy chủ có thể hoạt động đủ lâu để quét.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Việc này có tác dụng gì:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Chèn lấp pháp y

Chỉ sử dụng tùy chọn này khi có chủ ý xem lại nhật ký lịch sử.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Trước khi sử dụng:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Thử nghiệm thực thi

Sử dụng cái này trước Admin.ini đang viết.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Nội dung cần kiểm tra:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Đã bật thực thi

Chỉ sử dụng tùy chọn này sau khi kết quả đánh giá chính xác.

```lua
enforcement = {
    review_only_mode = false,
    auto_ban = true,
    write_admin_ini = true,
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
},
```

Trước khi bật:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Tăng trưởng đĩa thấp

Sử dụng tính năng này khi các tệp thời gian chạy đang phát triển quá nhanh.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    compact_json_outputs = true,
},
```

<a id="sticky-backup-setup"></a>
## Thiết lập sao lưu cố định

Sử dụng sau đường cơ sở hoàn thành đầu tiên.

Kiểm tra xem những thứ này có tồn tại không:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Sau đó sao lưu chúng bằng `config.lua`, `SavedRoot.txt` và `Admin.ini`.

<a id="related-docs"></a>
## Tài liệu liên quan

* [`CONFIG_REFERENCE.md`](THAM_KH%E1%BA%A2O_C%E1%BA%A4U_H%C3%8CNH.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](B%E1%BA%A2N_T%E1%BB%94NG_H%E1%BB%A2P_PH%C3%81P_Y_H%C3%80NG_NG%C3%80Y.md)
* [`ADMIN_INI_ENFORCEMENT.md`](TH%E1%BB%B0C_THI_INI_C%E1%BB%A6A_QU%E1%BA%A2N_TR%E1%BB%8A_VI%C3%8AN.md)
