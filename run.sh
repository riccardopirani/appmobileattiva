# Chiudi Xcode prima
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ios/Pods
rm ios/Podfile.lock
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run
