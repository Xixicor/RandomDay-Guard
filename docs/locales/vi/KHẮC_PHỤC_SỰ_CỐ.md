<a id="troubleshooting"></a>
# Khắc phục sự cố

> **Nguồn tiếng Anh chuẩn:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Sử dụng trang này khi Guard không tải, không thể thu thập nguồn, báo cáo không xuất hiện hoặc bằng chứng lộ trình mâu thuẫn với những gì bạn mong đợi. Bắt đầu với cây quyết định và đi theo một nhánh. Sử dụng [tham chiếu trạng thái và lỗi](THAM_KH%E1%BA%A2O_TR%E1%BA%A0NG_TH%C3%81I_V%C3%80_L%E1%BB%96I.md) chỉ sau khi biết lớp bị lỗi.

Bảo toàn các tệp thời gian chạy hiện tại trước khi thay đổi cấu hình hoặc cài đặt lại. Một hiện vật cũ hoặc bị thiếu xác định một giai đoạn thất bại; việc khởi động lại nhiều lần có thể xóa đi bằng chứng đó.

<a id="choose-the-failure-path"></a>
## Chọn đường dẫn thất bại

<a id="1-decide-whether-guard-loaded"></a>
### 1. Quyết định xem Guard có được tải hay không

- **Không tồn tại tệp `runtime/`:** tuân theo [Khôi phục các tệp thời gian chạy bị thiếu](#restore-missing-runtime-files). Xác minh đường dẫn cài đặt, trình tải chuẩn, `enabled.txt` và `mods.txt` trước khi điều tra các báo cáo.
- **Tồn tại các tệp trạng thái hiện tại:** Bảo vệ được tải đủ xa để ghi trạng thái. Tiếp tục bước 2; cài đặt lại không phải là phản hồi đầu tiên.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Quyết định xem lịch trình có tiến triển hay không

Mở:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Tiến bộ bộ đếm và dấu thời gian:** tiếp tục đến bước 3.
- **`poll_id` là tĩnh, `poll_in_flight` vẫn đúng hoặc trạng thái bộ lập lịch không chạy:** tuân theo [Khôi phục vòng lặp thăm dò bị mắc kẹt](#recover-a-stuck-poll-loop).
- **Đang chờ quét cơ sở trong khi tiến trình của bộ lập lịch vẫn tiếp tục:** đây là một cảnh báo chứ không phải tự động khởi động thất bại. Chỉ điều tra nếu tiến trình quét hoặc tồn đọng dừng lại.

<a id="3-classify-route-proof"></a>
### 3. Phân loại bằng chứng lộ trình

Mở `runtime/final_logs/route_proof.json` và kiểm tra từng tuyến đường riêng biệt.

- **`full`:** so sánh cách diễn đạt không mong muốn với `source_references` và dòng dõi. Đừng thay đổi cách phân phối chỉ vì cách diễn đạt có vẻ sai.
- **`limited_expected_empty`:** hiện tại để xác nhận tính toán nguồn hỗ trợ kết quả trống hợp pháp. Không tạo trình phát hoặc trường hợp tổng hợp.
- **`missing`:** tuân theo [Chẩn đoán tuyến đường bị thiếu](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Phân loại vùng phủ sóng nguồn

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` hoặc `error`:** tuân theo [Giải thích phạm vi nguồn không đầy đủ](#interpret-incomplete-source-coverage), sau đó tra cứu mã chính xác trong [Tham chiếu trạng thái và lỗi](THAM_KH%E1%BA%A2O_TR%E1%BA%A0NG_TH%C3%81I_V%C3%80_L%E1%BB%96I.md).
- **Nguồn có cấu trúc là hiện tại nhưng đầu ra đã dịch hoặc đang chờ xử lý cũ hơn:** chẩn đoán chuyển giao hoàn thành chứ không phải điểm cuối phân phối. Giữ nguyên cả dấu thời gian cũng như kiểm tra trạng thái báo cáo và gửi trước khi thay đổi cấu hình phân phối.

<a id="5-follow-the-matching-branch"></a>
### 5. Theo nhánh phù hợp

- Danh tính không đầy đủ: [Lập bản đồ trình phát chưa được ánh xạ](#map-an-unmapped-player).
- Thiếu tính liên tục hàng ngày: [Khôi phục tổng hợp hàng ngày bị thiếu](#restore-a-missing-daily-rollup).
- Thử nghiệm thực thi được phê duyệt rõ ràng không ghi: [Chẩn đoán Admin.ini ghi bị chặn](#diagnose-a-blocked-adminini-write).
- ZIP quá trình trích xuất không thành công: [Giải quyết xung đột trường hợp trích xuất Windows](#resolve-a-windows-extraction-folder-collision).
- Kiểm tra bản sửa lỗi, gói hoặc kho lưu trữ không thành công: [Đánh giá xác thực và phát hành](X%C3%81C_TH%E1%BB%B0C_V%C3%80_PH%C3%81T_H%C3%80NH.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Dừng lại với một kết quả đã được chứng minh

Thẻ khắc phục sự cố kết thúc khi:

- tuyến đường hiện tại và `full`;
- tuyến đường hiện tại và `limited_expected_empty` vì một lý do được nêu tên;
- một trình chặn chính xác, đường dẫn bằng chứng và hành động tiếp theo được ghi lại; hoặc
- khôi phục đã khôi phục trạng thái đã biết trước đó và bảo toàn bằng chứng thất bại.

“Máy chủ đang chạy”, nhịp tim tăng dần hoặc HTTP chỉ thành công không chứng tỏ lộ trình báo cáo đã hoàn thành.

<a id="diagnose-a-missing-route"></a>
## Chẩn đoán tuyến đường bị thiếu

Mở `runtime/final_logs/route_proof.json` và so sánh `server_status`, `daily_rollup`, `player_activity`, `case_review` và `critical_guard`.

1. Đọc lý do, dòng dõi, thời gian tạo và nguồn của tuyến đường tham khảo.
2. Xác nhận rằng nguồn có cấu trúc được đặt tên tồn tại và thuộc cùng một chu kỳ.
3. So sánh thời gian của nó với đầu ra đã dịch và phong bì đang chờ xử lý.
4. Nếu nhật ký cuối cùng mới hơn đầu ra đã dịch hoặc đang chờ xử lý, trước tiên hãy ghi lại công văn hoàn thành cũ và sửa chữa chuyển giao đó.
5. Nếu tất cả đầu ra cục bộ đều hiện hành nhưng không có quá trình phân phối thì hãy kiểm tra cấu hình tuyến đường và người gửi trạng thái.

Không quảng bá tình trạng của trình lập lịch trình hoặc một thông báo thành công cho bằng chứng năm tuyến.

<a id="interpret-incomplete-source-coverage"></a>
## Giải thích phạm vi nguồn không đầy đủ

| Trạng thái | Việc cần làm |
|---|---|
| `partial` | Chỉ sử dụng bằng chứng đã thu thập và tránh các tuyên bố về phạm vi bảo hiểm hoàn chỉnh. |
| `deferred` | Xác nhận các tiến bộ công việc được giới hạn sau này trước khi thay đổi cấu hình. |
| `unavailable` | Ghi lại giới hạn môi trường; chỉ sửa đường dẫn đã được chứng minh hoặc vấn đề về quyền. |
| `malformed` | Giữ nguyên nguồn và lỗi phân tích cú pháp; không đoán các giá trị bị thiếu. |
| `permission_denied` | Chỉ cấp quyền đọc hẹp cần thiết. |
| `error` | Lưu giữ thông tin chi tiết và chẩn đoán giai đoạn được đặt tên trước khi dựa vào tuyến đường. |

<a id="restore-missing-runtime-files"></a>
## Khôi phục các tệp thời gian chạy bị thiếu

Xác nhận:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

Gốc cài đặt chính xác là:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Từ chối bố cục lồng nhau này:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Nếu tệp đúng nhưng UE4SS không khởi động Guard, bảo quản `UE4SS.log` và so sánh dấu thời gian khởi động của nó với thời điểm bắt đầu quá trình trò chơi thực tế.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Giải quyết xung đột thư mục giải nén Windows

Bản phát hành cũ hơn sử dụng các thư mục chương trình có tên chỉ khác nhau ở cách viết hoa. Một số trình giải nén của Windows hợp nhất những tên đó khi ZIP được đặt trên một thư mục hiện có.

1. Chỉ xóa bản trích xuất tạm thời không thành công chứ không xóa bản mod đã cài đặt hoặc bằng chứng của nó.
2. Tạo một thư mục tạm thời trống mới.
3. Trích xuất bản phát hành hiện tại ở đó.
4. Hãy xác nhận rằng nó tạo ra một thư mục RandomDayGuard và một thư mục chương trình.
5. Nếu Windows vẫn báo xung đột, hãy tải xuống lại bản phát hành và báo cáo phiên bản phát hành cũng như trình giải nén được sử dụng.

Không bao giờ trích xuất bản phát hành mới qua thư mục đã cài đặt. Làm theo quy trình cập nhật thư mục sạch trong [`../INSTALL.md`](C%C3%80I_%C4%90%E1%BA%B6T.md).

<a id="load-the-expected-version"></a>
## Tải phiên bản dự kiến

Kiểm tra điểm đánh dấu nguồn và điểm đánh dấu bản dựng:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Nếu họ không đồng ý:

1. Dừng máy chủ.
2. Sao lưu thư mục đã cài đặt, cấu hình đã xem xét và bằng chứng thời gian chạy.
3. Giai đoạn và kiểm tra gói dự định.
4. Chỉ thay thế các tệp dữ liệu và chương trình được quản lý gói.
5. Xác nhận rằng trình tải chuẩn tồn tại và không có bản sao chữ thường nào được thêm vào.
6. Bắt đầu một lần và đọc lại các điểm đánh dấu hiện tại trước khi đánh giá kết quả thời gian chạy.

<a id="correct-a-missing-saved-root"></a>
## Sửa một thư mục gốc đã lưu bị thiếu

Mở `runtime/saved_path_probe.json`. Đặt đường dẫn tuyệt đối đã được xác minh tới Yếu tố phi sinh học hoàn chỉnh `Saved/` đó trong `SavedRoot.txt`; không chỉ trỏ đến một thư mục thế giới. Đường dẫn bên ngoài gốc bị chặn vẫn phải bị từ chối.

<a id="recover-a-stalled-historical-scan"></a>
## Khôi phục quá trình quét lịch sử bị đình trệ

Việc giám sát hiện tại và khám phá lịch sử là riêng biệt. Một kho lưu trữ lớn có thể cần nhiều chu kỳ giới hạn, do đó, một quan sát không thay đổi là không đủ để gọi là nó bị đình trệ.

1. Mở `runtime/current/report_worker_status.json`.
2. Ghi lại `scan_cursor`, các tệp được phát hiện, các tệp đã hoàn thành và `last_progress_ts`.
3. Đợi ít nhất hai cơ hội làm báo cáo bình thường và so sánh lại các trường tương tự.
4. Nếu con trỏ, số đếm đã hoàn thành hoặc thời gian tiến triển tăng lên thì quá trình quét vẫn hoạt động. Để giới hạn.
5. Nếu tất cả các trường tiến trình không thay đổi trong khi ID cuộc thăm dò và báo cáo hiện tại tiếp tục tiến triển, hãy giữ nguyên tệp trạng thái và kiểm tra lớp nguồn được đặt tên theo giai đoạn công nhân. Hãy sửa đường dẫn nguồn đó hoặc lỗi đọc trước khi thử lại.

Quá trình quét lịch sử bị đình trệ sẽ hạn chế các kết luận cần bản ghi cũ hơn. Nó không làm mất hiệu lực báo cáo hiện tại có bằng chứng mới về nhật ký hoạt động và chu kỳ hiện tại.

<a id="recover-a-stuck-poll-loop"></a>
## Khôi phục vòng lặp thăm dò bị mắc kẹt

Mở:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Ghi lại `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status` và dấu thời gian hai lần trong một khoảng thời gian giới hạn.

- Nếu bộ đếm tiến lên, vòng lặp không bị kẹt; chẩn đoán giai đoạn công nhân sau.
- Nếu `poll_in_flight=true` không thay đổi, giữ nguyên giai đoạn tiến trình cuối cùng và lỗi trước khi khởi động lại.
- Nếu bộ lập lịch dừng, hãy kiểm tra lỗi trước đó và chuyển giao khởi động.

Không thêm chủ sở hữu vòng lặp thứ hai để bù đắp cho một vòng đời bị đình trệ.

<a id="start-the-scan-after-log-backlog"></a>
## Bắt đầu quét sau nhật ký tồn đọng

Trong `runtime/current/poll_status.json`, so sánh:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

Quét lịch sử sẽ đợi trong khi nhật ký hoạt động có byte chưa đọc. Xác nhận các cuộc thăm dò sau này làm giảm tồn đọng. Số lượng chưa đọc cố định với các cuộc thăm dò nâng cao là vấn đề về đuôi nguồn; cuộc thăm dò cố định là sự cố với bộ lập lịch.

<a id="preserve-scan-progress-after-a-crash"></a>
## Duy trì tiến trình quét sau sự cố

Duy trì và so sánh:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Kiểm tra xem điểm kiểm tra hoặc bảng kê khai có bị thiếu hay không, thư mục gốc hoặc thế giới đã lưu đã thay đổi hay điểm kiểm tra được đánh dấu là cũ. Không xóa đường cơ sở hợp lệ để làm cho tiến trình có vẻ mới hơn.

<a id="map-an-unmapped-player"></a>
## Lập bản đồ trình phát chưa được ánh xạ

So sánh bằng chứng phiên với nhật ký chính xác:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Tìm mối quan hệ `Login request` hoàn chỉnh giữa tên hiển thị, `ConnectID` và `UniqueId`. Nếu không có danh tính kết nối được chấp nhận nào tồn tại, chỉ giữ lại hàng xem xét. Tên hiển thị hoặc tên tệp PlayerData không phải là danh tính có thể thực thi được.

<a id="diagnose-a-blocked-adminini-write"></a>
## Chẩn đoán Admin.ini ghi bị chặn

Chỉ chạy thử nghiệm thực thi khi có phê duyệt rõ ràng và tệp thử nghiệm dùng một lần, không bao giờ chạy thử nghiệm thực thi khi có sự phê duyệt rõ ràng và tệp thử nghiệm dùng một lần, không bao giờ chạy bằng tệp máy chủ trực tiếp. Trước tiên hãy xác nhận cấu hình kiểm tra yêu cầu Guard viết:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Sau đó đọc lý do lỗi được ghi lại. Guard phải xác định một tài khoản, bảo vệ người kiểm duyệt và các tài khoản đáng tin cậy, tìm đủ bằng chứng cụ thể cho tài khoản, tạo và xác minh bản sao lưu mới, xác nhận rằng không có chương trình nào khác thay đổi tệp, lưu bản cập nhật dự định và so sánh tệp đã lưu hoàn chỉnh với kết quả dự định đó. Nếu bất kỳ bước nào không thành công hoặc không thể kiểm tra được, hãy giữ nguyên danh sách cấm. Xem [Admin.ini thực thi](TH%E1%BB%B0C_THI_INI_C%E1%BB%A6A_QU%E1%BA%A2N_TR%E1%BB%8A_VI%C3%8AN.md).

<a id="restore-a-missing-daily-rollup"></a>
## Khôi phục tổng hợp hàng ngày bị thiếu

Xác nhận `forensic_rollup.enabled = true`, sau đó kiểm tra:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Nếu những thông tin này bị thiếu, hãy kiểm tra trạng thái khởi động, thăm dò ý kiến, nhân viên báo cáo và tính toán nguồn theo thứ tự đó. Bản tổng hợp hàng ngày là một bản ghi liên tục mỗi ngày, không phải là thông báo trạng thái máy chủ lặp lại.

<a id="look-up-an-exact-status-or-error"></a>
## Tra cứu trạng thái hoặc lỗi chính xác

Sử dụng [Tham chiếu trạng thái và lỗi](THAM_KH%E1%BA%A2O_TR%E1%BA%A0NG_TH%C3%81I_V%C3%80_L%E1%BB%96I.md) để biết lộ trình, nguồn hoàn chỉnh, PlayerData, thực thi, khởi động, lập lịch, báo cáo và thông báo hoàn chỉnh. Việc tách biệt các bảng tra cứu sẽ ngăn trang sửa chữa này trở thành hướng dẫn sử dụng lược đồ thứ hai.

<a id="related-docs"></a>
## Tài liệu liên quan

- [Bắt đầu tại đây](B%E1%BA%AET_%C4%90%E1%BA%A6U_T%E1%BA%A0I_%C4%90%C3%82Y.md)
- [Sách hướng dẫn vận hành](S%C3%81CH_H%C6%AF%E1%BB%9ANG_D%E1%BA%AAN_HO%E1%BA%A0T_%C4%90%E1%BB%98NG.md)
- [Tham chiếu trạng thái và lỗi](THAM_KH%E1%BA%A2O_TR%E1%BA%A0NG_TH%C3%81I_V%C3%80_L%E1%BB%96I.md)
- [Đánh giá xác thực và phát hành](X%C3%81C_TH%E1%BB%B0C_V%C3%80_PH%C3%81T_H%C3%80NH.md)
