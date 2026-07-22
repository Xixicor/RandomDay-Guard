<a id="world-save-folder-changes"></a>
# Thay đổi thư mục lưu thế giới

> **Nguồn tiếng Anh chuẩn:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Tài liệu được bản địa hóa này bảo toàn chính xác các lệnh, đường dẫn, khóa, giá trị trạng thái, hàm băm và tên tệp. Nếu cách diễn đạt kỹ thuật khác nhau, hãy sử dụng nguồn tiếng Anh.


Sử dụng trang này khi thư mục thế giới hoạt động thay đổi.

<a id="normal-layout"></a>
## Bố cục bình thường

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` vẫn phải trỏ tới:

```text
AbioticFactor/Saved
```

không phải thư mục thế giới.

<a id="case-1-same-world-renamed"></a>
## Trường hợp 1: cùng một thế giới được đổi tên

Ví dụ:

```text
Worlds/OldName/
Worlds/NewName/
```

Hành vi dự kiến:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Trường hợp 2: thế giới khác hoặc bản sao lưu được khôi phục

Hành vi dự kiến:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Trường hợp 3: đã quét một phần trước khi thay đổi

Hành vi dự kiến:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Trường hợp 4: đường cơ sở hoàn chỉnh đã tồn tại trước khi thay đổi

Hành vi dự kiến:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Những gì cần kiểm tra

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Tài liệu liên quan

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](TI%E1%BA%BET_KI%E1%BB%86M_B%E1%BB%98_NH%E1%BB%9A_V%C3%80_%C4%90%E1%BA%A6U_RA.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](H%C3%8CNH_M%E1%BA%AAU_V%C3%80_KH%E1%BA%A2_N%C4%82NG_PH%E1%BB%A4C_H%E1%BB%92I_C%E1%BB%A6A_K%E1%BA%BA_X%E1%BA%A4U.md)
