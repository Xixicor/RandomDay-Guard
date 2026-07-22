<a id="examples-of-the-five-guard-reports"></a>
# Ví dụ về năm báo cáo của Guard

> **Nguồn tiếng Anh chuẩn:** [REPORT_EXAMPLES.md](../../REPORT_EXAMPLES.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Những ví dụ này được tạo ra từ dữ liệu mẫu đi kèm với bản phát hành; tên và số tài khoản được phát minh. Chúng hiển thị các trường báo cáo được thử nghiệm, tính toán và ranh giới tuyến đường. Một báo cáo thực sẽ thay thế chúng bằng thông tin được thu thập từ máy chủ đó và cho biết khi nào thông tin không có sẵn.

Mỗi báo cáo có một công việc. Tình trạng máy chủ không lặp lại lịch sử của người chơi, đánh giá hàng ngày không được gửi vài phút một lần và các tuyến trường hợp hoặc trình phát yên tĩnh không nhận được thông báo phụ. Báo cáo hiện tại có thể sẵn sàng trong khi quá trình quét lịch sử bị giới hạn vẫn đang diễn ra; trong trường hợp đó, báo cáo đặt tên cho khoảng trống thay vì trình bày lịch sử cũ hơn dưới dạng hoàn chỉnh.

<a id="server-status"></a>
## Trạng thái máy chủ

> **Trạng thái máy chủ: Trực tuyến sau khi khởi động lại**  **Trạng thái hiện tại:** Trực tuyến **Có sẵn kể từ:** 14:07  **Đã hoàn tất khởi động lại:** 14:06  **Thời gian ngừng hoạt động:** 3 phút, 12 giây **Lý do khởi động lại:** Cập nhật trò chơi theo lịch **Đang giám sát:** Đang hoạt động. Lần kiểm tra thành công cuối cùng: 14:09 **Nhật ký trò chơi:** Có sẵn và đang cập nhật **Quét lịch sử:** 312 trên 355 tệp được xem xét **Sao lưu:** Xác minh lần cuối: 13:00. Dự kiến ​​tiếp theo: 15:00. Lỗi hôm nay: 0 **Hành động:** Không có. Máy chủ đã khôi phục bình thường.

Trạng thái máy chủ dành cho hoạt động hiện tại của máy chủ: khởi động, khởi động lại quá trình khôi phục, thời gian ngừng hoạt động, sao lưu, bộ lập lịch và tình trạng bảo vệ. Nó không chứa các phiên của người chơi hoặc chi tiết trường hợp.

<a id="daily-rollup"></a>
## Bản tổng hợp hàng ngày

> **Đánh giá hàng ngày: Ngày 19 tháng 7 năm 2026**  **Tính khả dụng của máy chủ:** Trực tuyến trong 23 giờ 47 phút. Ngoại tuyến trong 13 phút.  **Khởi động lại:** Tổng cộng 2: 1 đã lên lịch và 1 không mong muốn.  **Sao lưu:** 23 thành công. 1 thiếu hoặc thất bại. Backup thành công muộn nhất: 23h00.  **Hoạt động của người chơi:** 3 người chơi duy nhất. 7 buổi: 6 buổi hoàn thành bình thường và 1 buổi gián đoạn.  **Hoạt động của trường hợp:** 1 trường hợp mới, 2 trường hợp cập nhật, 1 trường hợp cần chú ý và 0 trường hợp nghiêm trọng.  **Mức độ bao phủ bằng chứng:** 6 trong số 7 nhóm nguồn dự kiến ​​đã có sẵn. Nhật ký sao lưu lúc 04:00 không có sẵn.  **Tóm tắt ngày:** Máy chủ vẫn khả dụng hầu hết thời gian trong ngày. Một sự gián đoạn bất ngờ đã kết thúc phiên người chơi sớm. Quá trình giám sát được tiếp tục sau khi khôi phục và một trường hợp đã sẵn sàng để xem xét.  **Hành động:** Trường hợp xem xét `RDG-20260719-004`. Không cần thực hiện hành động tức thời nào khác.

Bản tổng hợp hàng ngày được ghi một lần cho ngày theo lịch của nó. Nó kết hợp ngày trong những khoảng thời gian yên tĩnh và khởi động lại mà không trở thành ping trạng thái máy chủ khác.

<a id="player-activity"></a>
## Hoạt động của người chơi

> **Hoạt động của người chơi: Alex**  **Tài khoản:** `76561198000000400`  **Được quan sát lần đầu:** Ngày 12 tháng 7 năm 2026 **Phiên gần đây nhất:** Tham gia lúc 10:02, rời đi lúc 11:18, kéo dài 1 giờ 16 phút và kết thúc bình thường.  **Hôm nay:** 3 kết nối, 2 phiên hoàn thành, 1 phiên bị gián đoạn và 2 kết nối lại nhanh chóng trong vòng 10 phút.  **7 ngày trước:** 9 phiên, 6 giờ 18 phút phát được ghi lại và 0 trường hợp trước đó.  **Đã quan sát thấy:** Alex đã quay lại hai lần ngay sau một phiên bị gián đoạn. Hoạt động được ghi lại đủ đầy đủ để lưu giữ dưới dạng lịch sử nhưng bản thân nó không giải thích được lý do xảy ra việc kết nối lại.  **Hành động:** Tiếp tục theo dõi. Không cần thực hiện hành động ngay lập tức.

Hoạt động của người chơi chỉ được gửi khi thông tin về phiên hoặc người chơi được hỗ trợ thay đổi. Khoảng thời gian yên tĩnh không tạo ra thông điệp cho người chơi.

<a id="case-review"></a>
## Đánh giá trường hợp

> **Đánh giá trường hợp: RDG-20260719-004**  **Chủ đề:** Alex **Tài khoản:** `76561198000000400`  **Trạng thái:** Đã yêu cầu xem xét của quản trị viên **Xếp hạng đánh giá:** 90 - Mức độ ưu tiên cao **Tại sao trường hợp này được mở:** Tài khoản đã thực hiện nhiều lần thử kết nối sau một phiên bị gián đoạn và máy chủ đã ghi lại trực tiếp các yêu cầu đăng nhập.  **Quan sát đã được xác nhận:** - Yêu cầu đăng nhập được ghi lại lúc 18:42. - Bốn lần thử được ghi lại trong vòng 6 phút. - Hai buổi kết thúc mà không có lịch khởi hành bình thường. - Tài khoản tương tự đã được quan sát vào ngày 12 tháng 7 và ngày 17 tháng 7.  **Lịch sử liên quan:** Không có trường hợp nào trước đó được ghi lại cho tài khoản này.  **Không xác định:** Các bản ghi có sẵn không xác định lý do kết nối lại, ý định của người chơi hoặc liệu trạng thái thế giới có thay đổi hay không.  **Hành động được đề xuất:** So sánh thời gian phiên với nhật ký máy chủ và hoạt động trên thế giới được ghi lại trước khi quyết định xem có cần thực hiện bất kỳ hành động nào hay không.

Đánh giá trường hợp bao gồm tài liệu đánh giá được đặt tên, các quan sát đã được xác nhận, các giới hạn của tài liệu đó và một bước đánh giá cụ thể. Chỉ sự hiện diện lịch sử không tạo ra ca bệnh mới.

<a id="critical-guard"></a>
## Bảo vệ quan trọng

> **Critical Guard: Viết báo cáo đã dừng**  **Đã bắt đầu:** 21:14  **Chức năng bị ảnh hưởng:** Người viết báo cáo người chơi **Tác động:** Không thể hoàn thành tóm tắt người chơi mới.  **Máy chủ:** Vẫn trực tuyến.  **Đang giám sát:** Việc thu thập bằng chứng vẫn tiếp tục nhưng các báo cáo có thể đọc được bị trì hoãn.  **Báo cáo thành công lần cuối:** 21:09  **Lỗi:** Không thể lưu đầu ra báo cáo.  **Lý do có thể là:** Đích không có sẵn hoặc bị từ chối ghi.  **Hành động:** Kiểm tra vị trí đầu ra thời gian chạy Guard. Không khởi động lại máy chủ trò chơi trừ khi quá trình giám sát cũng dừng lại.

Khi sự cố được giải quyết, tuyến đường tương tự sẽ ghi lại quá trình khôi phục:

> **Critical Guard Đã giải quyết: Đã khôi phục Viết báo cáo**  **Đã tiếp tục:** 21:22  **Gián đoạn:** 8 phút **Kết quả:** Bằng chứng thu thập được trong quá trình gián đoạn được bảo tồn và các báo cáo bị trì hoãn đã được hoàn thành.

Critical Guard chỉ hoạt động khi có lỗi. Trạng thái thường lệ, lịch sử hàng ngày, hoạt động của người chơi và kết quả dự kiến ​​thông thường vẫn trống trong báo cáo của riêng họ.

<a id="when-a-route-is-quiet"></a>
## Khi tuyến đường yên tĩnh

Lộ trình yên tĩnh ghi lại kết quả trực tiếp mà không gửi phụ đến Discord:

> **Đã kiểm tra; không có gì cho báo cáo này.** Đã có sẵn các bản ghi bắt buộc và không có hoạt động, trường hợp hoặc lỗi bảo vệ phù hợp nào của người chơi xảy ra trong cửa sổ báo cáo này.

Đó là một kết quả hoàn toàn trống rỗng. Nó khác với báo cáo bị thiếu, trong đó không thể kiểm tra nguồn được yêu cầu hoặc không thể tạo đầu ra có thể đọc được.

Mọi báo cáo có thể đọc được đều đi theo cùng một đường dẫn:

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Sử dụng [sổ tay hoạt động](S%C3%81CH_H%C6%AF%E1%BB%9ANG_D%E1%BA%AAN_HO%E1%BA%A0T_%C4%90%E1%BB%98NG.md) để xem lại các báo cáo hiện tại và [lược đồ đầu ra](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md) để tham khảo trường kỹ thuật.
