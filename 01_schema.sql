-- ============================================================
-- WAREHOUSE & LOGISTICS MARKETPLACE - DATABASE SCHEMA
-- File 1/3: Struktur tabel, relasi (FK), dan sample data
-- ============================================================

CREATE DATABASE IF NOT EXISTS warehouse_logistics_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE warehouse_logistics_db;

DROP TABLE IF EXISTS tracking_pengiriman;
DROP TABLE IF EXISTS detail_pengiriman;
DROP TABLE IF EXISTS pengiriman;
DROP TABLE IF EXISTS stok_gudang;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS status_pengiriman;
DROP TABLE IF EXISTS kurir;
DROP TABLE IF EXISTS gudang;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS pelanggan;

-- ============================================================
-- 1. TABEL INDUK (tidak punya FK)
-- ============================================================

CREATE TABLE pelanggan (
    pelanggan_id INT PRIMARY KEY AUTO_INCREMENT,
    nama         VARCHAR(100) NOT NULL,
    email        VARCHAR(100) UNIQUE,
    no_hp        VARCHAR(15) UNIQUE,
    alamat       VARCHAR(200) NOT NULL,
    kota         VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE supplier (
    supplier_id   INT PRIMARY KEY AUTO_INCREMENT,
    nama_supplier VARCHAR(100) NOT NULL,
    email         VARCHAR(100) UNIQUE,
    no_hp         VARCHAR(15) UNIQUE,
    alamat        VARCHAR(200) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE gudang (
    gudang_id   INT PRIMARY KEY AUTO_INCREMENT,
    nama_gudang VARCHAR(100) NOT NULL,
    kota        VARCHAR(50) NOT NULL,
    kapasitas   INT NOT NULL CHECK (kapasitas > 0)   -- mencegah divide-by-zero di vw_laporan_gudang
) ENGINE=InnoDB;

CREATE TABLE kurir (
    kurir_id     INT PRIMARY KEY AUTO_INCREMENT,
    nama_kurir   VARCHAR(100) NOT NULL,
    no_hp        VARCHAR(15) UNIQUE,
    status_kurir VARCHAR(20) DEFAULT 'Aktif'
) ENGINE=InnoDB;

CREATE TABLE status_pengiriman (
    status_id   INT PRIMARY KEY AUTO_INCREMENT,
    nama_status VARCHAR(30) UNIQUE
) ENGINE=InnoDB;

-- ============================================================
-- 2. TABEL DENGAN 1 FK
-- ============================================================

CREATE TABLE produk (
    produk_id   INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    nama_produk VARCHAR(150) NOT NULL,
    harga       DECIMAL(12,2) NOT NULL,
    berat       DECIMAL(6,2) NOT NULL,
    satuan      VARCHAR(20) DEFAULT 'Unit',
    CONSTRAINT fk_produk_supplier
        FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 3. TABEL ASOSIASI / TRANSAKSI (2+ FK)
-- ============================================================

CREATE TABLE stok_gudang (
    stok_id        INT PRIMARY KEY AUTO_INCREMENT,
    gudang_id      INT,
    produk_id      INT,
    jumlah_stok    INT NOT NULL,
    tanggal_update DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_stok_gudang_gudang
        FOREIGN KEY (gudang_id) REFERENCES gudang(gudang_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_stok_gudang_produk
        FOREIGN KEY (produk_id) REFERENCES produk(produk_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pengiriman (
    pengiriman_id      INT PRIMARY KEY AUTO_INCREMENT,
    pelanggan_id       INT,
    kurir_id           INT,
    tanggal_pengiriman DATETIME DEFAULT CURRENT_TIMESTAMP,
    alamat_tujuan      VARCHAR(200) NOT NULL,
    kota_tujuan        VARCHAR(50) NOT NULL,
    status_pengiriman  VARCHAR(20) DEFAULT 'Diproses',
    CONSTRAINT fk_pengiriman_pelanggan
        FOREIGN KEY (pelanggan_id) REFERENCES pelanggan(pelanggan_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pengiriman_kurir
        FOREIGN KEY (kurir_id) REFERENCES kurir(kurir_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE detail_pengiriman (
    detail_id     INT PRIMARY KEY AUTO_INCREMENT,
    pengiriman_id INT,
    produk_id     INT,
    jumlah_item   INT NOT NULL,
    CONSTRAINT fk_detail_pengiriman
        FOREIGN KEY (pengiriman_id) REFERENCES pengiriman(pengiriman_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detail_produk
        FOREIGN KEY (produk_id) REFERENCES produk(produk_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tracking_pengiriman (
    tracking_id   INT PRIMARY KEY AUTO_INCREMENT,
    pengiriman_id INT,
    status_id     INT,
    waktu_update  DATETIME DEFAULT CURRENT_TIMESTAMP,
    keterangan    VARCHAR(200),
    CONSTRAINT fk_tracking_pengiriman
        FOREIGN KEY (pengiriman_id) REFERENCES pengiriman(pengiriman_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tracking_status
        FOREIGN KEY (status_id) REFERENCES status_pengiriman(status_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 4. SAMPLE DATA
-- ============================================================

INSERT INTO pelanggan (nama, email, no_hp, alamat, kota) VALUES
('Andi Saputra', 'andi@mail.com', '081200000001', 'Jl. Pahlawan No. 1', 'Semarang'),
('Budi Hartono', 'budi@mail.com', '081200000002', 'Jl. Diponegoro No. 5', 'Jakarta'),
('Citra Lestari', 'citra@mail.com', '081200000003', 'Jl. Merdeka No. 9', 'Surabaya');

INSERT INTO supplier (nama_supplier, email, no_hp, alamat) VALUES
('PT Sumber Makmur', 'sumbermakmur@mail.com', '082100000001', 'Jl. Industri No. 10, Semarang'),
('CV Mitra Jaya', 'mitrajaya@mail.com', '082100000002', 'Jl. Raya No. 22, Surabaya');

INSERT INTO gudang (nama_gudang, kota, kapasitas) VALUES
('Gudang Semarang', 'Semarang', 10000),
('Gudang Jakarta', 'Jakarta', 15000);

INSERT INTO kurir (nama_kurir, no_hp, status_kurir) VALUES
('Joko Setiawan', '083100000001', 'Aktif'),
('Wawan Saputra', '083100000002', 'Aktif');

INSERT INTO status_pengiriman (nama_status) VALUES
('Diproses'), ('Dikirim'), ('Sampai'), ('Gagal');

INSERT INTO produk (supplier_id, nama_produk, harga, berat, satuan) VALUES
(1, 'Beras Premium 5kg', 75000.00, 5.00, 'Karung'),
(1, 'Minyak Goreng 1L', 18000.00, 1.00, 'Botol'),
(2, 'Mie Instan Box', 85000.00, 4.50, 'Box'),
(2, 'Gula Pasir 1kg', 14000.00, 1.00, 'Pack');

INSERT INTO stok_gudang (gudang_id, produk_id, jumlah_stok) VALUES
(1, 1, 500),
(1, 2, 800),
(1, 3, 300),
(2, 2, 600),
(2, 4, 400);

INSERT INTO pengiriman (pelanggan_id, kurir_id, alamat_tujuan, kota_tujuan, status_pengiriman) VALUES
(1, 1, 'Jl. Pahlawan No. 1', 'Semarang', 'Sampai'),
(2, 2, 'Jl. Diponegoro No. 5', 'Jakarta', 'Dikirim'),
(3, 1, 'Jl. Merdeka No. 9', 'Surabaya', 'Diproses');

INSERT INTO detail_pengiriman (pengiriman_id, produk_id, jumlah_item) VALUES
(1, 1, 2),
(1, 2, 3),
(2, 3, 1),
(3, 4, 5);

INSERT INTO tracking_pengiriman (pengiriman_id, status_id, keterangan) VALUES
(1, 1, 'Pesanan diproses di gudang'),
(1, 2, 'Pesanan dikirim ke alamat tujuan'),
(1, 3, 'Pesanan sampai di tujuan'),
(2, 1, 'Pesanan diproses di gudang'),
(2, 2, 'Pesanan dalam pengiriman'),
(3, 1, 'Pesanan baru diproses');
