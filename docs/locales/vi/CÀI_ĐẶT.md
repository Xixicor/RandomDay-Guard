<a id="install-randomdayguard"></a>
# Cài đặt RandomDayGuard

> **Nguồn tiếng Anh chuẩn:** [INSTALL.md](../../../INSTALL.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Hướng dẫn này cài đặt `v0.4.12-alpha` trên máy chủ chuyên dụng Abiotic Factor đã sử dụng UE4SS. Bản mod này không bị ràng buộc với một công ty lưu trữ hoặc bảng điều khiển nào.

<a id="before-you-begin"></a>
## Trước khi bạn bắt đầu

Bạn cần:

- quyền truy cập để dừng và khởi động máy chủ chuyên dụng;
- Thư mục UE4SS `Mods` thư mục;
- của máy chủ là bản sao của thư mục RandomDayGuard hiện tại nếu bạn đang cập nhật;
- bản sao lưu dữ liệu máy chủ mà bạn thường bảo vệ trước khi thay đổi mod.

**Thư mục Mod** là `ue4ss/Mods/` thư mục bên trong bản cài đặt máy chủ chuyên dụng. RandomDayGuard thuộc ngay trong thư mục đó.

<a id="new-installation"></a>
## Cài đặt mới

1. Dừng máy chủ chuyên dụng.
2. Trích xuất RandomDayGuard ZIP vào một thư mục trống mới.
3. Sao chép `RandomDayGuard` thư mục vào thư mục UE4SS `Mods`. Kết quả phải là một `Mods/RandomDayGuard/` của máy chủ chứ không phải thư mục RandomDayGuard thứ hai được lồng bên trong nó.
4. Mở UE4SS `mods.txt` và bật:

   ```text
   RandomDayGuard : 1
   ```

5. Khởi động máy chủ bình thường.
6. Đợi UE4SS và máy chủ trò chơi để hoàn tất việc khởi động, sau đó theo dõi [Đọc báo cáo đầu tiên](B%E1%BA%AET_%C4%90%E1%BA%A6U_T%E1%BA%A0I_%C4%90%C3%82Y.md).

Không sao chép bản phát hành mới qua bản cài đặt đang chạy. Giữ bản sao lưu cho đến khi cài đặt cập nhật tạo ra báo cáo trạng thái máy chủ hiện tại.

<a id="update-an-existing-installation"></a>
## Cập nhật cài đặt hiện có

1. Dừng máy chủ.
2. Sao chép thư mục RandomDayGuard đã cài đặt hoàn chỉnh vào vị trí sao lưu an toàn.
3. Di chuyển thư mục chương trình cũ ra khỏi UE4SS `Mods` thay vì xếp bản phát hành mới lên trên đó.
4. Sao chép thư mục mới RandomDayGuard thư mục vào `Mods`.
5. Chỉ khôi phục cấu hình cục bộ đã xem xét của bạn và bằng chứng đã lưu. Nếu hướng dẫn cấu hình liệt kê các trường mới, hãy hợp nhất chúng vào bản sao đã xem xét thay vì thay thế tất cả cài đặt một cách mù quáng.
6. Xác nhận `RandomDayGuard : 1` vẫn được bật.
7. Khởi động máy chủ và đọc báo cáo trạng thái máy chủ hiện tại.

Bản cập nhật thư mục sạch này cũng xóa các tệp lỗi thời khỏi các bản phát hành cũ hơn mà không yêu cầu người vận hành kiểm tra tên tệp chương trình.

<a id="help-guard-find-the-server-records"></a>
## Help Guard tìm các bản ghi máy chủ

Guard thường tự động tìm thấy thư mục Yếu tố phi sinh học `Saved`. Nếu không thể, hãy đặt đường dẫn đầy đủ đến thư mục `Saved` đó trong `SavedRoot.txt` bên trong RandomDayGuard. Trỏ tới `Saved` chứ không phải một thế giới riêng lẻ bên dưới nó.

Báo cáo trạng thái máy chủ đầu tiên cho biết liệu vị trí bản ghi có được tìm thấy hay không và nhóm nguồn nào có sẵn. Sử dụng [Khắc phục sự cố](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md) khi nó không thể đọc được vị trí.

<a id="first-run-behavior"></a>
## Hành vi chạy lần đầu

Cài đặt mặc định xem các bản ghi có sẵn và viết báo cáo. Nó không thay đổi `Admin.ini` hoặc thêm lệnh cấm. Điều này cho phép bạn xác nhận chất lượng thu thập, dịch và báo cáo trước khi quyết định có bật bất kỳ hành động tùy chọn nào hay không.

[Đọc báo cáo đầu tiên](B%E1%BA%AET_%C4%90%E1%BA%A6U_T%E1%BA%A0I_%C4%90%C3%82Y.md)

<a id="disable-or-remove-randomdayguard"></a>
## Vô hiệu hóa hoặc xóa RandomDayGuard

1. Dừng máy chủ.
2. Sao chép toàn bộ RandomDayGuard vào thư mục lưu trữ an toàn.
3. Để tắt mod, hãy đặt `RandomDayGuard : 0` trong UE4SS `mods.txt`.
4. Để xóa nó, hãy di chuyển toàn bộ RandomDayGuard thư mục trong `Mods` sau khi xác nhận có thể mở được kho lưu trữ.
5. Khởi động máy chủ và xác nhận Guard không còn khởi động nữa.

Việc tắt hoặc xóa Guard sẽ ngừng thu thập trong tương lai. Nó không xóa dữ liệu trò chơi, xóa các báo cáo đã lưu trữ hoặc đảo ngược hành động riêng biệt của người vận hành.

<a id="roll-back-an-update"></a>
## Hoàn nguyên bản cập nhật

Nếu bản cài đặt mới không tải hoặc không thể tạo báo cáo hiện tại:

1. Dừng máy chủ.
2. Hãy chuyển bản cài đặt không thành công sang một bên mà không xóa bản ghi của nó.
3. Khôi phục bản cập nhật trước hoàn chỉnh RandomDayGuard thư mục.
4. Khôi phục cấu hình đã xem xét và bằng chứng đã lưu từ cùng một bản sao lưu.
5. Xác nhận đã bật mod và khởi động máy chủ.
6. Đọc báo cáo trạng thái máy chủ đã khôi phục trước khi thực hiện một thay đổi khác.

<a id="more-help"></a>
## Trợ giúp thêm

- [Đọc báo cáo đầu tiên](B%E1%BA%AET_%C4%90%E1%BA%A6U_T%E1%BA%A0I_%C4%90%C3%82Y.md)
- [Sách hướng dẫn vận hành](S%C3%81CH_H%C6%AF%E1%BB%9ANG_D%E1%BA%AAN_HO%E1%BA%A0T_%C4%90%E1%BB%98NG.md)
- [Khắc phục sự cố](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md)
- [Hồ sơ cấu hình](H%E1%BB%92_S%C6%A0_C%E1%BA%A4U_H%C3%8CNH.md)
- [Admin.ini thực thi](TH%E1%BB%B0C_THI_INI_C%E1%BB%A6A_QU%E1%BA%A2N_TR%E1%BB%8A_VI%C3%8AN.md)

Người bảo trì bản phát hành có thể tìm thấy các bước kiểm tra nguồn, gói và quyền riêng tư trong [Xác thực và phát hành](X%C3%81C_TH%E1%BB%B0C_V%C3%80_PH%C3%81T_H%C3%80NH.md). Chúng không cần thiết cho việc cài đặt thông thường.
