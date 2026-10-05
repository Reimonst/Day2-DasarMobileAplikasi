// HW 2 - Perpustakaan
// Nama: Raka Erlangga
// NIM: 1124160083

// --- 1. ABSTRACTION (Model Data) ---
enum Status { tersedia, dipinjam }

class Buku {
  String id;
  Status status;
  Buku(this.id, this.status);
}

class Anggota {
  String id;
  int jumlahPinjam; // Cukup simpan angka jumlahnya biar gampang
  Anggota(this.id, this.jumlahPinjam);
}

// --- 2. DATA (List) ---
final List<Buku> listBuku = [
  Buku('B01', Status.tersedia),
  Buku('B02', Status.dipinjam), // Sedang dipinjam orang lain
];

final List<Anggota> listAnggota = [
  Anggota('A01', 0), // Belum pinjam sama sekali
  Anggota('A02', 3), // Sudah pinjam 3 (Batas maksimal)
];


// --- 3. DECOMPOSITION (Fungsi-Fungsi) ---

// Fungsi 1: Cari buku pakai perulangan (mudah dijelaskan)
Buku? cariBuku(String id) {
  for (var b in listBuku) {
    if (b.id == id) return b;
  }
  return null;
}

// Fungsi 2: Cari anggota pakai perulangan
Anggota? cariAnggota(String id) {
  for (var a in listAnggota) {
    if (a.id == id) return a;
  }
  return null;
}

// Fungsi 3: Hitung denda (BR-03)
int hitungDenda(int telat) {
  if (telat > 0) return telat * 1000;
  return 0;
}

// Fungsi 4: Proses Pinjam
String pinjam(String idAnggota, String idBuku) {
  var anggota = cariAnggota(idAnggota);
  var buku = cariBuku(idBuku);

  // BR-01: Cek apakah sudah pinjam 3
  if (anggota!.jumlahPinjam >= 3) return 'Gagal: Maksimal pinjam 3 buku'; 
  
  // BR-02: Cek apakah buku sedang dipinjam
  if (buku!.status == Status.dipinjam) return 'Gagal: Buku sedang dipinjam'; 

  // Jika aman, tambahkan jumlah pinjaman & ubah status buku
  anggota.jumlahPinjam++;
  buku.status = Status.dipinjam;
  return 'Sukses: Buku berhasil dipinjam';
}

// Fungsi 5: Proses Kembali
String kembali(String idAnggota, String idBuku, int telat) {
  var anggota = cariAnggota(idAnggota);
  var buku = cariBuku(idBuku);

  // Kurangi jumlah pinjaman & ubah status buku jadi tersedia lagi
  anggota!.jumlahPinjam--;
  buku!.status = Status.tersedia;

  // Cek denda
  int denda = hitungDenda(telat);
  if (denda > 0) return 'Sukses kembali. Kena Denda: Rp$denda';
  
  return 'Sukses kembali tanpa denda';
}


// --- 4. TEST SCENARIO ---
void main() {
  print('--- TEST PERPUSTAKAAN ---');

  // Skenario 1 (Sukses)
  // expected: Sukses: Buku berhasil dipinjam
  print('Test 1: ' + pinjam('A01', 'B01')); 
  
  // Skenario 2 (Gagal BR-02: Buku B02 sedang dipinjam)
  // expected: Gagal: Buku sedang dipinjam
  print('Test 2: ' + pinjam('A01', 'B02')); 
  
  // Skenario 3 (Gagal BR-01: Anggota A02 sudah pinjam 3)
  // expected: Gagal: Maksimal pinjam 3 buku
  print('Test 3: ' + pinjam('A02', 'B01')); 
  
  // Skenario 4 (Sukses kembali tepat waktu / telat 0 hari)
  // expected: Sukses kembali tanpa denda
  print('Test 4: ' + kembali('A01', 'B01', 0)); 
  
  // Skenario 5 (Sukses kembali tapi telat 2 hari -> kena denda BR-03)
  // expected: Sukses kembali. Kena Denda: Rp2000
  print('Test 5: ' + kembali('A01', 'B01', 2)); 
}