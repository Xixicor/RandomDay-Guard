<a id="player-review-workflow"></a>
# Quy trình đánh giá người chơi

> **Nguồn tiếng Anh chuẩn:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Sử dụng trang này cho một người chơi, tài khoản hoặc trường hợp. Mục đích là để đưa ra quyết định xem xét có thể lặp lại chứ không phải là cáo buộc tự động.

<a id="quick-path"></a>
## Đường dẫn nhanh

1. Mở `runtime/final_logs/player_activity_latest.json`.
2. Xác nhận trạng thái tuyến đường trong `runtime/final_logs/route_proof.json`.
3. Xác định quan sát nào là hiện tại và quan sát nào là lịch sử.
4. Kiểm tra danh tính được trích dẫn và tham chiếu nguồn phiên.
5. Xem lại `case_review_latest.json` khi tồn tại trường hợp tương quan.
6. Ghi lại thông tin không xác định và `does_not_prove` trước khi chọn hành động.
7. Hãy tắt tính năng thực thi trừ khi có các cổng thực thi riêng biệt đã được chứng minh.

<a id="1-confirm-route-proof"></a>
## 1. Xác nhận bằng chứng lộ trình

Giải thích lộ trình của người chơi dưới dạng:

| Trạng thái | Hành động |
|---|---|
| `full` | Tiếp tục trong khi vẫn xem xét giới hạn nguồn. |
| `limited_expected_empty` | Chỉ tiếp tục với các chủ đề thực sự có mặt; không bịa ra một trình phát hoặc trường hợp bị thiếu. |
| `missing` | Dừng quyết định của người chơi và khắc phục sự cố lộ trình. |

Một bộ lập lịch hoạt động tốt không thay thế bằng chứng về lộ trình.

<a id="2-establish-identity"></a>
## 2. Thiết lập danh tính

Ưu tiên số nhận dạng tài khoản sạch được xác nhận bằng bằng chứng nhận dạng do máy chủ cung cấp và, nếu có, PlayerData tên tệp. Giữ nguyên tham chiếu nguồn thô.

Không thực thi từ:

- chỉ tên hiển thị;
- tên được nhìn thấy trong bảng thông báo hoặc bảng lưu trữ;
- sự tương đồng về thời gian;
- danh tính chưa được ánh xạ hoặc có độ tin cậy yếu;
- một báo cáo lịch sử không có chứng thực hiện tại.

<a id="3-separate-current-from-historical"></a>
## 3. Tách biệt hiện tại khỏi lịch sử

Bằng chứng hiện tại mô tả cửa sổ báo cáo hoặc kỷ nguyên máy chủ đang hoạt động. Bằng chứng lịch sử có thể giải thích một mô hình, nhưng nó không thể âm thầm lấp đầy những khoảng trống trong cửa sổ hiện tại.

Ghi lại cả hai phạm vi một cách độc lập:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Xem lại các quan sát và giải thích

Đọc rõ ràng các phần báo cáo này:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Mở lại bằng chứng có cấu trúc được trích dẫn cho bất kỳ quyết định quan trọng nào. Bản dịch là sự định hướng và giải thích chứ không phải bằng chứng mới.

<a id="5-calibrate-the-decision"></a>
## 5. Hiệu chỉnh quyết định

| Quyết định | Sử dụng khi |
|---|---|
| `INFO` | Quan sát thông thường hoặc theo ngữ cảnh thấp. |
| `WATCH` | Tín hiệu yếu hoặc không đầy đủ đáng được theo dõi. |
| `REVIEW` | Bằng chứng tương quan cần có sự đánh giá của quản trị viên. |
| `BAN-ELIGIBLE` | Đạt được các ngưỡng bằng chứng được định cấu hình và danh tính rõ ràng; cổng ghi vẫn được áp dụng. |
| `AUTO-BANNED` | Tính năng thực thi đã được kích hoạt rõ ràng và tất cả các hoạt động sao lưu, ghi, đọc lại và kiểm tra đều thành công. |

Không có nhãn quyết định nào chứng minh được tội lỗi hoặc ý định.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Áp dụng ranh giới bằng chứng

Sự cố, kết nối lại, cảnh báo, object/class và việc nhóm trường hợp có thể hỗ trợ việc xem xét. Riêng chúng không chứng minh được hành vi gian lận, trộm cắp, sao chép, sở hữu, gây thiệt hại trực tiếp hoặc gây ra sự cố.

Nếu nhận dạng, phân tích cú pháp, sao lưu, ghi, đọc lại hoặc khôi phục yếu hoặc không thành công thì quá trình thực thi phải đóng lại.

<a id="review-note-template"></a>
## Xem lại mẫu ghi chú

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## Tài liệu liên quan

- [`EVIDENCE_BOUNDARY.md`](RANH_GI%E1%BB%9AI_B%E1%BA%B0NG_CH%E1%BB%A8NG.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md)
- [`ADMIN_INI_ENFORCEMENT.md`](TH%E1%BB%B0C_THI_INI_C%E1%BB%A6A_QU%E1%BA%A2N_TR%E1%BB%8A_VI%C3%8AN.md)
- [`DETECTION_SIGNALS.md`](T%C3%8DN_HI%E1%BB%86U_PH%C3%81T_HI%E1%BB%86N.md)
