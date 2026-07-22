<a id="world-save-folder-changes"></a>
# การเปลี่ยนแปลงโฟลเดอร์บันทึกโลก

> **แหล่งที่มาของภาษาอังกฤษตามรูปแบบบัญญัติ:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). เอกสารที่แปลเป็นภาษาท้องถิ่นนี้จะรักษาคำสั่ง เส้นทาง คีย์ ค่าสถานะ แฮช และชื่อไฟล์ที่แน่นอน หากถ้อยคำทางเทคนิคแตกต่างออกไป ให้ใช้ต้นฉบับภาษาอังกฤษ


ใช้หน้านี้เมื่อโฟลเดอร์โลกที่ใช้งานอยู่เปลี่ยนแปลง

<a id="normal-layout"></a>
## รูปแบบปกติ

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` ควรยังคงชี้ไปที่:

```text
AbioticFactor/Saved
```

ไม่ใช่โฟลเดอร์ world

<a id="case-1-same-world-renamed"></a>
## กรณีที่ 1: โลกเดียวกันเปลี่ยนชื่อ

ตัวอย่าง:

```text
Worlds/OldName/
Worlds/NewName/
```

พฤติกรรมที่คาดหวัง:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## กรณีที่ 2: โลกที่แตกต่างหรือการสำรองข้อมูลที่ได้รับการกู้คืน

พฤติกรรมที่คาดหวัง:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## กรณีที่ 3: มีการสแกนบางส่วนก่อนการเปลี่ยนแปลง

พฤติกรรมที่คาดหวัง:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## กรณีที่ 4: มีพื้นฐานที่เสร็จสมบูรณ์ก่อนการเปลี่ยนแปลง

พฤติกรรมที่คาดหวัง:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## สิ่งที่ต้องตรวจสอบ

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## เอกสารที่เกี่ยวข้อง

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%9B%E0%B8%A3%E0%B8%B0%E0%B8%AB%E0%B8%A2%E0%B8%B1%E0%B8%94%E0%B8%AB%E0%B8%99%E0%B9%88%E0%B8%A7%E0%B8%A2%E0%B8%84%E0%B8%A7%E0%B8%B2%E0%B8%A1%E0%B8%88%E0%B9%8D%E0%B8%B2%E0%B9%81%E0%B8%A5%E0%B8%B0_%E0%B9%80%E0%B8%AD%E0%B8%B2%E0%B8%97%E0%B9%8C%E0%B8%9E%E0%B8%B8%E0%B8%95.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](%E0%B8%A3%E0%B8%B9%E0%B8%9B%E0%B9%81%E0%B8%9A%E0%B8%9A%E0%B8%99%E0%B8%B1%E0%B8%81%E0%B9%81%E0%B8%AA%E0%B8%94%E0%B8%87%E0%B8%97%E0%B8%B5%E0%B9%88%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%94%E0%B8%B5%E0%B9%81%E0%B8%A5%E0%B8%B0%E0%B8%84%E0%B8%A7%E0%B8%B2%E0%B8%A1%E0%B8%A2%E0%B8%B7%E0%B8%94%E0%B8%AB%E0%B8%A2%E0%B8%B8%E0%B9%88%E0%B8%99.md)
