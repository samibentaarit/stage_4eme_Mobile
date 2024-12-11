import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
const String baseUrl = 'http://192.168.0.4:8080';
const String wsUrl = 'ws://192.168.0.4:40510';

/*String baseUrl = '';

Future<void> setBaseUrl() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    baseUrl = 'http://${androidInfo.host}:8080';
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    baseUrl = 'http://${iosInfo.utsname.nodename}:8080';
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final hostname = await InternetAddress.lookup('localhost');
    baseUrl = 'http://${hostname.first.address}:8080';
  }
}
*/