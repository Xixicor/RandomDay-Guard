<a id="start-here-read-the-first-guard-report"></a>
# Kezdje itt: olvassa el az első őrségi jelentést

> **Kanonikus angol forrás:** [START_HERE.md](../../START_HERE.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ez az útmutató RandomDayGuard telepítve van és engedélyezve van. Hasznos eredményt bizonyít anélkül, hogy új kezelőt kérne fel a forráskód, a csomag belső részei vagy a csak gép állapotfájljainak vizsgálatára.

<a id="what-happens-after-the-server-starts"></a>
## Mi történik a szerver elindulása után

Az őr a játékszerverre vár, és a UE4SS betöltéséhez, megkeresi a kiszolgáló elérhető rekordjait, és elindít egy korlátozott háttérvizsgálatot. Jelentheti a szerver aktuális állapotát, miközben a régebbi előzmények továbbra is indexelés alatt állnak.

Az első jelentés **Szerver állapota**. Megválaszolja, hogy a Guard most befejezi-e a megfigyelési ciklusokat, amikor az aktuális szerverfutás elkezdődött, ha elérhető az időbélyeg, mennyi active/rotated létezik naplózási és vizsgálati lefedettség, hány játékos csatlakozik, mely forráscsoportok hiányoznak, és szükség van-e operátori műveletre.

A még folyamatban lévő háttérvizsgálat korlátozza a korábbi lefedettséget, nem pedig automatikusan indítási hiba. A Guard rögzíti a szkennelési kurzort, a befejezett fájlokat, a felfedezett fájlokat és az utolsó folyamatidőt. Ha ezek az értékek nem változnak az ismételt megfigyelési ciklusok során, kezelje az előzményút leálltként, és kövesse a Hibaelhárítás szakasz vizsgálati ágát. Ne dobja el az aktuális napló- és munkamenet-eredményeket kizárólag azért, mert a régebbi előzmények nem teljesek.

<a id="read-the-first-server-status-report"></a>
## Olvassa el az első szerverállapot-jelentést

1. Indítsa el a dedikált szervert a szokásos módon.
2. Várjon a játékszerverre, és UE4SS az indítás befejezéséhez.
3. Megnyitás RandomDayGuard's végső jelentések mappába, és válassza ki a legújabb olvasható szerverállapot-jelentést.
4. Győződjön meg arról, hogy a jelentés tartalmazza:
   - **Összefoglaló**
   - **Amit Guard megfigyelt**
   - **Mit jelent?**
   - **Ami ismeretlen marad**
   - **Ajánlott következő lépés**
   - **Műszaki nyilvántartás**
5. In **Amit Guard megfigyelt**, erősítse meg a legutóbbi megfigyelési ciklus előrehaladását, valamint a rendelkezésre álló napló, szkennelés, lejátszó és forráslefedettség jelentésneveket.
6. Ha a következő lépés szerint nincs szükség beavatkozásra, tartsa meg a jelentést az első sikeres eredményként. Ha hiányzó forrást vagy leállított folyamatot nevez meg, kövesse pontosan ezt a tünetet a [Hibaelhárítás](HIBAELH%C3%81R%C3%8DT%C3%81S.md).

A jelentés műszaki bizonyítékokra hivatkozhat a mélyebb áttekintés érdekében. Egy normál operátor először elolvashatja a jelentést, és csak akkor nyithatja meg ezeket a hivatkozásokat, ha az egyszerű eredményt kell ellenőrizni.

<a id="understand-quiet-reports"></a>
## A csendes jelentések megértése

A játékosok tevékenysége, az esetek áttekintése és a Critical Guard eseményvezérelt. Egy csendes szerver nem hozhat létre kitalált lejátszót, esetet vagy kudarcot pusztán egy csatorna kitöltésére. Az olvasható eredmény azt mondhatja, hogy a forrást ellenőrizték, és semmi sem tartozott a jelentéshez.

A napi összesítés különbözik: jelentésdátumonként egy felülvizsgálatot biztosít az ugyanazon a napon zajló munkamenetek, aktuális felülvizsgálati témák, megtartva identity/case kontextus, szkennelés folyamata és forráshiányok, amelyeket a Guard valóban ki tud olvasni. A rendelkezésre álló szerverrekordokból hiányzó tények becslések helyett ismeretlenek maradnak.

<a id="test-one-ordinary-player-session"></a>
## Tesztelj le egy normál játékos munkamenetet

Miután az első szerverállapot-jelentés aktuális:

1. Egy ismert játékos csatlakozzon, és hagyja el a szokásos módon.
2. Várja meg a következő jelentési ciklust.
3. Nyissa meg a lejátszó tevékenységét.
4. Erősítse meg, hogy azonosítja az őr számára elérhető fiókot vagy megjelenített nevet, a csatlakozási és kilépési időket, a tiszta vagy nem teljes munkamenet eredményét, a korábbi előzményeket, ha elérhető, és egy következő műveletet.

A munkamenet-jelentésnek tartalmaznia kell a megfigyelt adatokat. Nem helyettesíthető fájlnevek listájával vagy általános utasítással, hogy léteznek rekordok.

<a id="continue"></a>
## Folytatás

- [Öt jelentési példa](P%C3%89LD%C3%81K_JELENT%C3%89SRE.md)
- [Műveleti útmutató](M%C5%B0VELETI_%C3%9ATMUTAT%C3%93.md)
- [Játékos ellenőrzési munkafolyamat](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
- [Hibaelhárítás](HIBAELH%C3%81R%C3%8DT%C3%81S.md)
- [Teljes dokumentációs index](DOKUMENT%C3%81CI%C3%93.md)
