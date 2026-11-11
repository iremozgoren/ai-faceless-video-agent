#!/usr/bin/env bash
# Metni ElevenLabs ile seslendirir (mp3).
# Kullanım: scripts/seslendir.sh <metin.txt> <çıktı.mp3> [dil] [ses_id]
#   dil: tr (varsayılan) | de
#   Ses ID ve model kural dosyasından okunur:
#     tr → kural-dosyasi.md            de → almanca/kural-dosyasi-de.md
#   satır biçimi:  - ElevenLabs ses ID: `<id>`   /   - ElevenLabs model: `<model>`
#   ses_id verilirse kural dosyası yerine o kullanılır (ses denemeleri için).
# API anahtarı: ELEVENLABS_API_KEY ortam değişkeni ya da proje kökündeki .env dosyası.
set -euo pipefail
cd "$(dirname "$0")/.."

metin="${1:?Kullanım: scripts/seslendir.sh <metin.txt> <çıktı.mp3> [tr|de] [ses_id]}"
cikti="${2:?Kullanım: scripts/seslendir.sh <metin.txt> <çıktı.mp3> [tr|de] [ses_id]}"
dil="${3:-tr}"
ses_id="${4:-}"

case "$dil" in
  tr) kural="kural-dosyasi.md" ;;
  de) kural="almanca/kural-dosyasi-de.md" ;;
  *)  echo "Dil tr ya da de olmalı: $dil" >&2; exit 1 ;;
esac

oku() { grep -m1 "ElevenLabs $1:" "$kural" 2>/dev/null | sed -E 's/.*`([^`]+)`.*/\1/' || true; }
[ -z "$ses_id" ] && ses_id="$(oku 'ses ID')"
model="$(oku 'model')"; model="${model:-eleven_multilingual_v2}"
if [ -z "$ses_id" ] || [ "$ses_id" = "BELIRLENMEDI" ]; then
  echo "Ses ID yok: $kural içine '- ElevenLabs ses ID: \`<id>\`' satırı ekle." >&2; exit 1
fi

if [ -z "${ELEVENLABS_API_KEY:-}" ] && [ -f .env ]; then
  ELEVENLABS_API_KEY="$(grep -m1 '^ELEVENLABS_API_KEY=' .env | cut -d= -f2- | tr -d '"'"'"' ')"
fi
: "${ELEVENLABS_API_KEY:?ELEVENLABS_API_KEY yok (ortam değişkeni ya da .env)}"

mkdir -p "$(dirname "$cikti")"
govde="$(python3 -c 'import json,sys; print(json.dumps({"text": open(sys.argv[1], encoding="utf-8").read().strip(), "model_id": sys.argv[2], "language_code": sys.argv[3]}))' "$metin" "$model" "$dil")"

kod="$(curl -sS -o "$cikti" -w '%{http_code}' \
  -X POST "https://api.elevenlabs.io/v1/text-to-speech/$ses_id?output_format=mp3_44100_128" \
  -H "xi-api-key: $ELEVENLABS_API_KEY" -H "Content-Type: application/json" \
  -d "$govde")"
if [ "$kod" != "200" ]; then
  echo "ElevenLabs hata $kod:" >&2; cat "$cikti" >&2; rm -f "$cikti"; exit 1
fi
echo "Tamam ($dil, $ses_id): $cikti"
