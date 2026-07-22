<a id="examples-of-the-five-guard-reports"></a>
# Példák az öt őrségi jelentésre

> **Kanonikus angol forrás:** [REPORT_EXAMPLES.md](../../REPORT_EXAMPLES.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ezek a példák a kiadáshoz mellékelt mintaadatokból készültek; a neveket és számlaszámokat kitalálták. Megmutatják a tesztelt jelentésmezőket, számításokat és útvonalhatárokat. Egy valódi jelentés helyettesíti őket az adott szerverről gyűjtött információkkal, és jelzi, ha egy tény nem volt elérhető.

Minden jelentésnek egy feladata van. A szerver állapota nem ismétli meg a játékosok előzményeit, a napi értékelést nem küldik el néhány percenként, és a csendes játékosok vagy esetek útvonalai nem kapnak kitöltési üzeneteket. Előfordulhat, hogy egy aktuális jelentés készen áll, amíg a korlátos előzményvizsgálat még folyamatban van; ebben az esetben a jelentés megnevezi a hiányosságot ahelyett, hogy a régebbi előzményeket teljesnek mutatná be.

<a id="server-status"></a>
## Szerver állapota

> **Szerver állapota: Újraindítás után online**  **Jelenlegi állapot:** Online **Elérhető:** 14:07  **Újraindítás befejeződött:** 14:06  **Leállás:** 3 perc, 12 másodperc **Újraindítás oka:** Ütemezett játékfrissítés **Monitoring:** Aktív. Utolsó sikeres ellenőrzés: 14:09 **Játéknapló:** Elérhető és frissül **Előzmény vizsgálat:** 355/312 fájl felülvizsgálva **Biztonsági mentések:** Utolsó ellenőrzés: 13:00. Következő várható: 15:00. A mai kudarcok: 0 **Művelet:** Nincs. A szerver rendesen helyreállt.

A kiszolgáló állapota a kiszolgáló jelenlegi működésére vonatkozik: indítás, újraindítás helyreállítás, leállás, biztonsági mentések, ütemező és Guard állapot. Nem tartalmazza a játékosok munkameneteit vagy az eset részleteit.

<a id="daily-rollup"></a>
## Napi összesítés

> **Napi áttekintés: 2026. július 19.**  **A szerver elérhetősége:** Online 23 óra 47 percig. Offline 13 percig.  **Újraindítások:** 2 összesen: 1 ütemezett és 1 váratlan.  **Biztonsági mentések:** 23 sikeres. 1 hiányzik vagy nem sikerült. Utolsó sikeres mentés: 23:00.  **Játékos tevékenység:** 3 egyedi játékos. 7 alkalom: 6 normálisan befejeződött és 1 megszakítva.  **Ügytevékenység:** 1 új eset, 2 frissített eset, 1 ügyet igényel, és 0 kritikus eset.  **Bizonyítéki lefedettség:** A 7 várt forráscsoportból 6 volt elérhető. A 04:00 biztonsági mentési napló nem volt elérhető.  **Napi összegzés:** A szerver a nap nagy részében elérhető maradt. Egy váratlan megszakítás korán véget ért egy játékos munkamenetet. A megfigyelés a felépülés után folytatódott, és egy eset készen áll a felülvizsgálatra.  **Művelet:** Tekintse át az esetet `RDG-20260719-004`. Nincs szükség más azonnali teendőre.

A napi összesítés egyszer kerül megírásra a naptári dátumhoz. Egyesíti a napot a csendes időszakok között, és újraindul anélkül, hogy újabb szerverállapotú ping lenne.

<a id="player-activity"></a>
## Játékos tevékenység

> **Játékos tevékenység: Alex**  **Fiók:** `76561198000000400`  **Első megfigyelés:** 2026. július 12. **Utolsó munkamenet:** 10:02-kor csatlakozott, 11:18-kor távozott, 1 óra 16 percig tartott, és a szokásos módon ért véget.  **Ma:** 3 kapcsolat, 2 befejezett munkamenet, 1 megszakított munkamenet és 2 gyors újracsatlakozás 10 percen belül.  **Előző 7 nap:** 9 munkamenet, 6 óra 18 perc rögzített lejátszás és 0 korábbi eset.  **Megfigyelt:** Alex kétszer is visszatért röviddel egy megszakított munkamenet után. A feljegyzett tevékenység elég teljes ahhoz, hogy történelemként megőrizze, de önmagában nem magyarázza meg, miért történt az újracsatlakozás.  **Művelet:** Folytassa a figyelést. Nincs szükség azonnali intézkedésre.

A játékostevékenység csak akkor kerül elküldésre, ha a támogatott játékos vagy munkamenet információi megváltoznak. A csendes időszak nem hoz létre játékosüzenetet.

<a id="case-review"></a>
## Eset áttekintése

> **Eset áttekintése: RDG-20260719-004**  **Tárgy:** Alex **Fiók:** `76561198000000400`  **Állapot:** Rendszergazdai felülvizsgálat kérve **Értékelés értékelése:** 90 - Magas prioritás **Miért nyitották meg az ügyet:** A fiók ismételt csatlakozási kísérletet tett egy megszakadt munkamenet után, és a szerver közvetlenül rögzítette a bejelentkezési kéréseket.  **Megerősített megfigyelések:** - Bejelentkezési kérést rögzítettünk 18:42-kor. - 6 percen belül négy kísérletet rögzítettek. - Két ülés normál indulási rekord nélkül ért véget. - Ugyanezt a beszámolót figyelték meg július 12-én és július 17-én.  **Releváns előzmények:** Nincs korábbi eset rögzítve ehhez a fiókhoz.  **Ismeretlen:** A rendelkezésre álló rekordok nem állapítják meg az újracsatlakozások okát, a játékos szándékát vagy azt, hogy a világállapot megváltozott-e.  **Javasolt művelet:** Hasonlítsa össze a munkamenetek idejét a szervernaplóval és a rögzített világtevékenységgel, mielőtt eldönti, hogy szükség van-e bármilyen műveletre.

Az eset áttekintése névvel ellátott felülvizsgálati anyagot, megerősített megfigyeléseit, korlátait és egy konkrét felülvizsgálati lépést tartalmaz. A történelmi jelenlét önmagában nem hoz létre új esetet.

<a id="critical-guard"></a>
## Critical Guard

> **Critical Guard: A jelentésírás leállt**  **Kezdve:** 21:14  **Érintett függvény:** Játékos jelentésíró **Hatás:** Az új játékosok összefoglalóit nem lehet kitölteni.  **Szerver:** Online marad.  **Monitoring:** A bizonyítékgyűjtés folytatódik, de az olvasható jelentések késnek.  **Utolsó sikeres jelentés:** 21:09  **Hiba:** A jelentés kimenetét nem sikerült elmenteni.  **Valószínű ok:** A cél nem volt elérhető, vagy elutasította az írást.  **Művelet:** Ellenőrizze a Guard futásidejű kimeneti helyét. Ne indítsa újra a játékszervert, hacsak a figyelés is le nem áll.

Amikor a probléma megszűnik, ugyanaz az útvonal rögzíti a helyreállítást:

> **A kritikus őr feloldva: a jelentésírás visszaállítva**  **Folytatás:** 21:22  **Megszakadás:** 8 perc **Eredmény:** A megszakítás során gyűjtött bizonyítékokat megőriztük, és a késedelmes bejelentéseket befejeztük.

A Critical Guard csak hiba esetén működik. A rutin állapot, a napi előzmények, a játékosok aktivitása és a szokásos várt üres eredmények a saját jelentésükben maradnak.

<a id="when-a-route-is-quiet"></a>
## Ha egy útvonal csendes

A csendes útvonal közvetlen eredményt rögzít anélkül, hogy kitöltést küldene a Discordnak:

> **Ellenőrzött; semmi ehhez a jelentéshez.** A szükséges rekordok rendelkezésre álltak, és nem történt megfelelő játékos tevékenység, eset vagy gárdahiba a jelentési ablakban.

Ez egy teljesen üres eredmény. Ez különbözik a hiányzó jelentéstől, ahol a szükséges forrás nem ellenőrizhető, vagy az olvasható kimenet nem hozható létre.

Minden olvasható jelentés ugyanazt az utat követi:

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Használja a [műveleti útmutató](M%C5%B0VELETI_%C3%9ATMUTAT%C3%93.md) az aktuális jelentések és a [kimeneti séma](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md) a műszaki területi hivatkozáshoz.
