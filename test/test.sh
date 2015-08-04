rm -rf Export/android/bin/deps/*
lime build android -simulator
/opt/AndroidSDK/platform-tools/adb install -r Export/android/bin/bin/Srvtest-debug.apk
