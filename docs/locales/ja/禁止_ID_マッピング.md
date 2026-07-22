<a id="ban-id-mapping"></a>
# 禁止 IDマッピング

> **正規の英語ソース:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). このローカライズされたドキュメントには、正確なコマンド、パス、キー、ステータス値、ハッシュ、ファイル名が保存されています。技術的な表現が異なる場合は、英語のソースを使用してください。


プレイヤー名を安全な`Admin.ini`禁止ラインに変換する場合は、このページを使用します。

<a id="core-rule"></a>
## 基本ルール

表示名は禁止 ID ではありません。

`Admin.ini`使用するもの:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## 証拠階層

| ランク | ソース | 使用 |
|---:|---|---|
| 1 | サーバー ログ `Login request` | 名前から ID への最適なマッピング |
| 2 | `Player_<ID>.sav` | ID が存在することを確認 |
| 3 | 既存`Admin.ini` | 既存bans/moderators |
| 4 | 外部通知またはホスティング パネル アクティビティ | Time/nameコンテキストのみ。 ID 証明ではありません |
| 5 | UE4SS focus/player行 | Presence/contextのみ |
| 6 | システム ライフサイクルまたはコンテナ ログ | ホスト ライフサイクル コンテキストのみ。 ID 証明ではありません |

<a id="extract-the-clean-id"></a>
## クリーンな ID を抽出します

生の例:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

クリーンな `Admin.ini`値:

```ini
BannedPlayer=2535422284688820
```

貼り付けないでください`_+_|...`.

<a id="verify-with-playerdata"></a>
## PlayerData

チェック項目:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

意味:

```text
The ID exists in the world save.
```

制限事項:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## 禁止すべきでない場合

次の場合は禁止 ID を割り当てないでください。

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## 証拠テーブル テンプレート

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
## 関連ドキュメント

* [`ADMIN_INI_ENFORCEMENT.md`](%E7%AE%A1%E7%90%86%E8%80%85%E6%96%BD%E8%A1%8C.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](%E3%83%97%E3%83%AC%E3%83%BC%E3%83%A4%E3%83%BC_%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC_%E3%83%AF%E3%83%BC%E3%82%AF%E3%83%95%E3%83%AD%E3%83%BC.md)
