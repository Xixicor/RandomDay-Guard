<a id="detection-signals"></a>
# Érzékelési jelek

> **Kanonikus angol forrás:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


A jelek felülvizsgálati bemenetek, nem pedig automatikus vádak.

<a id="signal-table"></a>
## Jeltáblázat

| Jel | Jelentés | Erősebb, ha... | Önmagában nem elég |
|---|---|---|---|
| Bejelentkezési azonosító | Név hozzárendelése a fiókazonosítóhoz | A ConnectID jelen van | Kitiltás |
| Tiszta szabadság | Normál munkamenet-bezárás | Csatlakozás és kilépés a meccsből | Gyanú |
| Gyors újracsatlakozás | Churn/probing kontextus | Gyorsan ismétlődik | Kitiltás |
| Tiszta leválasztás | A munkamenet nem zárult le tisztán | Ismétlődő vagy átfedő összeomlások | Kitiltás |
| Összeomlási átfedés | A fiók összeomlás közelében aktív | Ugyanaz a fiók ismétlődik | Kitiltás |
| Összeomlás utáni visszatérés | A fiók újraindítás után visszatér | Epochokon át ismétlődik | Kitiltás egy eseménnyel |
| Figyelmeztető sorozat | Szerver figyelmeztető ablak | Átfed a leképezett munkameneteket | Kitiltás egy sorozattal |
| Színész mentési érintés | Világkímélő kontextus | Korelál a munkamenetekkel | A use/theft |
| Objektum-delta | World/class módosítás | Korelál a munkamenetekkel | Csak a számlálás tiltása |
| Raid eset | Többfiókos fürt | A központi fiók ismétlődik | Minden fiók tömeges kitiltása |

<a id="login-identity"></a>
## Bejelentkezési azonosító

Legjobb forrás:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Használja a térképhez:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Gyors újracsatlakozás

Minta:

```text
join -> leave -> join -> leave -> join
```

Ismétléskor használja felülvizsgálathoz.

Biztonság:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Az összeomlás átfedése és az összeomlás utáni visszatérés

Minta:

```text
account active before crash
server restarts
same account returns quickly
```

Használja felülvizsgálathoz, ha korszakokon át ismétli.

Biztonság:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Figyelmeztető sorozatok

Példák:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Használja kontextusként, amíg nem kapcsolódik hozzárendelt munkamenetekhez és küszöbértékekhez.

<a id="actor-save-touch"></a>
## Színész mentési érintés

Jelentés:

```text
The server evidence referenced a class or actor.
```

Nem jelentése:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Raid esetek

A raideset időzítés és megosztott ablakok szerint csoportosítja a fiókokat.

Szabály:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](ROSSZ_SZ%C3%8DN%C3%89SZI_MINT%C3%81K_%C3%89S_RUGALMASS%C3%81G.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
