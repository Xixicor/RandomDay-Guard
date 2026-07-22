<a id="status-and-error-reference"></a>
# Tham chiếu trạng thái và lỗi

> **Nguồn tiếng Anh chuẩn:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Sử dụng tài liệu tham khảo này sau khi một triệu chứng đã được phân loại trong [Khắc phục sự cố](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md). Đọc tệp trạng thái có cấu trúc được đặt tên theo lỗi. Các mã riêng biệt thể hiện trạng thái an toàn và vòng đời riêng biệt; không thu gọn chúng thành kết quả chung chung "Guard thất bại".

<a id="route-and-source-states"></a>
## Trạng thái tuyến và nguồn

| Giá trị | Ý nghĩa | Phản hồi của người vận hành |
|---|---|---|
| `full` | Hợp đồng lộ trình đã hoàn thành với bằng chứng nguồn chu kỳ hiện tại. | Đọc ranh giới bằng chứng của tuyến đường; không ngụ ý sửa chữa. |
| `limited_expected_empty` | Lộ trình đã hoàn thành và hoạt động còn thiếu là hợp lệ cho chu trình này. | Không nên tạo sự kiện player/case tổng hợp. |
| `missing` | Không có đầu ra bắt buộc, trường dòng dõi hoặc bằng chứng nguồn. | Kiểm tra lý do tuyến đường và trạng thái nguồn được đặt tên. |
| `available` | Nguồn được đặt tên có thể đọc và sử dụng được. | Không làm gì cả. |
| `expected_empty` | Nguồn đã được kiểm tra và không có hàng nào. | Không có hành động nào trừ khi hoạt động được dự kiến độc lập. |
| `partial` / `complete_with_gaps` | Có bằng chứng hữu ích nhưng các lớp nguồn được đặt tên là không đầy đủ. | Giới hạn kết luận đối với bằng chứng đã thu thập. |
| `deferred` | Công việc có giới hạn được lên kế hoạch cho cơ hội làm việc sau này. | Xác nhận tiến độ tiến bộ trước khi thay đổi cấu hình. |
| `unavailable` | Môi trường không cung cấp nguồn. | Ghi lại giới hạn; chỉ sửa đường dẫn đã được chứng minh hoặc vấn đề về quyền. |
| `malformed` | Nguồn có thể đọc được nhưng xác thực cấu trúc không thành công. | Giữ nguyên và sửa nguồn; đừng đoán. |
| `permission_denied` | Nguồn tồn tại nhưng không thể đọc được. | Chỉ cấp quyền đọc bắt buộc trong phạm vi hẹp. |
| `error` | Việc thu thập không thành công vì lý do đã được ghi lại. | Giữ lại lỗi và chẩn đoán giai đoạn đó. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData và mã hàng tồn kho

| Mã | Ý nghĩa | Phản hồi an toàn |
|---|---|---|
| `saved_root_unavailable` | Không có thư mục gốc đã lưu nào được xác minh có sẵn cho hệ thống công cộng. | Sửa `SavedRoot.txt` và kiểm tra lại thăm dò đường dẫn. |
| `unsafe_playerdata_root` | PlayerData khám phá được giải quyết bên ngoài thư mục gốc đã lưu bị chặn. | Sửa đường dẫn; không bao giờ làm suy yếu ranh giới. |
| `playerdata_discovery_not_run` | Nhân viên khám phá bị chặn chưa chạy. | Kiểm tra tiến trình của nhân viên và bộ lập lịch. |
| `playerdata_discovery_read_failed:*` | Không thể đọc đầu ra của Discovery. | Giữ lại chi tiết hậu tố và xác minh lệnh kiểm kê bị giới hạn. |
| `inventory_command_open_failed` | Không thể bắt đầu quá trình kiểm kê. | Xác minh thời gian chạy có cung cấp cầu lệnh đã định cấu hình. |
| `inventory_command_read_failed` | Không xuất được khoảng không quảng cáo trong khi đọc. | Giữ nguyên một phần đầu ra và chỉ chạy lại sau khi lỗi cơ bản được khắc phục. |
| `inventory_command_close_failed` | Kho lưu trữ đã hoàn thành mà không có kết quả đóng đáng tin cậy. | Hãy coi nguồn là chưa hoàn chỉnh. |
| `identity_ledger_row_limit_exceeded` | Đầu vào danh tính bền vững đã vượt quá giới hạn an toàn công cộng. | Lưu trữ và xem lại sổ cái; đừng âm thầm cắt bớt nó thành bằng chứng đầy đủ. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini mã thực thi

Tất cả các mã trong phần này đều bị đóng lỗi. Họ không tự mình cho phép lệnh cấm thủ công.

| Mã | Ý nghĩa | Phản hồi an toàn |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Các cổng ghi an toàn công cộng đã tắt. | Dự kiến ​​trong hoạt động chỉ xem xét. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | Chính sách sao lưu bắt buộc không hoạt động. | Hãy tắt tính năng ghi. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Một cổng thực thi rõ ràng bị tắt. | Dự kiến ở các giá trị mặc định chỉ dành cho đánh giá công khai; đừng diễn giải lại nó như một lỗi ghi. |
| `review_only_mode_enabled` | Chế độ chỉ xem lại có chủ ý ngăn chặn đột biến. | Chỉ xem lại bằng chứng. |
| `duplicate_prevention_disabled` | Tính năng bảo vệ trùng lặp đã bị tắt. | Hãy tắt tính năng ghi cho đến khi cổng an toàn được khôi phục. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | Xác minh sau khi ghi hoặc bảo vệ khôi phục đã bị tắt. | Hãy tắt tính năng ghi; không bao giờ vượt qua các cổng này. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | Việc thực thi danh tính sạch hoặc bằng chứng dành riêng cho tài khoản đã bị vô hiệu hóa. | Khôi phục cổng trước bất kỳ thử nghiệm thực thi nào. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | Việc duy trì tài khoản được bảo vệ hoặc lệnh cấm hiện có đã bị vô hiệu hóa. | Hãy tắt tính năng ghi. |
| `clean_numeric_identity_required` | ID được đề xuất không phải là biểu mẫu kết nối hoàn chỉnh được chấp nhận hoặc ID số sạch. | Lấy bản đồ đã xác minh; không bao giờ cắt bớt tiền tố tùy ý. |
| `identity_strength_below_minimum` | Bằng chứng nhận dạng yếu hơn ngưỡng được định cấu hình. | Chỉ xem lại bằng chứng. |
| `playerdata_verification_required` | Cấu hình yêu cầu PlayerData xác nhận và tài khoản không có nó. | Chỉ giữ ứng viên được xem xét; không suy ra quyền sở hữu từ tên tệp. |
| `trusted_or_moderator_identity` | Tài khoản được bảo vệ bởi trạng thái đáng tin cậy hoặc người kiểm duyệt. | Không được phép ghi. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | Đường dẫn đích không hợp lệ hoặc thoát khỏi thư mục gốc đã lưu. | Cấu hình đúng; không bao giờ bỏ qua bộ bảo vệ đường dẫn. |
| `admin_ini_unavailable` | Không tìm thấy Admin.ini được định cấu hình có thể đọc được bên trong thư mục gốc đã lưu. | Sửa đường dẫn bị chặn hoặc vô hiệu hóa việc thực thi. |
| `admin_ini_read_failed` | Không thể đọc được các byte có thẩm quyền. | Dừng trước khi đột biến. |
| `admin_ini_parse_failed` | Admin.ini xác thực thất bại nếu không có mã cấu trúc cụ thể hơn. | Bảo quản tệp và kiểm tra phần cũng như cấu trúc dòng của nó. |
| `admin_ini_contains_nul` | Tệp chứa NUL byte và không được chấp nhận dưới dạng văn bản. | Bảo quản tệp và sửa chữa nó bên ngoài Guard. |
| `admin_ini_duplicate_banned_players_section` | Nhiều hơn một `[BannedPlayers]` tồn tại. | Hợp nhất các phần theo cách thủ công khi đã dừng. |
| `admin_ini_banned_player_outside_section` | Một hàng cấm xuất hiện bên ngoài `[BannedPlayers]`. | Sửa bố cục theo cách thủ công. |
| `admin_ini_invalid_banned_player_line` | Dòng cấm không hẳn là một hàng ID được hỗ trợ rõ ràng. | Sửa dòng không đúng định dạng. |
| `admin_ini_backup_failed` | Bản sao lưu duy nhất không ghi và đọc lại byte giống nhau. | Không được phép đột biến. |
| `admin_ini_external_change_detected` | Một người viết khác đã thay đổi tệp sau ảnh chụp nhanh của Guard. | Giữ lại các byte bên ngoài và chỉ thử lại sau khi điều phối người viết. |
| `atomic_rename_unavailable` | Đã yêu cầu thay thế nguyên tử nhưng Lua không cung cấp `os.rename`. | Không có thao tác ghi nào được tin cậy; sử dụng thời gian chạy được hỗ trợ hoặc tiếp tục tắt tính năng thực thi. |
| `admin_ini_write_failed` | Việc thay thế được kiểm soát chưa hoàn tất. | Kiểm tra lỗi thay thế và bản sao lưu đã ghi. |
| `post_write_verification_failed` | Số byte sản xuất không bằng ứng cử viên. | Kiểm tra `rollback_success` và `rollback_refused_external_change` trước bất kỳ hành động nào. |

<a id="startup-scheduler-and-backlog-states"></a>
## Trạng thái khởi động, lập lịch và tồn đọng

Những giá trị này là bằng chứng về vòng đời, không phải bằng chứng về lộ trình. Đọc chúng với các tệp thăm dò ý kiến, nhân viên báo cáo và chứng minh lộ trình hiện tại.

| Giá trị | Ý nghĩa | Phản hồi an toàn |
|---|---|---|
| `not_started` | Giai đoạn khởi động hoặc lập lịch được đặt tên chưa bắt đầu. | Trong quá trình khởi chạy, hãy đợi khoảng thời gian được ghi lại; sau đó kiểm tra giai đoạn không thay đổi đầu tiên. |
| `main_lua_loaded` / `starting` | Trình tải chuẩn đã chạy và Guard bắt đầu khởi động. | Tiếp tục các giai đoạn sau; chỉ điều này thôi thì chưa sẵn sàng. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Nâng cao quá trình khởi tạo nguồn cốt lõi và tính liên tục. | Không có hành động nào trừ khi giai đoạn tiếp theo ngừng tiến triển. |
| `admin_state_written` / `playerdata_index_written` | Các chỉ mục giới hạn ban đầu đã được xuất. | Không có hành động nào; vẫn phải tuân theo quá trình chuyển giao bộ lập lịch. |
| `watchdog_started` | Cơ quan giám sát báo cáo và cuộc thăm dò đã được đăng ký. | Tiếp theo hãy xác nhận tiến trình của bộ lập lịch và cuộc thăm dò ý kiến. |
| `ready_degraded` / `scan_running` | Bộ bảo vệ đang chạy trong khi quá trình quét lịch sử bị giới hạn vẫn đang chờ xử lý. | Thận trọng, không thất bại; xác minh trước bộ đếm tiến trình. |
| `ready` | Khởi động và quét giới hạn hiện tại đã đạt đến trạng thái sẵn sàng. | Kiểm tra bằng chứng lộ trình riêng. |
| `scan_failed` / `error` | Khởi động hoặc quét bị kết thúc với một lỗi được ghi. | Lưu giữ lỗi được đặt tên hoặc tệp trạng thái và chẩn đoán giai đoạn đó. |
| `running` | Người lập lịch sở hữu cuộc thăm dò trong tương lai cơ hội. | Xác nhận `poll_id` và `poll_completed_count` thăng tiến. |
| `manual_only` | Lập lịch vòng lặp không khả dụng; chỉ công việc rõ ràng mới có thể chạy. | Coi hoạt động không được giám sát là không khả dụng. |
| `stopped` | Hoạt động của bộ lập lịch đã kết thúc. | Kiểm tra các điểm dừng trước đó và bằng chứng lỗi trước khi khởi động lại. |
| `active_log_caught_up` | Không còn tồn đọng nhật ký hoạt động chưa đọc nào. | Có thể tiến hành quét lịch sử. |
| `active_log_unavailable_nonblocking` | Nhật ký hoạt động không có, nhưng quá trình khởi động vẫn không bị chặn. | Ghi lại giới hạn nguồn và xác minh các nguồn khác. |
| `active_log_read_failed` | Nhật ký đang hoạt động đã tồn tại nhưng không thể đọc được. | Giữ lại lỗi và chỉ sửa đường dẫn đã được chứng minh hoặc vấn đề về quyền. |
| `budget_exhausted` / `active_log_has_unread_bytes` | Biên tập đuôi bị chặn đã dừng khi còn tồn đọng. | Xác nhận các cuộc thăm dò sau này sẽ giảm số lượng chưa đọc. |
| `offset_commit_failed_after_events_applied` | Các sự kiện đã được xử lý nhưng việc duy trì bù trừ nhật ký lâu dài không thành công. | Việc thực thi bị trì hoãn; sửa chữa bộ lưu trữ bù đắp trước khi dựa vào một chu kỳ khác. |

<a id="scheduler-report-and-notification-codes"></a>
## Mã lập lịch, báo cáo và thông báo

| Mã hoặc trạng thái | Ý nghĩa | Phản hồi an toàn |
|---|---|---|
| `poll already in flight` | Cuộc gọi lại thứ hai đã đến trong khi cuộc thăm dò hiện tại sở hữu vòng đời. | Xác nhận các tiến bộ cuộc thăm dò hiện tại; không thêm chủ sở hữu vòng lặp khác. |
| `no_log_files_found` | Không phát hiện thấy nhật ký hoạt động hoặc sao lưu đã định cấu hình nào. | Xác minh cấu hình nguồn và gốc đã lưu. |
| `current_poll_error` | Chu kỳ hiện tại đã ghi lại lỗi nguồn thăm dò ý kiến. | Đọc `runtime/current/poll_error.json`. |
| `cadence_deferred` | Bộ điều phối hoàn thành chưa đến hạn. | Dự kiến cho đến khi có cơ hội giới hạn tiếp theo. |
| `reports_disabled` | Việc tạo báo cáo công khai bị tắt. | Chỉ bật nếu báo cáo được mong muốn. |
| `local_outbox_write_failed` | Không thể ghi một phong bì cục bộ đã dịch. | Sửa chữa thư mục đầu ra thời gian chạy; đây không phải là lỗi truyền tải thông báo. |
| `source_accounting_disabled` | Bằng chứng định tuyến không thể yêu cầu phạm vi phủ sóng nguồn hoàn chỉnh. | Bật tính năng tính toán nguồn hoặc chấp nhận bằng chứng bị thiếu một cách rõ ràng. |
| `route_disabled` | Tuyến đường bị vô hiệu hóa có chủ ý. | Dự kiến ​​sẽ không có chuyến giao hàng nào cho tuyến đường đó. |
| `poll_owner_between_polls` | Nhân viên báo cáo được xếp hàng chờ khoảng trống do người lập lịch trình sở hữu giữa các cuộc thăm dò. | Chỉ được mong đợi khi dấu thời gian và con trỏ tiếp tục tiến lên. |
| `unsafe_shell_path` | Khoảng không quảng cáo bị giới hạn hoặc đường dẫn shell không thể xác thực an toàn nền tảng. | Sửa đường dẫn; không bao giờ làm suy yếu trích dẫn hoặc xác thực đường dẫn. |

<a id="related-procedures"></a>
## Thủ tục liên quan

- [Khắc phục sự cố](KH%E1%BA%AEC_PH%E1%BB%A4C_S%E1%BB%B0_C%E1%BB%90.md) để phân loại triệu chứng và sửa chữa.
- [Đánh giá xác thực và phát hành](X%C3%81C_TH%E1%BB%B0C_V%C3%80_PH%C3%81T_H%C3%80NH.md) cho các lỗi cố định và gói.
- [Tham chiếu lược đồ đầu ra](THAM_KH%E1%BA%A2O_L%C6%AF%E1%BB%A2C_%C4%90%E1%BB%92_%C4%90%E1%BA%A6U_RA.md) cho các hợp đồng hiện trường hoàn chỉnh.
