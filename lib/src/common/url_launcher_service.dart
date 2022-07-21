import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static Future<bool> launchUrlString(String url) async {
    final res = await launchUrl(Uri.parse(url));
    return res;
  }
}
