# RandomDayGuard 简体中文指南

**v0.4.12-alpha**

RandomDayGuard 将 Abiotic Factor 专用服务器中有限、可追溯的证据整理为易读的
管理员报告。服务器状态、每日汇总、玩家活动、案例复核和严重故障分别输出。

## 安装

按照[安装指南](../../../INSTALL.md)操作。模组目录必须是
`ue4ss/Mods/RandomDayGuard`，并在 `mods.txt` 中加入 `RandomDayGuard : 1`。
不要创建嵌套安装，也不要保留重复的 `Scripts` 目录。

## 验证第一份报告

依次查看 `runtime/current/startup_status.json`、
`runtime/final_logs/latest_dossier.json` 和
`runtime/final_logs/route_proof.json`。每条路由应显示 `full`、
`limited_expected_empty` 或 `missing`。可读摘要与引用的数据源必须来自同一轮处理。

## 配置与运行

公开默认值为 `review_only_mode = true`、`auto_ban = false` 和
`write_admin_ini = false`。请阅读[首次运行](../../START_HERE.md)、
[日常操作](../../OPERATIONS_PLAYBOOK.md)、[配置](../../CONFIG_PROFILES.md)和
[故障排查](../../TROUBLESHOOTING.md)。结构化证据是技术记录，翻译层用于帮助阅读。

命令、路径、配置键和状态值保留英文，以便与实际文件完全一致。

## Alpha 版本与两条证据路径

这是 Alpha 版本。文档中的收集、报告和恢复流程已经过测试；兼容性、历史覆盖范围和报告质量仍在继续改进。

当前路径使用活动日志、当前启动和调度器状态以及当前会话，因此可以立即写入当前报告。历史路径按受限步骤检查保留日志、PlayerData 文件名、现有证据和案例。

`runtime/current/report_worker_status.json`

跨多个周期比较 `runtime/current/report_worker_status.json` 中的 `scan_cursor` 和 `last_progress_ts`。如果数值前进，扫描仍在工作。如果当前报告继续更新而这两个值不变，历史扫描已停滞；当前事实仍可使用，但需要旧历史的结论会受到限制。

[Troubleshooting](../../TROUBLESHOOTING.md)
