<a id="detection-signals"></a>
# Algılama sinyalleri

> **Kanonik İngilizce kaynağı:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Sinyaller, otomatik suçlamalar değil, inceleme girişleridir.

<a id="signal-table"></a>
## Sinyal tablosu

| Sinyal | Anlam | Şu durumda daha güçlü... | Tek başına yeterli değil |
|---|---|---|---|
| Giriş kimliği | Adı hesap kimliğiyle eşleştirir | ConnectID mevcut | Yasakla |
| Temiz ayrılma | Normal oturum kapatma | Katılma ve eşleşmeden ayrılma | Şüphe |
| Hızlı yeniden bağlanma | Churn/probing istiyorsunuz | Hızlı bir şekilde tekrarlanır | Yasakla |
| Kuru olmayan bağlantı | Oturum temiz bir şekilde kapanmadı | Kilitlenmeler tekrarlanıyor veya çakışıyor | Yasakla |
| Kilitlenme çakışıyor | Hesap kilitlenme yakınında etkin | Aynı hesap tekrarlanıyor | Yasakla |
| Kilitlenme sonrası geri dönüş | Hesap yeniden başlatıldıktan sonra geri döner | Dönemler arasında tekrarlanır | Tek bir etkinlikle yasaklama |
| Uyarı patlaması | Sunucu uyarı penceresi | Eşlenen oturumlarla çakışır | Tek patlamayla yasaklama |
| Aktör kaydetme dokunuşu | Dünyayı kaydetme bağlamı | Şununla bağlantılıdır: oturumlar | use/theft |
| Object delta | World/class değişikliğinin kanıtı | Şununla bağlantılıdır: oturumlar | Yalnızca sayım yasağı |
| Baskın vakası | Çoklu hesap kümesi | Merkezi hesap tekrarlar | Tüm hesapları toplu olarak yasaklayın |

<a id="login-identity"></a>
## Giriş kimliği

En iyi kaynak:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Haritalamak için kullanın:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Hızlı yeniden bağlanma

Desen:

```text
join -> leave -> join -> leave -> join
```

Tekrarlandığında inceleme için kullanın.

Güvenlik:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Kilitlenme çakışması ve kilitlenme sonrası geri dönüş

Desen:

```text
account active before crash
server restarts
same account returns quickly
```

İnceleme için kullanın çağlar boyunca tekrarlandığında.

Güvenlik:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Uyarı patlamaları

Örnekler:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Eşlenen oturumlara ve eşiklere bağlanana kadar bağlam olarak kullanın.

<a id="actor-save-touch"></a>
## Aktör kaydetme dokunuşu

Anlamı:

```text
The server evidence referenced a class or actor.
```

Anlamı:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Baskın durumları

Baskın vakası, hesapları zamanlamaya ve paylaşılan pencerelere göre gruplandırır.

Kural:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## İlgili belgeler

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](K%C3%96T%C3%9C_AKT%C3%96R_KALIPLARI_VE_DAYANIKLILIK.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
