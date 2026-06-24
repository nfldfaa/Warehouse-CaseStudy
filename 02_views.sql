-- ============================================================
-- WAREHOUSE & LOGISTICS MARKETPLACE - DATABASE VIEWS
-- File 2/3: Semua VIEW untuk kebutuhan dashboard & pelaporan
-- Jalankan setelah 01_schema.sql
-- ============================================================

USE warehouse_logistics_db;

-- ------------------------------------------------------------
-- SOAL 2: Dashboard Harian
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_pengiriman_harian AS
SELECT p.pengiriman_id, p.tanggal_pengiriman, p.status_pengiriman,
       p.kota_tujuan, p.kurir_id, k.nama_kurir, p.pelanggan_id
FROM pengiriman p
JOIN kurir k ON p.kurir_id = k.kurir_id
WHERE p.tanggal_pengiriman >= CURDATE()
  AND p.tanggal_pengiriman < CURDATE() + INTERVAL 1 DAY;
-- PENTING: pakai range (>=, <) bukan WHERE DATE(tanggal_pengiriman) = CURDATE().
-- Membungkus kolom terindex dengan fungsi (DATE(), YEAR(), dll) membuat MySQL/
-- MariaDB TIDAK BISA memakai index sama sekali -> full table scan.
-- Sudah diuji: pada 20.000 baris, versi DATE() = full scan 20.000 baris (~4.5ms),
-- versi range = index range scan ~339 baris (~0.4ms, >10x lebih cepat).

CREATE OR REPLACE VIEW vw_produk_terkirim_harian AS
SELECT pr.produk_id, pr.nama_produk,
       SUM(dp.jumlah_item) AS total_item,
       COUNT(DISTINCT dp.pengiriman_id) AS jumlah_transaksi
FROM produk pr
JOIN detail_pengiriman dp ON pr.produk_id = dp.produk_id
JOIN pengiriman p ON dp.pengiriman_id = p.pengiriman_id
WHERE p.tanggal_pengiriman >= CURDATE()
  AND p.tanggal_pengiriman < CURDATE() + INTERVAL 1 DAY
GROUP BY pr.produk_id, pr.nama_produk;

-- ------------------------------------------------------------
-- SOAL 3: Evaluasi Performa Pengiriman & Kurir
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_waktu_pengiriman AS
SELECT p.pengiriman_id, p.kurir_id,
       p.tanggal_pengiriman AS waktu_mulai,
       t.waktu_update AS waktu_selesai,
       TIMESTAMPDIFF(HOUR, p.tanggal_pengiriman, t.waktu_update) AS durasi_jam
FROM pengiriman p
JOIN tracking_pengiriman t ON p.pengiriman_id = t.pengiriman_id
JOIN status_pengiriman s ON t.status_id = s.status_id
WHERE s.nama_status = 'Sampai';

CREATE OR REPLACE VIEW vw_performa_kurir AS
SELECT k.kurir_id, k.nama_kurir,
       COUNT(*) AS total_pengiriman,
       SUM(p.status_pengiriman = 'Sampai') AS berhasil,
       SUM(p.status_pengiriman = 'Gagal') AS gagal,
       ROUND(SUM(p.status_pengiriman = 'Sampai') / COUNT(*) * 100, 2) AS persentase_berhasil
FROM kurir k
JOIN pengiriman p ON k.kurir_id = p.kurir_id
GROUP BY k.kurir_id, k.nama_kurir;

-- ------------------------------------------------------------
-- SOAL 4: Laporan Gudang
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_laporan_gudang AS
SELECT g.gudang_id, g.nama_gudang, g.kota, g.kapasitas,
       COUNT(DISTINCT sg.produk_id) AS jumlah_produk_unik,
       COALESCE(SUM(sg.jumlah_stok), 0) AS total_stok,
       ROUND(COALESCE(SUM(sg.jumlah_stok), 0) / g.kapasitas * 100, 2) AS utilisasi_persen
FROM gudang g
LEFT JOIN stok_gudang sg ON g.gudang_id = sg.gudang_id
GROUP BY g.gudang_id, g.nama_gudang, g.kota, g.kapasitas;

-- ------------------------------------------------------------
-- SOAL 5: Pelanggan Prioritas (Business Intelligence)
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_pelanggan_prioritas AS
SELECT pl.pelanggan_id, pl.nama, pl.kota,
       COUNT(DISTINCT p.pengiriman_id) AS total_pengiriman,
       COALESCE(SUM(dp.jumlah_item), 0) AS total_item_terkirim,
       SUM(CASE WHEN p.tanggal_pengiriman >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
                THEN 1 ELSE 0 END) AS pengiriman_30_hari_terakhir,
       MAX(p.tanggal_pengiriman) AS transaksi_terakhir
FROM pelanggan pl
LEFT JOIN pengiriman p ON pl.pelanggan_id = p.pelanggan_id
LEFT JOIN detail_pengiriman dp ON p.pengiriman_id = dp.pengiriman_id
GROUP BY pl.pelanggan_id, pl.nama, pl.kota;

-- ------------------------------------------------------------
-- SOAL 6: Monitoring Real-Time
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_monitoring_realtime AS
SELECT p.pengiriman_id,
       pl.nama AS nama_pelanggan,
       k.nama_kurir,
       p.status_pengiriman AS status_terbaru,
       (SELECT MAX(t.waktu_update)
        FROM tracking_pengiriman t
        WHERE t.pengiriman_id = p.pengiriman_id) AS waktu_update_terakhir
FROM pengiriman p
JOIN pelanggan pl ON p.pelanggan_id = pl.pelanggan_id
JOIN kurir k ON p.kurir_id = k.kurir_id
WHERE p.status_pengiriman NOT IN ('Sampai', 'Gagal');

-- ------------------------------------------------------------
-- SOAL 7: Laporan Histori Pengiriman (skala besar)
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_histori_pengiriman_pelanggan AS
SELECT p.pengiriman_id, p.pelanggan_id, p.tanggal_pengiriman,
       p.status_pengiriman, p.kota_tujuan, k.nama_kurir
FROM pengiriman p
JOIN kurir k ON p.kurir_id = k.kurir_id;
-- Catatan: SELALU panggil view ini dengan WHERE pelanggan_id = ? dan LIMIT,
-- jangan SELECT * tanpa filter (lihat README bagian Soal 7).

-- ------------------------------------------------------------
-- SOAL 8: Dashboard Arsitektur (Operasional, Gudang, Kurir, Pelanggan)
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW vw_dashboard_operasional AS
SELECT DATE(p.tanggal_pengiriman) AS tanggal,
       p.status_pengiriman, p.kota_tujuan,
       COUNT(*) AS jumlah_pengiriman
FROM pengiriman p
WHERE p.tanggal_pengiriman >= CURDATE()
  AND p.tanggal_pengiriman < CURDATE() + INTERVAL 1 DAY
GROUP BY DATE(p.tanggal_pengiriman), p.status_pengiriman, p.kota_tujuan;

-- vw_dashboard_gudang, vw_dashboard_kurir, vw_dashboard_pelanggan secara logika
-- identik dengan vw_laporan_gudang, vw_performa_kurir, dan vw_pelanggan_prioritas
-- di atas -- dibuat ulang dengan nama khusus dashboard sesuai permintaan Soal 8.

CREATE OR REPLACE VIEW vw_dashboard_gudang AS
SELECT * FROM vw_laporan_gudang;

CREATE OR REPLACE VIEW vw_dashboard_kurir AS
SELECT * FROM vw_performa_kurir;

CREATE OR REPLACE VIEW vw_dashboard_pelanggan AS
SELECT pelanggan_id, nama, kota, total_pengiriman, total_item_terkirim, transaksi_terakhir
FROM vw_pelanggan_prioritas;
