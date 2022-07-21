import 'package:package_info_plus/package_info_plus.dart';

class AboutService {
  static Future<PackageInfo> getPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    return info;
  }
}
