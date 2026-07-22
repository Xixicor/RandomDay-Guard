<a id="player-review-workflow"></a>
# Oyuncu inceleme iş akışı

> **Kanonik İngilizce kaynağı:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu sayfayı bir oyuncu, hesap veya vaka için kullanın. Amaç, otomatik bir suçlama değil, tekrarlanabilir bir inceleme kararıdır.

<a id="quick-path"></a>
## Hızlı yol

1. Aç `runtime/final_logs/player_activity_latest.json`.
2. Rota durumunu `runtime/final_logs/route_proof.json`.
3. Hangi gözlemlerin güncel, hangilerinin geçmişe ait olduğunu tanımlayın.
4. Alıntılanan kimliği ve oturum kaynağı referanslarını kontrol edin.
5. Çıkarımdan önce `case_review_latest.json` ilişkili bir durum mevcut olduğunda.
6. Bir eylem seçmeden önce bilinmeyenleri ve `does_not_prove` kaydedin.
7. Uygulamayı devre dışı bırakın. ayrı yaptırım geçitleri kanıtlanmadığı sürece.

<a id="1-confirm-route-proof"></a>
## 1. Rota kanıtını onaylayın

Oynatıcı rotasını şu şekilde yorumlayın:

| Durum | Eylem |
|---|---|
| `full` | Kaynak sınırlarını incelerken devam edin. |
| `limited_expected_empty` | Yalnızca gerçekten mevcut olan konularla devam edin; eksik bir oyuncu veya vaka icat etmeyin. |
| `missing` | Oyuncu kararını durdurun ve rotadaki sorunları giderin. |

Sağlıklı bir planlayıcı, rota kanıtlamanın yerini almaz.

<a id="2-establish-identity"></a>
## 2. Kimlik oluşturun

Sunucunun açığa çıkardığı kimlik kanıtlarıyla desteklenen temiz bir hesap tanımlayıcıyı tercih edin ve mümkün olduğunda PlayerData dosya adları. Ham kaynak referansını koruyun.

Şunlardan zorunlu kılmayın:

- tek başına bir görünen ad;
- bir bildirimde veya barındırma panelinde görülen bir ad;
- zamanlama benzerliği;
- eşlenmemiş veya güveni zayıf bir kimlik;
- mevcut doğrulaması olmayan geçmiş bir rapor.

<a id="3-separate-current-from-historical"></a>
## 3. Günceli geçmişten ayırın

Mevcut kanıtlar, etkin raporlama penceresini veya sunucu dönemini açıklar. Tarihsel kanıtlar bir modeli açıklayabilir ancak mevcut penceredeki boşlukları sessizce dolduramaz.

Her iki kapsamı bağımsız olarak kaydedin:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Gözlemleri ve yorumları inceleyin

Raporun bu bölümlerini ayrı ayrı okuyun:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Herhangi bir önemli karar için alıntı yapılan yapılandırılmış kanıtları yeniden açın. Çeviri yeni bir kanıt değil, gezinme ve açıklamadır.

<a id="5-calibrate-the-decision"></a>
## 5. Kararı kalibre edin

| Karar | Ne zaman kullanın |
|---|---|
| `INFO` | Normal veya düşük bağlamlı gözlem. |
| `WATCH` | İzlenmeye değer zayıf veya eksik sinyal. |
| `REVIEW` | İlişkili kanıtlar yönetici kararı gerektirir. |
| `BAN-ELIGIBLE` | Temiz kimlik ve yapılandırılmış kanıt eşiklere ulaşıldı; yazma geçitleri hala geçerlidir. |
| `AUTO-BANNED` | Uygulama açıkça etkinleştirildi ve yedekleme, yazma, geri okuma ve denetim işlemlerinin tümü başarılı oldu. |

Hiçbir karar etiketi suçu veya niyeti kanıtlamaz.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Kanıt sınırını uygulayın

Çökmeler, yeniden bağlanmalar, uyarılar, object/class belirteçleri ve vaka gruplaması incelemeyi destekleyebilir. Tek başına hile, hırsızlık, çoğaltma, sahiplik, doğrudan hasar veya olayın nedenselliğini kanıtlamazlar.

Kimlik, ayrıştırma, yedekleme, yazma, geri okuma veya geri alma zayıfsa veya başarısız olursa yaptırım başarısız şekilde kapatılmalıdır.

<a id="review-note-template"></a>
## Not şablonunu inceleyin

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## İlgili belgeler

- [`EVIDENCE_BOUNDARY.md`](KANIT_SINIRI.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md)
- [`ADMIN_INI_ENFORCEMENT.md`](Y%C3%96NETICI_INI_UYGULAMASI.md)
- [`DETECTION_SIGNALS.md`](ALGILAMA_SINYALLERI.md)
