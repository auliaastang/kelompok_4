# kelompok_4
NAMA: IKRIMANSA
      AULIA
      NADYA PRATIWI RISWANTO
      ZADLY BAAN
MATA KULIAH: PEMBROGRAMAN BASIS DATA
DOSEN PENGAMPUH MATA KULIA: ABDUL MALIK,S.COM.,M.CS
# Sistem Informasi Klinik

Sistem Informasi Klinik merupakan aplikasi berbasis database yang dirancang untuk membantu pengelolaan data operasional klinik secara terstruktur. Sistem ini mendukung proses administrasi pasien mulai dari pendaftaran, kunjungan, pencatatan resep, hingga pembayaran sehingga seluruh data tersimpan dengan aman dan mudah dikelola.

# Fitur Utama
Manajemen data pasien
Manajemen data dokter
Pencatatan kunjungan pasien
Pengelolaan resep obat
Pencatatan pembayaran
Perhitungan total biaya resep menggunakan Function
Otomatisasi proses menggunakan Trigger
Prosedur tersimpan (Stored Procedure) untuk mempermudah pengolahan data
Audit Log untuk mencatat aktivitas penting pada database
Transaction Control (COMMIT, ROLLBACK, SAVEPOINT)
Exception Handling untuk validasi data
Indexing untuk meningkatkan performa pencarian data
🛠️ Teknologi yang Digunakan
MySQL / MariaDB
SQL (DDL, DML, DCL, TCL)
Stored Procedure
Function
Trigger
Cursor
# Struktur Database

Database terdiri dari beberapa tabel utama:

Tabel	Keterangan
pasien	Menyimpan data pasien
dokter	Menyimpan data dokter
kunjungan	Data kunjungan pasien
resep	Data obat yang diberikan
pembayaran	Data pembayaran pasien
audit_log	Menyimpan riwayat aktivitas database
# Fitur Database
Stored Procedure
Menambahkan data kunjungan
Memproses pembayaran
Menampilkan laporan data
Function
Menghitung total biaya resep
Menghitung jumlah kunjungan pasien
Trigger
Validasi jumlah obat
Audit log saat INSERT
Audit log saat UPDATE/DELETE
Transaction Control
COMMIT
ROLLBACK
SAVEPOINT
Exception Handling
Validasi data kosong
Validasi jumlah obat tidak boleh kurang dari 1
# Cara Menjalankan Project
Clone repository
git clone https://github.com/auliaastang/kelompok_4.git
Masuk ke folder project
cd kelompok_4
Import file database (.sql) menggunakan phpMyAdmin atau MySQL Workbench.
Jalankan seluruh script SQL sesuai urutan:
CREATE DATABASE
CREATE TABLE
INSERT DATA
FUNCTION
PROCEDURE
TRIGGER
INDEX
AUDIT LOG
Setelah seluruh script berhasil dijalankan, database siap digunakan.
# Struktur Relasi
Satu pasien dapat memiliki banyak kunjungan.
Satu dokter dapat melayani banyak kunjungan.
Setiap kunjungan dapat memiliki beberapa resep.
Setiap kunjungan memiliki satu data pembayaran.
# Repository

Repository GitHub:

https://github.com/auliaastang/kelompok_4

# Tim Pengembang

Kelompok 4

 IKRIMANSA
      AULIA
      NADYA PRATIWI RISWANTO
      ZADLY BAAN

#Tujuan Project

Project ini dibuat sebagai tugas mata kuliah Basis Data dengan tujuan mengimplementasikan berbagai konsep database, antara lain:

Perancangan database relasional
Primary Key & Foreign Key
Stored Procedure
Function
Trigger
Cursor
Exception Handling
Transaction Control
Indexing
Audit Logging
