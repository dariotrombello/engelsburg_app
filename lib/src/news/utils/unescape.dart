import 'package:html_unescape/html_unescape.dart';

class UnescapeHtml {
  static String fromString(String str) {
    return HtmlUnescape()
        .convert(str)
        // remove all newlines
        .replaceAll(RegExp(r'[\n]+'), ' ')
        // remove all html tags
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }
}
