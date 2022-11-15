adb devices
adb shell content insert --uri content://settings/secure --bind name:s:user_setup_complete --bind value:s:1
adb shell am start -n com.google.android.gsf.login/
adb shell am start -n com.google.android.gsf.login.LoginActivity
pause
