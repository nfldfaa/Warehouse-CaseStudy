-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 29, 2026 at 03:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `marketplace_warehouse`
--

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengiriman`
--

CREATE TABLE `detail_pengiriman` (
  `detail_id` int(11) NOT NULL,
  `pengiriman_id` int(11) NOT NULL,
  `produk_id` int(11) NOT NULL,
  `jumlah_item` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pengiriman`
--

INSERT INTO `detail_pengiriman` (`detail_id`, `pengiriman_id`, `produk_id`, `jumlah_item`) VALUES
(1, 1001, 1, 1),
(2, 1001, 2, 2),
(3, 1002, 5, 1),
(4, 1002, 7, 2),
(5, 1003, 4, 3),
(6, 1003, 6, 2),
(7, 1004, 9, 1),
(8, 1004, 10, 2),
(9, 1005, 12, 1),
(10, 1005, 13, 1),
(11, 1006, 3, 2),
(12, 1006, 8, 1),
(13, 1007, 14, 1),
(14, 1008, 15, 2),
(15, 1009, 11, 1),
(16, 1010, 1, 1),
(17, 1010, 5, 2),
(18, 1010, 13, 1);

-- --------------------------------------------------------

--
-- Table structure for table `gudang`
--

CREATE TABLE `gudang` (
  `gudang_id` int(11) NOT NULL,
  `nama_gudang` varchar(100) NOT NULL,
  `kota` varchar(50) NOT NULL,
  `kapasitas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gudang`
--

INSERT INTO `gudang` (`gudang_id`, `nama_gudang`, `kota`, `kapasitas`) VALUES
(1, 'Gudang Jakarta', 'Jakarta', 10000),
(2, 'Gudang Semarang', 'Semarang', 8000),
(3, 'Gudang Surabaya', 'Surabaya', 9000),
(4, 'Gudang Bandung', 'Bandung', 7000),
(5, 'Gudang Makassar', 'Makassar', 6000);

-- --------------------------------------------------------

--
-- Table structure for table `kurir`
--

CREATE TABLE `kurir` (
  `kurir_id` int(11) NOT NULL,
  `nama_kurir` varchar(100) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `status_kurir` varchar(20) NOT NULL DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kurir`
--

INSERT INTO `kurir` (`kurir_id`, `nama_kurir`, `no_hp`, `status_kurir`) VALUES
(1, 'JNE Express', '83111111111', 'Aktif'),
(2, 'J&T Express', '83111111112', 'Aktif'),
(3, 'SiCepat', '83111111113', 'Aktif'),
(4, 'AnterAja', '83111111114', 'Aktif'),
(5, 'Pos Indonesia', '83111111115', 'Aktif'),
(6, 'Ninja Xpress', '83111111116', 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `pelanggan_id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `alamat` varchar(200) NOT NULL,
  `kota` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`pelanggan_id`, `nama`, `email`, `no_hp`, `alamat`, `kota`) VALUES
(1, 'Budi Santoso', 'budi@email.com', '81111111111', 'Jl. Merdeka No.1', 'Semarang'),
(2, 'Siti Rahma', 'siti@email.com', '81111111112', 'Jl. Melati No.5', 'Jakarta'),
(3, 'Andi Pratama', 'andi@email.com', '81111111113', 'Jl. Mawar No.7', 'Bandung'),
(4, 'Dewi Lestari', 'dewi@email.com', '81111111114', 'Jl. Anggrek No.2', 'Surabaya'),
(5, 'Rudi Hartono', 'rudi@email.com', '81111111115', 'Jl. Kenanga No.8', 'Yogyakarta'),
(6, 'Nina Putri', 'nina@email.com', '81111111116', 'Jl. Sudirman No.12', 'Semarang'),
(7, 'Ahmad Fauzi', 'ahmad@email.com', '81111111117', 'Jl. Ahmad Yani No.3', 'Solo'),
(8, 'Maya Sari', 'maya@email.com', '81111111118', 'Jl. Diponegoro No.4', 'Malang'),
(9, 'Yoga Saputra', 'yoga@email.com', '81111111119', 'Jl. Gajah Mada No.6', 'Medan'),
(10, 'Lina Wati', 'lina@email.com', '81111111120', 'Jl. Kartini No.10', 'Makassar');

-- --------------------------------------------------------

--
-- Table structure for table `pengiriman`
--

CREATE TABLE `pengiriman` (
  `pengiriman_id` int(11) NOT NULL,
  `pelanggan_id` int(11) NOT NULL,
  `kurir_id` int(11) NOT NULL,
  `tanggal_pengiriman` datetime NOT NULL DEFAULT current_timestamp(),
  `alamat_tujuan` varchar(200) NOT NULL,
  `kota_tujuan` varchar(50) NOT NULL,
  `status_pengiriman` varchar(20) NOT NULL DEFAULT 'Diproses'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengiriman`
--

INSERT INTO `pengiriman` (`pengiriman_id`, `pelanggan_id`, `kurir_id`, `tanggal_pengiriman`, `alamat_tujuan`, `kota_tujuan`, `status_pengiriman`) VALUES
(1001, 1, 1, '2025-06-01 08:00:00', 'Semarang', 'Semarang', 'Sampai'),
(1002, 2, 2, '2025-06-02 09:30:00', 'Jakarta', 'Jakarta', 'Dikirim'),
(1003, 3, 3, '2025-06-02 10:00:00', 'Bandung', 'Bandung', 'Diproses'),
(1004, 4, 4, '2025-06-03 08:20:00', 'Surabaya', 'Surabaya', 'Sampai'),
(1005, 5, 5, '2025-06-03 11:00:00', 'Yogyakarta', 'Yogyakarta', 'Gagal'),
(1006, 6, 6, '2025-06-04 13:15:00', 'Semarang', 'Semarang', 'Sampai'),
(1007, 7, 2, '2025-06-04 14:30:00', 'Solo', 'Solo', 'Dikirim'),
(1008, 8, 1, '2025-06-05 09:45:00', 'Malang', 'Malang', 'Sampai'),
(1009, 9, 3, '2025-06-05 10:20:00', 'Medan', 'Medan', 'Diproses'),
(1010, 10, 4, '2025-06-06 08:10:00', 'Makassar', 'Makassar', 'Sampai');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `produk_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `nama_produk` varchar(150) NOT NULL,
  `harga` decimal(12,2) NOT NULL,
  `berat` decimal(6,2) NOT NULL,
  `satuan` varchar(20) NOT NULL DEFAULT 'Unit'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`produk_id`, `supplier_id`, `nama_produk`, `harga`, `berat`, `satuan`) VALUES
(1, 1, 'Laptop ASUS VivoBook', 8500000.00, 1.80, 'Unit'),
(2, 1, 'Mouse Logitech', 250000.00, 0.20, 'Unit'),
(3, 1, 'Keyboard Mechanical', 650000.00, 0.80, 'Unit'),
(4, 2, 'Jaket Hoodie', 300000.00, 0.50, 'Unit'),
(5, 2, 'Sepatu Sneakers', 550000.00, 0.90, 'Unit'),
(6, 2, 'Kaos Polos', 120000.00, 0.30, 'Unit'),
(7, 3, 'Belajar SQL', 120000.00, 0.40, 'Buku'),
(8, 3, 'Basis Data Lanjut', 180000.00, 0.60, 'Buku'),
(9, 4, 'Raket Badminton', 750000.00, 0.70, 'Unit'),
(10, 4, 'Bola Futsal', 350000.00, 0.50, 'Unit'),
(11, 4, 'Sepeda Lipat', 2500000.00, 12.00, 'Unit'),
(12, 5, 'Vacuum Cleaner', 1200000.00, 3.50, 'Unit'),
(13, 5, 'Blender Philips', 650000.00, 2.00, 'Unit'),
(14, 5, 'Rice Cooker', 550000.00, 2.50, 'Unit'),
(15, 5, 'Kipas Angin', 450000.00, 4.00, 'Unit');

-- --------------------------------------------------------

--
-- Table structure for table `status_pengiriman`
--

CREATE TABLE `status_pengiriman` (
  `status_id` int(11) NOT NULL,
  `nama_status` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status_pengiriman`
--

INSERT INTO `status_pengiriman` (`status_id`, `nama_status`) VALUES
(2, 'Dikirim'),
(1, 'Diproses'),
(4, 'Gagal'),
(3, 'Sampai');

-- --------------------------------------------------------

--
-- Table structure for table `stok_gudang`
--

CREATE TABLE `stok_gudang` (
  `stok_id` int(11) NOT NULL,
  `gudang_id` int(11) NOT NULL,
  `produk_id` int(11) NOT NULL,
  `jumlah_stok` int(11) NOT NULL,
  `tanggal_update` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stok_gudang`
--

INSERT INTO `stok_gudang` (`stok_id`, `gudang_id`, `produk_id`, `jumlah_stok`, `tanggal_update`) VALUES
(1, 1, 1, 35, '2025-06-01 00:00:00'),
(2, 1, 2, 80, '2025-06-01 00:00:00'),
(3, 1, 3, 40, '2025-06-01 00:00:00'),
(4, 2, 4, 65, '2025-06-01 00:00:00'),
(5, 2, 5, 55, '2025-06-01 00:00:00'),
(6, 2, 6, 120, '2025-06-01 00:00:00'),
(7, 3, 7, 90, '2025-06-01 00:00:00'),
(8, 3, 8, 60, '2025-06-01 00:00:00'),
(9, 3, 9, 30, '2025-06-01 00:00:00'),
(10, 4, 10, 75, '2025-06-01 00:00:00'),
(11, 4, 11, 20, '2025-06-01 00:00:00'),
(12, 4, 12, 18, '2025-06-01 00:00:00'),
(13, 5, 13, 50, '2025-06-01 00:00:00'),
(14, 5, 14, 45, '2025-06-01 00:00:00'),
(15, 5, 15, 70, '2025-06-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `supplier_id` int(11) NOT NULL,
  `nama_supplier` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `alamat` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `nama_supplier`, `email`, `no_hp`, `alamat`) VALUES
(1, 'PT Elektronik Nusantara', 'supplier1@email.com', '82111111111', 'Jakarta'),
(2, 'PT Fashion Indonesia', 'supplier2@email.com', '82111111112', 'Bandung'),
(3, 'PT Buku Cerdas', 'supplier3@email.com', '82111111113', 'Semarang'),
(4, 'PT Sportindo', 'supplier4@email.com', '82111111114', 'Surabaya'),
(5, 'PT Home Living', 'supplier5@email.com', '82111111115', 'Yogyakarta');

-- --------------------------------------------------------

--
-- Table structure for table `tracking_pengiriman`
--

CREATE TABLE `tracking_pengiriman` (
  `tracking_id` int(11) NOT NULL,
  `pengiriman_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `waktu_update` datetime NOT NULL DEFAULT current_timestamp(),
  `keterangan` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tracking_pengiriman`
--

INSERT INTO `tracking_pengiriman` (`tracking_id`, `pengiriman_id`, `status_id`, `waktu_update`, `keterangan`) VALUES
(1, 1001, 1, '2025-06-01 08:00:00', 'Pesanan diterima'),
(2, 1001, 2, '2025-06-01 10:00:00', 'Dalam perjalanan'),
(3, 1001, 3, '2025-06-02 09:15:00', 'Barang diterima pelanggan'),
(4, 1002, 1, '2025-06-02 09:30:00', 'Pesanan diterima'),
(5, 1002, 2, '2025-06-02 14:10:00', 'Sedang dikirim'),
(6, 1003, 1, '2025-06-02 10:00:00', 'Menunggu diproses'),
(7, 1004, 1, '2025-06-03 08:20:00', 'Pesanan diterima'),
(8, 1004, 2, '2025-06-03 11:00:00', 'Dalam perjalanan'),
(9, 1004, 3, '2025-06-04 15:30:00', 'Barang diterima pelanggan'),
(10, 1005, 1, '2025-06-03 11:00:00', 'Pesanan diterima'),
(11, 1005, 4, '2025-06-04 10:20:00', 'Alamat tidak ditemukan'),
(12, 1006, 1, '2025-06-04 13:15:00', 'Pesanan diterima'),
(13, 1006, 2, '2025-06-04 17:30:00', 'Dalam perjalanan'),
(14, 1006, 3, '2025-06-05 16:10:00', 'Barang diterima pelanggan'),
(15, 1007, 1, '2025-06-04 14:30:00', 'Pesanan diterima'),
(16, 1007, 2, '2025-06-05 08:40:00', 'Dalam perjalanan'),
(17, 1008, 1, '2025-06-05 09:45:00', 'Pesanan diterima'),
(18, 1008, 2, '2025-06-05 12:15:00', 'Dalam perjalanan'),
(19, 1008, 3, '2025-06-06 11:20:00', 'Barang diterima pelanggan'),
(20, 1009, 1, '2025-06-05 10:20:00', 'Menunggu diproses'),
(21, 1010, 1, '2025-06-06 08:10:00', 'Pesanan diterima'),
(22, 1010, 2, '2025-06-06 13:00:00', 'Dalam perjalanan'),
(23, 1010, 3, '2025-06-07 09:30:00', 'Barang diterima pelanggan');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_pengiriman`
--
ALTER TABLE `detail_pengiriman`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `fk_detail_pengiriman` (`pengiriman_id`),
  ADD KEY `fk_detail_produk` (`produk_id`);

--
-- Indexes for table `gudang`
--
ALTER TABLE `gudang`
  ADD PRIMARY KEY (`gudang_id`);

--
-- Indexes for table `kurir`
--
ALTER TABLE `kurir`
  ADD PRIMARY KEY (`kurir_id`),
  ADD UNIQUE KEY `uq_kurir_no_hp` (`no_hp`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`pelanggan_id`),
  ADD UNIQUE KEY `uq_pelanggan_email` (`email`),
  ADD UNIQUE KEY `uq_pelanggan_no_hp` (`no_hp`);

--
-- Indexes for table `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD PRIMARY KEY (`pengiriman_id`),
  ADD KEY `fk_pengiriman_pelanggan` (`pelanggan_id`),
  ADD KEY `fk_pengiriman_kurir` (`kurir_id`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`produk_id`),
  ADD KEY `fk_produk_supplier` (`supplier_id`);

--
-- Indexes for table `status_pengiriman`
--
ALTER TABLE `status_pengiriman`
  ADD PRIMARY KEY (`status_id`),
  ADD UNIQUE KEY `uq_nama_status` (`nama_status`);

--
-- Indexes for table `stok_gudang`
--
ALTER TABLE `stok_gudang`
  ADD PRIMARY KEY (`stok_id`),
  ADD KEY `fk_stok_gudang` (`gudang_id`),
  ADD KEY `fk_stok_produk` (`produk_id`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`),
  ADD UNIQUE KEY `uq_supplier_email` (`email`),
  ADD UNIQUE KEY `uq_supplier_no_hp` (`no_hp`);

--
-- Indexes for table `tracking_pengiriman`
--
ALTER TABLE `tracking_pengiriman`
  ADD PRIMARY KEY (`tracking_id`),
  ADD KEY `fk_tracking_pengiriman` (`pengiriman_id`),
  ADD KEY `fk_tracking_status` (`status_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_pengiriman`
--
ALTER TABLE `detail_pengiriman`
  MODIFY `detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `gudang`
--
ALTER TABLE `gudang`
  MODIFY `gudang_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kurir`
--
ALTER TABLE `kurir`
  MODIFY `kurir_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `pelanggan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `produk_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `status_pengiriman`
--
ALTER TABLE `status_pengiriman`
  MODIFY `status_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `stok_gudang`
--
ALTER TABLE `stok_gudang`
  MODIFY `stok_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tracking_pengiriman`
--
ALTER TABLE `tracking_pengiriman`
  MODIFY `tracking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pengiriman`
--
ALTER TABLE `detail_pengiriman`
  ADD CONSTRAINT `fk_detail_pengiriman` FOREIGN KEY (`pengiriman_id`) REFERENCES `pengiriman` (`pengiriman_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`) ON UPDATE CASCADE;

--
-- Constraints for table `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD CONSTRAINT `fk_pengiriman_kurir` FOREIGN KEY (`kurir_id`) REFERENCES `kurir` (`kurir_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pengiriman_pelanggan` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`pelanggan_id`) ON UPDATE CASCADE;

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `fk_produk_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`) ON UPDATE CASCADE;

--
-- Constraints for table `stok_gudang`
--
ALTER TABLE `stok_gudang`
  ADD CONSTRAINT `fk_stok_gudang` FOREIGN KEY (`gudang_id`) REFERENCES `gudang` (`gudang_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stok_produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`) ON UPDATE CASCADE;

--
-- Constraints for table `tracking_pengiriman`
--
ALTER TABLE `tracking_pengiriman`
  ADD CONSTRAINT `fk_tracking_pengiriman` FOREIGN KEY (`pengiriman_id`) REFERENCES `pengiriman` (`pengiriman_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tracking_status` FOREIGN KEY (`status_id`) REFERENCES `status_pengiriman` (`status_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
