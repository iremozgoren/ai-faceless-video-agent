---
name: hayvan-videosu
description: Bir hayvan hakkında "4 şey" serisinden Türkçe + Almanca yüzsüz Shorts videosu üretir — araştırma, bağımsız doğrulama, metin, yapay zekâ seslendirme, kurgu, Almanca versiyon ve yayın metinleri. Kullanıcı /hayvan-videosu <hayvan> dediğinde kullan.
argument-hint: <hayvan>
disable-model-invocation: true
---

# /hayvan-videosu $ARGUMENTS

Hayvan: **$ARGUMENTS** (aşağıda `<hayvan>`; dosya adlarında küçük harf, Türkçe karakter kalabilir, boşluk yerine `-`).

Önce `CLAUDE.md`, `kural-dosyasi.md` ve `almanca/kural-dosyasi-de.md`'yi oku; hepsi bağlayıcıdır.

## Değişmez kurallar
- **⏸ işaretlerinde dur.** Kullanıcıya özet göster, açık onay ("onaylıyorum", "devam" vb.) gelmeden sonraki adıma geçme. Düzeltme gelirse uygula ve aynı ⏸'de tekrar onay iste.
- **Hiçbir şey otomatik yayınlanmaz.** YouTube/TikTok/Instagram'a yükleme, paylaşım linki üretme (`hyperframes publish`, Artifact publish vb.), e-posta/mesaj gönderme yok. Tüm çıktılar sadece yerel dosyadır.
- Metindeki her gerçek, doğrulayıcının **seçtiği 4 gerçekten** gelir. Metne yeni bir gerçek, sayı ya da genelleme ekleme.
- Bir adımı yeniden çalıştırırken önceki dosyanın üstüne yazmadan önce kullanıcıya söyle.

## 1. Araştırma — `arastirmaci` alt agent'ı
Agent aracıyla `subagent_type: "arastirmaci"` başlat. Prompt: hayvan adı + "az bilinen 6–8 gerçek, her biri için güvenilir kaynak ve kaynaktaki cümle; `arastirma/<hayvan>.md`'ye yaz". Bitince dosyanın oluştuğunu ve her maddede kaynak + alıntı olduğunu kontrol et; eksik varsa agent'a SendMessage ile tamamlat.

## 2. Doğrulama — `dogrulayici` alt agent'ı
`arastirma/<hayvan>.md`'den **sadece** her maddenin Türkçe iddiasını, tür/kapsamını ve kaynak URL'sini çıkar. Araştırmacının alıntılarını ve notlarını **verme** (bağımsız doğrulama). Agent aracıyla `subagent_type: "dogrulayici"` başlat ve bu listeyi ver.

Doğrulayıcı dosya yazamaz; dönen raporu `arastirma/<hayvan>.md`'nin sonuna `## Doğrulama (dogrulayici, YYYY-AA-GG)` başlığıyla sen ekle.

## ⏸ 1 — Gerçekleri onayla
Kullanıcıya göster:
| # | Gerçek (son hali) | Kaynak | Doğrulayıcı notu |
Ayrıca elenen iddiaları ve neden elendiklerini tek satırla listele. Araştırmacı ile doğrulayıcı arasında anlaşmazlık varsa açıkça söyle.

## 3. Türkçe metin → `metin/<hayvan>.txt`
Serinin yapısı (bkz. `metin/gelincik.txt`, `metin/balina.txt`):
```
<Hayvan>lar hakkında muhtemelen hiç duymadığın 4 şey.
Bir: <gerçek 1, 1–2 cümle>
İki: …
Üç: …
Dört: …
Bunlardan hangisini biliyordun? Yorumlara yaz.
```
- Hedef ~40 sn seslendirme ≈ 90–105 kelime. Kelime sayısını yaz.
- Sayılar/birimler doğrulanmış haliyle; "yaklaşık", "bazı" gibi niteleyiciler korunur.
- Yeni özel isim/terim varsa `kural-dosyasi.md` → "Doğru yazılışlar"a eklemeyi öner.

## ⏸ 2 — Metni onayla
Metni ve her cümlenin hangi doğrulanmış gerçeğe dayandığını göster.

## 4. Seslendirme + kurgu (mevcut Türkçe akış)
1. `scripts/seslendir.sh metin/<hayvan>.txt ham/<hayvan>.mp3 tr` (ses ID `kural-dosyasi.md`'den).
2. `scripts/transkript.sh ham/<hayvan>.mp3` → kelime zamanları; yazımı metne göre düzelt. Sayıların okunuşundan emin değilsen ilgili kısmı kesip kullanıcıya dinlet.
3. `CLAUDE.md` → "Standart akış" adım 3: **sahne sahne plan tablosu** göster (zaman | söylenen | ekranda ne olacak). Seri tutarlılığı: büyük "4" girişi, 01–04 rozetleri, üstte ilerleme çubuğu, ışık hüzmeleri, kapanışta 4 kart + soru + "YORUMLARA YAZ". Zemin rengi hayvana özel olabilir; renk kuralları geçerli.

## ⏸ 3 — Sahne planını onayla
Onaydan sonra: `motion/<hayvan>/` (iskeleti `motion/gelincik/`'ten kopyala, `index.html`'i yeniden yaz), ses `scripts/ses-seviye.sh ham/<hayvan>.mp3 motion/<hayvan>/assets/ses.wav`, `npm run check`, kare kontrolü (`npx hyperframes snapshot`), render → `cikti/<hayvan>-final.mp4`, LUFS ölç/düzelt.

## ⏸ 4 — Türkçe videoyu onayla
Dosya yolunu, süreyi, LUFS'u ve kontrolde düzelttiklerini söyle. Kullanıcı izleyip onaylamadan Almancaya geçme.

## 5. Almanca versiyon (mevcut akış)
`CLAUDE.md` → "Almanca akış"ı uygula: çeviri → **Almanca | Türkçe geri çeviri tablosu** → ⏸ onay → seslendirme (`de`) → kopyala/çevir/yeniden senkronla → render `almanca/cikti/<hayvan>-final.mp4` + `almanca/cikti/<hayvan>-de.srt`. Kullanıcı Almanca terim verdiyse onları kullan.

## ⏸ 5 — Almanca videoyu onayla

## 6. Yayın metinleri → `yayin/<hayvan>.md`
Sadece dosya yaz; hiçbir platforma gönderme. İçerik:
```markdown
# <hayvan> — yayın metinleri (taslak, otomatik yayınlanmaz)

## Türkçe
### YouTube Shorts
- Başlık önerileri (3): ≤ 60 karakter, merak uyandıran, clickbait değil
- Açıklama: 2–3 cümle + "Kaynaklar:" altında doğrulanmış 4 kaynağın URL'leri
- Hashtag'ler: 5–8 (#shorts dahil)
### TikTok
- Açıklama: ≤ 150 karakter + 3–5 hashtag (kaynak linki: "kaynaklar YouTube açıklamasında")
### Kapak metni önerileri (3): en fazla 4 kelime, kural dosyasındaki kapak/başlık stiline uygun

## Deutsch
(aynı yapı, du-Ansprache, Almanca hashtag'ler; kaynak URL'leri aynı)
```
Kaynak listesi `arastirma/<hayvan>.md`'deki doğrulanmış 4 kaynakla birebir aynı olmalı.

## 7. Yükleme dosyası → `yayin/<hayvan>-yukleme.md`
Her hayvan için ayrı dosya; video yüklenirken doğrudan kopyalanıp yapıştırılacak **son hali** (öneri değil, her alan için tek metin). Adım 6'daki ilk başlık önerisini kullan; kullanıcı başka birini seçtiyse onu. Sadece dosya yaz; hiçbir platforma gönderme. Her alan ayrı kod bloğunda (kolay kopyalama):
```markdown
# <hayvan> — yükleme metinleri (elle yüklenecek)
Videolar: `cikti/<hayvan>-final.mp4` (TR), `almanca/cikti/<hayvan>-final.mp4` (DE), altyazı `almanca/cikti/<hayvan>-de.srt`

## Türkçe
### YouTube Shorts
Başlık / Açıklama (kaynak URL'leri dahil) / Hashtag'ler — her biri ayrı kod bloğu
### TikTok
Açıklama + hashtag'ler (tek blok, ≤ 150 karakter açıklama)
### Instagram Reels
Açıklama (2–3 cümle + soru + "Kaynaklar YouTube açıklamasında") + 3–5 hashtag (tek blok)

## Deutsch
(aynı yapı, du-Ansprache, Almanca hashtag'ler; kaynak URL'leri aynı)
```
Gerçekler ve sayılar `metin/<hayvan>.txt` ile birebir aynı olmalı; yeni bilgi ekleme.

## Bitiş
Üretilen tüm dosyaları listele. Yayınlamanın kullanıcının elle yapacağı bir adım olduğunu hatırlat.
