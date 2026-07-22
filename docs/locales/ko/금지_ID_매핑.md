<a id="ban-id-mapping"></a>
# 금지 ID 매핑

> **표준 영어 소스:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). 이 현지화된 문서는 정확한 명령, 경로, 키, 상태 값, 해시 및 파일 이름을 보존합니다. 기술적인 표현이 다를 경우 영어 소스를 사용하세요.


플레이어 이름을 안전한 `Admin.ini` 금지 라인으로 변환할 때 이 페이지를 사용하십시오.

<a id="core-rule"></a>
## 핵심 규칙

표시 이름은 금지 ID가 아닙니다.

`Admin.ini` 다음을 사용합니다:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## 증거 계층구조

| 순위 | 소스 | 사용 |
|---:|---|---|
| 1 | 서버 로그 `Login request` | 최상의 이름-ID 매핑 |
| 2 | `Player_<ID>.sav` | ID가 존재하는지 확인 |
| 3 | 기존 `Admin.ini` | 기존 bans/moderators |
| 4 | 외부 알림 또는 호스팅 패널 활동 | Time/name 상황에 한함. ID 증명 아님 |
| 5 | UE4SS focus/player 라인 | Presence/context 전용 |
| 6 | 시스템 수명 주기 또는 컨테이너 로그 | 호스트 수명 주기 컨텍스트 전용, 신분증 아님 |

<a id="extract-the-clean-id"></a>
## 클린 ID 추출

원시 예:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

클린 `Admin.ini` 값:

```ini
BannedPlayer=2535422284688820
```

붙여넣지 않음 `_+_|...`.

<a id="verify-with-playerdata"></a>
## PlayerData

확인 사항:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

의미:

```text
The ID exists in the world save.
```

제한 사항:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## 차단하지 말아야 할 경우

다음과 같은 경우 금지 ID를 할당하지 마세요.

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## 증거 테이블 템플릿

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
## 관련 문서

* [`ADMIN_INI_ENFORCEMENT.md`](%EA%B4%80%EB%A6%AC%EC%9E%90_INI_%EC%8B%9C%ED%96%89.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](%ED%94%8C%EB%A0%88%EC%9D%B4%EC%96%B4_%EA%B2%80%ED%86%A0_%EC%9B%8C%ED%81%AC%ED%94%8C%EB%A1%9C.md)
