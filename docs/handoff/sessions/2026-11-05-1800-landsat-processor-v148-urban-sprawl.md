---
date: 2026-11-05 18:00
source: claude-code
topic: landsat-processor-v148-urban-sprawl
status: berlanjut
---

## Tujuan
Membangun tab Urban Sprawl di Advanced Analysis setelah diskusi literatur: lahan terbangun multi-indeks, uji kesesuaian GHSL, entropi dan pola, penduduk dari Excel dengan grid dasimetrik, serta PGR, LCR, LCRPGR.

## Keputusan dan alasannya
- Beberapa indeks (NDBI, IDBI, BUI, UI) digabung dengan pemungutan suara; peringatan dicatat bahwa indeks berbasis band sama saling berkorelasi, jadi hasil harus diuji akurasi.
- GHSL dipakai sebagai pembanding pada grid GHSL (permintaan pengguna: dianggap akurat). Dicatat di Excel dan README bahwa GHSL punya galat sendiri dan memakai data sensus.
- Penduduk: tabel Excel atau CSV dan shapefile dengan kode sama (asumsi pengguna: batas desa tidak berubah). Dasimetrik sederhana: penduduk unit dibagi rata ke piksel terbangun unit. RF gaya WorldPop ditolak sementara karena data latih satu kabupaten sedikit (dugaan).
- LCR, PGR, LCRPGR memakai rumus metadata UN-Habitat SDG 11.3.1 (terbaca langsung). LAC (selisih luas / selisih penduduk) diberi label perlu verifikasi.
- WUP TIDAK dibangun atas permintaan pengguna; rumus asli belum terbaca. Rujukan untuk dicari pengguna: Jaeger dkk. 2010 "Urban permeation of landscapes and sprawl per capita: New measures of urban sprawl" (Ecological Indicators 10) dan Jaeger dan Schwick 2014 "Improving the measurement of urban sprawl: Weighted Urban Proliferation (WUP) and its application to Switzerland" (Ecological Indicators 38). Judul terverifikasi lewat pencarian; halaman terbitan perlu dicek pengguna.
- Dispersi relatif dibuat sendiri (jarak rata-rata lawan cakram berluas sama), bukan DIS dari WUP; ditulis begitu di Excel.

## Hasil nyata
- core/sprawl.py, core/sprawl_report.py, gui/sprawl_page.py, tests/test_sprawl.py (18 uji lolos, dunia sintetis), README v148, i18n 3457 kunci, landsat_processor_v148.zip.
- Excel berumus hidup (LCR_PGR) diverifikasi hitung ulang LibreOffice: 0 galat sel, Cek_Rumus LOLOS.
- Uji lama test_tasseled_cap diperbaiki (urutan tab sudah usang sejak v146).

## Belum terverifikasi
- Belum diuji pada citra nyata. Risiko di Bali: tanah terbuka dan tambang tertukar dengan terbangun, tajuk di atas permukiman, piksel campuran.
- Nilai bawaan asumsi: batas NDVI 0,3, Otsu per tahun, ambang LI 0,5, ambang fraksi GHSL 0,1/0,25/0,5.
- Rumus LAC dan rujukan klasifikasi infill/edge/leapfrog perlu verifikasi.

## Langkah berikutnya
- Pengguna menjalankan pada Sarbagita atau Karangasem dengan Landsat L2, GHSL, batas desa, dan tabel penduduk, lalu uji titik acuan tambahan.
- WUP setelah artikel Jaeger dan Schwick terbaca dan data pekerjaan terkonfirmasi.
- Masih menunggu: SST, ERA5 single levels, Tes uvspec, perbandingan TEI dengan raster asli.
