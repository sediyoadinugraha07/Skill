---
date: 2026-11-09 12:30
source: claude-code
topic: landsat-processor-v152-tei-multitemporal
status: berlanjut
---

## Tujuan
Pengolahan multi-temporal di tab TEI: LST dipilih otomatis dari satu folder (hasil tab 2 dan menu LST), satu DEM, deret waktu per tanggal.

## Keputusan dan alasannya
- Sumber LST seragam untuk semua tanggal sebagai bawaan, karena mencampur metode antar tanggal menimbulkan tren palsu; mode per scene tetap ada dengan peringatan.
- Tiap tanggal memakai regresi DEM-ET sendiri (tidak digabung), sesuai arahan pengguna bahwa pemilihan menyesuaikan data masukan, tidak digabung.
- Satuan LST dipaksa Kelvin karena semua sumber katalog Kelvin.
- Normalisasi bawaan multi-temporal: seluruh scene, supaya persen kelas antar tanggal sebanding.
- Tren dilaporkan deskriptif (OLS berumus hidup, Theil-Sen, Kendall) dengan catatan musim dan n kecil.
- Angin per tanggal dan tinggi vegetasi tahunan ditunda ke v153 karena hanya dipakai rantai ET.

## Yang ditolak atau gagal
- ST_B10 USGS mentah sebagai sumber cadangan LST ditolak untuk v152: butuh konversi skala; bisa ditambahkan nanti.
- Uji GUI sempat menggantung karena QMessageBox.critical modal; diperbaiki dengan monkeypatch di uji.

## Hasil nyata
- core/lst_catalog.py, core/tei_multitemporal_report.py, compute_tei_multitemporal di core/tei.py, mode di gui/tei_page.py, 8 uji baru, 47 lulus pada rangkaian terkait.
- Rumus SLOPE Excel cocok dengan Python (selisih sekitar 1e-15) setelah dihitung ulang LibreOffice.
- Belum dijalankan pada data nyata pengguna.

## Belum terverifikasi
- Pola nama berkas keluaran menu LST pada data nyata (kunci scene harus ada di nama).
- Perilaku pada puluhan scene (waktu proses, memori).

## Langkah berikutnya
1. v153: ET Bandara otomatis dari folder Level 2, tabel angin per tanggal (kolom tanggal dan kecepatan), satu tinggi vegetasi untuk setahun, sambung ke TEI.
2. Geostatistik v154, regresi spasial v155.
