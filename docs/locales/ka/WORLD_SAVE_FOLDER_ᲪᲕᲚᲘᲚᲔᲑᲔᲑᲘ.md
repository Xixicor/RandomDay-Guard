<a id="world-save-folder-changes"></a>
# მსოფლიო შენახვის საქაღალდეში ცვლილებები

> **კანონიკური ინგლისური წყარო:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). ეს ლოკალიზებული დოკუმენტაცია ინახავს ზუსტ ბრძანებებს, ბილიკებს, გასაღებებს, სტატუსის მნიშვნელობებს, ჰეშებსა და ფაილების სახელებს. თუ ტექნიკური ფორმულირება განსხვავდება, გამოიყენეთ ინგლისური წყარო.


გამოიყენეთ ეს გვერდი, როდესაც შეიცვლება აქტიური მსოფლიო საქაღალდე.

<a id="normal-layout"></a>
## ნორმალური განლაგება

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` მაინც უნდა მიუთითებდეს:

```text
AbioticFactor/Saved
```

არა მსოფლიო საქაღალდე.

<a id="case-1-same-world-renamed"></a>
## შემთხვევა 1: იგივე სამყარო გადაერქვა

მაგალითი:

```text
Worlds/OldName/
Worlds/NewName/
```

მოსალოდნელი ქცევა:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## შემთხვევა 2: სხვა სამყარო ან აღდგენილი სარეზერვო ასლი

მოსალოდნელი ქცევა:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## შემთხვევა 3: ნაწილობრივი სკანირება არსებობდა ცვლილებამდე

მოსალოდნელი ქცევა:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## შემთხვევა 4: დასრულებული საბაზისო ხაზი არსებობდა ცვლილებამდე

მოსალოდნელი ქცევა:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## რა უნდა შეამოწმოთ

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## დაკავშირებული დოკუმენტები

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](%E1%B2%9B%E1%B2%94%E1%B2%AE%E1%B2%A1%E1%B2%98%E1%B2%94%E1%B2%A0%E1%B2%94%E1%B2%91%E1%B2%98%E1%B2%A1_%E1%B2%94%E1%B2%99%E1%B2%9D%E1%B2%9C%E1%B2%9D%E1%B2%9B%E1%B2%98%E1%B2%90_%E1%B2%93%E1%B2%90_%E1%B2%A8%E1%B2%94%E1%B2%93%E1%B2%94%E1%B2%92%E1%B2%94%E1%B2%91%E1%B2%98.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](%E1%B2%AA%E1%B2%A3%E1%B2%93%E1%B2%98_%E1%B2%9B%E1%B2%A1%E1%B2%90%E1%B2%AE%E1%B2%98%E1%B2%9D%E1%B2%91%E1%B2%98%E1%B2%A1_%E1%B2%9C%E1%B2%98%E1%B2%9B%E1%B2%A3%E1%B2%A8%E1%B2%94%E1%B2%91%E1%B2%98_%E1%B2%93%E1%B2%90_%E1%B2%92%E1%B2%90%E1%B2%9B%E1%B2%AB%E1%B2%9A%E1%B2%94%E1%B2%9D%E1%B2%91%E1%B2%90.md)
