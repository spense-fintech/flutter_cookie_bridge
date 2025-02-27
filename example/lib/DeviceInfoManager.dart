import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoManager {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final AndroidId _androidIdPlugin = AndroidId();

  Future<Map<String, String>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      String androidId;
      try {
        androidId = await _androidIdPlugin.getId() ?? 'unknown';
      } catch (e) {
        androidId = 'unknown';
        debugPrint("Error getting android id: $e");
      }
      return {
        "manufacturer": androidInfo.manufacturer,
        "model": androidInfo.model,
        "version": androidInfo.version.sdkInt.toString(),
        "device_uuid": androidId,
        "os_version": androidInfo.version.release,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      return {
        "manufacturer": 'Apple',
        "model": iosInfo.model,
        "version": iosInfo.systemVersion,
        "device_uuid": iosInfo.identifierForVendor ?? 'unknown',
        "os_version": iosInfo.systemVersion,
      };
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
