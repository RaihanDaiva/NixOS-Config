#!/bin/bash

# Konfigurasi karakter bar (tambahkan s/^ *$// agar saat hening/semua spasi, output jadi kosong)
dict="s/;//g;s/0/ /g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;s/^ *$//;"

# Buat config sementara otomatis
config_file="/tmp/waybar_cava_config"
echo "
[general]
bars = 12
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
" >$config_file

# Jalankan cava -> bersihkan output -> jalankan sed (unbuffered)
cava -p $config_file | sed -u "$dict"
