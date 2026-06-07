#!/usr/bin/env bash
set -uo pipefail

ANDROID_SDK="${ANDROID_HOME:-$HOME/Android/Sdk}"
ADB="$ANDROID_SDK/platform-tools/adb"

PKG="io.objectbox.example.sync.kotlin"
USER_ID="${USER_ID:-0}"

if [ ! -x "$ADB" ]; then
  echo "adb not found or not executable at: $ADB"
  echo "Set ANDROID_HOME, or install Android SDK platform-tools."
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 <device-serial> [package.name]"
  echo
  echo "Connected devices:"
  "$ADB" devices
  echo
  echo "Example:"
  echo "  $0 emulator-5554"
  echo "  $0 R5CT123ABC io.objectbox.example.sync.kotlin"
  exit 1
fi

DEVICE_SERIAL="$1"

if [ $# -ge 2 ]; then
  PKG="$2"
fi

ADB_CMD=("$ADB" -s "$DEVICE_SERIAL")

echo "Waiting for device: $DEVICE_SERIAL"
"${ADB_CMD[@]}" wait-for-device

SDK="$("${ADB_CMD[@]}" shell getprop ro.build.version.sdk | tr -d '\r')"

echo "Package: $PKG"
echo "Android SDK: $SDK"
echo

grant_perm() {
  local perm="$1"

  printf "Granting %-55s " "$perm"
  if "${ADB_CMD[@]}" shell pm grant --user "$USER_ID" "$PKG" "$perm" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "SKIPPED"
  fi
}

grant_perm android.permission.ACCESS_COARSE_LOCATION
grant_perm android.permission.ACCESS_FINE_LOCATION

# Android 12+ / API 31+
if [ "$SDK" -ge 31 ]; then
  grant_perm android.permission.BLUETOOTH_ADVERTISE
  grant_perm android.permission.BLUETOOTH_CONNECT
  grant_perm android.permission.BLUETOOTH_SCAN
fi

# Android 13+ / API 33+
if [ "$SDK" -ge 33 ]; then
  grant_perm android.permission.NEARBY_WIFI_DEVICES
fi

echo
echo "Normal/install-time permissions, not usually grantable with pm grant:"
echo "  android.permission.ACCESS_WIFI_STATE"
echo "  android.permission.CHANGE_WIFI_STATE"
echo "  android.permission.BLUETOOTH"
echo "  android.permission.BLUETOOTH_ADMIN"

echo
echo "Relevant granted permissions:"
"${ADB_CMD[@]}" shell dumpsys package "$PKG" | grep -E \
  "ACCESS_WIFI_STATE|CHANGE_WIFI_STATE|BLUETOOTH|ACCESS_COARSE_LOCATION|ACCESS_FINE_LOCATION|NEARBY_WIFI_DEVICES" || true