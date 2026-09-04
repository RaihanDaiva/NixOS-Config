#!/usr/bin/env bash

# Ambil nomor workspace yang sedang aktif/fokus
current=$(swaymsg -t get_workspaces | awk '
  /"num":/ { num = $2; sub(/,/, "", num) }
  /"focused": true/ { print num; exit }
')

# Fallback jika tidak terdeteksi angka
if ! [[ "$current" =~ ^[0-9]+$ ]]; then
  current=1
fi

action="$1"

if [ "$action" = "next" ]; then
  target=$((current + 1))
  if [ "$target" -gt 10 ]; then
    target=10
  fi
elif [ "$action" = "prev" ]; then
  target=$((current - 1))
  if [ "$target" -lt 1 ]; then
    target=1
  fi
else
  exit 1
fi

if [ "$target" -ne "$current" ]; then
  swaymsg workspace number "$target"
fi
