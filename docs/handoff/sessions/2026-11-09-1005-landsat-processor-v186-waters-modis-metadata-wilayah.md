---
date: 2026-11-09 10:05
source: claude-code
topic: landsat-processor-v186-waters-modis-metadata-wilayah
status: berlanjut
---

## Ringkasan
Versi 186 menambah dua tab Waters pada menu ET MODIS (satu granul dan multi-temporal) dan opsi wilayah studi pada Metadata MODIS. Permintaan pengguna 09:54 11 Nov: analisis berkas MOD021KM nyata, lalu tab Waters.

## Temuan berkas nyata (NetCDF koleksi 7)
- Atribut global yang diasumsikan v181 ada. Titik ikat 5 km 408x271. Variabel majemuk `Level 1B Swath Metadata` memuat `EV Sector Start Time` per scan (TAI93; UTC = TAI93 - 10 s sejak 2017).
- Granul selebar sekitar 2300 km: pusat bujur 109,9 vs Bali 115,2, selisih jam lokal sekitar 0,35 jam dan sudut matahari 49,2 vs 54,6 derajat. Karena itu metadata dibuat sadar wilayah.

## Keputusan
- Metadata: raster wilayah studi opsional; pusat, sudut matahari (titik ikat terdekat), waktu (scan terdekat); tidak mencakup wilayah (>0,15 derajat dari titik ikat) = gagal. Ditolak: memakai pusat granul diam-diam; alasan: galat jam lokal masuk ke G, angin harian, ETr sesaat.
- Waters: rantai menu ET Waters dipakai ulang tanpa mengubah kodenya; penyiapan masukan diekstrak ke `et_modis.prepare_inputs` (dipakai bersama Bandara). Luaran dipisah folder `<ID>_waters` agar tidak menimpa Bandara.
- ETr dari PET MOD16 (rata-rata scene / hari komposit, sinusoidal ke jam granul), ET24 = ETrF x PET per piksel. Angin stasiun dan hv wajib. Ditolak: angin dari citra pada Waters (u200 tak punya pengganti).
- Multi-temporal: komposit PET dipasangkan menurut awal <= tanggal < awal + hari; ganda/hilang = dilewati dan dilaporkan.

## Batas
Belum dijalankan pada LST dan MOD16 nyata; MOD16 bukan ETr alfalfa ASCE; jangkar Waters perlu lahan terbuka dan vegetasi rapat dalam scene; piksel 1 km campuran; konsistensi dengan ET Landsat belum diuji; detik kabisat TAI93 sebelum 2012 perlu verifikasi; urutan pytest nc->hdf->nc dapat segfault (pustaka), urutan alfabet aman.

## Berkas
core/et_modis_waters.py (baru), core/et_modis.py (prepare_inputs), core/et_modis_batch.py (method waters, scan_pet, match_pet), core/modis_meta.py (region), gui/et_modis_waters_page.py (baru), gui/modis_post_hosts.py, gui/modis_meta_page.py; tests baru 3 berkas (15 uji); i18n ex186 (24 kunci, total 3966); README v186.
