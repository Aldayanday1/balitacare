# 🎯 SETUP ALTSTORE - PANDUAN LENGKAP (GRATIS!)

## ✅ Cara Install IPA di iPhone via AltStore (100% GRATIS)

AltStore **MEMBUTUHKAN** IPA yang di-sign dengan Apple Developer Account. Tapi tenang, **Apple Developer Account GRATIS!**

---

## 📋 LANGKAH 1: Buat Apple ID (GRATIS - 5 Menit)

1. **Buka**: https://appleid.apple.com
2. **Klik**: "Create Your Apple ID"
3. **Isi**:
   - Email: `onlymarfa69@gmail.com` (atau email lain)
   - Password: (buat password kuat)
   - Nama, tanggal lahir
4. **Verifikasi** email
5. **SELESAI!** ✅ Apple ID sudah siap (100% GRATIS, tidak perlu bayar apapun)

---

## 📋 LANGKAH 2: Setup Code Signing di Codemagic (10 Menit)

### **A. Login ke Codemagic**

1. Buka: https://codemagic.io
2. Login dengan GitHub account Anda
3. Pilih project: **balitacare**

### **B. Setup iOS Code Signing**

1. **Go to**: Applications → balitacare → **Settings** (⚙️ icon)

2. **Click**: "Code signing identities" tab

3. **Click**: "iOS code signing" section → "**+ Add key**"

4. **Pilih**: "**Automatic**" (Codemagic akan auto-setup!)

5. **Login dengan Apple ID**:
   - Email: Apple ID yang tadi dibuat
   - Password: Password Apple ID
   - **Two-Factor Authentication**: Masukkan kode yang dikirim ke device Anda

6. **Codemagic akan otomatis**:
   - ✅ Buat certificate
   - ✅ Buat provisioning profile
   - ✅ Register bundle ID: `com.aldayanday.balitacare`

7. **Click "Save"**

---

## 📋 LANGKAH 3: Update Bundle ID (PENTING!)

Bundle ID harus **UNIQUE** untuk setiap app. Mari ganti:

### **A. Update di `pubspec.yaml`**

Buka file `pubspec.yaml` dan **TIDAK ADA** yang perlu diubah (sudah OK).

### **B. Update di `ios/Runner/Info.plist`**

1. Buka file: `ios/Runner/Info.plist`
2. Cari baris: `<key>CFBundleIdentifier</key>`
3. Ganti value-nya dari:
   ```xml
   <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
   ```
   **MENJADI**:
   ```xml
   <string>com.aldayanday.balitacare</string>
   ```

### **C. Update di `ios/Runner.xcodeproj/project.pbxproj`**

File ini akan auto-update saat build. **TIDAK PERLU** edit manual.

---

## 📋 LANGKAH 4: Update Codemagic Workflow

1. **Buka file**: `codemagic.yaml`

2. **Uncomment** bagian `ios_signing`:

   **SEBELUM** (commented):
   ```yaml
   # Uncomment setelah setup code signing di Codemagic UI:
   # ios_signing:
   #   distribution_type: development
   #   bundle_identifier: com.aldayanday.balitacare
   ```

   **SESUDAH** (uncommented):
   ```yaml
   # Code signing sudah di-setup!
   ios_signing:
     distribution_type: development
     bundle_identifier: com.aldayanday.balitacare
   ```

3. **Commit & Push**:
   ```bash
   git add codemagic.yaml ios/Runner/Info.plist
   git commit -m "feat: setup Apple Developer code signing for AltStore"
   git push origin main
   ```

---

## 📋 LANGKAH 5: Build IPA di Codemagic

1. **Buka**: Codemagic → balitacare → Builds

2. **Click**: "**Start new build**"

3. **Pilih workflow**: "**iOS Signed (AltStore Ready - Requires Apple Developer)**"

4. **Click**: "Start build"

5. **Tunggu** ~3-5 menit

6. **Expected result**:
   ```
   ✅ Clean project → SUCCESS
   ✅ Generate app icons → SUCCESS
   ✅ Setup code signing → SUCCESS
   ✅ Build signed iOS IPA → SUCCESS
   ✅ Balitacare-signed.ipa generated! 🎉
   ```

7. **Download IPA**:
   - Go to "Artifacts" tab
   - Download: `Balitacare-signed.ipa`

---

## 📋 LANGKAH 6: Install IPA via AltStore

### **A. Setup AltStore di iPhone**

1. **Download AltStore** di Mac/PC:
   - Mac: https://altstore.io
   - Windows: https://altstore.io

2. **Install AltServer** di Mac/PC

3. **Connect iPhone** via USB

4. **Install AltStore** ke iPhone:
   - Open AltServer di Mac/PC
   - Click icon → Install AltStore → Pilih iPhone
   - Login dengan Apple ID yang sama

5. **Trust AltStore** di iPhone:
   - Settings → General → VPN & Device Management
   - Trust Apple ID developer

### **B. Install IPA via AltStore**

1. **Transfer IPA** ke iPhone:
   - Via AirDrop (Mac) atau
   - Via Files app (save ke iCloud/Files) atau
   - Via iTunes File Sharing

2. **Open AltStore** di iPhone

3. **Go to**: "My Apps" tab

4. **Click**: "+" icon (top left)

5. **Select**: `Balitacare-signed.ipa`

6. **AltStore akan**:
   - ✅ Verify IPA
   - ✅ Sign dengan Apple ID Anda
   - ✅ Install app

7. **DONE!** 🎉 App sudah terinstall di iPhone!

---

## ⚠️ PENTING: Renewal Setiap 7 Hari

**Free Apple Developer Account** memiliki limitation:
- ✅ **GRATIS** selamanya
- ⚠️ App hanya valid **7 hari**
- 🔄 Harus **re-sign/refresh** setiap 7 hari

**Cara Refresh** (Mudah!):
1. Open AltStore di iPhone
2. Go to "My Apps"
3. Click "Refresh All"
4. DONE! Valid lagi 7 hari

**Atau** setup **AltStore Auto-Refresh**:
- AltStore bisa auto-refresh saat iPhone connect ke WiFi yang sama dengan Mac/PC yang running AltServer
- No manual action needed!

---

## 🎯 TROUBLESHOOTING

### **Error: "Bundle ID already taken"**

**Solusi**: Ganti bundle ID di `codemagic.yaml` dan `Info.plist`:
```
com.aldayanday.balitacare
```
**MENJADI**:
```
com.NAMA_KAMU.balitacare
```
(Ganti NAMA_KAMU dengan nama unik, contoh: `com.aldi123.balitacare`)

### **Error: "Code signing not configured"**

**Solusi**: 
1. Pastikan sudah setup di Codemagic → Settings → Code signing
2. Uncomment `ios_signing:` di `codemagic.yaml`
3. Push ke GitHub
4. Rebuild

### **Error: "Cannot install - not trusted"**

**Solusi**:
1. Settings → General → VPN & Device Management
2. Tap Apple ID developer
3. Tap "Trust"

---

## 💡 TIPS & TRICKS

### **Auto-Refresh AltStore**
1. Install AltServer di Mac/PC (always running)
2. Connect iPhone ke WiFi yang sama
3. AltStore akan auto-refresh every night!

### **Backup IPA**
Save `Balitacare-signed.ipa` di Google Drive/Dropbox untuk re-install kapanpun.

### **Multiple Devices**
1 Apple ID bisa install di **3 devices** max.

### **TestFlight (Advanced)**
Kalau mau distribusi ke banyak orang (sampai 10,000 testers), gunakan TestFlight (butuh Apple Developer Program $99/tahun).

---

## 🎉 SELESAI!

Sekarang Anda bisa:
- ✅ Build IPA signed di Codemagic (GRATIS!)
- ✅ Install via AltStore di iPhone (GRATIS!)
- ✅ App valid 7 hari, auto-refresh available
- ✅ Distribusi ke teman/keluarga (via AltStore)

**Total Cost**: **$0 (100% GRATIS!)** 🎊

---

## 📞 SUPPORT

Jika ada masalah, screenshot error dan kirim ke:
- Email: onlymarfa69@gmail.com
- GitHub Issues: https://github.com/Aldayanday1/balitacare/issues

**Good luck! 🚀**
