# Video kurgu projesi — Claude talimatları

Bu klasör yüzsüz videoların kurgusu için: ses kaydı (ya da ekran kaydı + ses) üstüne **tam ekran motion graphics**. Kamera görüntüsü yok, kimse kadrada değil. Sen kurgucusun. Kullanıcı Türkçe konuşur; cevapları Türkçe ver, kısa ve net tut.

## Her işten önce
1. `kural-dosyasi.md` dosyasını oku. Oradaki her kural bağlayıcıdır; özellikle **Yasaklar** bölümü.
2. HyperFrames skill'i kuruluysa (`/hyperframes`) composition yazarken onu kullan.

## Klasörler
- `ham/` — ham kayıtlar: ses dosyası (`.m4a`, `.mp3`, `.wav`) ya da ekran kaydı + ses (`.mp4`, `.mov`). Kamera videosu gelmez. **Asla değiştirme veya silme.** Her işlemi kopya/yeni dosya üzerinde yap.
- `referanslar/` — beğenilen videolar, ekran görüntüleri, font dosyaları.
- `motion/` — HyperFrames projeleri (her video için `motion/<video-adi>/`).
- `cikti/` — bitmiş videolar ve ara çıktılar.
- `scripts/` — yardımcı betikler.
- `metin/` — videoların temiz Türkçe metinleri (`metin/<ad>.txt`); Almanca çevirinin kaynağı.
- `arastirma/` — hayvan araştırmaları ve doğrulama notları (`arastirma/<hayvan>.md`).
- `yayin/` — yayın metni taslakları (`yayin/<hayvan>.md`); sadece taslak.
- `almanca/` — Almanca versiyonlar: `metin/`, `ses/`, `motion/`, `cikti/` ve `kural-dosyasi-de.md`.

## Standart akış ("ham kaydı kurgula" denince)
1. **Transkript:** `scripts/transkript.sh ham/<dosya>` (dil varsayılanı `tr`) ile kelime zaman damgalı transkript çıkar (Türkçe; ses ve video dosyalarıyla çalışır). Özel isimleri `kural-dosyasi.md` → "Doğru yazılışlar" listesine göre düzelt.
2. **Tekrarlar:** Aynı cümle birden fazla söylendiyse varsayılan olarak **sonuncuyu** tut. Emin değilsen kullanıcıya sor.
3. **Plan:** Sahne sahne bir tablo göster: zaman aralığı | söylenen cümle | ekranda ne olacak (hangi tam ekran tasarım / altyazı / ekran kaydı nasıl kullanılacak / geçiş). Her satırda ekranın tamamını dolduran bir görsel olmalı. **Onay almadan render etme.**
4. **Kesme:** Onaydan sonra sessizlikleri ve elenen denemeleri FFmpeg ile kes:
   - Sadece ses → `cikti/<ad>-kesim.wav`
   - Ekran kaydı + ses → `cikti/<ad>-kesim.mp4` (görüntü ve ses birlikte kesilir)
   Kesilmiş dosyanın transkriptini yeniden çıkar (zamanlar değişir).
   **Ses seviyesi:** `scripts/ses-seviye.sh cikti/<ad>-kesim.wav motion/<ad>/assets/ses.wav` ile kesilmiş sesi -14 LUFS'a (tepe -1 dBTP altı) getir; composition bu dosyayı kullanır.
5. **Motion:** `motion/<ad>/` altında HyperFrames composition yaz. Kurallar:
   - Tek `gsap.timeline({ paused: true })`, `window.__timelines["main"]` ile kaydet.
   - `Math.random`, `Date`, `setTimeout`, sonsuz tekrar yok; her şey deterministik.
   - `.clip` elemanının görünürlüğünü tweenleme, içindeki çocuğu animasyonla.
   - **Ekranın tamamı tasarıma ait.** Her sahne kadrajı baştan sona doldurur; boş/siyah kare, açıklıkta kalan “arka plan videosu” yok.
   - Kesilmiş ses composition'ın ses izi olur; animasyonlar kelime zamanlarına göre senkronlanır.
   - Ekran kaydı varsa tasarımın bir parçası olarak kullanılır (çerçeve, zoom, kırpma, vurgu); kurala göre tam ekran da gösterilebilir.
6. **Kontrol:** `npx hyperframes lint` (ya da `check`) çalıştır, hataları kendin düzelt. Render öncesi birkaç kareyi görsel olarak kontrol et ve sesle senkronu dinle/kontrol et.
7. **Render:** `cikti/<ad>-final.mp4` (ses dahil). Render sonrası seviyeyi ölç (`ffmpeg -i <final> -af ebur128=peak=true -f null -`); -14 LUFS değilse `scripts/ses-seviye.sh` ile düzelt. Kullanıcı isterse motion'ı sessiz ayrı dosya olarak da ver (Premiere/CapCut için).

## Almanca akış ("<ad> Almanca versiyon" denince)
Önce `kural-dosyasi.md`'yi, sonra `almanca/kural-dosyasi-de.md`'yi oku; ikisi birlikte bağlayıcı. Türkçe dosyalara (`ham/`, `motion/<ad>/`, `cikti/`) **dokunma**; her şey `almanca/` altında üretilir.
1. **Çeviri:** Kaynak `metin/<ad>.txt`; yoksa kesilmiş Türkçe transkript `cikti/transkript/<ad>-kesim/<ad>-kesim.txt`. Doğal, akıcı, Shorts diline uygun Almancaya çevir (birebir değil, hitap `du`). Gerçekleri, sayıları ve birimleri değiştirme. → `almanca/metin/<ad>.txt`
2. **Onay:** Çeviriyi kullanıcıya tablo olarak göster: `Almanca | Türkçe geri çeviri` (satır satır; kullanıcının Almancası A2, geri çeviri Almancada ne dendiğini birebir yansıtsın, güzelleştirme). **Onay almadan devam etme.**
3. **Seslendirme:** `scripts/seslendir.sh almanca/metin/<ad>.txt almanca/ses/<ad>.mp3 de`. Sonra `scripts/transkript.sh almanca/ses/<ad>.mp3 de` ile kelime zamanlarını çıkar (→ `almanca/cikti/transkript/<ad>/`); Whisper'ın yazımını `almanca/metin/<ad>.txt`'e göre düzelt (metin esastır, Whisper sadece zaman verir).
4. **Motion:** `motion/<ad>/`'ı `almanca/motion/<ad>/` altına kopyala (`.hyperframes/` render önbelleği hariç). Orada:
   - `lang="de"`; tüm ekran yazılarını ve altyazıları Almancaya çevir (bileşik kelime, sayı biçimi, tırnak kuralları `kural-dosyasi-de.md`'de).
   - Ses: `scripts/ses-seviye.sh almanca/ses/<ad>.mp3 almanca/motion/<ad>/assets/ses.wav`.
   - Tüm animasyon zamanlarını Almanca kelime zamanlarına göre yeniden senkronla; toplam süreyi yeni sese göre ayarla. Türkçe zamanlardan kalan sabit değer bırakma.
   - Kontrol adımı (lint + kare kontrolü) Türkçe akıştaki gibi; özellikle en uzun Almanca kelimelerin geçtiği kareler.
5. **Render:** `almanca/cikti/<ad>-final.mp4` (ses dahil, -14 LUFS) ve `almanca/cikti/<ad>-de.srt` (metin `almanca/metin/<ad>.txt`'ten, zamanlar Almanca kelime zamanlarından; bir altyazıda en fazla 4 kelime).

## Revizyon
- Kullanıcının notlarını tek tek uygula, değişen zamanları söyle.
- Aynı türde bir düzeltme **ikinci kez** istenirse, bunu `kural-dosyasi.md`'ye kural olarak eklemeyi öner.
- Kullanıcı "kurala ekle" derse ilgili bölüme tek satır olarak ekle.

## Sınırlar
- **Hiçbir adım otomatik yayın yapmaz:** YouTube/TikTok/Instagram'a yükleme, `hyperframes publish`, paylaşım linki, e-posta/mesaj yok. Yayın her zaman kullanıcının elle yaptığı adımdır.
- `ham/` dışındaki kişisel klasörlere çıkma; çıkman gerekirse sebebini söyle.
- `referanslar/` içindeki başkalarının videoları sadece tarz analizi içindir; kendi videoya parça olarak koyma.
