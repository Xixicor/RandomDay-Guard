<a id="memory-economy-and-output-files"></a>
# Tệp đầu ra và mức tiết kiệm bộ nhớ

> **Nguồn tiếng Anh chuẩn:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Trang này giải thích tệp nào tăng trưởng, tệp nào bị ghi đè và nội dung nào cần tải lên để xem xét nhanh.

<a id="fast-answer"></a>
## Câu trả lời nhanh

| Câu hỏi | Mở |
|---|---|
| Người bảo vệ còn sống không? | `runtime/current/poll_status.json` |
| Ai đã được nhìn thấy? | `runtime/account_evidence.json` |
| Điều gì đã xảy ra với phiên? | `runtime/evidence/session_events.jsonl` |
| Chuyện gì đã xảy ra hôm nay? | `runtime/forensic_days/YYYY-MM-DD/` |
| Tóm tắt bằng ngôn ngữ đơn giản là gì? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| Tiến trình quét là gì? | `runtime/scan_progress.json` |
| Bối cảnh thế giới là gì? | `runtime/world_state/current/world_state_latest.json` |
| Những lệnh cấm nào được viết ra? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Mô hình đầu ra

| Loại | Hành vi | Ví dụ |
|---|---|---|
| Ảnh chụp nhanh hiện tại | Ghi đè | `runtime/current/*.json` |
| Nhật ký sự kiện | Chỉ nối thêm | `runtime/evidence/*.jsonl` |
| Bảng | Đã cập nhật hoặc nối thêm | `*.tsv` |
| Cơ sở | Sử dụng lại sau khi hoàn thành | `runtime/baselines/*` |
| Bản tổng hợp hàng ngày | Đã cập nhật tại chỗ | `runtime/forensic_days/YYYY-MM-DD/*` |
| Nhật ký cuối cùng | Bản tóm tắt hàng ngày bằng ngôn ngữ đơn giản | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Ảnh chụp nhanh hiện tại

Những bản tóm tắt này ở dạng nhỏ và trả lời "điều gì là đúng".

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

<a id="player-summaries"></a>
## Bản tóm tắt về người chơi

Đây là những tệp đầu tiên được kiểm tra để xem xét tài khoản.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Chúng tóm tắt:

```text
account_id
ban_id
name
identity_confidence
first_seen
last_seen
join_count
leave_count
status
score
```

<a id="event-logs"></a>
## Nhật ký sự kiện

Những bản tóm tắt này duy trì dòng thời gian.

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
```

<a id="daily-forensic-rollups"></a>
## Hàng ngày bản tổng hợp điều tra

Đây là các gói tải lên nhanh.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Tải lên một trong những thư mục đó khi bạn muốn phân tích nhanh chóng.

<a id="scan-and-baseline-files"></a>
## Quét và các tệp cơ sở

Sử dụng các gói này để hiểu bối cảnh thế giới là một phần hay toàn bộ.

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

<a id="enforcement-files"></a>
## Các tệp thực thi

Chỉ sử dụng các tệp này khi việc thực thi được kích hoạt.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` sẽ chỉ nhận được:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Những cập nhật nào khi người chơi tham gia

Những cập nhật dự kiến:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-server-crashes-or-restarts"></a>
## Những cập nhật nào khi máy chủ gặp sự cố hoặc khởi động lại

Những cập nhật dự kiến:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Những cập nhật nào khi quá trình quét diễn ra

Những cập nhật dự kiến:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Nội dung cần tải lên nhanh chóng phân tích

Gói tốt nhất:

```text
runtime/final_logs/YYYY-MM-DD/
```

Gói hoàn chỉnh hơn:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Gói bằng chứng đầy đủ:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Tài liệu liên quan

* [`FORENSIC_DAILY_ROLLUPS.md`](B%E1%BA%A2N_T%E1%BB%94NG_H%E1%BB%A2P_PH%C3%81P_Y_H%C3%80NG_NG%C3%80Y.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
