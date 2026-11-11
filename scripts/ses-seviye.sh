#!/usr/bin/env bash
# Sesi Reels/Shorts seviyesine getirir: -14 LUFS, tepe -1 dBTP altında (iki geçişli loudnorm).
# Kullanım: scripts/ses-seviye.sh <girdi.wav|girdi.mp4> <çıktı>
#   - .wav  → normalize edilmiş wav
#   - .mp4  → görüntü olduğu gibi kopyalanır, sadece ses normalize edilir (AAC 192k)
set -euo pipefail

girdi="${1:?Kullanım: scripts/ses-seviye.sh <girdi> <çıktı>}"
cikti="${2:?Kullanım: scripts/ses-seviye.sh <girdi> <çıktı>}"
hedef="I=-14:TP=-1.5:LRA=11"  # AAC kodlaması tepeyi biraz yükseltir; -1.5 hedefle sonuç -1 altında kalır

olcum="$(ffmpeg -hide_banner -nostats -i "$girdi" -af "loudnorm=${hedef}:print_format=json" -f null - 2>&1 | sed -n '/^{/,/^}/p')"
deger() { echo "$olcum" | python3 -c "import json,sys; print(json.load(sys.stdin)['$1'])"; }
filtre="loudnorm=${hedef}:measured_I=$(deger input_i):measured_TP=$(deger input_tp):measured_LRA=$(deger input_lra):measured_thresh=$(deger input_thresh):offset=$(deger target_offset):linear=true"

case "$girdi" in
  *.mp4|*.mov) ffmpeg -y -loglevel error -i "$girdi" -map 0:v -map 0:a -c:v copy -af "$filtre" -ar 48000 -c:a aac -b:a 192k -movflags +faststart "$cikti" ;;
  *)           ffmpeg -y -loglevel error -i "$girdi" -af "$filtre" -ar 48000 "$cikti" ;;
esac
echo "Tamam: $cikti"
