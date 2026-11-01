#!/bin/bash
cd "$(dirname "$0")" || exit 1
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.nvm/current/bin:$PATH"
URL="http://127.0.0.1:4317"
alert() { osascript -e 'display dialog "'"$1"'" buttons {"Tamam"} with title "Pair Arama"' 2>/dev/null || echo "$1"; }
if ! command -v node >/dev/null 2>&1; then
  alert "Node.js bulunamadı. nodejs.org adresinden LTS sürümünü kurup tekrar aç."
  exit 1
fi
if ! curl -fsS -o /dev/null --max-time 2 "$URL"; then
  nohup node server.js >> "$PWD/pair-arama.log" 2>&1 < /dev/null &
  for i in {1..30}; do
    sleep 0.4
    if curl -fsS -o /dev/null --max-time 2 "$URL"; then
      open "$URL"
      exit 0
    fi
  done
  alert "Sunucu başlamadı. Hata için pair-arama.log dosyasını kontrol et."
  exit 1
fi
open "$URL"
