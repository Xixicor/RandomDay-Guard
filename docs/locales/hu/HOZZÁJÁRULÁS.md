<a id="contributing"></a>
# Hozzájárulás

> **Kanonikus angol forrás:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


RandomDayGuard elfogadja az elemzők, a dokumentáció, a tesztek és a nyilvános ellenőrzés célzott, reprodukálható fejlesztéseit. Minden változtatást a nyilvános projektszerződéshez kell kötni, és őrizze meg a felülvizsgálat előtti viselkedést: Az őrnek távoznia kell `Admin.ini` változatlan, ha a szükséges biztonsági ellenőrzés nem erősíthető meg.

<a id="prepare-a-safe-workspace"></a>
## Készítsen elő egy biztonságos munkaterületet

1. Forgassa el vagy klónozza a tárat, és hozzon létre egy fókuszált ágat.
2. Telepítsen egy támogatott Python 3 értelmezőt. Telepítsen egy Lua fordítót, amikor módosítja a Lua-t `luac -p` ellenőrizheti a szintaxist.
3. Olvassa el a [a dokumentáció főoldala](DOKUMENT%C3%81CI%C3%93.md), [architektúra](ARCHITEKT%C3%9ARA.md) és [bizonyítékok határa](A_BIZONY%C3%8DT%C3%89KOK_HAT%C3%81RA.md) a módosítani kívánt területhez.
4. Vizsgálja meg `git status` szerkesztés előtt, és őrizze meg a nem kapcsolódó munkákat.
5. Csak szintetikus vagy fertőtlenített lámpatesteket használjon.

Soha ne küldjön be privát szervernaplókat, mentett mappákat, lejátszóazonosítókat, `Admin.ini`, privát értesítési végpontok, hitelesítő adatok, privát elérési utak, futásidejű kimenet vagy másolt élő bizonyíték.

<a id="make-a-focused-change"></a>
## Végezzen el egy célzott változtatást

- Kövesse a meglévő elnevezéseket, formázásokat, biztonsági ellenőrzéseket és a modulok tulajdonjogát.
- Minden eljáráshoz vagy pontos tényhez tartson egy kanonikus dokumentációtulajdonost.
- Frissítse a felhasználói dokumentációt és a példákat, amikor a viselkedés vagy a nyilvános kimenet megváltozik.
- Adjon hozzá egy regressziós tesztet a hibajavításhoz, ha lehetséges.
- Ne gyengítse a fiók megerősítését, a megbízható fiók védelmét, a biztonsági másolat ellenőrzését, a külső változások észlelését, a mentett fájlok összehasonlítását, a helyreállítást vagy a csak ellenőrzés alapértelmezéseit, hogy sikeres legyen a teszt.

<a id="run-the-relevant-checks"></a>
## Futtassa le a vonatkozó ellenőrzéseket

A csak dokumentációs változtatásokhoz futtassa:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

A forrás-, konfiguráció-, csomagolás- vagy tesztmódosításokhoz futtassa le a vonatkozó ellenőrzéseket is innen: [Érvényesítés és kiadás felülvizsgálata](%C3%89RV%C3%89NYES%C3%8DT%C3%89S_%C3%89S_KIAD%C3%81S.md), beleértve a Lua szintaktikai ellenőrzéseket, a lerakat érvényesítését, a nyilvános csővezeték teszteket és a teljes egységteszt-készletet. Jelentsen minden kihagyott vagy nem elérhető ellenőrzést; ne írja le, hogy átment.

<a id="submit-the-change-for-review"></a>
## Küldje be a módosítást felülvizsgálatra

Csak a teljes eltérés áttekintése után nyissa meg a fókuszált lekérési kérelmet. Tartalmazza:

- a probléma és a tervezett viselkedés;
- pontos fájlok és közbeszerzési szerződések módosultak;
- futnak a parancsok és azok eredményei;
- adatvédelmi, kompatibilitási és végrehajtási hatás; és
- fennmaradó korlátozások vagy nyomon követési munka.

Ne tartalmazzon generált futásidejű bizonyítékokat vagy kiadási archívumokat, kivéve, ha a módosítás kifejezetten megköveteli és érvényesíti azokat. A hozzájárulás nem engedélyez kiadást, telepítést, élő szervertesztet, betartatási műveletet vagy közzétételt harmadik fél webhelyén.

A sebezhetőségek bejelentése a következőn keresztül: [a privát biztonsági útvonal](BIZTONS%C3%81G.md), nem nyilvános probléma vagy közönséges lekérési kérelem.
