<a id="faq"></a>
# FAQ

> **Kanonikus angol forrás:** [FAQ.md](../../FAQ.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


<a id="is-randomdayguard-the-randomday-mod"></a>
## Van RandomDayGuard a RandomDay Mod?

Nem. RandomDay A mod megváltoztatja a szerver élményét. RandomDayGuard figyeli a szerver bizonyíték rétegét.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## Működik az élő védelem a vizsgálat befejezése előtt?

Igen. Az élő védelem naplókat és munkamenet-eseményeket használ. Az alapvonal vizsgálat később javítja a kontextust.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## Miért tarthat sokáig az első vizsgálat?

Az első vizsgálati összeállítások world/object kontextus, fájljegyzékek és újrafelhasználható alapadatok.

<a id="what-do-i-check-first-after-startup"></a>
## Mit kell először ellenőriznem az indítás után?

```text
runtime/current/poll_status.json
```

Keresse meg:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## Hol vannak a játékosok összefoglalói?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## Hol van a napi gyors áttekintő csomag?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## Melyik fájlt töltsem fel a leggyorsabb ellenőrzéshez?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## Írhat automatikusan tiltásokat?

Csak ha kifejezetten engedélyezve van.

Alapértelmezett:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## Mit csinál Admin.ini fogadni?

Csak:

```ini
BannedPlayer=<ID>
```

Nincsenek nevek, megjegyzések, okok vagy utótagok.

<a id="is-a-display-name-enough-to-ban"></a>
## Elegendő egy megjelenített név a kitiltáshoz?

Nem. Használjon szervernaplót `Login request` és `ConnectID` vagy ezzel egyenértékű szerver bizonyíték.

<a id="can-one-crash-ban-someone"></a>
## Egy összeomlás kitilthat valakit?

Alapértelmezés szerint nem.

<a id="can-object-count-alone-ban-someone"></a>
## Az objektumszámlálás önmagában kitilthat valakit?

Alapértelmezés szerint nem.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## Kell SavedRoot.txt mutasson a világmappára?

Nem. Mutasson rá a `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## Mi van, ha megváltozik a világmappa?

Kezelje alapvonalbeli identitásmódosításként. Őrizze meg a régi alapvonalat, és építsen egy újat.

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

* [`START_HERE.md`](KEZDJE_EL_ITT.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](B%C5%B0N%C3%9CGYI_NAPI_%C3%96SSZES%C3%8DT%C3%89SEK.md)
* [`TROUBLESHOOTING.md`](HIBAELH%C3%81R%C3%8DT%C3%81S.md)
