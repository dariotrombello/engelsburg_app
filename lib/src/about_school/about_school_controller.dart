import 'package:engelsburg_app/src/about_school/about_school_urls.dart';

import '../common/url_launcher_service.dart';

class AboutSchoolController {
  static void openKasselSource() {
    UrlLauncherService.launchUrlString(AboutSchoolUrls.kasselSource);
  }

  static void callPforte() {
    UrlLauncherService.launchUrlString(AboutSchoolUrls.pforteNumber);
  }

  static void callSekretariat() {
    UrlLauncherService.launchUrlString(AboutSchoolUrls.sekretariatNumber);
  }

  static void mailToSekretariat() {
    UrlLauncherService.launchUrlString(AboutSchoolUrls.schoolEmail);
  }
}
