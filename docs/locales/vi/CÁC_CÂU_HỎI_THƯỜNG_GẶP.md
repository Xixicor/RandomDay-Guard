<a id="faq"></a>
# FAQ

> **Nguồn tiếng Anh chuẩn:** [FAQ.md](../../FAQ.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


<a id="is-randomdayguard-the-randomday-mod"></a>
## Là RandomDayGuard Bản sửa đổi RandomDay?

Không. RandomDay Mod thay đổi trải nghiệm máy chủ. RandomDayGuard xem lớp bằng chứng của máy chủ.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## Tính năng bảo vệ trực tiếp có hoạt động trước khi quá trình quét hoàn tất không?

Có. Phòng thủ trực tiếp sử dụng nhật ký và sự kiện phiên. Quá trình quét cơ bản sẽ cải thiện bối cảnh sau này.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## Tại sao lần quét đầu tiên có thể mất nhiều thời gian?

Lần quét đầu tiên xây dựng world/object bối cảnh, tệp kê khai tệp và dữ liệu cơ sở có thể sử dụng lại.

<a id="what-do-i-check-first-after-startup"></a>
## Tôi phải kiểm tra điều gì đầu tiên sau khi khởi động?

```text
runtime/current/poll_status.json
```

Hãy tìm:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## Các bản tóm tắt của người chơi ở đâu?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## Gói đánh giá nhanh hàng ngày ở đâu?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## Tôi nên tải lên tệp nào để xem xét nhanh nhất?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## Nó có thể tự động ghi lệnh cấm không?

Chỉ khi được bật rõ ràng.

Mặc định:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## Admin.ini nhận được?

Chỉ:

```ini
BannedPlayer=<ID>
```

Không có tên, nhận xét, lý do hoặc hậu tố.

<a id="is-a-display-name-enough-to-ban"></a>
## Tên hiển thị có đủ để cấm không?

Không. Sử dụng nhật ký máy chủ `Login request` với `ConnectID` hoặc bằng chứng máy chủ tương đương.

<a id="can-one-crash-ban-someone"></a>
## Một sự cố có thể cấm ai đó không?

Không theo mặc định.

<a id="can-object-count-alone-ban-someone"></a>
## Chỉ tính đối tượng có thể cấm ai đó không?

Không theo mặc định.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## Có nên SavedRoot.txt trỏ tới thư mục world không?

Không. Trỏ nó tới `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## Điều gì sẽ xảy ra nếu thư mục thế giới thay đổi?

Hãy coi đó là thay đổi nhận dạng cơ bản. Giữ nguyên đường cơ sở cũ và xây dựng đường cơ sở mới.

<a id="related-docs"></a>
## Tài liệu liên quan

* [`START_HERE.md`](B%E1%BA%AET_%C4%90%E1%BA%A6U_T%E1%BA%A0I_%C4%90%C3%82Y.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](B%E1%BA%A2N_T%E1%BB%94NG_H%E1%BB%A2P_PH%C3%81P_Y_H%C3%80NG_NG%C3%80Y.md)
* [`TROUBLESHOOTING.md`](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md)
