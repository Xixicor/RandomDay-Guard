<a id="adminini-enforcement"></a>
# Admin.ini 시행

> **표준 영어 소스:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). 이 현지화된 문서는 정확한 명령, 경로, 키, 상태 값, 해시 및 파일 이름을 보존합니다. 기술적인 표현이 다를 경우 영어 소스를 사용하세요.


RandomDayGuard은 기본 설정에서 서버 금지 목록을 변경하지 않습니다. 관리자가 검토할 수 있는 보고서만 생성됩니다. 이 페이지에서는 의도적으로 활성화한 관리자를 위한 선택적 자동 금지 목록 업데이트에 대해 설명합니다.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## 금지 목록을 변경하기 전에 Guard가 확인하는 사항

경비원은 아래의 모든 답변이 다음과 같은 경우에만 차단을 추가합니다**예**:

1. 현재 증거에 따르면 하나의 특정 계정이 충분한 신뢰도로 식별되었습니까?
2. 해당 계정은 중재자가 아닙니다. 관리자가 신뢰할 수 있다고 표시한 계정도 아닌가요?
3. 해당 계정이 이미 차단 목록에 없나요?
4. 계정이 구성된 자동 작업 점수에 도달했나요?
5. Guard가 현재를 읽을 수 있나요 `Admin.ini`동일한 백업을 저장하시겠습니까?
6. Guard가 업데이트를 준비하는 동안 `Admin.ini`변경되지 않은 상태로 유지됩니까?
7. 저장 후 전체 파일이 의도한 결과와 정확하게 일치합니까?

답변이 다음과 같은 경우**아니요**, 확인할 수 없는 경우 경비원이 떠납니다 `Admin.ini` 변경되지 않고 그대로 유지됩니다. 그 이유를 보고서에 기록합니다. 저장이 시작되었지만 최종 확인이 실패하면 Guard는 확인된 백업을 복원합니다.

<a id="file-format"></a>
## 파일 형식

`Admin.ini`은 깨끗한 금지선만 수신해야 합니다:

```ini
BannedPlayer=<ID>
```

- 이름 없음.
- 설명 없음.
- 이유 없음.
- 아니요 접미사.

<a id="safe-defaults"></a>
## 안전한 기본값

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## 금지 ID 소스

최상의 소스:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

런타임은 전체 숫자 ID 또는 완전히 문서화된 `<digits>_+_|<non-space token>` 연결 양식을 허용하고 여기에서 숫자 금지 ID를 파생합니다. 알 수 없는 접미사가 있는 임의의 숫자 접두사는 거부됩니다. 금지 ID로 잘리지 않습니다.

맞음:

```ini
BannedPlayer=2535422284688820
```

잘못됨:

```ini
BannedPlayer=ExamplePlayer
```

잘못됨:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## 정확한 설정 Guard 확인

이러한 설정은 위에서 설명한 확인을 구현합니다. 나열된 모든 조건은 true여야 합니다.

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

어떤 조건이라도 false이거나 확인할 수 없는 경우 Guard는 금지 목록을 변경하지 않고 그대로 두고 이를 중지한 항목을 기록합니다.

<a id="transaction-safety"></a>
## 거래 안전

유일한 `Admin.ini` 변형 경로는 다음 단계를 순서대로 수행합니다.

1. 신뢰할 수 있는 바이트를 읽고 구조적으로 유효성을 검사합니다.
2. 동일한 스냅샷에서 중재자, 신뢰할 수 있는 상태 및 기존 차단 상태를 파생시킵니다.
3. `runtime/backups/` 및 바이트 단위로 확인하십시오.
4. 교체 직전에 `Admin.ini` 다시 읽고 외부 변경 사항을 거부하십시오.
5. 구성된 제어된 교체 경로를 통해 후보를 쓰십시오.
6. 전체 읽기 바이트가 전체 후보 바이트와 동일해야 합니다.
7. 다시 읽기가 실패하는 경우에만 확인된 백업을 복원하십시오. 현재 파일은 여전히 Guard가 작성한 정확한 후보입니다. 다른 작성자가 변경한 경우 Guard는 알 수 없는 외부 바이트를 덮어쓰는 대신 롤백을 거부합니다.

중복 ID는 멱등성을 갖습니다. 두 번째 줄과 두 번째 백업이 기록되지 않습니다. 백업 이름에는 타임스탬프, 소스 바이트 지문 및 클린 ID가 포함되므로 별도의 시도가 이전 1초 파일 이름을 공유할 수 없습니다.

<a id="local-regression-proof"></a>
## 로컬 회귀 증명

`tests/lua/enforcement_runtime_test.lua` 제공된 로더를 한 번 부팅한 다음 저장소 `append_ban()` 클로저를 실행합니다. 여기에는 삽입, 중복 멱등성, `.tmp/` 디렉터리 아래에 있는 격리된 합성 파일에 대해 실제 로컬 moderator/trusted 거부, 약하고 잘못된 형식의 ID 거부, 바이트 단위의 정확한 백업 확인, 동시 수정 거부, 읽기 실패 후 성공적인 롤백, 쓰기 후 외부 변경 덮어쓰기 거부 등이 포함됩니다. 파일 시스템 래퍼는 픽스처 루트 외부의 모든 변형을 거부합니다. 실제 서버 경로가 없거나 실제 `Admin.ini`가 사용됩니다.

`python tools/test_public_pipeline.py`를 통해 실행하세요. Fixture Pass는 로컬 트랜잭션 동작만 증명합니다. 시행을 활성화하거나 프로덕션 쓰기를 승인하거나 호스트별 권한을 증명하지 않습니다.

<a id="files-to-check"></a>
## 확인할 파일

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## 롤백

1. 서버를 중지하세요.
2. 다음에서 최신 Admin.ini 백업을 `runtime/backups/`.
3. 잘못된 내용을 삭제하세요 `BannedPlayer=<ID>` 필요한 경우 라인
4. 서버를 시작하세요.
5. 다시 열기 Admin.ini 줄이 지속되거나 제거되었는지 확인하세요.
6. 보존 `enforced_bans.jsonl`감사용.

<a id="related-docs"></a>
## 관련 문서

* [`BAN_ID_MAPPING.md`](%EA%B8%88%EC%A7%80_ID_%EB%A7%A4%ED%95%91.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](%ED%94%8C%EB%A0%88%EC%9D%B4%EC%96%B4_%EA%B2%80%ED%86%A0_%EC%9B%8C%ED%81%AC%ED%94%8C%EB%A1%9C.md)
