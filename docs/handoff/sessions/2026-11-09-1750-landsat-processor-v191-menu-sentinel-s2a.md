---
date: 2026-11-09 17:50
source: claude-code
topic: landsat-processor-v191-menu-sentinel-s2a
status: berlanjut
---

## Ringkasan
v191: menu Sentinel dengan submenu S2A (Sentinel-2 Level-2A). Delapan tab: adegan/metadata, tumpukan reflektansi, masker SCL, 28 indeks dan produk biofisik, ekstraksi air, penajaman 20 ke 10 m, deteksi perubahan (dNBR dan selisih indeks), komposit dan deret waktu.

## Berkas
- core/s2a.py (adegan, offset dari XML, blok 1020 baris, AOI bbox/shapefile, masker SCL+probabilitas, registri indeks, laporan, tumpukan), core/s2a_adv.py (air, penajaman, perubahan, komposit), gui/s2a_page.py, gui/main_window.py (kategori "Sentinel"), tests/s2a_fixture.py, test_s2a.py (17), test_s2a_adv.py (20), test_s2a_gui.py (7), i18n ex191 (140 kunci; total 4117), README v191.
- Seluruh rangkaian 1064 lulus (tanpa test_twi dan test_modis_lst).

## Keputusan dan alasan
- "S2A" dibaca sebagai level L2A, bukan satelit 2A; S2A/S2B/S2C diterima. L1C ditolak (butuh koreksi atmosfer).
- Offset BOA dibaca per band dari MTD_MSIL2A.xml (sampel -1000); tanpa XML diasumsikan -1000 dengan peringatan.
- Blok 1020 baris (kelipatan 6, 3, 2) supaya jendela 10/20/60 m sejajar; AOI dibulatkan ke 60 m.
- Penajaman: regresi + residu bilinear + koreksi piknofilaktik. Uji degradasi 40 ke 20 m dipakai sebagai ukuran akurasi, bukan galat agregasi (itu dipaksa nol). Sampel nyata: B05-B8A membaik 14-18% vs bilinear, B11 6%, B12 1,3%.
- Ditolak/ditunda: Tasseled Cap S2 (koefisien tidak bisa diverifikasi), biofisik jaringan saraf SNAP, koreksi topografi (tunggu DEM), L1C.
- Otsu air pada sampel -0,197: 7996 km2 vs SCL 7932 km2.

## Risiko terbuka
- Koefisien albedo Bonafoni dan Sekertekin 2020 ditulis dari ingatan (jumlah 1,0000): verifikasi ke makalah.
- Perubahan dan komposit baru diuji sintetik (satu adegan nyata saja). 36% daratan sampel tertutup awan.
- Batas dNBR USGS dan tren belum divalidasi lapangan. Tampilan Windows belum dilihat. Pesan core belum semua diterjemahkan.

## Berikutnya
- Unggahan Sentinel berikutnya: L1C, DEM (Copernicus GLO-30, DEMNAS) untuk koreksi topografi, S3 SLSTR L2 LST, S5P.
- Uji komposit dan perubahan pada dua adegan nyata atau lebih; uji W-pairing v189 dan ET Waters v186 pada data nyata.
