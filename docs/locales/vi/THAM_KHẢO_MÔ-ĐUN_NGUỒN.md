<a id="source-module-reference"></a>
# Tham khảo mô-đun nguồn

> **Nguồn tiếng Anh chuẩn:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Trang này ánh xạ mọi nguồn, cấu hình, dữ liệu, lớp trình tải tương thích và trình giữ chỗ thời gian chạy được danh sách cho phép phát hành thừa nhận. Chỉ số máy là [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); trang này là lời giải thích kinh điển có thể đọc được. Mỗi hàng máy được tạo đặt tên một path/class, mục đích, sở hữu khối nguồn, cài đặt công khai, tác dụng phụ, trạng thái mà người vận hành có thể nhìn thấy, lỗi, khôi phục và tài liệu chuẩn.

<a id="packaged-file-map"></a>
## Bản đồ tệp được đóng gói

| Đường dẫn | Trách nhiệm | Điểm truy cập hoặc người gọi | Đầu vào | Kết quả đầu ra và tác dụng phụ | Hành vi lỗi | Người dùng có thể chỉnh sửa |
|---|---|---|---|---|---|---|
| `LICENSE` | Giấy phép dự án được gửi đến thư mục gốc của kho lưu trữ. | Trình cài đặt, nhà phân phối lại và nhà điều hành. | Văn bản giấy phép kho lưu trữ đã được xem xét. | Nêu rõ các điều khoản áp dụng cho gói; không có đột biến thời gian chạy. | Việc thiếu sót khiến gói phát hành không hoàn chỉnh về mặt pháp lý và chặn danh sách cho phép. | Không. |
| `NOTICE.md` | Thông báo dự án được gửi đến thư mục gốc của kho lưu trữ. | Trình cài đặt và nhà điều hành. | Thông báo dự án đã được xem xét. | Giữ nguyên ghi công và dự án bắt buộc bối cảnh; không có đột biến thời gian chạy. | Việc thiếu sót khiến gói phát hành không đầy đủ và chặn danh sách cho phép. | Không. |
| `THIRD_PARTY_NOTICES.md` | Thông báo của bên thứ ba được gửi tại thư mục gốc của kho lưu trữ. | Trình cài đặt và nhà phân phối lại. | Văn bản ghi công của bên thứ ba đã xem xét. | Duy trì ghi công phụ thuộc; không có đột biến thời gian chạy. | Việc thiếu sót khiến gói phát hành không đầy đủ và chặn danh sách cho phép. | Không. |
| `RandomDayGuard/enabled.txt` | UE4SS cờ kích hoạt mod. | UE4SS trình tải mod. | `1` hoặc `0` được hỗ trợ bởi UE4SS. | Bật hoặc tắt tải; không ghi bằng chứng thời gian chạy. | Cờ bị vô hiệu hóa hoặc không đúng định dạng sẽ ngăn chặn bằng chứng khởi động bình thường. | Có, trong khi cài đặt. |
| `RandomDayGuard/config.lua` | Hoàn thành bảng cài đặt công khai. | `Scripts/main.lua` khi khởi động. | Các trường riêng biệt được phân loại trong [`CONFIG_FIELD_CATALOG.md`](DANH_M%E1%BB%A4C_TR%C6%AF%E1%BB%9CNG_C%E1%BA%A4U_H%C3%8CNH.md). | Kiểm soát việc khám phá, ngân sách, báo cáo, cổng đánh giá và điểm đánh dấu cục bộ tùy chọn. | Lua/load/default chặn quá trình xác thực hoặc khiến quá trình khởi động bị đóng. | Có; giữ một bản sao lưu. |
| `RandomDayGuard/SavedRoot.txt` | Ghi đè gốc đã lưu rõ ràng tùy chọn. | Trình phân giải gốc đã lưu trong `main.lua`. | Một đường dẫn hệ thống tệp chung tới `AbioticFactor/Saved`. | Chọn root được sử dụng cho nhật ký, lưu, PlayerData tên tệp và `Admin.ini`. | Cho phép thiếu; các đường dẫn không an toàn, sai hoặc không thể đọc được vẫn chưa được chứng minh. | Có; không bao giờ đặt thông tin xác thực ở đây. |
| `RandomDayGuard/BUILD_MARKER.txt` | Danh tính gói mà con người có thể đọc được. | Trình cài đặt, trình xác thực và nhà điều hành. | Phiên bản phát hành do trình tạo cung cấp. | Không có đột biến khi chạy. | Phiên bản không khớp chặn việc đóng gói. | Không. |
| `RandomDayGuard/MANIFEST.json` | Máy có thể đọc được. Siêu dữ liệu bố cục và nhận dạng gói. | Trình xác thực, trình tạo và công cụ hỗ trợ. | Phiên bản phát hành do trình tạo cung cấp. | Không có đột biến khi chạy. | JSON hoặc phiên bản đóng gói khối không khớp. | Không. |
| `RandomDayGuard/README.txt` | Đã cài đặt tham chiếu nhanh bằng tiếng Anh. | Toán tử. | Đường dẫn đóng gói và các giá trị mặc định an toàn. | Không có đột biến khi chạy. | Stale đường dẫn hoặc từ ngữ an toàn không đảm bảo tính chẵn lẻ của tài liệu. | Không. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS mục nhập, thu thập bằng chứng, quyền sở hữu nhà nước, lập lịch có giới hạn, thực thi tùy chọn và người viết đầu ra. | UE4SS. | Cấu hình, nguồn gốc đã lưu, trạng thái thời gian chạy hiện tại, từ điển và mô-đun báo cáo. | Viết các lớp thời gian chạy trong [`OUTPUT_SCHEMA_REFERENCE.md`](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md); đường dẫn thực thi đã được phê duyệt có thể sao lưu và cập nhật `Admin.ini`. | Startup/poll/write lỗi tạo ra trạng thái lỗi rõ ràng và không bao giờ chứng minh được việc hoàn thành lộ trình. | Không. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Kế toán nguồn, dòng chu kỳ hiện tại, dịch báo cáo, bằng chứng lộ trình, lịch sử công khai lâu dài và hộp thư đi cục bộ tùy chọn. | `main.lua` nhân viên báo cáo. | Gọi lại state/context chỉ đọc và bằng chứng cục bộ được giữ lại. | Viết cặp báo cáo JSON/TXT, source/history tính toán, bằng chứng lộ trình, lịch sử tài khoản lâu bền và thông báo status/envelopes. | Thiếu dòng, nguồn bắt buộc, ghi theo cặp hoặc lực lượng ghi kiểm chứng lộ trình `missing` và chặn hàng đợi. | Không. |
| `RandomDayGuard/data/detection_events.json` | Từ vựng và giải thích về sự kiện công cộng. | `main.lua` sự kiện normalization/reporting. | Hợp lệ JSON từ điển. | Gắn nhãn bằng chứng; không tạo ra quan sát. | Missing/malformed dữ liệu chặn xác thực kho lưu trữ. | Không. |
| `RandomDayGuard/data/warning_types.json` | Từ vựng loại cảnh báo và ý nghĩa đánh giá. | Cảnh báo normalization/reporting. | Hợp lệ JSON từ điển. | Gắn nhãn bằng chứng cảnh báo. | Missing/malformed dữ liệu chặn xác thực kho lưu trữ. | Không. |
| `RandomDayGuard/data/object_categories.json` | Object/class từ vựng danh mục. | Quét và báo cáo đăng ký đối tượng. | Hợp lệ JSON từ điển. | Các nhãn được trích xuất bối cảnh lớp. | Missing/malformed dữ liệu chặn xác thực kho lưu trữ. | Không. |
| `RandomDayGuard/runtime/**/.gitkeep` | Chỉ các phần giữ chỗ bố cục cài đặt trống. | Trích xuất gói. | Các byte trống. | Tạo cấu trúc thư mục có thể ghi; không có bằng chứng nào được đóng gói. | Bất kỳ thành viên thời gian chạy không giữ chỗ nào đều chặn danh sách cho phép chính xác. | Không. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS trình tải và cơ quan giám sát

`Scripts/main.lua` sở hữu phần khởi động của cơ quan giám sát độc lập, tính năng khám phá Root đã lưu, đuôi nhật ký hiện tại, kỷ nguyên và phiên máy chủ, bỏ phiếu và quét giới hạn, bối cảnh object/world, tính điểm đánh giá, `Admin.ini` sự an toàn cổng, đầu ra hoạt động kế thừa và chuyển giao nhân viên báo cáo riêng biệt. Nó phải giữ giới hạn bỏ phiếu trực tiếp trong khi công việc lịch sử chậm lại tiếp tục một cách độc lập. Nhịp tim, điểm đánh dấu khởi động hoặc tăng `poll_id` chỉ chứng minh thành phần đó; việc hoàn thành tuyến đường yêu cầu cùng mức khởi động, kỷ nguyên, thăm dò, độ mới của nguồn, cặp báo cáo và bằng chứng tuyến đường hiện tại.

Nguồn và gói có một thẩm quyền: `RandomDayGuard/Scripts/main.lua`. Bản sao `scripts/` chữ thường không phải là một phần của cây nguồn hoặc bản phát hành. Việc giữ một cách viết chuẩn sẽ ngăn chặn lỗi xung đột chữ hoa chữ thường khi gói được trích xuất trên Windows hoặc Linux.

<a id="public-reporting-module"></a>
## Mô-đun báo cáo công khai

`Scripts/public_pipeline.lua` nhận lệnh gọi lại thay vì thông tin xác thực máy chủ hoặc bộ điều hợp nhà cung cấp. Nó kiểm kê tám lớp nguồn, ghi lại các trạng thái đầu cuối và trạng thái chưa hoàn chỉnh, tách biệt người chơi hiện tại khỏi lịch sử được giữ lại, dịch từng tuyến đường theo thứ tự `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action` và `Source references`, sau đó viết bằng chứng lộ trình. Chế độ thông báo tùy chọn ghi JSON chỉ phong bì; nó không bao giờ yêu cầu giao hàng hoặc đóng gói một giao hàng endpoint/bridge.

Phần cố định thực thi trong `tests/lua/public_pipeline_runtime_test.lua` tải mô-đun được vận chuyển này bằng Lua, chứng minh các tuyến đã đầy và dự kiến trống, chứng minh chu trình thiếu nguồn hiện tại không đóng được và chứng minh các tuyến không hoàn chỉnh không đi vào hộp thư đi.

<a id="configuration-and-data"></a>
## Cấu hình và dữ liệu

[`CONFIG_FIELD_CATALOG.md`](DANH_M%E1%BB%A4C_TR%C6%AF%E1%BB%9CNG_C%E1%BA%A4U_H%C3%8CNH.md) và [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) được tạo bởi `tools/generate_documentation_audit.py` từ phân tích cú pháp cấu trúc không thực thi của `config.lua`, danh sách cho phép gói và các lớp đầu ra được phát hiện nguồn. Nội dung được tạo chính xác và mức độ phù hợp từng người một được xác thực. Ba JSON từ điển là nhãn và ánh xạ, không phải nguồn bằng chứng. Nhà điều hành có thể chỉnh sửa cấu hình, lựa chọn gốc đã lưu và kích hoạt; nguồn, từ điển, bảng kê khai và readmes đóng gói đều thuộc sở hữu của bản phát hành.

<a id="package-layout"></a>
## Bố cục gói

Trình tạo chỉ thừa nhận ba tệp pháp lý gốc, `RandomDayGuard/` ở trên và các phần giữ chỗ thời gian chạy trống. Nó ra lệnh cho các thành viên theo từng bước, sửa lỗi ZIP siêu dữ liệu, đóng gói trình tải chuẩn một lần, quét mọi thành viên để tìm tài liệu riêng tư, ghi lại SHA-256 cho mọi thành viên, liên kết tên và byte thành một bản tóm tắt nội dung và xây dựng hai lần. Các cuộc kiểm tra loại bỏ mọi xung đột theo từng trường hợp và chứng minh việc trích xuất thông thường tạo ra chính xác một tệp vật lý cho mỗi mục lưu trữ.

Kho lưu trữ công cộng chỉ giữ thư mục phát hành hiện tại. Trình xây dựng sẽ kiểm tra xem nó ZIP, tổng kiểm tra, ghi chú, điểm đánh dấu phiên bản và cây nguồn đều đồng ý.

<a id="code-comment-contract"></a>
## Hợp đồng nhận xét mã

Nhận xét trong thời gian chạy là hợp đồng ngắn gọn dành cho người bảo trì, không phải là hướng dẫn sử dụng thứ hai. Mỗi mô-đun thời gian chạy được vận chuyển phải đặt một liên kết chuẩn trong khối nhận xét mở đầu của nó:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Trạng thái không rõ ràng, lập kế hoạch, write/readback/rollback, khám phá nguồn, dịch thuật, bằng chứng, lược đồ đầu ra, nhịp tuyến và khối biên tập sử dụng các nhận xét tập trung với các nhãn này nếu có:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

Trình tải chính cũng có một nhận xét chủ sở hữu tập trung để tải cấu hình, Khám phá đã lưu, thay thế nguyên tử, thực thi và lập lịch. Những nhận xét này nêu rõ ranh giới luồng điều khiển và lỗi; chúng không thay đổi hành vi thời gian chạy.

Trình xác thực yêu cầu liên kết `Documentation:` cấp mô-đun cho mỗi mô-đun thời gian chạy, giải quyết mọi đường dẫn nhận xét và neo, yêu cầu các nhận xét về hợp đồng và lỗi tập trung trong cả hai mô-đun thời gian chạy và so sánh các liên kết chuẩn giống nhau với `TRACEABILITY_INDEX.json`. Nhận xét là khả năng truy nguyên, không phải bằng chứng thời gian chạy.

<a id="contributor-change-checklist"></a>
## Danh sách kiểm tra thay đổi của người đóng góp

1. Cập nhật một mô-đun sở hữu và phần cố định tập trung của nó.
2. Cập nhật phần cấu hình, lược đồ, đầu ra, bằng chứng hoặc vòng đời chuẩn.
3. Chạy `python -B tools/generate_documentation_audit.py --write` sau một cấu hình, đường dẫn đóng gói, lớp đầu ra được tạo, chủ sở hữu, hoặc thay đổi hợp đồng khôi phục.
4. Chạy `python -B tools/generate_documentation_audit.py --check`, kiểm thử đơn vị tập trung, bản cố định Lua thực có Lua, trình xác thực đầy đủ, hai bản dựng xác định độc lập và `git diff --check`.
5. Xem lại ZIP danh sách thành viên, tổng kiểm tra và quét tài liệu riêng tư trước khi tạo bản phát hành.
