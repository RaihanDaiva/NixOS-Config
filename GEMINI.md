# NixOS-Config - Context & Instructions for Gemini

## 1. Ringkasan Proyek
- **Deskripsi:** Repositori konfigurasi dotfiles dan sistem operasi NixOS berbasis Wayland (Sway WM), Waybar, Pywal, dan terminal Alacritty dengan skema warna dinamis serta shell modern.
- **Tech Stack:** 
  - **Sistem Operasi / Paket:** NixOS (Nix Expression Language)
  - **Window Manager / Compositor:** Sway (Wayland tiling compositor)
  - **Status Bar & UI Elements:** Waybar, Wofi
  - **Terminal & Shell:** Alacritty, Bash (ble.sh) / Zsh (Oh My Zsh), Starship prompt
  - **Theming Engine:** Pywal (ekstraksi dan penerapan palet warna dari wallpaper secara dinamis)

## 2. Struktur Repositori
- `configuration.nix`: Konfigurasi utama sistem NixOS (boot, driver NVIDIA/Intel PRIME, Bluetooth, audio, packages, services, dan shell). Terhubung via symlink ke `/etc/nixos/configuration.nix`.
- `hardware-configuration.nix`: Konfigurasi perangkat keras dan partisi filesystem (dihasilkan oleh NixOS).
- `sway/`: Berisi `config` untuk keybinding, layout, gesture touchpad, gaps, border, dan script utilitas seperti `workspace-swipe.sh`. Terhubung via symlink ke `~/.config/sway/`.
- `waybar/`: Berisi konfigurasi modul (`config.jsonc`) dan stylesheet (`style.css`) untuk taskbar Waybar. Terhubung via symlink ke `~/.config/waybar/`.
- `alacritty/`: Konfigurasi emulator terminal (`alacritty.toml`) dengan integrasi warna Pywal. Terhubung via symlink ke `~/.config/alacritty/`.
- `rofi/`: Berisi skrip wallpaper selector (`wallpaper-select.sh`) dan tema grid (`wallpaper-select.rasi`). Terhubung via symlink ke `~/.config/rofi/`.
- `wal/`: Berisi template kustom Pywal (seperti `wal/templates/starship.toml`) yang diproses otomatis ke `~/.cache/wal/`.

## 3. Standar & Konvensi Kode
- **Gaya Penulisan Nix:** 
  - Gunakan format kode Nix yang rapi dan konsisten (indentasi 2 spasi).
  - Kelompokkan opsi konfigurasi berdasarkan fungsinya (hardware, programs, environment, services).
- **Konvensi Konfigurasi Sway & Waybar:**
  - Gunakan variabel (seperti `$mod`, `$left`, `$term`) untuk mempermudah konfigurasi.
  - Untuk styling Waybar, gunakan CSS standar yang mengimpor palet warna Pywal (`@import url(...)`).
  - Pertahankan struktur asli (simbol, spacing, icon) saat melakukan modifikasi palet warna dinamis.
- **Integritas Symlink:**
  - File dalam repositori ini terhubung langsung ke `~/.config/` dan `/etc/nixos/`. Setiap perubahan akan berdampak langsung ke sistem pengguna.

## 4. Alur & Perintah Penting (Commands)
Daftar perintah yang valid dan diizinkan:
- **Validasi Sintaks Nix (Hanya Cek Sintaks / Parse):**
  - `nix-instantiate --parse configuration.nix`
- **Validasi Konfigurasi Sway (Hanya Cek Validitas Sway):**
  - `sway -C -c sway/config`
- **Aturan Eksekusi:**
  - **HANYA** boleh menjalankan perintah untuk validasi Sway dan Nix di atas tanpa izin.
  - **DILARANG** menjalankan perintah lain (seperti `sudo nixos-rebuild switch`, instalasi dependensi/paket, modifikasi sistem, push git, dsb.) tanpa meminta izin dan konfirmasi terlebih dahulu kepada pengguna.

## 5. Batasan & Aturan Khusus (Do's and Don'ts)
- **DO:**
  - Jika sudah paham dan mengerti maksud instruksi pengguna, **langsung berikan jawaban/solusi** yang diminta tanpa menjalankan perintah-perintah yang tidak diperlukan.
  - Utamakan efisiensi dan respons langsung to the point.
  - Pastikan setiap konfigurasi tetap konsisten dan tidak merusak integritas sintaks yang sudah berjalan.
- **DON'T:**
  - **JANGAN** menjalankan banyak sekali command secara berlebihan jika informasi sudah jelas dan dipahami.
  - **JANGAN** merombak struktur layout atau icon jika permintaan hanya berfokus pada penyesuaian warna.
  - **JANGAN** menghapus keybinding atau blok konfigurasi penting secara sembarangan tanpa instruksi eksplisit.
  - **JANGAN** menjalankan perintah berbahaya atau yang membutuhkan akses root (`sudo`) tanpa izin eksplisit dari pengguna.
