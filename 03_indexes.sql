-- ============================================================
-- WAREHOUSE & LOGISTICS MARKETPLACE - DATABASE INDEXES
-- File 3/3: Semua INDEX untuk optimasi performa query
-- Jalankan setelah 01_schema.sql (dan 02_views.sql)
--
-- Catatan: index sudah dirapikan/dedup dari jawaban Soal 2-8.
-- Beberapa index dipakai bersama oleh beberapa soal (lihat komentar).
-- ============================================================

USE warehouse_logistics_db;

-- --- Tabel: pengiriman ---------------------------------------
-- Soal 2 & 7: filter tanggal pada dashboard harian & laporan histori
CREATE INDEX idx_pengiriman_tanggal ON pengiriman (tanggal_pengiriman);

-- Soal 2, 3, 6, 8: filter & GROUP BY status pengiriman
CREATE INDEX idx_pengiriman_status ON pengiriman (status_pengiriman);

-- Soal 2: GROUP BY kota tujuan pada dashboard harian
CREATE INDEX idx_pengiriman_kota_tujuan ON pengiriman (kota_tujuan);

-- Soal 2, 3, 5, 6, 7, 8: JOIN ke tabel kurir
CREATE INDEX idx_pengiriman_kurir ON pengiriman (kurir_id);

-- Soal 5 & 7: composite, mendukung filter per pelanggan + rentang tanggal
-- sekaligus (juga otomatis melayani query yang hanya filter pelanggan_id
-- saja, karena MySQL membaca index dari kolom paling kiri / leftmost-prefix)
CREATE INDEX idx_pengiriman_pelanggan_tanggal ON pengiriman (pelanggan_id, tanggal_pengiriman);

-- --- Tabel: detail_pengiriman ----------------------------------
-- Soal 2 & 8: JOIN ke produk untuk menghitung produk paling sering dikirim
CREATE INDEX idx_detail_pengiriman_produk ON detail_pengiriman (produk_id);

-- Soal 2, 5, 7: JOIN balik ke pengiriman
CREATE INDEX idx_detail_pengiriman_pengiriman ON detail_pengiriman (pengiriman_id);

-- --- Tabel: tracking_pengiriman ---------------------------------
-- Soal 3: composite untuk mencari status "Sampai"/"Gagal" per pengiriman
CREATE INDEX idx_tracking_pengiriman_status ON tracking_pengiriman (pengiriman_id, status_id);

-- Soal 6, 7, 8: covering index untuk subquery MAX(waktu_update) per
-- pengiriman -- index TERPENTING untuk monitoring real-time di skala
-- jutaan baris tracking
CREATE INDEX idx_tracking_pengiriman_waktu ON tracking_pengiriman (pengiriman_id, waktu_update);

-- --- Tabel: stok_gudang -------------------------------------------
-- Soal 4: JOIN ke gudang untuk agregasi total stok per gudang
CREATE INDEX idx_stok_gudang_gudang ON stok_gudang (gudang_id);

-- Soal 4: JOIN ke produk
CREATE INDEX idx_stok_gudang_produk ON stok_gudang (produk_id);

-- Soal 4 & 8: composite, mempercepat COUNT(DISTINCT produk_id) per gudang
CREATE INDEX idx_stok_gudang_komposit ON stok_gudang (gudang_id, produk_id);
