cd ios
rm -Rf Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData
pod install --repo-update
cd ..