# Prompt untuk claude.ai

Tempel ini di akhir percakapan, atau di tengah percakapan panjang setiap kali ada keputusan penting.

---

Tulis entri jurnal serah-terima untuk percakapan ini, supaya sesi Claude Code bisa melanjutkan tanpa saya mengulang. Gunakan persis format di bawah, bahasa Indonesia, ringkas. Jangan mengarang: jika sesuatu tidak pasti, taruh di "Belum terverifikasi". Jangan sertakan rahasia atau data pribadi. Catat alasan keputusan dan opsi yang ditolak.

Keluarkan dua blok kode terpisah:
1. Isi berkas entri dengan format ini (front matter lalu bagian Tujuan, Keputusan dan alasannya, Yang ditolak atau gagal, Hasil nyata, Belum terverifikasi, Langkah berikutnya). Isi `source: claude.ai` dan `date` dengan tanggal dan jam saat ini yang saya sebutkan.
2. Satu baris tabel untuk INDEX.md: `| tanggal | claude.ai | topik | status | sessions/<nama-berkas>.md |`

Usulkan juga nama berkas: `YYYY-MM-DD-HHMM-<slug>.md`.

Tanggal dan jam sekarang: <ISI MANUAL>

---

Setelah mendapat hasilnya: simpan blok 1 ke `docs/handoff/sessions/<nama-berkas>.md`, tambahkan baris blok 2 ke bagian atas tabel di `docs/handoff/INDEX.md`, commit, push.
