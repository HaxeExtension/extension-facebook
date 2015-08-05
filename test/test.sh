rm -rf Export/android/bin/*
lime build android -simulator
/opt/AndroidSDK/platform-tools/adb install -r Export/android/bin/bin/Srvtest-debug.apk
