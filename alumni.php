<?php
$koneksi = mysqli_connect('localhost', 'root', '', 'perguruan_tinggi');

// Cek apakah ada data POST
$aksi = isset($_POST["aksi"]) ? $_POST["aksi"] : "";

if ($aksi != "tampil") {
    $nim = $_POST["nim"];
    
    if ($aksi != "hapus") {
        // PERBAIKAN: Nama variabel disamakan dengan yang di SQL
        $nm_alumni  = $_POST["nm_alumni"]; 
        $prodi      = $_POST["prodi"];
        $tmpt_lahir = $_POST["tmpt_lahir"];
        $tgl_lahir  = $_POST["tgl_lahir"];
        $alamat     = $_POST["alamat"];
        $no_hp      = $_POST["no_hp"];
        $thn_lulus  = $_POST["thn_lulus"];
        $foto       = isset($_POST["foto"]) ? $_POST["foto"] : "";
    }
}

switch ($aksi) {
    case "tampil":
        $sql = "SELECT * FROM alumni ORDER BY nm_alumni";
        $result = mysqli_query($koneksi, $sql);
        $data = [];
        while ($row = mysqli_fetch_assoc($result)) $data[] = $row;
        echo json_encode($data);
        break;

    case "simpan":
        // Pastikan urutan kolom sesuai dengan struktur tabel kamu
        $sql = "INSERT INTO alumni (nim, nm_alumni, prodi, tmpt_lahir, tgl_lahir, alamat, no_hp, thn_lulus) 
                VALUES ('$nim', '$nm_alumni', '$prodi', '$tmpt_lahir', '$tgl_lahir', '$alamat', '$no_hp', '$thn_lulus')";
        $result = mysqli_query($koneksi, $sql);
        if($result) {
            if(!empty($foto)) {
                file_put_contents("foto/$nim.jpeg", base64_decode($foto));
            }
            echo "berhasil";
        } else {
            echo "gagal: " . mysqli_error($koneksi);
        }
        break;

    case "ubah":
        $sql = "UPDATE alumni SET 
                nm_alumni = '$nm_alumni', prodi = '$prodi', tmpt_lahir = '$tmpt_lahir', 
                tgl_lahir = '$tgl_lahir', alamat = '$alamat', no_hp = '$no_hp', thn_lulus = '$thn_lulus' 
                WHERE nim = '$nim'";
        $result = mysqli_query($koneksi, $sql);
        
        if($result) {
            // HANYA UPDATE FOTO JIKA ADA DATA BARU
            // Jika $foto kosong, file lama di folder /foto tidak akan diganggu
            if (!empty($foto) && strlen($foto) > 100) { 
                file_put_contents("foto/$nim.jpeg", base64_decode($foto));
            }
            echo "berhasil";
        } else {
            echo "gagal";
        }
        break;

    case "hapus":
        $sql = "DELETE FROM alumni WHERE nim = '$nim'";
        $result = mysqli_query($koneksi, $sql);
        // Hapus file foto jika ada
        if (file_exists("foto/$nim.jpeg")) {
            unlink("foto/$nim.jpeg");
        }
        echo ($result) ? "berhasil" : "gagal";
        break;
}
?>