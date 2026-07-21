# Hướng dẫn RandomDayGuard bằng tiếng Việt

**v0.4.12-alpha**

RandomDayGuard chuyển bằng chứng có giới hạn từ máy chủ chuyên dụng Abiotic
Factor thành báo cáo dễ đọc cho quản trị viên. Trạng thái máy chủ, tổng kết
hằng ngày, hoạt động người chơi, xem xét vụ việc và lỗi nghiêm trọng được giữ
trên các tuyến riêng.

## Cài đặt

Làm theo [hướng dẫn cài đặt](../../../INSTALL.md). Thư mục đúng là
`ue4ss/Mods/RandomDayGuard` và `mods.txt` phải chứa
`RandomDayGuard : 1`. Tránh cài đặt lồng nhau và thư mục `Scripts` trùng lặp.

## Kiểm tra báo cáo đầu tiên

Mở `runtime/current/startup_status.json`, sau đó
`runtime/final_logs/latest_dossier.json` và
`runtime/final_logs/route_proof.json`. Mỗi tuyến phải hiển thị `full`,
`limited_expected_empty` hoặc `missing`. Báo cáo và nguồn được trích dẫn phải
thuộc cùng một chu kỳ.

## Cấu hình và vận hành

Giá trị công khai mặc định là `review_only_mode = true`, `auto_ban = false`
và `write_admin_ini = false`. Đọc [Bắt đầu](../../START_HERE.md),
[Vận hành](../../OPERATIONS_PLAYBOOK.md), [Cấu hình](../../CONFIG_PROFILES.md)
và [Khắc phục sự cố](../../TROUBLESHOOTING.md).

Lệnh, đường dẫn, khóa và giá trị trạng thái vẫn giữ nguyên tiếng Anh để khớp
chính xác với tệp thực tế.

## Bản alpha và hai luồng bằng chứng

Đây là bản alpha. Các luồng thu thập, báo cáo và khôi phục đã được kiểm thử; khả năng tương thích, độ bao phủ lịch sử và chất lượng báo cáo vẫn tiếp tục được cải thiện.

Luồng hiện tại dùng log đang hoạt động, trạng thái khởi động và bộ lập lịch hiện tại, cùng các phiên hiện thời nên có thể viết báo cáo hiện tại ngay. Luồng lịch sử kiểm tra log lưu lại, tên PlayerData, bằng chứng và hồ sơ cũ theo từng bước giới hạn.

`runtime/current/report_worker_status.json`

So sánh `scan_cursor` và `last_progress_ts` trong `runtime/current/report_worker_status.json` qua nhiều chu kỳ. Nếu chúng tiến lên, quá trình quét vẫn hoạt động. Nếu báo cáo hiện tại tiến lên nhưng chúng không đổi, quá trình quét lịch sử bị kẹt; dữ kiện hiện tại vẫn dùng được, nhưng kết luận cần lịch sử cũ bị giới hạn.

[Troubleshooting](../../TROUBLESHOOTING.md)
