import 'dart:io';

import 'package:engelsburg_app/src/about/about_urls.dart';
import 'package:engelsburg_app/src/common/url_launcher_service.dart';

class AboutController {
  static void openReview() {
    UrlLauncherService.launchUrlString(
        Platform.isIOS ? AboutUrls.appStore : AboutUrls.googlePlayStore);
  }

  static void openGithub() {
    UrlLauncherService.launchUrlString(AboutUrls.gitHub);
  }

  static void openHomepage() {
    UrlLauncherService.launchUrlString(AboutUrls.homePage);
  }

  static void openEmailApp() {
    UrlLauncherService.launchUrlString(AboutUrls.mail);
  }
}
