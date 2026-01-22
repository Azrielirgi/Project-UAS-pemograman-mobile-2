@echo off
cd /d "c:\Users\User\Documents\My Dokumen\Azriel\flutter_application_1"
flutter clean
flutter pub get
echo Menjalankan di Windows Desktop...
flutter run -d windows
pause
