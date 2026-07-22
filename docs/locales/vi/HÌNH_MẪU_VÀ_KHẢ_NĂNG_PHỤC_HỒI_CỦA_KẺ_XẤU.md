<a id="bad-actor-patterns-and-resilience"></a>
# Mô hình tác nhân xấu và khả năng phục hồi

> **Nguồn tiếng Anh chuẩn:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Sử dụng trang này để hiểu cách trình bảo vệ giúp xem xét hành vi lạm dụng sự cố, hành vi liền kề với hoạt động khai thác và lập kế hoạch khôi phục.

<a id="what-the-guard-can-help-with"></a>
## Người bảo vệ có thể giúp gì

| Mẫu | Những gì cần kiểm tra |
|---|---|
| Trả về tương quan với sự cố | Cùng một tài khoản hoạt động trước khi gặp sự cố và quay lại sau khi khởi động lại |
| Thăm dò kết nối lại nhanh chóng | Đã lặp lại join/leave hoặc timeout/reconnect vòng lặp |
| Cụm nhiều tài khoản | Tham gia các đợt, cửa sổ cảnh báo được chia sẻ, cửa sổ lỗi được chia sẻ |
| Cảnh báo căng thẳng bùng phát | Đã lặp lại ActorChannelFailure hoặc cửa sổ lưu cảnh báo |
| Bối cảnh ngoài giới hạn | PlayerData/map/world ngữ cảnh khi có thể đọc được |
| Chồng chéo lưu chạm | Các phiên ánh xạ chồng chéo bối cảnh lưu thế giới |
| Nhầm lẫn danh tính | Tên cần ánh xạ ConnectID |

<a id="why-it-avoids-memory-access"></a>
## Tại sao nó tránh truy cập bộ nhớ

RandomDayGuard hoạt động từ các tệp do máy chủ sở hữu:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Điều đó làm cho nó ít phụ thuộc hơn vào trạng thái bộ nhớ phía máy khách và ít dễ bị hỏng hơn khi cập nhật trò chơi.

Đánh đổi:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Người trả về có liên quan đến sự cố

Mẫu:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Các tệp hữu ích:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Thăm dò kết nối lại nhanh chóng

Mẫu:

```text
join -> leave -> join -> leave -> join
```

Các tệp hữu ích:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Cụm nhiều tài khoản

Mẫu:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Các tệp hữu ích:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Quy tắc:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Đề xuất sao lưu cố định

Tạo bản sao lưu cố định sau:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Sao lưu:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Mô hình khôi phục

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use daily rollups for review
-> restore sticky backup if needed
```

<a id="related-docs"></a>
## Tài liệu liên quan

* [`FORENSIC_DAILY_ROLLUPS.md`](B%E1%BA%A2N_T%E1%BB%94NG_H%E1%BB%A2P_PH%C3%81P_Y_H%C3%80NG_NG%C3%80Y.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](THAY_%C4%90%E1%BB%94I_TH%C6%AF_M%E1%BB%A4C_L%C6%AFU_TH%E1%BA%BE_GI%E1%BB%9AI.md)
