<a id="worked-operation-examples"></a>
# Műveleti példák

> **Kanonikus angol forrás:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ezek a példák kitalált értékeket használnak a várható állapotátmenetek magyarázatára; ezek nem élő kompatibilitási vagy játékos bizonyítékok.

<a id="successful-current-cycle"></a>
## A jelenlegi ciklus sikeres

Bemenetek: olvasható aktív napló, version/boot/epoch, `poll_id=41`, aktuális szavazás befejeződött, írható accounting/history/report gyökér, nem blokkolja a lassú keresési szabályzatot.

Várható:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Minden engedélyezett útvonalon van JSON/TXT kimenet és ugyanaz a származás a `route_proof.json`. Az útvonal állapota a saját tárgyától függ, nem pedig egy általános sikerüzenettől.

<a id="expected-empty-player-and-case-routes"></a>
## Várhatóan üres lejátszó és tok útvonalak

Bemenetek: az aktuális ciklus ellenőrzése befejeződött; nincsenek jelenlegi vagy megtartott játékossorok; nincs megtartott tok és nincs áram REVIEW/BAN-ELIGIBLE fiók.

Várható:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

A lefordított jelentések szerint nem figyeltek meg megfelelő korlátos tárgyat. Azt is mondják, hogy ez nem bizonyítja, hogy soha senki sem csatlakozott, vagy hogy egyetlen kontextus sem hiányzik. Nincs helyőrző player/case létrejön.

<a id="partial-bounded-scan"></a>
## Részleges korlátos vizsgálat

Bemenetek: friss áram log/poll; `scan_checkpoint.json` vagy `scan_progress.json` létezik; a szkennelés nem teljes; alapértelmezett `slow_world_scan_blocks_current_reports=false`.

Várható:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Beállítás `slow_world_scan_blocks_current_reports=true` csak akkor, ha az operátor azt akarja, hogy az opcionális lassú forrás blokkolja az aktuális jelentéseket. A helyreállítás célja, hogy lehetővé tegye a vizsgálati dolgozó számára a folytatást, nem pedig az ellenőrzőpont törlését.

<a id="missing-current-cycle-proof"></a>
## Hiányzó aktuális ciklus igazolás

Bemenetek: az aktív napló nem érhető el, `poll_id=0` vagy boot/epoch/last-poll vonal hiányzik.

Várható:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

A letiltott boríték egy ellenőrzési rekord, nem pedig egy sorba állított kézbesítés. A régi végleges naplók csak történetiek maradnak. Javítsa meg az első hiányzót lineage/source mezőt, és hozzon létre egy újabb ciklust.

<a id="malformed-optional-adminini-source"></a>
## Rosszul formázott, nem kötelező Admin.ini forrás

Bemenetek: `Admin.ini` létezik, de a tiszta szerkezeti érvényesítés sikertelen.

Várható:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Őrizze meg a fájlt, és állítsa vissza a felülvizsgált tiszta formátumot. Tartsa a magyarázó szöveget futásidejű bizonyítékokban; mindegyik `Admin.ini` a kitiltás csak `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Szükséges aktív napló vizsgálati hiba

Bemenetek: a behatárolt kötelező aktív-napló-próba meghiúsult olvasási hibával meghiúsul.

Várható:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` a forrássorban marad a behatárolt részletekkel együtt. A legfelső szintű jelentés a `unavailable`, és az útvonal-igazolás marad `missing` amíg egy újabb aktuális ciklus nem igazolja a szükséges forrást.

<a id="incompatible-or-stale-baseline"></a>
## Inkompatibilis vagy elavult alapvonal

Bemenetek: megváltozott package/source azonosság vagy stale/incompatible alapvonali jegyzék.

Várható: az érvényesítés vagy a futásidejű állapot rögzíti az inkompatibilitást; A szkennelés állapota nem követeli a befejezett újrafelhasználást. Őrizze meg a korábbi bizonyítékokat, kezdjen el egy explicit alapvonal-újraépítést, és várja meg az új terminál-bizonyítékot. A rögzített ok nélküli kényszerített újraépítés nem az alapértelmezett helyreállítás.

<a id="paired-report-write-failure"></a>
## A párosított jelentésírási hiba

Bemenetek: JSON az írás sikeres, de TXT az írás sikertelen, vagy fordítva.

Várható:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

Az író a legjobb erőfeszítéssel átírja mindkét testvért, hogy kudarcot valljon. Egy sikeres testvér nem maradhat sikerkövetelésként. A behatárolt írási részlet nem hoz létre ötödik legfelső szintű lefedettségi értéket.

<a id="route-proof-write-failure"></a>
## Útvonalbiztos írási hiba

Bemenetek: útvonalpárokat írtak, de `route_proof.json` nem cserélhető.

Várható: minden jelentés átírásra kerül `missing`, minden értesítés eredménye `route_proof_write_failed`, és nem fogadunk el borítékot. A konfigurált útvonalon lehet egy `suppressed_current_cycle` ellenőrzési boríték kézbesítési jelzőkkel hamis. Javítsa meg a kimeneti gyökeret, és állítsa újra ugyanazt az áramciklust.

<a id="review-only-enforcement-example"></a>
## Példa csak felülvizsgálatra

Konfig.:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Várható: pontszámok, esetek és ajánlások írhatók; `Admin.ini` változatlan marad. Ez a nyilvános alapértelmezett.

<a id="approved-write-success-example"></a>
## Jóváhagyott sikeres írási példa

Csak egy külön jóváhagyott teszt állíthatja be mindhárom íráskapcsolót. A tiszta numerikus azonosságot is igazolnia kell, trust/moderator kizárás, küszöbérték, érvényes Admin.ini path/parse, sikeres biztonsági mentés, sikeres írás, visszaolvasási egyenlőség és fiókspecifikus bizonyítékok.

Várható:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

A sikeres példa nem teszi lehetővé más fiókok automatikus végrehajtását.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback hiba a visszaállításnál

Bemenetek: minden írás előtti kapu átment; a helyettesítő írás vagy visszaolvasás sikertelen; `rollback_on_readback_failure=true` és az ellenőrzött biztonsági másolat elérhető.

Várható: a hiba bizonyítéka rögzíti a szakaszt és `rollback_success`; az eredeti Admin.ini bájtot, és a rendszer nem jelenti a fiók sikeres végrehajtását. Ha a visszagörgetés sem sikerül, állítsa le az írást, őrizze meg mindkettőt files/evidence, és állítsa vissza manuálisan a biztonsági másolatból.

<a id="local-outbox-example"></a>
## Példa a helyi kimenő levelekre

Bemenetek: értesítés engedélyezve itt: `local_file_outbox` mód, útvonal engedélyezve, befejezett útvonal-ellenőrzés és bármelyik `full` vagy kifejezetten engedélyezett várt-üres.

Várható boríték:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

A missing/ineligible kimenet, ugyanaz az útvonal tartalmazhatja a `status=suppressed_current_cycle`, `completed_output=false` és `delivery_eligible=false`. Bármelyik fájl csak helyi írást bizonyít. A szolgáltató, a szállítás, a kézbesítés vagy az olvasási bizonylat nem kötődik vagy következtet.

Lásd [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md), [`CONFIG_FIELD_CATALOG.md`](KONFIGUR%C3%81CI%C3%93S_MEZ%C5%90KATAL%C3%93GUS.md) és [`TROUBLESHOOTING.md`](HIBAELH%C3%81R%C3%8DT%C3%81S.md).
