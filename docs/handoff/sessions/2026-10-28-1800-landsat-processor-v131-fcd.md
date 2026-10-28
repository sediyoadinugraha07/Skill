---
date: 2026-10-28 18:00
source: claude-code
topic: landsat-processor-v131-fcd
status: berlanjut
---

## Tujuan
Tab FCD (Forest Canopy Density) di Advanced Analysis: tiap masukan (AVI, BI, SI, TI) punya tab sendiri, ada Excel dan hasil tiap langkah sampai FCD.

## Keputusan dan alasannya
- Rumus AVI, BI, SI, FCD akhir diambil dari sumber yang dibaca (ACRS 1997, jurnal UGM, ENNRJ, TROFMIS); VD, SSI, TI hanya garis besar di sumber, jadi PCA terstandar PC1 dan skala 0-100 (potong rerata +- 3 SB lalu min-maks) adalah keputusan implementasi dan dilabeli begitu di UI, Excel, README.
- Reflektan 0-1 dikali 255 agar konstanta 256 rumus asli tetap berlaku; DN ditolak dengan pesan.
- Langkah mandiri per tab ditambah "vdssi" dan "all" memakai satu mesin (core/fcd.run_step) supaya hasil mandiri sama dengan alur lengkap (diuji).
- Sampel_Cek Excel memeriksa tiap langkah dari masukan langkah itu, bukan dari rantai, agar galat tidak menular.

## Yang ditolak atau gagal
- Peringatan awal "SI dan TI berkorelasi negatif tidak sesuai model" dihapus: itu klaim tanpa dasar (negatif wajar: gelap dan dingin = bayangan atau tajuk). Diganti catatan tafsir yang dilabeli bukan ketentuan sumber.
- Tes lama TWI dan tab Advanced Analysis mengandaikan TWI tab terakhir; diperbarui.

## Hasil nyata
- landsat_processor_v131.zip; 623 tes lolos (satu tes TWI diperbaiki setelah suite). Citra Landsat 8 Karangasem 2025-10-03 (B2-B6 reflektan, B10 BT): 860.097 piksel valid, FCD median 54, kelas 20/40/60/80: 6,7/19,5/39,6/34,2/0,006 persen. Selisih rumus Excel terhadap program sekitar 1e-13 (LibreOffice).

## Belum terverifikasi
- Kecocokan dengan FCD Mapper asli; Rikimaru 1996 tidak dibaca. Tidak ada data lapangan untuk validasi.
- TI pada wilayah bergunung tampak didominasi gradien suhu menurut ketinggian (dari peta); belum diuji terhadap DEM.
- GUI belum diuji di Windows asli.

## Langkah berikutnya
1. Pengguna mencoba tab per masukan dan FCD lengkap; memutuskan apakah TI perlu dikoreksi terhadap ketinggian.
2. Validasi FCD dengan data lapangan bila ada.
