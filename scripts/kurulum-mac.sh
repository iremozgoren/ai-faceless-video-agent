#!/usr/bin/env bash
# Video kurgu araçlarını macOS'a kurar: FFmpeg, Node.js (>=22), yt-dlp, Whisper, HyperFrames skill'i.
# Kullanım: bash scripts/kurulum-mac.sh
set -euo pipefail

ok()   { printf "\033[32m✓\033[0m %s\n" "$1"; }
info() { printf "\033[36m→\033[0m %s\n" "$1"; }
fail() { printf "\033[31m✗\033[0m %s\n" "$1"; }

# 1) Homebrew
if ! command -v brew >/dev/null 2>&1; then
  fail "Homebrew yok. Önce şunu Terminal'de çalıştır, sonra bu betiği tekrar çalıştır:"
  echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  exit 1
fi
ok "Homebrew"

# 2) FFmpeg, yt-dlp, pipx
for pkg in ffmpeg yt-dlp pipx; do
  if brew list --formula "$pkg" >/dev/null 2>&1; then ok "$pkg zaten kurulu"
  else info "$pkg kuruluyor"; brew install "$pkg"; fi
done
pipx ensurepath >/dev/null 2>&1 || true
export PATH="$HOME/.local/bin:$PATH"

# 3) Node.js >= 22 (HyperFrames gereksinimi)
need_node=1
if command -v node >/dev/null 2>&1; then
  major=$(node -p 'process.versions.node.split(".")[0]')
  if [ "$major" -ge 22 ]; then need_node=0; ok "Node.js $(node -v)"; fi
fi
if [ "$need_node" -eq 1 ]; then
  info "Node.js 22+ kuruluyor"
  brew install node || brew upgrade node
  ok "Node.js $(node -v)"
fi

# 4) Whisper (kelime zaman damgalı transkript)
if command -v whisper >/dev/null 2>&1; then ok "Whisper zaten kurulu"
else info "Whisper kuruluyor (birkaç dakika sürebilir)"; pipx install openai-whisper; fi

# 5) HyperFrames skill'leri (Claude Code'a doğru composition yazmayı öğretir)
info "HyperFrames skill'leri kuruluyor"
npx -y skills add heygen-com/hyperframes || fail "Skill kurulamadı; Claude'a hata mesajını yapıştır."

# 6) Kontrol
echo
info "Kontrol"
ffmpeg -version | head -1
yt-dlp --version | sed 's/^/yt-dlp /'
node -v | sed 's/^/node /'
command -v whisper >/dev/null && ok "whisper: $(command -v whisper)"
npx -y hyperframes doctor || fail "hyperframes doctor sorun bildirdi; çıktıyı Claude'a yapıştır."
echo
ok "Kurulum bitti. Not: Whisper ilk çalıştığında modelini indirir."
