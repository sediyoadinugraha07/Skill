---
date: 2026-11-08 11:22
source: claude-code
topic: draf-artikel-fcd-suhi-jurnal-geo
status: berlanjut
---

## Tujuan
Menyusun rancangan artikel FCD dan SUHI untuk Jurnal Geo (Unimed, SINTA), dengan Claude berperan sebagai editor ahli, plus literatur pendukung dari jurnal internasional.

## Keputusan dan alasannya
- Variabel utama dirancang FCD tanpa TI (SSI = SI linear, bawaan v132) karena TI berasal dari kanal termal yang sama dengan LST; varian SSI dari PCA SI+TI hanya untuk sensitivitas. Klaim sirkularitas semula terlalu keras dan dikoreksi setelah dicocokkan dengan catatan v132.
- Klaim "FCD menjelaskan SUHI" diubah menjadi uji tambahan daya jelaskan di atas NDVI dengan kontrol kedap air dan ketinggian, karena FCD belum tervalidasi dan dirancang untuk hutan.
- Ambang selisih ketinggian zona acuan ditandai keputusan desain peneliti, bukan hasil literatur.

## Yang ditolak atau gagal
- Aturan penulisan Geo tidak terbaca: jurnal.unimed.ac.id tidak ter-resolve dari sesi cloud (di luar daftar jaringan). Gaya sitasi, panjang naskah, jumlah rujukan minimum, dan peringkat SINTA tidak diasumsikan.
- Rujukan Murphy 2011, Melaas, studi Antalya dan Johor Bahru tidak dimasukkan: penulis atau jurnal tidak terkonfirmasi di hasil pencarian.

## Hasil nyata
- docs/draf-artikel/draf-fcd-suhi-jurnal-geo.md (penilaian editor, desain analisis, kerangka IMRaD, peta literatur, daftar kebutuhan).
- Sembilan rujukan terkonfirmasi hanya pada tingkat abstrak/bibliografi (Rikimaru dan Miyatake 1997 ACRS, Peng 2012, Imhoff 2010, Xian dan Crane 2006, Clinton dan Gong 2013, Zhou 2014, Zhou 2019, Jung 2021, Cook 2014 lewat dokumentasi USGS).

## Belum terverifikasi
- Teks lengkap semua rujukan belum dibaca; judul lengkap Jung 2021 dan penulis Rikimaru 1997 perlu dicek.
- Klaim bahwa belum ada studi FCD-SUHI di Indonesia (belum disurvei tuntas).
- Aturan dan peringkat SINTA Geo.

## Langkah berikutnya
1. Penulis menentukan wilayah studi, tanggal citra, ada tidaknya data lapangan.
2. Izinkan jurnal.unimed.ac.id atau tempel Author Guidelines.
3. Jalankan analisis di aplikasi (v132 bawaan sudah tanpa TI; konfirmasi di kode bahwa TI memang tidak masuk) dan isi tanda [ISI].
