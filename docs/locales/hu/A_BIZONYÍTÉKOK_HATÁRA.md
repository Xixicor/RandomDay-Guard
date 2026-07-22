<a id="evidence-boundary"></a>
# A bizonyítékok határa

> **Kanonikus angol forrás:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ezen az oldalon döntheti el, mit RandomDayGuard jelenthet, és ami még emberi felülvizsgálatot igényel.

<a id="core-rule"></a>
## Alapszabály

RandomDayGuard korlátos megfigyeléseket rögzít a szerver tulajdonában lévő fájlokból. Meg kell határoznia minden lényeges következtetés forrását, hatókörét, gyűjtési állapotát és határait.

A strukturált bizonyítékok mérvadóak. Egy lefordított jelentés magyarázza a bizonyítékokat; nem adhat hozzá olyan tényeket, amelyek hiányoznak a strukturált rekordból.

<a id="evidence-source-classes"></a>
## Bizonyítékforrás osztályok

| Forrásosztály | Tipikus felhasználás | Önmagában nem bizonyítja |
|---|---|---|
| `admin_ini` | Meglévő adminisztrációs állapot és ellenőrzött write/readback kontextus | Ki okozott incidenst |
| `active_log` | Jelenlegi server/session az aktív naplóban látható események | Szándék, tulajdonjog vagy közvetlen kár |
| `recent_backup_logs` | Előzménynapló-kontextus | Aktuális esemény történt |
| `playerdata_filenames` | A tiszta fiókazonosító megerősítése | Viselkedés, bűntudat vagy személyazonosság-tulajdonlás a nyilvánosságra hozott azonosítón kívül |
| `existing_cases` | Előzetes felülvizsgálat kontextusa | Az előzetes értelmezés helyes marad |
| `existing_reports` | Korábbi összefoglalók és döntések | A jelenlegi igazság jelenlegi megerősítés nélkül |
| `existing_evidence` | Strukturált történelmi bizonyítékok | Jelenlegi tevékenység |
| korlátozott világmentő szkennelés | Lassú world/class kontextus | Játékos tevékenység, tulajdonjog, lopás, másolás vagy sérülés |

Minden forrásrekord availability/readability, fájlok száma, forráshivatkozások, jelenlegi vagy történelmi hatókör és explicit `does_not_prove` utasítás.

<a id="source-states"></a>
## Forrásállapotok

| Állam | Az operátor jelentése |
|---|---|
| `available` | A forrás olvasható volt, és bizonyítékokat gyűjtöttünk. |
| `expected_empty` | A forrás olvasható volt, és jogszerűen nem volt egyező rekord. |
| `partial` | Néhány bizonyítékot gyűjtöttek; a fedezet hiányos. |
| `deferred` | A korlátozott munkavégzést szándékosan halasztották el. |
| `unavailable` | A forrás nem található ebben a környezetben. |
| `malformed` | A forrás létezik, de nem elemezhető biztonságosan. |
| `permission_denied` | A watchdognak nincs olvasási engedélye. |
| `error` | A begyűjtés más rögzített ok miatt nem sikerült. |

A várt üres érték érvényes megfigyelés. Soha nem szabad kitalált játékossá, üggyé, incidenssé vagy vádassá alakítani.

<a id="current-versus-historical-evidence"></a>
## A jelenlegi versus történelmi bizonyítékok

A jelenlegi bizonyítékok az aktív gyűjtési ablakhoz vagy a szerver korszakához tartoznak. A történelmi bizonyítékok korábbi naplókból, esetekből, jelentésekből, bizonyítékok nyilvántartásából, biztonsági másolatokból vagy kiindulási helyzetekből származnak.

A történelmi bizonyítékok kontextust adhatnak. Nem tudja csendben betölteni a jelenlegi bizonyítékok közötti rést. A jelentésekben mindkét hatókört fel kell címkézni, és külön kell hivatkozni a forrásokra.

<a id="corroboration-rule"></a>
## Megerősítési szabály

Ezek hasznos kontextusok, de önmagukban nem közvetlen bizonyítékok:

- nevek megjelenítése vagy névhasonlóság;
- időzítés egybeesése;
- lekapcsolása vagy újracsatlakoztatása;
- egy összeomlás vagy figyelmeztető sorozat;
- osztály-, útvonal-, szereplő-, térkép- vagy objektumszámláló tokenek;
- tagság automatikusan csoportosított esetben;
- korábbi jelentések az aktuális forrás megerősítése nélkül.

Ne állítson bűnösséget, szándékot, csalást, tulajdonjogot, lopást, másolást, közvetlen kárt, közvetlen konténerhasználatot, közvetlen leltárműveletet, pontos élő koordinátákat, élő ping-elést vagy memóriaszintű viselkedést anélkül, hogy a tényt közvetlenül felfedő bizonyítékok merülnének fel.

<a id="truthful-report-language"></a>
## A jelentés igaz nyelve

Használja:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Kerülje:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Jelentés olvasási sorrendje

Minden nyilvános jelentésnek magyarázatot kell adnia:

1. Egyszerű jelentése.
2. Miért számít?
3. Technikai bizonyíték és forráshivatkozások.
4. Következő művelet.
5. A korlátok, az ismeretlenek és az állítások nem bizonyítottak.

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

- [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
- [`BAN_ID_MAPPING.md`](ID_MAPPING_KITILT%C3%81SA.md)
- [`DETECTION_SIGNALS.md`](%C3%89RZ%C3%89KEL%C3%89SI_JELEK.md)
