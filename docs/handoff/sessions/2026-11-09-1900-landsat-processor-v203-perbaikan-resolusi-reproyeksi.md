---
date: 2026-11-09 19:00
source: claude-code
topic: landsat-processor-v203-perbaikan-resolusi-reproyeksi
status: berlanjut
---

# Landsat Processor v203: galat memori reproyeksi hasil LST

Laporan pengguna (2026-11-17 14:36, tab 3): MemoryError 7,87 GiB (1, 46389, 45543) di reproject_raster_file saat menulis LST_Level2_band10.

## Diagnosis
- 46389 x 45543 piksel = satu scene (sekitar 231 x 228 km) pada resolusi hasil sekitar 5 m; dicek dengan calculate_default_transform (res 5 menghasilkan 46200 piksel, otomatis 7700). Kolom resolusi di pengaturan CRS tab 3 kemungkinan terisi sekitar 5. Nilai itu tidak terlihat di log pengguna, jadi ini inferensi dari ukuran, perlu dikonfirmasi pengguna.
- Bukan akibat pilihan sumber W (tanpa ERA5, tanpa skala).

## Dibuat
- check_out_resolution di awal run_lst (di bawah 7,5 m atau 0,00007 derajat ditolak dengan pesan jelas).
- Penolakan di reproject_raster_file bila piksel hasil lebih dari 16 kali citra asal, sebelum alokasi.
- Penulisan per blok 2048 baris (identik dengan sekali jalan, diuji).
- Tes 26 di test_wv_apply.py; suite penuh 1168 lolos, 4 dilewati.

## Keputusan
- Perbaikan di core (berlaku juga untuk tab 2 dan menu lain yang memakai reproject_raster_file); alasan: bug ada di fungsi bersama.
- Kombinasi sumber W "pasangan tab 1 lalu ERA5" belum dibangun (menunggu keputusan pengguna).
