<a id="security-policy"></a>
# Biztonsági szabályzat

> **Kanonikus angol forrás:** [SECURITY.md](../../../SECURITY.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


<a id="report-a-vulnerability-privately"></a>
## Sérülékenység privát bejelentése

Használja a [GitHub privát biztonsági rések jelentése](https://github.com/Xixicor/RandomDay-Guard/security/advisories/new) bizalmas jelentés küldéséhez az adattár tulajdonosának. Ha ez az űrlap nem érhető el, használja a [tulajdonos nyilvános GitHub profil](https://github.com/Xixicor) privát kapcsolatfelvételi csatorna kéréséhez a sebezhetőség részleteinek megadása nélkül.

Ne nyisson meg olyan nyilvános kérdést, amely kihasználási lépéseket, hitelesítési adatokat, privát szerver elérési utat, játékosazonosítókat, `Admin.ini`, Mentett adatok, webhook URL-ek vagy élő bizonyítékok.

<a id="include-useful-evidence"></a>
## Tartalmazzon hasznos bizonyítékokat

Adja meg:

- az érintett RandomDayGuard verzió vagy véglegesítés;
- az érintett összetevő és a várható biztonságos viselkedés;
- minimális reprodukálási lépések fertőtlenített fixtures használatával;
- a megfigyelt hatás, és hogy megismételhető-e; és
- minden olyan javasolt mérséklés, amely nem tesz közzé személyes adatokat.

Ne küldj valódi titkokat. Cserélje le a privát elérési utakat, fiókazonosítókat, gazdagépneveket és tokeneket egyértelmű helyőrzőkre, miközben megőrzi a probléma reprodukálásához szükséges struktúrát.

<a id="expect-review-first-handling"></a>
## Ellenőrzés előtti kezelés várható

A jelentés a karbantartói felülvizsgálat bizonyítéka, nem pedig a szerver eléréséhez, egy élő célpont teszteléséhez, a kihasználás részleteinek közzétételéhez vagy a hibazárás alapértékeinek gyengítéséhez való felhatalmazás. A tulajdonos a magánjelentésen keresztül érvényesíti a hatókört és koordinálja a közzétételt.
