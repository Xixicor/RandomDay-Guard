<a id="player-review-workflow"></a>
# Játékos ellenőrzési munkafolyamat

> **Kanonikus angol forrás:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Használja ezt az oldalt egy játékoshoz, fiókhoz vagy esethez. A cél egy megismételhető felülvizsgálati határozat, nem pedig egy automatikus vádemelés.

<a id="quick-path"></a>
## Gyors elérési út

1. Megnyitás `runtime/final_logs/player_activity_latest.json`.
2. Erősítse meg az útvonal állapotát itt: `runtime/final_logs/route_proof.json`.
3. Azonosítsa, mely megfigyelések aktuálisak és melyek történelmiek.
4. Ellenőrizze az idézett identitást és a munkamenet forráshivatkozásait.
5. Áttekintés `case_review_latest.json`, ha korrelált eset létezik.
6. Ismeretlenek és `does_not_prove` művelet kiválasztása előtt.
7. Hagyja letiltva a végrehajtást, hacsak nem bizonyítják a külön végrehajtási kapukat.

<a id="1-confirm-route-proof"></a>
## 1. Erősítse meg az útvonal igazolását

A játékos útvonalát a következőképpen értelmezze:

| Állapot | Művelet |
|---|---|
| `full` | Folytassa, miközben továbbra is áttekinti a forráskorlátokat. |
| `limited_expected_empty` | Csak a ténylegesen jelenlévő alanyokkal folytassa; ne találjon ki hiányzó lejátszót vagy tokot. |
| `missing` | Állítsa le a játékos döntését, és hárítsa el az útvonalat. |

Egy egészséges ütemező nem helyettesíti az útvonalellenőrzést.

<a id="2-establish-identity"></a>
## 2. Identitás megállapítása

Előnyben részesítse a tiszta fiókazonosítót, amelyet a szerver által elérhető személyazonossági bizonyítékok támasztanak alá, és ahol elérhető, PlayerData fájlnevek. Tartsa meg a nyers forrás hivatkozását.

Ne kényszerítse innen:

- csak egy megjelenített név;
- egy értesítési vagy tárhelypanelen látható név;
- időzítési hasonlóság;
- leképezés nélküli vagy gyenge megbízhatóságú identitás;
- egy előzményjelentés aktuális megerősítés nélkül.

<a id="3-separate-current-from-historical"></a>
## 3. Különítse el a jelenlegit a történelmi

A jelenlegi bizonyítékok az aktív jelentési ablakot vagy a szerver korszakát írják le. A történelmi bizonyítékok megmagyarázhatnak egy mintát, de nem tudják csendben kitölteni a jelenlegi ablak hiányosságait.

Rögzítse mindkét hatókört egymástól függetlenül:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Tekintse át a megfigyeléseket és az értelmezést

Olvassa el pontosan ezeket a jelentésszakaszokat:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Nyissa meg újra az idézett strukturált bizonyítékot bármilyen lényeges döntéshez. A fordítás navigáció és magyarázat, nem új bizonyíték.

<a id="5-calibrate-the-decision"></a>
## 5. Kalibrálja a döntést

| Határozat | Használja mikor |
|---|---|
| `INFO` | Normál vagy alacsony kontextusú megfigyelés. |
| `WATCH` | Gyenge vagy hiányos jel, amelyet érdemes figyelni. |
| `REVIEW` | A kapcsolódó bizonyítékokhoz adminisztrátor döntése szükséges. |
| `BAN-ELIGIBLE` | A tiszta személyazonosság és a beállított bizonyítékok küszöbértékei teljesülnek; az írási kapuk továbbra is érvényesek. |
| `AUTO-BANNED` | A végrehajtás kifejezetten engedélyezve lett, és a biztonsági mentés, az írás, a visszaolvasás és az ellenőrzés sikeres volt. |

Egy döntési címke sem bizonyítja a bűnösséget vagy a szándékot.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Alkalmazza a bizonyítékok határát

Összeomlások, újracsatlakozások, figyelmeztetések, object/class tokenek, és az esetek csoportosítása támogathatja a felülvizsgálatot. Önmagukban nem bizonyítják csalást, lopást, másolást, tulajdonjogot, közvetlen kárt vagy incidens okozati összefüggést.

Ha az identitás, az elemzés, a biztonsági mentés, az írás, a visszaolvasás vagy a visszaállítás gyenge vagy sikertelen, a végrehajtást sikertelenül kell lezárni.

<a id="review-note-template"></a>
## Jegyzetsablon áttekintése

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

- [`EVIDENCE_BOUNDARY.md`](A_BIZONY%C3%8DT%C3%89KOK_HAT%C3%81RA.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md)
- [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_V%C3%89GREHAJT%C3%81S.md)
- [`DETECTION_SIGNALS.md`](%C3%89RZ%C3%89KEL%C3%89SI_JELEK.md)
