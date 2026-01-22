# Catering System - Flutter Application

Sistem pemesan catering dengan Flutter yang komprehensif dengan fitur dinamis, animasi menarik, dan integrasi Firebase serta REST API.

## Fitur Utama

✨ **7+ Halaman Dinamis:**
1. **Home Screen** - Menampilkan menu catering dengan pencarian dan filter kategori
2. **Menu Detail Screen** - Detail lengkap menu, bahan-bahan, dan rating
3. **Cart Screen** - Keranjang belanja dengan kode promo
4. **Checkout Screen** - Formulir pengiriman dan pembayaran
5. **Orders Screen** - Riwayat pesanan dengan tab status
6. **Order Detail Screen** - Detail lengkap pesanan dengan timeline status
7. **Profile Screen** - Profil pengguna dan pengaturan
8. **Favorites Screen** - Menu favorit pengguna
9. **Login/Register Screen** - Autentikasi pengguna

📱 **Halaman Statis:**
- About Screen - Informasi tentang aplikasi

🎨 **Animasi & UI:**
- Flutter Animate untuk transisi smooth
- Material Design 3
- Gradient backgrounds
- Status timeline animation
- Card flip animation
- Loading animation

🔐 **Teknologi:**
- **State Management**: Provider
- **Routing**: Go Router
- **Backend**: Firebase (Auth, Firestore, Storage)
- **API**: Mock API (bisa diganti dengan REST API)
- **Database**: Firestore
- **Payments**: Integrasi metode pembayaran

## Struktur Folder

```
lib/
├── main.dart                 # Entry point & routing
├── models/                   # Data models
│   ├── menu_item.dart
│   ├── cart_item.dart
│   ├── order.dart
│   ├── user_profile.dart
│   └── promo_code.dart
├── services/                 # Business logic
│   ├── mock_api_service.dart
│   └── firebase_service.dart
├── providers/               # State management
│   ├── auth_provider.dart
│   ├── menu_provider.dart
│   ├── cart_provider.dart
│   └── order_provider.dart
├── screens/                 # UI Screens
│   ├── home_screen.dart
│   ├── menu_detail_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── orders_screen.dart
│   ├── order_detail_screen.dart
│   ├── profile_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── favorites_screen.dart
│   ├── order_success_screen.dart
│   └── about_screen.dart
├── widgets/                 # Reusable widgets
│   ├── menu_card.dart
│   ├── bottom_nav_bar.dart
│   └── cart_badge.dart
└── utils/                   # Utilities
    ├── app_constants.dart   # Colors, typography, spacing
    └── helpers.dart         # Date, currency helpers
```

## Setup & Installation

### Prerequisites
- Flutter 3.10.7 atau lebih tinggi
- Dart 3.x
- Android Studio / Xcode / VS Code

### Langkah Instalasi

1. **Clone/Download Project**
```bash
cd flutter_application_1
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Setup Firebase (Optional)**
- Buat project di Firebase Console
- Download google-services.json (Android) dan GoogleService-Info.plist (iOS)
- Tempat kan di folder android/app dan ios/Runner

4. **Run aplikasi**
```bash
flutter run
```

### Build Release

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web (PWA):**
```bash
flutter build web --release
```

## Deployment

### APK Android
- File hasil build: `build/app/outputs/flutter-apk/app-release.apk`
- Bisa di-install langsung ke device Android

### iOS
- File hasil build: `build/ios/iphoneos/Runner.app`
- Deploy via TestFlight atau App Store

### Web/PWA (Netlify)
```bash
# Build web
flutter build web

# Deploy ke Netlify
netlify deploy --prod --dir=build/web
```

## Fitur Animasi

✅ Implemented:
- Fade-in animations untuk images
- Slide-up animations untuk cards dan buttons
- Scale animations untuk success icons
- Stagger animations untuk list items
- Smooth transitions antar screen

## Mock Data

Aplikasi menggunakan Mock API dengan data catering:
- 8 menu items dengan harga bervariasi
- 2 promo codes aktif
- Status tracking pesanan
- User profiles

Data ini bisa diganti dengan REST API atau Firebase Firestore.

## Teknologi Stack

| Bagian | Teknologi |
|--------|-----------|
| UI Framework | Flutter 3.10+ |
| State Management | Provider |
| Routing | Go Router |
| Animasi | Flutter Animate, Lottie |
| Backend | Firebase |
| Database | Firestore |
| Authentication | Firebase Auth |
| Image Caching | Cached Network Image |
| UUID | UUID v4 |
| Format | Intl (internationalization) |

## Panduan Penggunaan

1. **Login/Register** - Buat akun atau login
2. **Browse Menu** - Lihat menu catering yang tersedia
3. **Filter & Search** - Cari atau filter berdasarkan kategori
4. **Add to Cart** - Tambahkan menu ke keranjang
5. **Apply Promo** - Gunakan kode promo jika ada
6. **Checkout** - Isi alamat dan pilih metode pembayaran
7. **Track Order** - Pantau status pesanan secara real-time
8. **View History** - Lihat riwayat pesanan

## Fitur Bonus

- 🎁 Kode promo dengan diskon
- ⭐ Rating & review produk
- 💝 Menu favorit/wishlist
- 📱 Responsive design
- 🔔 Order status tracking
- 💳 Berbagai metode pembayaran
- 🌍 Localization ready (ID)

## Note Penting

### Mock API
Saat ini menggunakan Mock API. Untuk implementasi production:
1. Setup Firebase Project
2. Implementasi Firestore database
3. Setup Firebase Authentication
4. Atau gunakan REST API sendiri

### Customization
Warna, font, dan styling bisa di-customize di `lib/utils/app_constants.dart`

## Troubleshooting

**Build Error:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

**Firebase Issues:**
- Pastikan google-services.json/GoogleService-Info.plist sudah di-setup
- Check Firebase Project settings

## License

MIT License - Gunakan untuk project pribadi atau komersial

## Support & Contact

Untuk pertanyaan atau bug report, silakan hubungi melalui:
- Email: support@cateringsystem.com
- Phone: +62 812 3456 7890

---

**Version**: 1.0.0
**Last Updated**: Januari 2025
