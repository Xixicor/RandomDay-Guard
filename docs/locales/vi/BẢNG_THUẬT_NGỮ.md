<a id="glossary"></a>
# Bảng thuật ngữ

> **Nguồn tiếng Anh chuẩn:** [GLOSSARY.md](../../GLOSSARY.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


| Thuật ngữ | Ý nghĩa đơn giản | Ý nghĩa kỹ thuật chính xác |
|---|---|---|
| Nhật ký hoạt động | Nhật ký máy chủ hiện tại được sử dụng cho bằng chứng mới. | Bắt buộc `active_log` nguồn; Cần có khả năng đọc cộng với dòng hiện tại để hoàn thành tuyến đường. |
| ID khởi động | Một quy trình giám sát bắt đầu. | Số nhận dạng thời gian chạy hiện tại được sử dụng để từ chối khởi động trước errors/reports. |
| ID kỷ nguyên | Khoảng thời gian liên tục của một máy chủ. | Mã định danh kéo dài thời gian chạy bình thường cho đến khi logic liên tục bắt đầu một kỷ nguyên khác. |
| ID cuộc thăm dò ý kiến | Một cơ hội thăm dò ý kiến ​​có giới hạn. | Trường chu trình đơn điệu dương; zero/missing không thể hoàn thành lộ trình. |
| Độ mới của nguồn | Liệu nguồn hiện tại và dòng thăm dò có đồng ý hay không. | `fresh_current_poll` hoặc `stale_or_unproven` có dấu thời gian và trạng thái nhật ký hoạt động. |
| Kế toán nguồn | Kiểm kê về tính sẵn có và giới hạn của bằng chứng. | `randomdayguard.source-accounting/v1` với tám lớp nguồn và current/historical phạm vi. |
| `available` | Đã tìm thấy và đọc một nguồn. | Trạng thái nguồn thiết bị đầu cuối với `available=true`, `readable=true`. |
| `expected_empty` | Một nguồn tùy chọn đã được kiểm tra và hợp pháp absent/empty. | Thiết bị đầu cuối trạng thái nguồn có thể đọc được; không bao giờ tạo ra một chủ đề. |
| `partial` | Công việc bị ràng buộc có kết quả hữu ích nhưng không đầy đủ. | Trạng thái không kết thúc source/accounting; tiếp tục công việc sở hữu. |
| `deferred` | Công việc đang chờ xử lý có chủ ý. | Trạng thái nguồn không kết thúc; không phải là lỗi hoặc hoàn thành. |
| `unavailable` | Hiện không thể sử dụng nguồn. | Khoảng cách thiết bị đầu cuối; khoảng cách nguồn bắt buộc khiến việc tính toán không khả dụng. |
| `malformed` | Một nguồn tồn tại nhưng không hợp lệ về mặt cấu trúc. | Khoảng cách thiết bị đầu cuối bảo toàn chi tiết xác thực và đóng hoạt động ghi phụ thuộc. |
| `permission_denied` | Hệ điều hành đã từ chối quyền truy cập một cách rõ ràng. | Khoảng cách thiết bị đầu cuối khác biệt với missing/unavailable. |
| `error` | Một hoạt động giới hạn đã thất bại bất ngờ. | Lỗi thiết bị đầu cuối yêu cầu khôi phục được đặt tên; không có chi tiết bí mật nào xuất hiện trong các báo cáo công khai. |
| `complete` | Tất cả các nguồn được thống kê đều là thiết bị cuối cùng không có khoảng trống. | Trạng thái kế toán nguồn cấp cao nhất. |
| `complete_with_gaps` | Bằng chứng hiện tại bắt buộc hoạt động; vẫn còn các khoảng trống thiết bị đầu cuối tùy chọn. | Trạng thái kế toán cấp cao nhất; các tuyến đường vẫn áp dụng yêu cầu riêng. |
| `full` | Một tuyến đường đã hoàn thành với hợp đồng không trống được yêu cầu. | Enum chứng minh tuyến đường với các đầu ra của chu kỳ hiện tại đã hoàn thành. |
| `limited_expected_empty` | Một tuyến đường đã hoàn thành và không tìm thấy subject/failure. | Enum chứng minh tuyến đường với `completed=true`, `expected_empty=true`. |
| `missing` | Bằng chứng hoàn thành tuyến đường không có hoặc không thành công. | Enum chứng minh tuyến đường với `completed=false`; không bao giờ đủ điều kiện cho hộp thư đi. |
| Báo cáo có cấu trúc | Đầu ra tuyến đường có thể đọc được bằng máy. | `<route>_latest.json` sử dụng `randomdayguard.report/v1`. |
| Báo cáo đã dịch | Hiển thị mà con người có thể đọc được của cùng một tuyến đường. | `<route>_latest.txt` với các tham chiếu được quan sát đến nguồn cố định đặt hàng. |
| Bằng chứng định tuyến | Sổ cái hoàn thành định tuyến chéo. | `route_proof.json` ràng buộc các đường dẫn version/boot/epoch/poll/freshness/output. |
| Bằng chứng hiện tại | Quan sát thuộc sở hữu của chu trình hoạt động. | Phạm vi `current`; không được xây dựng lại từ filenames/reports. |
| Bằng chứng lịch sử cũ | Bối cảnh được giữ lại từ các chu kỳ trước đó hoặc quá trình quét chậm. | Phạm vi `historical`; có thể thông báo đánh giá nhưng không thể xác nhận sự hiện diện hiện tại. |
| Chỉ đánh giá | Tạo bằng chứng đánh giá mà không có Admin.ini ghi. | Mặc định `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Kiểm tra an toàn trong danh sách cấm | Một câu hỏi Guard phải trả lời trước khi có thể thay đổi `Admin.ini`. | Nó phải xác nhận tài khoản và tính điểm, loại trừ các tài khoản đáng tin cậy và các tài khoản trùng lặp, xác minh bản sao lưu, phát hiện các thay đổi bên ngoài, lưu bản cập nhật dự định và xác minh hoặc khôi phục toàn bộ một cách an toàn file. |
| Hộp thư đi cục bộ | Chuyển giao thông báo trung lập với nhà cung cấp tùy chọn. | JSON với nội dung gì? `delivery_backend="none"` và `delivery_attempted=false`. |
| Đường cơ sở | Đã hoàn thành ảnh chụp nhanh ngữ cảnh của tệp đã lưu có giới hạn. | Manifest/object/world trạng thái chỉ được sử dụng lại khi tương thích và đủ mới. |
| Điểm kiểm tra | Tiếp tục vị trí cho công việc quét chưa hoàn tất. | `scan_checkpoint.json`; xóa không phải là khôi phục mặc định. |
| Chỉ mục có thể xây dựng lại | Tóm tắt có thể được tạo lại. | Daily/weekly/forensic/final kết quả đánh giá; bằng chứng nguồn vẫn có căn cứ. |
| Ranh giới bằng chứng | Giới hạn về những gì nguồn có thể hỗ trợ. | Rõ ràng `does_not_prove`, ẩn số, độ mạnh nhận dạng và quy tắc phạm vi. |

Các định nghĩa chuẩn cho các lược đồ có trong [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md); các thuật ngữ cấu hình có trong [`CONFIG_FIELD_CATALOG.md`](DANH_M%E1%BB%A4C_TR%C6%AF%E1%BB%9CNG_C%E1%BA%A4U_H%C3%8CNH.md).
