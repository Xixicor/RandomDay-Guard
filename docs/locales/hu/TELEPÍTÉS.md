<a id="install-randomdayguard"></a>
# Telepítés RandomDayGuard

> **Kanonikus angol forrás:** [INSTALL.md](../../../INSTALL.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ez az útmutató a telepítéshez `v0.4.12-alpha` egy Abiotic Factor dedikált szerveren, amely már használja a UE4SS. A mod nem egy hosting céghez vagy vezérlőpulthoz van kötve.

<a id="before-you-begin"></a>
## Mielőtt elkezdi

Szükséged van:

- hozzáférés a dedikált szerver leállításához és elindításához;
- a szerveré UE4SS `Mods` mappa;
- a jelenlegi RandomDayGuard mappába, ha éppen frissít;
- a szerveradatok biztonsági mentése, amelyet általában véd a mod megváltoztatása előtt.

A **Mods mappa** a `ue4ss/Mods/` könyvtár a dedikált szerver telepítésen belül. RandomDayGuard közvetlenül ebbe a mappába tartozik.

<a id="new-installation"></a>
## Új telepítés

1. A dedikált szerver leállítása.
2. Kicsomagolja a RandomDayGuard ZIP egy új üres mappába.
3. Másolja a kibontott fájlt `RandomDayGuard` mappát a szerver UE4SS `Mods` mappát. Az eredmény egy `Mods/RandomDayGuard/` mappa, nem egy második RandomDayGuard mappa van beágyazva benne.
4. Megnyitás UE4SS `mods.txt` és engedélyezze:

   ```text
   RandomDayGuard : 1
   ```

5. Indítsa el a szervert a szokásos módon.
6. Várjon UE4SS és a játékszerver az indítás befejezéséhez, majd kövesse a [Olvassa el az első jelentést](KEZDJE_EL_ITT.md).

Ne másoljon új kiadást futó telepítésre. Tartsa a biztonsági másolatot mindaddig, amíg a frissített telepítés nem készít egy aktuális szerverállapot-jelentést.

<a id="update-an-existing-installation"></a>
## Meglévő telepítés frissítése

1. Állítsa le a szervert.
2. Másolja a teljes telepített fájlt RandomDayGuard mappát egy biztonságos biztonsági mentési helyre.
3. A régi programmappa áthelyezése a UE4SS `Mods` ahelyett, hogy rárétegezné az új kiadást.
4. Másolja az újat RandomDayGuard mappába `Mods`.
5. Csak az ellenőrzött helyi konfigurációt és a mentett bizonyítékokat állítsa vissza. Ha a konfigurációs útmutató új mezőket sorol fel, ahelyett, hogy vakon cserélné le az összes beállítást, egyesítse azokat a felülvizsgált másolattal.
6. Megerősítés `RandomDayGuard : 1` engedélyezve marad.
7. Indítsa el a szervert, és olvassa el az aktuális szerverállapot-jelentést.

Ez a tiszta mappafrissítés a régebbi kiadások elavult fájljait is eltávolítja anélkül, hogy a kezelőt kérné a programok fájlneveinek ellenőrzésére.

<a id="help-guard-find-the-server-records"></a>
## Segítsen a Guardnak a szerverrekordok megtalálásában

Az őr általában megtalálja az Abiotikus faktort `Saved` könyvtár automatikusan. Ha nem, adja meg a teljes elérési utat a `Saved` könyvtár itt: `SavedRoot.txt` belül RandomDayGuard mappát. Mutasson a `Saved`, nem pedig az alatta lévő világra.

Az első szerverállapot jelentés azt mondja, hogy a rekord helye megtalálható-e, és mely forráscsoportok voltak elérhetők. Használja a [Hibaelhárítás](HIBAELH%C3%81R%C3%8DT%C3%81S.md), ha nem tudja olvasni a helyet.

<a id="first-run-behavior"></a>
## Első futtatási viselkedés

Az alapértelmezett telepítés figyeli az elérhető rekordokat és jelentéseket ír. Nem változik `Admin.ini` vagy adjon hozzá kitiltást. Ezzel ellenőrizheti a gyűjtés, a fordítás és a jelentés minőségét, mielőtt eldöntené, hogy engedélyez-e bármilyen opcionális műveletet.

[Olvassa el az első jelentést](KEZDJE_EL_ITT.md)

<a id="disable-or-remove-randomdayguard"></a>
## Letiltás vagy eltávolítás RandomDayGuard

1. Állítsa le a szervert.
2. A teljes RandomDayGuard mappát egy biztonságos archívumba.
3. A mod letiltásához állítsa be a `RandomDayGuard : 0` in UE4SS `mods.txt`.
4. Eltávolításához mozgassa át a teljes RandomDayGuard mappa nincs a következőből: `Mods` megerősítése után az archívum megnyitható.
5. Indítsa el a szervert, és ellenőrizze, hogy a Guard már nem indul el.

A Guard letiltása vagy eltávolítása leállítja a jövőbeli adatgyűjtést. Nem törli a játékadatokat, nem törli az archivált jelentéseket, és nem fordít vissza külön kezelői műveletet.

<a id="roll-back-an-update"></a>
## Frissítés visszaállítása

Ha az új telepítés nem töltődik be, vagy nem tud aktuális jelentést készíteni:

1. Állítsa le a szervert.
2. Tegye félre a sikertelen telepítést a rekordok törlése nélkül.
3. A teljes előzetes frissítés visszaállítása RandomDayGuard mappába.
4.  Állítsa vissza a felülvizsgált konfigurációt és a mentett bizonyítékokat ugyanabból a biztonsági másolatból.
5. Győződjön meg arról, hogy a mod engedélyezve van, és indítsa el a szervert.
6. Olvassa el a visszaállított szerverállapot-jelentést, mielőtt újabb módosítást hajtana végre.

<a id="more-help"></a>
## További segítség

- [Olvassa el az első jelentést](KEZDJE_EL_ITT.md)
- [Műveleti útmutató](M%C5%B0VELETI_%C3%9ATMUTAT%C3%93.md)
- [Hibaelhárítás](HIBAELH%C3%81R%C3%8DT%C3%81S.md)
- [Konfigurációs profilok](KONFIGUR%C3%81CI%C3%93S_PROFILOK.md)
- [Admin.ini végrehajtás](ADMIN_INI_V%C3%89GREHAJT%C3%81S.md)

A kiadás karbantartói megtalálhatják a forrás-, csomag- és adatvédelmi ellenőrzéseket [Érvényesítés és kiadás](%C3%89RV%C3%89NYES%C3%8DT%C3%89S_%C3%89S_KIAD%C3%81S.md). Nem szükségesek a szokásos telepítéshez.
