<a id="ban-id-mapping"></a>
# 禁止 ID 映射

> **规范的英文来源:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). 此本地化文档保留了准确的命令、路径、键、状态值、哈希值和文件名。如果技术措辞不同，请使用英文来源。


转换时使用此页面将玩家名称添加到安全的`Admin.ini`禁令行中。

<a id="core-rule"></a>
## 核心规则

显示名称不是禁令 ID。

`Admin.ini`用途：

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## 证据层次结构

| 排名 | 来源 | 使用 |
|---:|---|---|
| 1 | 服务器日志`Login request` | 最佳名称到 ID 映射 |
| 2 | `Player_<ID>.sav` | 确认 ID 存在 |
| 3 | 现有`Admin.ini` | 现有bans/moderators |
| 4 | 外部通知或托管面板活动 | Time/name仅限上下文；不提供 ID 证明 |
| 5 | UE4SS focus/player行 | Presence/context仅限 |
| 6 | 系统生命周期或容器日志 | 仅限主机生命周期上下文；不是 ID 证明 |

<a id="extract-the-clean-id"></a>
## 提取干净的 ID

原始示例：

```text
ConnectID=2535422284688820_+_|0002d07b...
```

干净的 `Admin.ini`值：

```ini
BannedPlayer=2535422284688820
```

不要粘贴`_+_|...`.

<a id="verify-with-playerdata"></a>
## 使用 PlayerData

检查：

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

含义：

```text
The ID exists in the world save.
```

限制：

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## 何时不禁止

在以下情况下不要分配禁令 ID：

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## 证据表模板

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
## 相关文档

* [`ADMIN_INI_ENFORCEMENT.md`](%E7%AE%A1%E7%90%86%E5%91%98%E5%88%9D%E5%A7%8B%E5%8C%96%E6%89%A7%E8%A1%8C.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](%E7%8E%A9%E5%AE%B6%E5%AE%A1%E6%A0%B8%E5%B7%A5%E4%BD%9C%E6%B5%81%E7%A8%8B.md)
