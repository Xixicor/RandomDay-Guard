<a id="validation-and-release"></a>
# Érvényesítés és kiadás

> **Kanonikus angol forrás:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ez az oldal a közreműködőknek és a kiadás-karbantartóknak szól. A kiszolgáló üzemeltetőinek nem kell futtatniuk ezeket a parancsokat a telepítéshez RandomDayGuard.

<a id="user-visible-proof"></a>
## Felhasználó által látható bizonyíték

A kiadás érthető, ha egy új üzemeltető telepítheti, megkeresheti az első szerverállapot-jelentést, megkülönböztetheti az öt jelentési útvonalat, és egyetlen egyértelmű műveletet követhet egy működő példából. Az olvasói feladatok nem igényelhetnek Git, PowerShell, Python vagy ellenőrzőösszeg ismereteket.

<a id="contributor-checks"></a>
## Közreműködői ellenőrzések

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Mikor `luac` elérhető:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

A Lua fixture tesztek lefedik a betöltőt, az ütemezőt, a jelentési útvonalakat és az opcionális Admin.ini tranzakció írása. A végrehajtási eszközök csak ideiglenes fájlokat használnak, és ellenőrzik a személyazonosságot, a megbízható fiókok elutasítását, a küszöbértékeket, a biztonsági mentést, az egyidejű változtatások elutasítását, a visszaolvasást és a visszaállítást.

<a id="package-proof"></a>
## Csomagellenőrzés

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Minden verziójelző egyezik `VERSION`.
- Csak a jelenlegi verzió létezik a `releases/`.
- A ZIP tartalmazza a kanonikus `RandomDayGuard/Scripts/main.lua` elérési út és nincs kisbetűs változat betöltő.
- A futásidejű kimenet, a privát konfiguráció, a hitelesítő adatok, a helyi elérési utak, a gyorsítótárak és a tesztműtermékek kizárva.
- A nyilvános konfiguráció továbbra is csak áttekinthető marad, a végrehajtás letiltása mellett.
- Az öt kidolgozott jelentéspélda összhangban marad az útvonal tulajdonjogával és a kiadási teszttel.
- ZIP bájtok determinisztikusak és egyeznek `CHECKSUMS.sha256`.
- Minden helyi dokumentációs link és 27 területi beállítási oldal érvényes.

<a id="avoid-validation-environment-pitfalls"></a>
## Kerülje el az érvényesítési környezet buktatóit

- Futtassa le az adattár-írási ellenőrzéseket sorozatosan, hogy elkerülje az ideiglenes fájlok versengését.
- Windows rendszeren ellenőrizze az archivált tagneveket vagy a felsorolt ​​elérési útvonalak helyesírását, és ne a kis- és nagybetűket megkülönböztető fájlkeresést végezzen, amikor ismétlődő betöltőket keres.
- Hiányzik egy `luac` parancs vagy a Lua futtatókörnyezet egy nem elérhető képesség, nem egy átmenő szintaxis vagy futásidejű teszt.
- Egy fixture csak a modellezett bemeneteit bizonyítja. Ez nem bizonyítja, hogy egy élő szerver készített aktuális jelentést.
- Rögzítse a parancsok időtúllépéseit és a részleges kimenetet a befejezés feltételezése helyett.

<a id="repair-failed-repository-validation"></a>
## A lerakat sikertelen ellenőrzésének javítása

Kezdje az első bejelentett útvonallal vagy szerződéssel. Javítsa ki az elemet, futtassa újra a szűkített tesztet, majd futtassa újra a teljes mátrixot. Ne rejtse el a hiányzó képességet az azt igénylő teszt eltávolításával.

<a id="known-limits-and-release-decision"></a>
## Ismert korlátok és kiadási döntés

Helyi ellenőrzések igazolják a forrás-, szerelvény-, csomag- és dokumentációs szerződéseket. Egy adott kiszolgálótelepítés, hosszan tartó stabilitási ablak vagy ügyfélmegjelenítés külön integrációs eredményt igényel. Jegyezze fel az eredményt a felépítésével, konfigurációjával, időtartamával és megfigyelt kimenetével együtt, mielőtt az egyezési követelést megadná.
