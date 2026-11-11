# Almanca videolar — ek kurallar

> **Görsel tarz için ana kaynak `../kural-dosyasi.md`'dir** (format, renkler, font, altyazı ölçüleri, hareket, ses seviyesi, yasaklar). Önce onu oku; buradaki kurallar onun **üstüne eklenir**. Orada değişen bir şey burada da geçerlidir; buraya kopyalama.

## Ses
- ElevenLabs ses ID: `aTTiK3YzK3dXETpuDE2h`
- ElevenLabs ses adı: Ben - Effortless and Casual (erkek, genç, samimi; 2026-11-11'de seçildi)
- ElevenLabs model: `eleven_multilingual_v2`
- Seviye: Türkçe ile aynı (-14 LUFS, `scripts/ses-seviye.sh`).

## Dil ve ton
- Altyazı, başlık ve tüm ekran yazıları Almanca. Türkçe kelime kalmaz (özel isimler hariç).
- Hitap **du** (Shorts/TikTok samimi tonu). `Sie` yok. Çoğul hitapta `ihr` ("Schreibt es in die Kommentare").
- Çeviri birebir değil; doğal, kısa, konuşma dili. Gerçekler, sayılar ve birimler aynen korunur.

## Font ve karakterler
- Font: Inter (ana kural dosyasıyla aynı). `ä ö ü Ä Ö Ü ß ẞ ° „ “ –` dahil hepsi var (kontrol edildi: 2026-11-11).
- Başka font eklenirse bu karakterleri kontrol et; eksik varsa kullanma.
- `ß` asla `ss`'e, umlaut asla `ae/oe/ue`'ye çevrilmez. Büyük harfle yazımda `ß` → `SS` (ör. `GROSS`) ya da `ẞ`; tek videoda tutarlı ol.
- Tırnak: „Almanca tırnak“ (alt-üst), düz `"` değil.

## Uzun kelimeler (bileşik kelimeler)
- Sığmayan kelime için **font küçültülmez**; boyutlar ana kural dosyasındaki gibi kalır.
- Kelime, anlam sınırından (bileşik parçaları arasından) tire ile bölünür: `Krokodils-tränen` (yanlış: `Krokodilst-ränen`); `Salzwasser-krokodil`; `Beiß-kraft`.
- Uygulama: HTML'de `lang="de"`, `hyphens: manual` ve bölünecek yere `&shy;` koy. Otomatik `hyphens: auto` ya da `word-break` kullanma (yanlış yerden böler).
- Bölünmeden sığıyorsa bölme. Bir satırda tek başına kalan hece parçası olmasın.
- Render öncesi en uzun kelimelerin geçtiği kareleri görsel olarak kontrol et.

## Sayı ve birim biçimi
- Ondalık virgül: `1,7 Tonnen`. Binlik nokta: `1.000`.
- Sayı ile birim arasında boşluk, satır sonunda ayrılmasın (`&nbsp;`): `33&nbsp;°C`, `1,7&nbsp;Tonnen`, `30&nbsp;%`.
- Sıralı liste: `1.` `2.` (Almanca sıra sayısı noktalı).
- Seslendirme metninde sayılar yanlış okunursa (ör. "1,7") seslendirme için yazıyla yaz (`eins Komma sieben`); ekranda rakam kalır.

## Doğru yazılışlar
- Claude
- Konstanz
- İrem Özgören

## Revizyonlardan çıkan kurallar
- (Her Almanca videodan sonra buraya ekle.)
