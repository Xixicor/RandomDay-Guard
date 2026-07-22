<a id="ban-id-mapping"></a>
# Cấm ánh xạ ID

> **Nguồn tiếng Anh chuẩn:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Sử dụng trang này khi chuyển đổi tên người chơi thành `Admin.ini` dòng cấm.

<a id="core-rule"></a>
## Quy tắc cốt lõi

Tên hiển thị không phải là ID lệnh cấm.

`Admin.ini` sử dụng:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Phân cấp bằng chứng

| Xếp hạng | Nguồn | Sử dụng |
|---:|---|---|
| 1 | Nhật ký máy chủ `Login request` | Ánh xạ tên-ID tốt nhất |
| 2 | `Player_<ID>.sav` | Xác nhận ID tồn tại |
| 3 | Hiện tại `Admin.ini` | Hiện tại bans/moderators |
| 4 | Thông báo bên ngoài hoặc hoạt động của bảng lưu trữ | Time/name chỉ ngữ cảnh; không phải bằng chứng ID |
| 5 | UE4SS focus/player dòng | Presence/context chỉ |
| 6 | Nhật ký vùng chứa hoặc vòng đời hệ thống | Chỉ ngữ cảnh vòng đời của máy chủ; không phải bằng chứng ID |

<a id="extract-the-clean-id"></a>
## Trích xuất ID sạch

Ví dụ thô:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Làm sạch `Admin.ini` giá trị:

```ini
BannedPlayer=2535422284688820
```

Không dán `_+_|...`.

<a id="verify-with-playerdata"></a>
## Xác minh bằng PlayerData

Kiểm tra:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Ý nghĩa:

```text
The ID exists in the world save.
```

Giới hạn:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Khi nào không nên cấm

Không chỉ định ID lệnh cấm khi:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Mẫu bảng bằng chứng

```text
display_name:
server_time:
log_file:
line_number:
log_name:
connect_id_raw:
ban_id:
unique_id:
playerdata_file:
decision:
notes:
```

<a id="related-docs"></a>
## Tài liệu liên quan

* [`ADMIN_INI_ENFORCEMENT.md`](TH%E1%BB%B0C_THI_INI_C%E1%BB%A6A_QU%E1%BA%A2N_TR%E1%BB%8A_VI%C3%8AN.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
