-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 21 Jul 2026 pada 09.22
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_klinik`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_laporan_pasien` ()   BEGIN
    DECLARE selesai INT DEFAULT 0;
    DECLARE v_nama VARCHAR(100);

    DECLARE cur_pasien CURSOR FOR
        SELECT nama FROM pasien;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET selesai = 1;

    OPEN cur_pasien;

    baca_data: LOOP

        FETCH cur_pasien INTO v_nama;

        IF selesai = 1 THEN
            LEAVE baca_data;
        END IF;

        SELECT CONCAT('Nama Pasien : ', v_nama) AS Laporan;

    END LOOP;

    CLOSE cur_pasien;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tambah_kunjungan` (IN `p_id_pasien` INT, IN `p_id_dokter` INT, IN `p_tanggal` DATE, IN `p_keluhan` TEXT)   BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SAVEPOINT sebelum_insert;

    INSERT INTO kunjungan (
        id_pasien,
        id_dokter,
        tanggal,
        keluhan
    )
    VALUES (
        p_id_pasien,
        p_id_dokter,
        p_tanggal,
        p_keluhan
    );

    COMMIT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tambah_pasien` (IN `p_nama` VARCHAR(100), IN `p_alamat` TEXT, IN `p_telp` VARCHAR(20), IN `p_tgl` DATE)   BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Gagal menambahkan data pasien.' AS pesan;
    END;

    START TRANSACTION;

    INSERT INTO pasien
    (nama, alamat, telepon, tanggal_lahir)
    VALUES
    (p_nama, p_alamat, p_telp, p_tgl);

    COMMIT;

END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_hitung_umur` (`p_tanggal_lahir` DATE) RETURNS INT(11) DETERMINISTIC BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_tanggal_lahir, CURDATE());
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_total_resep` (`p_id_kunjungan` INT) RETURNS INT(11) DETERMINISTIC BEGIN

    DECLARE total_harga INT;

    SELECT SUM(jumlah * harga)
    INTO total_harga
    FROM resep
    WHERE id_kunjungan = p_id_kunjungan;

    RETURN IFNULL(total_harga, 0);

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `audit_log`
--

CREATE TABLE `audit_log` (
  `id_log` int(11) NOT NULL,
  `aktivitas` varchar(200) DEFAULT NULL,
  `waktu` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `audit_log`
--

INSERT INTO `audit_log` (`id_log`, `aktivitas`, `waktu`) VALUES
(1, 'Pembayaran baru dengan ID 2', '2026-07-20 12:02:45'),
(2, 'Data pasien Budi Santoso diubah menjadi Budi Santoso', '2026-07-20 12:06:37'),
(3, 'Pembayaran baru dengan ID 3', '2026-07-20 12:12:28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `dokter`
--

CREATE TABLE `dokter` (
  `id_dokter` int(11) NOT NULL,
  `nama_dokter` varchar(100) DEFAULT NULL,
  `spesialis` varchar(100) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `dokter`
--

INSERT INTO `dokter` (`id_dokter`, `nama_dokter`, `spesialis`, `telepon`) VALUES
(1, 'Dr. Andi', 'Umum', '081298765432'),
(2, 'Dr. Siti', 'Anak', '081355566677'),
(3, 'Dr. Ahmad', 'Umum', '081234567891'),
(4, 'Dr. Sinta', 'Anak', '081234567892'),
(5, 'Dr. Rina', 'Gigi', '081234567893');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kunjungan`
--

CREATE TABLE `kunjungan` (
  `id_kunjungan` int(11) NOT NULL,
  `id_pasien` int(11) DEFAULT NULL,
  `id_dokter` int(11) DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `keluhan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kunjungan`
--

INSERT INTO `kunjungan` (`id_kunjungan`, `id_pasien`, `id_dokter`, `tanggal`, `keluhan`) VALUES
(2, 1, 2, '2026-07-20', 'Demam dan Batuk'),
(3, 1, 2, '2026-07-20', 'Sakit Kepala'),
(4, 1, 1, '2025-07-01', 'Demam'),
(5, 2, 2, '2025-07-02', 'Batuk'),
(6, 3, 3, '2025-07-03', 'Sakit Gigi'),
(7, 4, 1, '2025-07-04', 'Pusing');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pasien`
--

CREATE TABLE `pasien` (
  `id_pasien` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pasien`
--

INSERT INTO `pasien` (`id_pasien`, `nama`, `alamat`, `telepon`, `tanggal_lahir`) VALUES
(1, 'Budi Santoso', 'Jl. Mawar No. 10', '081234567890', '2000-05-15'),
(2, 'Rina', 'Jl. Melati', '08123456789', '2001-05-12'),
(3, 'Andi Saputra', 'Bandung', '081111111111', '2000-01-10'),
(4, 'Budi Santoso', 'Jakarta', '081111111112', '1999-02-15'),
(5, 'Citra Lestari', 'Bogor', '081111111113', '2001-03-20'),
(6, 'Dewi Anggraini', 'Bekasi', '081111111114', '1998-04-12'),
(7, 'Eko Prasetyo', 'Depok', '081111111115', '2002-05-18'),
(8, 'Fajar Hidayat', 'Solo', '081111111116', '2000-06-25');

--
-- Trigger `pasien`
--
DELIMITER $$
CREATE TRIGGER `trg_update_pasien` AFTER UPDATE ON `pasien` FOR EACH ROW BEGIN
    INSERT INTO audit_log (aktivitas)
    VALUES (
        CONCAT(
            'Data pasien ',
            OLD.nama,
            ' diubah menjadi ',
            NEW.nama
        )
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id_bayar` int(11) NOT NULL,
  `id_kunjungan` int(11) DEFAULT NULL,
  `tanggal_bayar` date DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pembayaran`
--

INSERT INTO `pembayaran` (`id_bayar`, `id_kunjungan`, `tanggal_bayar`, `total`, `status`) VALUES
(2, 2, '2026-07-20', 100000, 'Lunas'),
(3, 2, '2026-07-20', 150000, 'Lunas');

--
-- Trigger `pembayaran`
--
DELIMITER $$
CREATE TRIGGER `trg_audit_pembayaran` AFTER INSERT ON `pembayaran` FOR EACH ROW BEGIN

INSERT INTO audit_log(aktivitas)

VALUES(CONCAT('Pembayaran baru dengan ID ', NEW.id_bayar));

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `resep`
--

CREATE TABLE `resep` (
  `id_resep` int(11) NOT NULL,
  `id_kunjungan` int(11) DEFAULT NULL,
  `nama_obat` varchar(100) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `harga` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `resep`
--

INSERT INTO `resep` (`id_resep`, `id_kunjungan`, `nama_obat`, `jumlah`, `harga`) VALUES
(1, 2, 'Paracetamol', 10, 5000),
(27, 2, 'Paracetamol', 10, 5000),
(28, 3, 'Amoxicillin', 8, 7000),
(29, 4, 'Ibuprofen', 6, 6000),
(30, 5, 'Vitamin C', 15, 3000),
(31, 6, 'Cetirizine', 10, 2500);

--
-- Trigger `resep`
--
DELIMITER $$
CREATE TRIGGER `trg_validasi_resep` BEFORE INSERT ON `resep` FOR EACH ROW BEGIN
    IF NEW.jumlah <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jumlah obat harus lebih dari 0';
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id_log`);

--
-- Indeks untuk tabel `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`id_dokter`);

--
-- Indeks untuk tabel `kunjungan`
--
ALTER TABLE `kunjungan`
  ADD PRIMARY KEY (`id_kunjungan`),
  ADD KEY `id_pasien` (`id_pasien`),
  ADD KEY `id_dokter` (`id_dokter`),
  ADD KEY `idx_tanggal_kunjungan` (`tanggal`);

--
-- Indeks untuk tabel `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`id_pasien`),
  ADD KEY `idx_nama_pasien` (`nama`);

--
-- Indeks untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id_bayar`),
  ADD KEY `id_kunjungan` (`id_kunjungan`);

--
-- Indeks untuk tabel `resep`
--
ALTER TABLE `resep`
  ADD PRIMARY KEY (`id_resep`),
  ADD KEY `id_kunjungan` (`id_kunjungan`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `dokter`
--
ALTER TABLE `dokter`
  MODIFY `id_dokter` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `kunjungan`
--
ALTER TABLE `kunjungan`
  MODIFY `id_kunjungan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `pasien`
--
ALTER TABLE `pasien`
  MODIFY `id_pasien` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id_bayar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `resep`
--
ALTER TABLE `resep`
  MODIFY `id_resep` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `kunjungan`
--
ALTER TABLE `kunjungan`
  ADD CONSTRAINT `kunjungan_ibfk_1` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`),
  ADD CONSTRAINT `kunjungan_ibfk_2` FOREIGN KEY (`id_dokter`) REFERENCES `dokter` (`id_dokter`);

--
-- Ketidakleluasaan untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`id_kunjungan`) REFERENCES `kunjungan` (`id_kunjungan`);

--
-- Ketidakleluasaan untuk tabel `resep`
--
ALTER TABLE `resep`
  ADD CONSTRAINT `resep_ibfk_1` FOREIGN KEY (`id_kunjungan`) REFERENCES `kunjungan` (`id_kunjungan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
