<a id="detection-signals"></a>
# Tín hiệu phát hiện

> **Nguồn tiếng Anh chuẩn:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Tín hiệu là đầu vào đánh giá chứ không phải lời buộc tội tự động.

<a id="signal-table"></a>
## Bảng tín hiệu

| Tín hiệu | Ý nghĩa | Mạnh hơn khi... | Bản thân nó là không đủ |
|---|---|---|---|
| Nhận dạng đăng nhập | Ánh xạ tên tới ID tài khoản | Đã có ConnectID | Cấm |
| Nghỉ phép sạch sẽ | Đóng phiên bình thường | Tham gia và rời khỏi trận đấu | Nghi ngờ |
| Kết nối lại nhanh chóng | Churn/probing bối cảnh | Lặp lại nhanh chóng | Cấm |
| Ngắt kết nối không sạch | Phiên không được đóng sạch sẽ | Lặp lại hoặc chồng chéo sự cố | Cấm |
| Sự cố chồng chéo | Tài khoản đang hoạt động gần gặp sự cố | Lặp lại cùng một tài khoản | Cấm |
| Quay lại sau sự cố | Tài khoản trả về sau khi khởi động lại | Lặp lại qua các kỷ nguyên | Cấm một sự kiện |
| Cảnh báo bùng nổ | Cửa sổ cảnh báo máy chủ | Các phiên được ánh xạ chồng chéo | Cấm theo một loạt |
| Tác nhân lưu liên lạc | Bối cảnh lưu thế giới | Tương quan với các phiên | Bằng chứng về use/theft |
| Thay đổi đối tượng delta | World/class | Tương quan với các phiên | Cấm chỉ đếm |
| Trường hợp đột kích | Cụm nhiều tài khoản | Tài khoản trung tâm lặp lại | Cấm hàng loạt tất cả tài khoản |

<a id="login-identity"></a>
## Nhận dạng đăng nhập

Nguồn tốt nhất:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Sử dụng nó để ánh xạ:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Kết nối lại nhanh chóng

Mẫu:

```text
join -> leave -> join -> leave -> join
```

Sử dụng để xem xét khi lặp lại.

An toàn:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Chồng chéo sự cố và quay lại sau sự cố

Mẫu:

```text
account active before crash
server restarts
same account returns quickly
```

Sử dụng để xem xét khi lặp lại trong các kỷ nguyên.

An toàn:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Cảnh báo bùng phát

Ví dụ:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Sử dụng làm ngữ cảnh cho đến khi được liên kết với các phiên và ngưỡng được ánh xạ.

<a id="actor-save-touch"></a>
## Tác nhân lưu liên lạc

Ý nghĩa:

```text
The server evidence referenced a class or actor.
```

Không có nghĩa:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Các trường hợp đột kích

Trường hợp đột kích nhóm các tài khoản theo thời gian và khoảng thời gian dùng chung.

Quy tắc:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Tài liệu liên quan

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](H%C3%8CNH_M%E1%BA%AAU_V%C3%80_KH%E1%BA%A2_N%C4%82NG_PH%E1%BB%A4C_H%E1%BB%92I_C%E1%BB%A6A_K%E1%BA%BA_X%E1%BA%A4U.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](QUY_TR%C3%8CNH_%C4%90%C3%81NH_GI%C3%81_NG%C6%AF%E1%BB%9CI_CH%C6%A0I.md)
