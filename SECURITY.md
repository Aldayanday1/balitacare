## 🔒 Data Security & Privacy Configuration

Demi menjaga keamanan data sensitif, file-file berikut **TIDAK di-push** ke GitHub:

#### 📁 **Database Files**
- `*.db` - File database SQLite lokal
- `*.sqlite`, `*.sqlite3` - Database SQLite variants
- `*.db-shm`, `*.db-wal` - SQLite temporary files

#### 📄 **Export Files**
- `*.xlsx`, `*.xls` - File export Excel (mungkin berisi data personal)
- `exports/`, `downloads/` - Folder export files

#### 🔑 **Configuration Files**
- `.env` - Environment variables dengan data sensitif
- `secrets.dart` - Hardcoded secrets (jika ada)
- `app_config.dart` - Application configuration

#### 🔐 **API Keys & Credentials**
- `google-services.json` - Firebase Android config
- `GoogleService-Info.plist` - Firebase iOS config
- `*.keystore`, `*.jks` - Android signing keys
- `key.properties` - Android build configuration

---

### 🚀 Setup untuk Developer

Jika Anda clone repository ini, ikuti langkah berikut:

#### 1. **Copy Environment Configuration**
```bash
# Copy file .env.example ke .env
cp .env.example .env

# Edit .env dengan configuration Anda sendiri
# (File .env tidak akan ter-commit ke git)
```

#### 2. **Database Local**
Database SQLite akan otomatis dibuat saat pertama kali aplikasi dijalankan di:
- **Android**: `/data/data/com.example.aplikasibalita/databases/balita.db`
- **iOS**: `Library/Application Support/balita.db`

Tidak perlu setup manual, aplikasi akan handle secara otomatis.

#### 3. **Run Aplikasi**
```bash
flutter pub get
flutter run
```

---

### 📝 **Data yang Tersimpan di Database Lokal**

Aplikasi menyimpan data berikut di **database lokal perangkat**:

1. **Data Balita**:
   - NIK (Nomor Induk Kependudukan) ⚠️ SENSITIF
   - Nama lengkap
   - Tanggal lahir
   - Jenis kelamin
   - Nama orang tua
   - Data kelahiran (berat & tinggi badan lahir)

2. **Data Perkembangan**:
   - Tanggal pengukuran
   - Berat badan
   - Tinggi badan
   - Lingkar kepala
   - Lingkar lengan atas
   - Cara ukur (terlentang/berdiri)

⚠️ **PENTING**: Data-data ini bersifat **pribadi dan sensitif**. Pastikan:
- Tidak membagikan database file
- Tidak commit file export yang berisi data real
- Gunakan data dummy untuk testing/demo

---

### 🧪 **Testing dengan Data Dummy**

Untuk testing atau demo, gunakan data dummy:

```dart
// Contoh data dummy untuk testing
final dummyBalita = Balita(
  nik: '1234567890123456', // NIK dummy
  nama: 'Balita Test',
  tanggalLahir: DateTime(2023, 1, 1),
  jenisKelamin: 'Laki-laki',
  namaOrangTua: 'Orang Tua Test',
  beratBadanLahir: 3.2,
  tinggiBadanLahir: 49.0,
);
```

---

### 🔐 **Best Practices**

1. **Jangan** commit file `.env` dengan nilai actual
2. **Selalu** gunakan `.env.example` sebagai template
3. **Hindari** hardcode sensitive data di source code
4. **Gunakan** data dummy untuk screenshot/demo
5. **Backup** database lokal secara berkala
6. **Encrypt** backup jika berisi data real

---

### 📧 **Kontak untuk Security Issues**

Jika menemukan security vulnerability, hubungi:
- Email: onlymarfa69@gmail.com
- Jangan buat public issue di GitHub

---

### 📜 **Compliance**

Aplikasi ini menyimpan data kesehatan yang bersifat pribadi. Pastikan compliance dengan:
- ✅ UU Perlindungan Data Pribadi (PDP)
- ✅ Peraturan Menteri Kesehatan tentang data kesehatan
- ✅ Privacy Policy yang jelas untuk end-users

---

**Made with ❤️ and 🔒 Security in mind**
