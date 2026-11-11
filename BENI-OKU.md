# video-kurgu — başlangıç paketi

## Kurulum (bir kere, ~30 dk)
1. Bu klasörü Masaüstüne koy (adı `video-kurgu` kalsın; boşluk ve Türkçe karakter yok).
2. Claude uygulamasında **Code**'a geç, klasör seçiciden `video-kurgu`'yu seç.
3. Claude'a yaz:
   > `scripts/kurulum-mac.sh` betiğini çalıştır, hata çıkarsa düzelt ve her şeyin çalıştığını kontrol et.

   Homebrew yoksa betik durur ve kurulum komutunu verir; onu Terminal'de kendin çalıştır (şifre yazarken görünmez, normal).

## Tarzını tanımla (bir kere, en önemli adım)
Claude'a yaz:
> `kural-dosyasi.md`'yi benimle doldur. Şu videoların tarzını incele: renkler, font, altyazı boyu ve yeri, animasyon hızı, geçişler. Emin olmadıklarını bana sor.
> [link] — neyini seviyorum
> [link] — neyini seviyorum

Fontunu `referanslar/` içine koy.

## Her video
1. Çekimi `ham/` içine koy.
2. Claude'a yaz:
   > `ham/<dosya>`'yı kurgula: boşlukları kes, sahne sahne planı göster.
3. Planı oku, düzelt, onayla. İlk denemeyi 20–30 saniyelik bir videoyla yap.
4. Telefonda izle, notlarını **tek mesajda** gönder. Net ol: saniye + yer + ne olacak.
   - ✗ "Başı sıkıcı."  ✓ "0:00–0:03 arası çok yavaş, ilk cümleden önce küçük bir kırma yap."
5. Aynı düzeltmeyi ikinci kez istiyorsan: "bunu kural dosyasına ekle."

## Dosyalar
| Dosya | Ne işe yarar |
|---|---|
| `CLAUDE.md` | Claude'un iş akışı: önce plan, onay, sonra render; `ham/`'a dokunmama |
| `kural-dosyasi.md` | Senin tarzın — her videoda okunur, her videoda büyür |
| `scripts/kurulum-mac.sh` | FFmpeg, Node 22+, yt-dlp, Whisper, HyperFrames skill'i |
| `scripts/transkript.sh` | Kelime zaman damgalı transkript; dil `tr` (varsayılan) ya da `de` (`medium`; final için `large-v3`) |
| `scripts/seslendir.sh` | ElevenLabs seslendirme; dil `tr`/`de`, ses ID kural dosyasından |
| `almanca/kural-dosyasi-de.md` | Almancaya özel kurallar + Almanca ses ID |

## Takılırsan
- Hata mesajını olduğu gibi Claude'a yapıştır, "bunu düzelt" de.
- Altyazıda isim yanlışsa `kural-dosyasi.md` → "Doğru yazılışlar"a ekle.
- Whisper yavaşsa: denemelerde `medium`, finalde `large-v3`.
