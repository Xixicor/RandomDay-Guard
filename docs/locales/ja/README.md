# RandomDayGuard 日本語ガイド

**v0.4.12-alpha**

RandomDayGuard は Abiotic Factor 専用サーバーから取得した範囲限定の証拠を、
運用者が読めるレポートに整理します。サーバー状態、日次集計、プレイヤー活動、
ケース確認、重大障害は別々の経路で出力されます。

## インストール

[インストールガイド](../../../INSTALL.md)に従ってください。Mod の場所は
`ue4ss/Mods/RandomDayGuard`、`mods.txt` の設定は `RandomDayGuard : 1` です。
入れ子の配置や重複した `Scripts` フォルダーは残さないでください。

## 最初のレポートを確認する

`runtime/current/startup_status.json`、
`runtime/final_logs/latest_dossier.json`、
`runtime/final_logs/route_proof.json` の順に確認します。各経路は `full`、
`limited_expected_empty`、`missing` のいずれかを示します。要約と参照元は同じ
処理サイクルのものでなければなりません。

## 設定と運用

公開初期値は `review_only_mode = true`、`auto_ban = false`、
`write_admin_ini = false` です。[開始手順](../../START_HERE.md)、
[運用](../../OPERATIONS_PLAYBOOK.md)、[設定](../../CONFIG_PROFILES.md)、
[トラブル対応](../../TROUBLESHOOTING.md)を参照してください。構造化された証拠が
技術記録であり、翻訳はその内容を読みやすくします。

コマンド、パス、キー、状態値は実ファイルと一致させるため英語のままです。

## アルファ版と2つの証拠経路

これはアルファ版です。文書化された収集、報告、復旧経路はテスト済みですが、互換性、履歴範囲、報告品質は引き続き改善中です。

現在経路はアクティブログ、現在の起動・スケジューラー状態、現在のセッションを使うため、現在の報告をすぐ作成できます。履歴経路は保存ログ、PlayerDataファイル名、既存証拠とケースを制限された手順で確認します。

`runtime/current/report_worker_status.json`

複数サイクルにわたり `runtime/current/report_worker_status.json` の `scan_cursor` と `last_progress_ts` を比較してください。進んでいればスキャン中です。現在報告が進む一方で変化しなければ履歴スキャンは停止しています。現在の事実は利用できますが、古い履歴が必要な結論は制限されます。

[Troubleshooting](../../TROUBLESHOOTING.md)
