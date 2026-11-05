---
date: 2026-11-05 16:30
source: claude-code
topic: landsat-processor-v146-tei
status: berlanjut
---

## Tujuan
Bangun tab TEI (Advanced Analysis) dari ET, LST, DEM sesuai alur catatan pengolahan pengguna; naskah RSASE dibaca lebih dulu.

## Keputusan dan alasannya
- Alur final (pengguna): cLST = LST + 0,00645 DEM; regresi DEM = a ET + b (DEM sumbu y); DEM_reg dikalikan ET; TEI = sqrt(cLST + ET x DEM_reg) tanpa kuadrat; normalisasi min-max; ambang 0,449 dan 0,832; ET negatif jadi 0.
- Pers. 17 naskah tidak cocok dengan alur itu (tanpa normalisasi, suku regresi tak terdefinisi); pengguna memutuskan alur catatan penelitiannya dipakai, rumus naskah tidak dikoreksi.
- Simulasi pada data pengguna (LC08 3 Okt 2025 Karangasem): arah regresi sebaliknya (ET sumbu y) membuat TEI didominasi cLST dan berkorelasi negatif dengan ET; arah dibalik membuat TEI praktis fungsi ET (varians 100,4% dari suku ET x DEM_reg).
- ET negatif asli berasal dari ET potensial (Rn24 negatif), bukan dari Lambda (sudah dipotong 0 sampai 1).

## Yang ditolak atau gagal
- Mengoreksi rumus naskah ditolak pengguna untuk saat ini.
- Normalisasi persentil tidak dijadikan bawaan; min-max penuh dipakai sesuai pengguna meski kelas tidak kering hampir kosong (0,3%).

## Hasil nyata
- core/tei.py, core/tei_report.py, gui/tei_page.py, tests/test_tei.py (7 lolos), README v146, i18n 22 kunci, landsat_processor_v146.zip. Regresi atmo_lst, libradtran, tvdi, i18n lolos.
- Dijalankan pada data nyata (8,7 detik); Excel dihitung ulang LibreOffice tanpa galat dan Cek_Rumus lolos.

## Belum terverifikasi
- Belum dibandingkan dengan raster TEI asli pengguna; alur dibalik adalah dugaan dari catatan, bukan bukti.
- Ambang 0,449 dan 0,832 belum diuji untuk Bali; belum divalidasi lapangan.
- Beberapa versi ET24 pengguna berbeda isi; versi final belum dipastikan.

## Langkah berikutnya
- Pengguna menjalankan tab TEI dan membandingkan dengan TEI asli; menjalankan tab 3 dengan ERA5 single levels; kirim berkas SST untuk tab uji SST (v147 atau berikutnya).
