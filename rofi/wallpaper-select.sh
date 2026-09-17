#!/usr/bin/env bash

# --- KONFIGURASI ---
WALL_DIR="$HOME/Pictures/wallpapers"
CACHE_PATH="$HOME/.cache/current_wallpaper.jpg"
ROFI_THEME="$HOME/.config/rofi/wallpaper-select.rasi"

# 1. Pastikan Rofi terinstall
if ! command -v rofi &>/dev/null; then
  echo "Error: Rofi tidak ditemukan. Pastikan 'rofi-wayland' terpasang."
  exit 1
fi

# 2. Pastikan direktori wallpaper ada
if [ ! -d "$WALL_DIR" ]; then
  notify-send -u critical "Wallpaper Selector" "Direktori $WALL_DIR tidak ditemukan!" 2>/dev/null || echo "Folder $WALL_DIR tidak ditemukan."
  exit 1
fi

# 3. Format input untuk Rofi agar menampilkan preview icon gambar
# Format dmenu Rofi: "NamaFile\0icon\x1f/path/ke/file"
SELECTED_FILE=$(find -L "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) -printf "%f\n" | sort | while read -r file; do
  echo -en "$file\0icon\x1f$WALL_DIR/$file\n"
done | rofi -dmenu -i -p " " -theme "$ROFI_THEME")

# Jika user menekan ESC / membatalkan pilihan
if [ -z "$SELECTED_FILE" ]; then
  exit 0
fi

FULL_PATH="$WALL_DIR/$SELECTED_FILE"

# 4. Buat symlink wallpaper aktif ke cache
mkdir -p "$HOME/.cache"
ln -sf "$FULL_PATH" "$CACHE_PATH"

# 5. Terapkan wallpaper ke Sway WM secara instan
swaymsg "output * bg '$FULL_PATH' fill"

# 6. Update warna Pywal
if command -v wal >/dev/null 2>&1; then
  wal -i "$FULL_PATH" -n -q

  # Reload Sway agar warna border jendela langsung menyesuaikan tema baru
  swaymsg reload
fi

# 7. Reload Cava jika sedang berjalan
if pgrep -x "cava" >/dev/null; then
  pkill -USR1 cava 2>/dev/null || true
fi

# 8. Reload Waybar stylesheet
if pgrep -x "waybar" >/dev/null; then
  pkill -SIGUSR2 waybar 2>/dev/null || true
fi

# 9. Kirim notifikasi desktop
if command -v notify-send >/dev/null 2>&1; then
  notify-send "Wallpaper Changed" "$SELECTED_FILE" -i "$FULL_PATH"
fi
