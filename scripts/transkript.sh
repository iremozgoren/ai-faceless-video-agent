#!/usr/bin/env bash
# Kelime zaman damgalı transkript çıkarır.
# Kullanım: scripts/transkript.sh <ses|video> [dil] [model]
#   dil:   tr (varsayılan) | de
#   model: medium (varsayılan, hız/kalite dengesi). Final için large-v3.
# Eski kullanım da çalışır: scripts/transkript.sh ham/video.mp4 large-v3
# Çıktı: tr → cikti/transkript/<ad>/   de → almanca/cikti/transkript/<ad>/
set -euo pipefail

girdi="${1:?Kullanım: scripts/transkript.sh <dosya> [tr|de] [model]}"
dil="tr"
model="medium"
for arg in "${@:2}"; do
  case "$arg" in
    tr|de) dil="$arg" ;;
    *)     model="$arg" ;;
  esac
done

ad="$(basename "${girdi%.*}")"
case "$dil" in
  tr) hedef="cikti/transkript/$ad" ;;
  de) hedef="almanca/cikti/transkript/$ad" ;;
esac
mkdir -p "$hedef"

# Önce sesi 16 kHz mono WAV'a çevir (Whisper için hızlı ve güvenilir)
ffmpeg -y -loglevel error -i "$girdi" -ac 1 -ar 16000 "$hedef/$ad.wav"

whisper "$hedef/$ad.wav" \
  --language "$dil" \
  --model "$model" \
  --word_timestamps True \
  --output_format all \
  --output_dir "$hedef"

echo "Transkript ($dil): $hedef/$ad.json (kelime zamanları), $hedef/$ad.srt (altyazı)"
