<a id="validation-and-release"></a>
# Xác thực và phát hành

> **Nguồn tiếng Anh chuẩn:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Trang này dành cho những người đóng góp và người bảo trì bản phát hành. Người vận hành máy chủ không cần chạy các lệnh này để cài đặt RandomDayGuard.

<a id="user-visible-proof"></a>
## Bằng chứng hiển thị cho người dùng

Một bản phát hành là điều dễ hiểu khi người vận hành mới có thể cài đặt nó, tìm báo cáo trạng thái máy chủ đầu tiên, phân biệt năm lộ trình báo cáo và thực hiện theo một hành động rõ ràng từ một ví dụ đã hoạt động. Các tác vụ của người đọc không được yêu cầu kiến ​​thức về Git, PowerShell, Python hoặc tổng kiểm tra.

<a id="contributor-checks"></a>
## Kiểm tra cộng tác viên

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Khi `luac` khả dụng:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

Kiểm tra lịch thi đấu Lua bao gồm bộ tải, bộ lập lịch, lộ trình báo cáo và Admin.ini ghi giao dịch tùy chọn. Các công cụ thực thi chỉ sử dụng các tệp tạm thời và xác minh danh tính, từ chối tài khoản đáng tin cậy, ngưỡng, sao lưu, từ chối thay đổi đồng thời, đọc lại và khôi phục.

<a id="package-proof"></a>
## Bằng chứng gói

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Tất cả các điểm đánh dấu phiên bản đều khớp với `VERSION`.
- Chỉ có phiên bản hiện tại tồn tại trong `releases/`.
- ZIP chứa các byte `RandomDayGuard/Scripts/main.lua` chuẩn và không có trình tải biến thể chữ thường.
- Đầu ra thời gian chạy, cấu hình riêng tư, thông tin xác thực, đường dẫn cục bộ, bộ nhớ đệm và các tạo phẩm thử nghiệm đều bị loại trừ.
- Cấu hình công khai vẫn chỉ ở chế độ xem xét khi tính năng thực thi bị vô hiệu hóa.
- Năm ví dụ báo cáo đã hoạt động vẫn nhất quán với quyền sở hữu tuyến đường và bản thử nghiệm phát hành cố định.
- ZIP chuẩn có tính xác định và khớp `CHECKSUMS.sha256`.
- Tất cả các liên kết tài liệu cục bộ và 27 trang nhập ngôn ngữ đều xác thực.

<a id="avoid-validation-environment-pitfalls"></a>
## Tránh những cạm bẫy trong môi trường xác thực

- Chạy kiểm tra việc ghi kho lưu trữ một cách tuần tự để tránh xung đột tệp tạm thời.
- Trên Windows, hãy kiểm tra tên thành viên được lưu trữ hoặc đánh vần đường dẫn được liệt kê thay vì tra cứu tệp không phân biệt chữ hoa chữ thường khi kiểm tra các trình tải trùng lặp.
- Thiếu `luac` hoặc thời gian chạy Lua là một khả năng không khả dụng, không phải là một cú pháp vượt qua hoặc kiểm tra thời gian chạy.
- Một thiết bị cố định chỉ chứng minh các đầu vào được mô hình hóa của nó. Điều đó không chứng minh được máy chủ trực tiếp đã tạo ra báo cáo hiện tại.
- Ghi lại thời gian chờ của lệnh và đầu ra một phần thay vì giả sử hoàn thành.

<a id="repair-failed-repository-validation"></a>
## Sửa chữa xác thực kho lưu trữ bị lỗi

Bắt đầu với đường dẫn hoặc hợp đồng được báo cáo đầu tiên. Hãy sửa mục đó, chạy lại bài kiểm tra hẹp, sau đó chạy lại ma trận hoàn chỉnh. Đừng che giấu khả năng còn thiếu bằng cách loại bỏ bài kiểm tra yêu cầu khả năng đó.

<a id="known-limits-and-release-decision"></a>
## Các giới hạn đã biết và quyết định phát hành

Kiểm tra cục bộ chứng minh các hợp đồng về nguồn, vật cố định, gói và tài liệu. Cài đặt máy chủ cụ thể, cửa sổ ổn định lâu dài hoặc màn hình máy khách yêu cầu kết quả tích hợp riêng. Ghi lại kết quả đó cùng với bản dựng, cấu hình, thời lượng và kết quả quan sát được trước khi đưa ra xác nhận tương ứng.
