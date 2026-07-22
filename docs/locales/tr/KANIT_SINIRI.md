<a id="evidence-boundary"></a>
# Kanıt sınırı

> **Kanonik İngilizce kaynağı:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Neye karar vereceğinize karar vermek için bu sayfayı kullanın. RandomDayGuard raporlayabilir ve yine de insan incelemesi gerektiren şeyleri rapor edebilir.

<a id="core-rule"></a>
## Temel kural

RandomDayGuard, sunucuya ait dosyalardan sınırlı gözlemleri kaydeder. Her önemli sonuç için kaynağı, kapsamı, toplama durumunu ve sınırları tanımlamalıdır.

Yapılandırılmış kanıtlar güvenilirdir. Çevrilmiş bir rapor kanıtları açıklıyor; yapılandırılmış kayıtta bulunmayan gerçekleri ekleyemez.

<a id="evidence-source-classes"></a>
## Kanıt kaynağı sınıfları

| Kaynak sınıfı | Genel kullanım | Kendi başına kanıtlanmaz |
|---|---|---|
| `admin_ini` | Mevcut yönetim durumu ve denetlendi write/readback istiyorsunuz | Kimin sebep olduğu bir olay |
| `active_log` | Etkin günlükte görünen güncel server/session olaylar | Kasıt, sahiplik veya doğrudan hasar |
| `recent_backup_logs` | Geçmiş günlük bağlamı | Güncel bir olay meydana geldi |
| `playerdata_filenames` | Temiz bir hesabın doğrulanması tanımlayıcı mevcut | Açık tanımlayıcının ötesinde davranış, suçluluk veya kimlik sahipliği |
| `existing_cases` | Önceki inceleme bağlamı | Önceki yorumun doğru olduğu |
| `existing_reports` | Daha önceki özetler ve kararlar | Güncel doğrulama olmaksızın güncel gerçek |
| `existing_evidence` | Geçmişsel yapılandırılmış kanıt | Mevcut etkinlik |
| sınırlı dünya kurtarma taraması | Yavaş world/class istiyorsunuz | Oyuncu eylemi, sahiplik, hırsızlık, çoğaltma veya hasar |

Her kaynak availability/readability, dosya sayısını, kaynak referanslarını, güncel veya geçmiş kapsamı ve açık bir `does_not_prove` kaydeder beyanı.

<a id="source-states"></a>
## Kaynak durumları

| Durum | Operatörün anlamı |
|---|---|
| `available` | Kaynak okunabilirdi ve kanıt toplandı. |
| `expected_empty` | Kaynak okunabilirdi ve yasal olarak eşleşen bir kayıt yoktu. |
| `partial` | Bazı kanıtlar toplandı; kapsam eksik. |
| `deferred` | Sınırlı çalışma kasıtlı olarak ertelendi. |
| `unavailable` | Kaynak bu ortamda mevcut değil. |
| `malformed` | Kaynak mevcut ancak güvenli bir şekilde ayrıştırılamıyor. |
| `permission_denied` | İzleyicinin okuma izni yok. |
| `error` | Kaydedilen başka bir dosyanın toplanması başarısız oldu. sebep. |

Beklenen boş geçerli bir gözlemdir. Asla uydurma bir oyuncuya, davaya, olaya veya suçlamaya dönüştürülmemelidir.

<a id="current-versus-historical-evidence"></a>
## Güncel ve geçmişe ait kanıtlar

Mevcut kanıtlar aktif toplama penceresine veya sunucu dönemine aittir. Tarihsel kanıtlar önceki günlüklerden, vakalardan, raporlardan, kanıt kayıtlarından, yedeklemelerden veya temellerden gelir.

Geçmişsel kanıtlar bağlam sağlayabilir. Mevcut kanıt boşluğunu sessizce dolduramaz. Raporlar her iki kapsamı da etiketlemeli ve kaynaklarını ayrı ayrı belirtmelidir.

<a id="corroboration-rule"></a>
## Doğrulama kuralı

Bunlar yararlı bağlamlardır ancak kendi başlarına doğrudan kanıt değildir:

- görünen adlar veya ad benzerliği;
- zamanlama çakışması;
- bağlantıyı kesme veya yeniden bağlama;
- bir kilitlenme veya uyarı patlaması;
- sınıf, yol, aktör, harita veya nesne sayımı belirteçleri;
- otomatik olarak gruplandırılmış bir vakada üyelik;
- mevcut kaynak onayı olmadan önceki raporlar.

Gerçeği doğrudan ortaya koyan bir kanıt olmadan suç, niyet, hile, mülkiyet, hırsızlık, çoğaltma, doğrudan hasar, doğrudan konteyner kullanımı, doğrudan envanter eylemi, tam canlı koordinatlar, canlı ping veya hafıza düzeyinde davranış iddiasında bulunmayın.

<a id="truthful-report-language"></a>
## Doğru rapor dili

Kullanım:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Kaçının:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Rapor okuma sırası

Herkese açık olan her rapor şunları açıklamalıdır:

1. Açık anlam.
2. Neden önemlidir.
3. Teknik kanıt ve kaynak referansları.
4. Sonraki işlem.
5. Sınırlar, bilinmeyenler ve kanıtlanmamış iddialar.

<a id="related-docs"></a>
## İlgili belgeler

- [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
- [`BAN_ID_MAPPING.md`](YASAKLI_KIMLIK_E%C5%9ELEME.md)
- [`DETECTION_SIGNALS.md`](ALGILAMA_SINYALLERI.md)
