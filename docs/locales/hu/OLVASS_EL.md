# RandomDayGuard magyarul

**v0.4.12-alpha**

A RandomDayGuard az Abiotic Factor dedikált szerverének körülhatárolt
bizonyítékait áttekinthető üzemeltetői jelentésekké alakítja. A szerverállapot,
a napi összegzés, a játékosaktivitás, az esetvizsgálat és a kritikus hibák
külön útvonalon maradnak.

## Telepítés

Kövesse a [telepítési útmutatót](TELEP%C3%8DT%C3%89S.md). A helyes mappa
`ue4ss/Mods/RandomDayGuard`, a `mods.txt` pedig tartalmazza ezt:
`RandomDayGuard : 1`. Kerülje a beágyazott telepítést és a kettős `Scripts` mappát.

## Az első jelentés ellenőrzése

Nyissa meg a `runtime/current/startup_status.json`, majd a
`runtime/final_logs/latest_dossier.json` és a
`runtime/final_logs/route_proof.json` fájlt. Minden útvonal értéke `full`,
`limited_expected_empty` vagy `missing` legyen. A jelentés és a hivatkozott
forrás ugyanahhoz a ciklushoz tartozzon.

## Beállítás és üzemeltetés

A nyilvános alapértékek: `review_only_mode = true`, `auto_ban = false` és
`write_admin_ini = false`. Olvassa el a [Kezdés](KEZDJE_EL_ITT.md),
[Üzemeltetés](M%C5%B0VELETI_%C3%9ATMUTAT%C3%93.md), [Beállítás](KONFIGUR%C3%81CI%C3%93S_PROFILOK.md)
és [Hibaelhárítás](HIBAELH%C3%81R%C3%8DT%C3%81S.md) oldalakat.

A parancsok, elérési utak, kulcsok és állapotértékek angolul maradnak, hogy
pontosan egyezzenek a fájlokkal.

## Alfa kiadás és két bizonyítékút

Ez alfa kiadás. A dokumentált gyűjtési, jelentési és helyreállítási útvonalakat teszteltük; a kompatibilitást, a történeti lefedettséget és a jelentések minőségét tovább javítjuk.

Az aktuális út az aktív naplót, a jelenlegi indítási és ütemezőállapotot, valamint a futó munkameneteket használja, ezért az aktuális jelentéseket azonnal megírhatja. A történeti út korlátozott lépésekben vizsgálja a megőrzött naplókat, PlayerData fájlneveket, bizonyítékokat és ügyeket.

`runtime/current/report_worker_status.json`

Több cikluson át hasonlítsa össze a `runtime/current/report_worker_status.json` `scan_cursor` és `last_progress_ts` mezőit. Ha haladnak, a vizsgálat működik. Ha az aktuális jelentések haladása mellett változatlanok, a történeti vizsgálat elakadt; az aktuális tények használhatók, a régi előzményeket igénylő következtetések korlátozottak.

[Troubleshooting](HIBAELH%C3%81R%C3%8DT%C3%81S.md)

## Teljes dokumentációs könyvtár

Minden nyilvános Markdown-dokumentum elérhető ezen a nyelven, lokalizált fájlnevekkel.

- [Nyissa meg a lokalizált dokumentációs indexet](DOKUMENT%C3%81CI%C3%93.md)
