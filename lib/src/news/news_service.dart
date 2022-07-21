import 'package:engelsburg_app/src/news/dto/wordpress.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static Future<List<Post>> getPosts() async {
    final url = Uri.parse(
        'https://engelsburg.smmp.de/wp-json/wp/v2/posts?per_page=30&_embed');
    final res = await http.get(url);
    final posts = postsFromJson(res.body);
    return posts;
  }
}
