<a id="forensic-daily-rollups"></a>
# Bản tổng hợp pháp y hàng ngày

> **Nguồn tiếng Anh chuẩn:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Bản tổng hợp hàng ngày là một chỉ mục có thể xây dựng lại. Bằng chứng nguồn vẫn có thẩm quyền; thư mục hàng ngày và nhật ký cuối cùng là các gói đánh giá nhanh được tạo từ bằng chứng thời gian chạy.

Sử dụng trang này khi bạn muốn tải lên một thư mục để phân tích nhanh.

<a id="what-it-is"></a>
## Nó là gì
Bản tổng hợp hàng ngày là bản tóm tắt có thể xây dựng lại bằng chứng thô trong một ngày.

Nó không thay thế bằng chứng thô.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Nơi nó ghi
Ngày hiện tại:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Gói hàng ngày:

```text
runtime/forensic_days/YYYY-MM-DD/
- forensic_day_summary.json
- forensic_day_summary.md
- forensic_day_summary.txt
- players.tsv
- sessions.tsv
- crash_reconnects.tsv
- warning_bursts.tsv
- raid_cases.tsv
- world_context.tsv
- ban_recommendations.tsv
- enforcement_audit.tsv
- evidence_index.json

## Final log contents
```text
runtime/final_logs/YYYY-MM-DD/
- final_forensic_log.txt
- final_forensic_log.md
- final_forensic_log.json

TXT được viết bằng ngôn ngữ đơn giản để nhà điều hành xem xét nhanh.

<a id="what-the-final-txt-should-answer"></a>
## Tệp TXT cuối cùng sẽ trả lời
```text
Did the guard run?
Was the scan partial or complete?
Who joined?
Who left cleanly?
Who did not leave cleanly?
Who rapidly reconnected?
Who overlapped crashes?
Who returned after crashes?
Who had warning overlap?
Who appears in a cluster?
Who is REVIEW?
Who is BAN-ELIGIBLE?
Which BannedPlayer=<ID> lines are candidates?
Which gates blocked enforcement?
What evidence files support each recommendation?
```

<a id="source-files-used"></a>
## Các tệp nguồn được sử dụng
Bản tổng hợp có thể đọc những thứ này khi có:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
runtime/warning_events.jsonl
runtime/raid_cases/
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry.json
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

Các tệp bị thiếu phải được đánh dấu là thiếu, không được coi là nghiêm trọng.

<a id="update-behavior"></a>
## Hành vi cập nhật
Trong cùng một ngày, người bảo vệ cập nhật các tệp giống nhau.

Đúng:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Sai:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## An toàn khi xảy ra sự cố
Người bảo vệ nên ghi tệp tạm thời trước, sau đó đổi tên:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Điều này bảo vệ bản tóm tắt tốt cuối cùng nếu máy chủ gặp sự cố khi đang ghi.

<a id="playerstsv-columns"></a>
## `players.tsv` cột
```text
date
account_id
ban_id
name
identity_confidence
playerdata_verified
first_seen
last_seen
join_count
leave_count
clean_leave_count
unclean_disconnect_count
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
raid_case_count
world_context_count
score
status
recommended_action
ban_eligible
already_enforced
admin_ini_line
```

<a id="ban_recommendationstsv-columns"></a>
## `ban_recommendations.tsv` cột
```text
date
account_id
ban_id
name
status
recommended_action
reason
admin_ini_line
gates_passed
blocked_by
evidence_files
```

<a id="review-rule"></a>
## Quy tắc xem xét
Bản tổng hợp hàng ngày có thể giúp quá trình xem xét diễn ra nhanh chóng nhưng đó không phải là bằng chứng duy nhất.

Khi có đề xuất quan trọng, hãy xác minh bằng:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## Tài liệu liên quan
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](TI%E1%BA%BET_KI%E1%BB%86M_B%E1%BB%98_NH%E1%BB%9A_V%C3%80_%C4%90%E1%BA%A6U_RA.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md)
