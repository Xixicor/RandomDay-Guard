<a id="start-here-read-the-first-guard-report"></a>
# Bắt đầu tại đây: đọc báo cáo Guard đầu tiên

> **Nguồn tiếng Anh chuẩn:** [START_HERE.md](../../START_HERE.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Hướng dẫn này bắt đầu sau RandomDayGuard đã được cài đặt và kích hoạt. Nó chứng tỏ một kết quả hữu ích mà không cần yêu cầu người vận hành mới kiểm tra mã nguồn, nội bộ gói hoặc tệp trạng thái chỉ dành cho máy.

<a id="what-happens-after-the-server-starts"></a>
## Điều gì xảy ra sau khi máy chủ khởi động

Người bảo vệ đợi máy chủ trò chơi và UE4SS để tải, tìm các bản ghi có sẵn của máy chủ và bắt đầu quét nền có giới hạn. Nó có thể báo cáo tình trạng máy chủ hiện tại trong khi lịch sử cũ hơn vẫn đang được lập chỉ mục.

Báo cáo đầu tiên phải là **Trạng thái máy chủ**. Nó trả lời liệu hiện tại Guard có đang hoàn tất các chu trình giám sát hay không, thời điểm máy chủ hiện tại bắt đầu chạy nếu dấu thời gian đó có sẵn, active/rotated có phạm vi quét và ghi nhật ký, số lượng người chơi được kết nối, nhóm nguồn nào bị thiếu và liệu người vận hành có cần thực hiện hành động hay không.

Quá trình quét nền vẫn đang diễn ra là một hạn chế đối với phạm vi lịch sử chứ không phải tự động là lỗi khởi động. Guard ghi lại con trỏ quét, các tập tin đã hoàn thành, các tập tin được phát hiện và thời gian tiến hành lần cuối. Nếu những giá trị đó ngừng thay đổi trong các chu kỳ giám sát lặp lại, hãy coi đường dẫn lịch sử là bị đình trệ và thực hiện theo nhánh quét trong Khắc phục sự cố. Đừng loại bỏ kết quả phiên và nhật ký hiện tại chỉ vì lịch sử cũ chưa đầy đủ.

<a id="read-the-first-server-status-report"></a>
## Đọc báo cáo trạng thái máy chủ đầu tiên

1. Khởi động máy chủ chuyên dụng bình thường.
2. Đợi máy chủ trò chơi và UE4SS để hoàn tất việc bắt đầu.
3. Mở RandomDayGuard's thư mục báo cáo cuối cùng và chọn báo cáo trạng thái máy chủ mới nhất có thể đọc được.
4. Xác nhận báo cáo chứa:
   - **Tóm tắt**
   - **Những gì Guard quan sát được**
   - **Ý nghĩa của nó**
   - **Những điều còn chưa biết**
   - **Bước tiếp theo được đề xuất**
   - **Hồ sơ kỹ thuật**
5. Trong **Những gì Guard quan sát được** là bao nhiêu, xác nhận những tiến triển mới nhất của chu kỳ giám sát và tên báo cáo có sẵn trong nhật ký, bản quét, trình phát và phạm vi nguồn.
6. Nếu bước tiếp theo cho biết không cần can thiệp, hãy giữ báo cáo là kết quả thành công đầu tiên. Nếu nó nêu tên một nguồn bị thiếu hoặc quá trình đã dừng, hãy làm theo triệu chứng chính xác đó trong [Khắc phục sự cố](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md).

Báo cáo có thể liên kết với bằng chứng kỹ thuật để đánh giá sâu hơn. Người vận hành bình thường có thể đọc báo cáo trước và chỉ mở các tài liệu tham khảo đó khi cần kiểm tra kết quả đơn giản.

<a id="understand-quiet-reports"></a>
## Hiểu các báo cáo yên tĩnh

Hoạt động của người chơi, đánh giá trường hợp và Bảo vệ quan trọng đều theo sự kiện. Một máy chủ yên tĩnh không được tạo ra trình phát, trường hợp hư cấu hoặc lỗi chỉ lấp đầy kênh. Kết quả có thể đọc được có thể cho biết nguồn đã được kiểm tra và không có gì thuộc về báo cáo đó.

Bản tổng hợp hàng ngày khác nhau: nó cung cấp một bài đánh giá cho mỗi ngày báo cáo bằng cách sử dụng các phiên cùng ngày, chủ đề đánh giá hiện tại, được giữ lại identity/case bối cảnh, tiến trình quét và các khoảng trống nguồn mà Guard thực sự có thể đọc được. Những sự kiện vắng mặt trong hồ sơ máy chủ hiện có vẫn chưa được xác định thay vì được ước tính.

<a id="test-one-ordinary-player-session"></a>
## Thử nghiệm một phiên người chơi thông thường

Sau khi có báo cáo trạng thái máy chủ đầu tiên:

1. Cho phép một người chơi đã biết tham gia và rời đi một cách bình thường.
2. Đợi chu kỳ báo cáo tiếp theo.
3. Mở hoạt động của người chơi.
4. Xác nhận rằng nó xác định tài khoản hoặc tên hiển thị có sẵn cho Guard, thời gian tham gia và rời đi, kết quả phiên sạch hoặc chưa đầy đủ, lịch sử trước đó nếu có và một hành động tiếp theo.

Báo cáo phiên phải chứa dữ liệu được quan sát. Không nên thay thế nó bằng danh sách tên tệp hoặc tuyên bố chung chung rằng các bản ghi tồn tại.

<a id="continue"></a>
## Tiếp tục

- [Năm ví dụ báo cáo](V%C3%8D_D%E1%BB%A4_V%E1%BB%80_B%C3%81O_C%C3%81O.md)
- [Sách hướng dẫn vận hành](S%C3%81CH_H%C6%AF%E1%BB%9ANG_D%E1%BA%AAN_HO%E1%BA%A0T_%C4%90%E1%BB%98NG.md)
- [Quy trình đánh giá người chơi](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
- [Khắc phục sự cố](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md)
- [Chỉ mục tài liệu đầy đủ](T%C3%80I_LI%E1%BB%86U.md)
