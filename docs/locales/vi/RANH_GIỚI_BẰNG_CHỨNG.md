<a id="evidence-boundary"></a>
# Ranh giới bằng chứng

> **Nguồn tiếng Anh chuẩn:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Sử dụng trang này để quyết định nội dung nào RandomDayGuard có thể báo cáo và những gì vẫn cần có sự xem xét của con người.

<a id="core-rule"></a>
## Quy tắc cốt lõi

RandomDayGuard ghi lại các quan sát giới hạn từ các tệp do máy chủ sở hữu. Nó phải xác định nguồn, phạm vi, trạng thái thu thập và giới hạn cho mọi kết luận quan trọng.

Bằng chứng có cấu trúc là có căn cứ xác thực. Một báo cáo được dịch giải thích bằng chứng; nó không thể thêm các dữ kiện không có trong bản ghi có cấu trúc.

<a id="evidence-source-classes"></a>
## Các lớp nguồn bằng chứng

| Lớp nguồn | Cách sử dụng thông thường | Không tự chứng minh |
|---|---|---|
| `admin_ini` | Trạng thái quản lý hiện tại và đã được kiểm tra write/readback bối cảnh | Ai đã gây ra sự cố |
| `active_log` | Các sự kiện server/session hiện tại hiển thị trong nhật ký đang hoạt động | Ý định, quyền sở hữu hoặc thiệt hại trực tiếp |
| `recent_backup_logs` | Ngữ cảnh nhật ký lịch sử | Một sự kiện hiện tại đã xảy ra |
| `playerdata_filenames` | Xác thực rằng có tồn tại mã định danh tài khoản sạch | Hành vi, cảm giác tội lỗi hoặc quyền sở hữu danh tính ngoài thông tin nhận dạng bị lộ |
| `existing_cases` | Bối cảnh xem xét trước | Rằng cách giải thích trước đó vẫn đúng |
| `existing_reports` | Các bản tóm tắt và quyết định trước đó | Sự thật hiện tại không có sự chứng thực hiện tại |
| `existing_evidence` | Bằng chứng có cấu trúc lịch sử | Hoạt động hiện tại |
| quét lưu thế giới có giới hạn | Chậm world/class bối cảnh | Hành động, quyền sở hữu, trộm cắp, sao chép hoặc thiệt hại của người chơi |

Mỗi nguồn ghi lại availability/readability, số lượng tệp, tham chiếu nguồn, phạm vi hiện tại hoặc lịch sử và một tuyên bố `does_not_prove` rõ ràng.

<a id="source-states"></a>
## Trạng thái nguồn

| Trạng thái | Ý nghĩa toán tử |
|---|---|
| `available` | Nguồn có thể đọc được và bằng chứng đã được thu thập. |
| `expected_empty` | Nguồn có thể đọc được và hợp pháp không có bản ghi trùng khớp. |
| `partial` | Một số bằng chứng đã được thu thập; phạm vi phủ sóng chưa đầy đủ. |
| `deferred` | Công việc giới hạn đã bị trì hoãn một cách có chủ ý. |
| `unavailable` | Nguồn không có trong môi trường này. |
| `malformed` | Nguồn tồn tại nhưng không thể phân tích cú pháp một cách an toàn. |
| `permission_denied` | Cơ quan giám sát thiếu quyền đọc. |
| `error` | Bộ sưu tập không thành công vì một lý do khác đã được ghi lại. |

Dự kiến trống là quan sát hợp lệ. Nó không bao giờ được chuyển đổi thành một trình phát, vụ án, sự cố hoặc lời buộc tội bịa đặt.

<a id="current-versus-historical-evidence"></a>
## Bằng chứng hiện tại so với lịch sử

Bằng chứng hiện tại thuộc về thời điểm thu thập đang hoạt động hoặc kỷ nguyên máy chủ. Bằng chứng lịch sử đến từ nhật ký, vụ án, báo cáo, hồ sơ bằng chứng, bản sao lưu hoặc đường cơ sở trước đó.

Bằng chứng lịch sử có thể cung cấp bối cảnh. Nó không thể âm thầm lấp đầy khoảng trống bằng chứng hiện tại. Các báo cáo phải gắn nhãn cho cả hai phạm vi và trích dẫn nguồn riêng biệt.

<a id="corroboration-rule"></a>
## Quy tắc chứng thực

Đây là những ngữ cảnh hữu ích nhưng bản thân chúng không phải là bằng chứng trực tiếp:

- tên hiển thị hoặc sự giống nhau về tên;
- sự trùng hợp về thời gian;
- ngắt kết nối hoặc kết nối lại mạng;
- một sự cố hoặc một loạt cảnh báo;
- mã thông báo lớp, đường dẫn, tác nhân, bản đồ hoặc số lượng đối tượng;
- tư cách thành viên trong một trường hợp được nhóm tự động;
- báo cáo trước mà không có xác nhận nguồn hiện tại.

Không tuyên bố có tội, có ý định, gian lận, quyền sở hữu, trộm cắp, sao chép, thiệt hại trực tiếp, sử dụng container trực tiếp, hành động kiểm kê trực tiếp, tọa độ trực tiếp chính xác, ping trực tiếp hoặc hành vi ở cấp độ bộ nhớ mà không có bằng chứng trực tiếp vạch trần sự thật.

<a id="truthful-report-language"></a>
## Ngôn ngữ báo cáo trung thực

Sử dụng:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Tránh:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Thứ tự đọc báo cáo

Mỗi báo cáo công khai phải giải thích:

1. Ý nghĩa đơn giản.
2. Tại sao lại quan trọng.
3. Bằng chứng kỹ thuật và tài liệu tham khảo nguồn.
4. Hành động tiếp theo.
5. Các giới hạn, điều chưa biết và tuyên bố chưa được chứng minh.

<a id="related-docs"></a>
## Tài liệu liên quan

- [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
- [`BAN_ID_MAPPING.md`](C%E1%BA%A4M_%C3%81NH_X%E1%BA%A0_ID.md)
- [`DETECTION_SIGNALS.md`](T%C3%8DN_HI%E1%BB%86U_PH%C3%81T_HI%E1%BB%86N.md)
