<a id="architecture-and-lifecycle"></a>
# Cấu trúc và vòng đời

> **Nguồn tiếng Anh chuẩn:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


RandomDayGuard là một UE4SS cơ quan giám sát cộng với một mô-đun báo cáo riêng biệt. Nó đọc các tập tin thuộc sở hữu của máy chủ, duy trì trạng thái cục bộ bị giới hạn và ghi các kết quả đầu ra bằng chứng và đánh giá cục bộ. Nó không có nhà cung cấp, bảng điều khiển, dịch vụ thông báo, RandomDay hoặc phần phụ thuộc mạng.

<a id="end-to-end-data-flow"></a>
## Luồng dữ liệu từ đầu đến cuối

1. UE4SS tải điểm nhập chuẩn duy nhất `RandomDayGuard/Scripts/main.lua`. Các gói hiện tại không gửi bản sao biến thể chữ thường.
2. Trình tải đọc `config.lua`, ba từ điển dữ liệu và `SavedRoot.txt` tùy chọn. Nhận dạng phiên bản phải phù hợp với `VERSION`, `MANIFEST.json` và `BUILD_MARKER.txt`.
3. Kiểm tra khám phá gốc đã lưu giới hạn các ứng cử viên đã biết và chỉ đạo các tệp đã biết. Nó ghi lại những gì có thể đọc được trong `runtime/saved_path_probe.json`; chỉ tìm một thư mục không phải là phạm vi bảo hiểm bằng chứng.
4. Lớp ngay lập tức theo dõi nhật ký máy chủ đang hoạt động từ một khoảng bù an toàn. Nó bình thường hóa vòng đời, phiên, tài khoản, cảnh báo, kết nối lại và các sự kiện được quan sát khác thành bằng chứng chỉ gắn thêm cùng với ảnh chụp nhanh hiện tại.
5. Lớp chậm kiểm kê các tệp đã lưu trong các khối giới hạn. Nó ghi lại tiến trình và điểm kiểm tra, tiếp tục công việc chưa hoàn thành, so sánh tệp kê khai đã thay đổi và tạo ra ngữ cảnh object/world một phần rồi cuối cùng.
6. Logic đánh giá chỉ tương quan với bằng chứng có sẵn cho nó. Tên tệp yếu, thời gian, số lượng lớp, tọa độ tương đối, lỗi, một sự cố hoặc ping vẫn giữ nguyên bối cảnh và không thể chỉ ủy quyền thực thi.
7. Một nhân viên báo cáo riêng gọi `Scripts/public_pipeline.lua`. Nó kiểm kê các lớp nguồn, ghi lại phạm vi hiện tại so với lịch sử, liên kết chu trình với version/boot/epoch/poll/source độ mới, ghi năm tuyến đường cụ thể JSON/TXT ghép đôi rồi ghi `route_proof.json`.
8. Khi được bật rõ ràng, hộp thư đi cục bộ sẽ sao chép các tham chiếu từ một báo cáo đã hoàn thành sau khi có bằng chứng về tuyến đường. Nó ghi lại `delivery_backend="none"` và `delivery_attempted=false`; việc vận chuyển nằm ngoài sản phẩm này.

<a id="ownership-and-asynchronous-boundaries"></a>
## Quyền sở hữu và ranh giới không đồng bộ

| Chủ sở hữu | Công việc bị giới hạn | Không được chặn hoặc ngụ ý |
|---|---|---|
| Khởi động | Cấu hình, Root đã lưu, nhật ký hoạt động, kỷ nguyên, chỉ mục, trạng thái ban đầu. | Điểm đánh dấu trình tải thành công không chứng minh được bằng chứng hoặc lộ trình. |
| Gọi lại cuộc thăm dò ý kiến | Byte nhật ký mới, cập nhật trạng thái, event/session/account đầu ra, lập lịch. | Phát hiện đệ quy hoặc thoát báo cáo chậm. |
| Nhân viên quét | Khám phá tệp kê khai, phân tích cú pháp tệp, điểm kiểm tra, partial/final đường cơ sở. | Tiến trình nhật ký hiện tại; một phần không phải là thất bại. |
| Nhân viên báo cáo | Kế toán nguồn, dịch thuật, cặp báo cáo, bằng chứng lộ trình, hộp thư đi cục bộ. | Thực thi hoặc phân phối bên ngoài. |
| Thực thi tùy chọn | Xác nhận tài khoản và ghi điểm, bảo vệ các tài khoản đáng tin cậy và các tài khoản trùng lặp, xác minh bản sao lưu, từ chối các thay đổi tệp bên ngoài, sau đó xác minh kết quả đã lưu. | Điểm báo cáo, trạng thái tuyến đường hoặc thành viên vụ việc bỏ qua mọi kiểm tra an toàn bắt buộc. |

Vòng thăm dò chỉ hoạt động tốt khi `poll_id` tiến bộ, `poll_in_flight` trả về sai và việc lập lịch vẫn hoạt động. Điều đó chứng tỏ thành phần thăm dò ý kiến ​​chứ không phải đường dẫn báo cáo. Quét chậm có thể là `partial` hoặc `deferred`; mặc định `slow_world_scan_blocks_current_reports=false` cho phép các tuyến đường hiện tại mới tiếp tục trong khi đặt tên cho giới hạn lịch sử.

<a id="state-and-lifecycle"></a>
## Trạng thái và vòng đời

| Trạng thái | Mục nhập | Trạng thái đầu cuối hoặc tiếp theo | Lỗi và khôi phục |
|---|---|---|---|
| Khởi động | UE4SS gọi trình tải. | Đang chạy poll/scan/report công nhân có ID khởi động và kỷ nguyên. | `startup_error` là bằng chứng quan trọng khi khởi động hiện tại; sửa chữaconfig/path/source và khởi động lại. |
| Cuộc thăm dò hiện tại | Cuộc gọi lại có giới hạn theo lịch trình bắt đầu. | Dấu thời gian và lịch trình lại của bản ghi cuộc thăm dò ý kiến ​​đã hoàn thành. | `poll_error` là bằng chứng quan trọng khi khởi động hiện tại; khôi phục công việc bị giới hạn và xác nhận cuộc thăm dò mới hơn. |
| Đang chờ quét | Đã tìm thấy điểm kiểm tra bắt buộc hoặc chưa hoàn chỉnh. | `partial`/`deferred`, sau đó `scan_complete`. | Tiếp tục điểm kiểm tra; chỉ xây dựng lại khi stale/incompatible bằng chứng được ghi lại. |
| Kế toán nguồn | Nhân viên báo cáo kiểm kê tám lớp nguồn. | `complete`, `complete_with_gaps`, `partial` hoặc `unavailable`. | Disabled/failed kế toán buộc tất cả các tuyến đường phải `missing`. |
| Tạo tuyến | Dòng chu kỳ hiện tại và kế toán nguồn là có sẵn. | `full`, `limited_expected_empty` hoặc `missing`. | Đã ghép nối JSON/TXT hoặc lỗi ghi chống định tuyến hội tụ tuyến đến `missing`. |
| Hộp thư đi cục bộ | Một tuyến đã được bật, hoàn thành và đủ điều kiện. | Kết quả trạng thái thông báo và phong bì cục bộ đang chờ xử lý. | Không ghi hoặc bằng chứng không đầy đủ có nghĩa là không có phong bì; không suy ra được chuyển giao nào. |
| Đánh giá thực thi | Bằng chứng dành riêng cho tài khoản đạt đến điểm được định cấu hình cho hành động tự động. | Đề xuất chỉ dành cho xem xét hoặc bản cập nhật `Admin.ini` được bật rõ ràng. | Kiểm tra an toàn không thành công hoặc không khả dụng sẽ dừng cập nhật; so sánh cuối cùng không thành công sẽ khôi phục bản sao lưu đã xác minh khi khôi phục được bật. |

<a id="current-and-historical-evidence"></a>
## Bằng chứng hiện tại và lịch sử

Bằng chứng hiện tại thuộc về boot/poll đang hoạt động và không bao giờ được xây dựng lại chỉ từ tên tệp được giữ lại. Bằng chứng lịch sử bao gồm các khúc gỗ được xoay, bền account/session lịch sử, được giữ lại cases/reports/evidence và quét giới hạn thế giới. Các báo cáo hiển thị các mảng và số lượng hiện tại và lịch sử riêng biệt. Việc khởi động lại trong im lặng không được xóa bỏ bối cảnh lâu dài và hồ sơ lịch sử không được hiển thị dưới dạng hiện diện hiện tại.

<a id="completion-and-recovery-boundary"></a>
## Ranh giới hoàn thành và phục hồi

Việc hoàn thành một tuyến yêu cầu phải khớp phiên bản chu kỳ hiện tại, ID khởi động, ID kỷ nguyên, ID thăm dò tích cực, trạng thái nhật ký hoạt động mới, cả đầu ra của tuyến và mục nhập của nó trong `route_proof.json`. Các yêu cầu thông báo cũng yêu cầu phong bì địa phương có cùng chu kỳ; việc cung cấp bên ngoài không bao giờ là một phần của bằng chứng công khai.

Nếu báo cáo cuối cùng bị thiếu hoặc cũ hơn poll/source, tiếp tục từ dòng không khớp đầu tiên hoặc ghi không thành công. Không thay đổi các lộ trình, từ ngữ hoặc cài đặt thực thi không liên quan. Xem các dòng [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md), [`TROUBLESHOOTING.md`](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md) và [`SOURCE_MODULE_REFERENCE.md`](THAM_KH%E1%BA%A2O_M%C3%94-%C4%90UN_NGU%E1%BB%92N.md).
