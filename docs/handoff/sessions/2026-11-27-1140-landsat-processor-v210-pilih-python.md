---
date: 2026-11-27 11:40
source: claude-code
topic: landsat-processor-v210-pilih-python
status: berlanjut
---

## Tujuan
Aplikasi gagal dibuka lewat dobel-klik main.py (ModuleNotFoundError: PySide6) padahal berjalan bila dipanggil dengan jalur Python 3.11 yang tepat.

## Keputusan dan alasannya
- Penyebab: dobel-klik memakai Python yang terkait dengan .py (berbeda dari Python 3.11 tempat pustaka terpasang, kemungkinan setelah Python 3.12 dipasang). Bukan galat kode aplikasi.
- main.py (hanya pustaka standar) memeriksa PySide6, numpy, rasterio dengan find_spec, mencari Python lain yang lengkap (python_path.txt, LP_PYTHON, py -0p, lokasi umum, PATH), lalu menjalankan ulang dengan LP_RELAUNCHED=1. Tidak aktif pada .exe PyInstaller.
- Jendela galat dan error_log.txt kini memuat sys.executable, modul hilang, kandidat yang dicoba, dan perintah pip yang tepat.
- python_path.txt berisi jalur Python 3.11 pengguna; jalankan.bat memakainya.

## Yang ditolak atau gagal
- Menanam jalur pengguna langsung di kode ditolak: spesifik mesin; dipakai berkas python_path.txt yang bisa diubah.
- Memasang paket otomatis dari main.py ditolak: mengubah lingkungan tanpa sepengetahuan pengguna.

## Hasil nyata
- landsat_processor_v210.zip; tests/test_main_bootstrap.py 7 lulus; main.py diuji menjalankan jendela galat baru di Linux.

## Belum terverifikasi
- Tidak diuji di Windows pengguna (dobel-klik, py -0p, relaunch pythonw). Kontainer baru tanpa rasterio/PySide6, jadi seluruh suite (1187 uji v209) belum dijalankan ulang untuk v210.

## Langkah berikutnya
1. Pengguna mencoba dobel-klik main.py dengan v210 dan melaporkan hasil.
2. Jalankan suite penuh bila lingkungan sudah lengkap.
