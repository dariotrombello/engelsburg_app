import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:http/http.dart' as http;

import 'models/wordpress.dart';

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  Future<http.Response> _getNews() {
    final url = Uri.parse(
        'https://engelsburg.smmp.de/wp-json/wp/v2/posts?per_page=30&_embed');
    return http.get(url);
  }

  Widget _postCard({
    final String content,
    final DateTime date,
    final String featuredMedia,
    final String title,
  }) {
    final renderedContent = HtmlUnescape()
        .convert(content)
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
    final renderedTitle =
        HtmlUnescape().convert(title).replaceAll(RegExp(r'<[^>]*>'), '').trim();
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NewsDetailPage(
                content: content,
                date: date,
                featuredMedia: featuredMedia,
                title: renderedTitle),
          ));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featuredMedia != null)
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                child: CachedNetworkImage(
                  imageUrl: featuredMedia,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Text(
                renderedTitle.toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                renderedContent.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: _getNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data.body == null
              ? <Post>[]
              : postsFromJson(snapshot.data.body);
          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final content = posts[index].content.rendered.toString();
                final date = posts[index].date;
                final featuredMedia =
                    posts[index].embedded.wpFeaturedmedia?.first?.sourceUrl;
                final title = posts[index].title.rendered.toString();

                return _postCard(
                  content: content,
                  date: date,
                  featuredMedia: featuredMedia,
                  title: title,
                );
              },
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String content;
  final DateTime date;
  final String featuredMedia;
  final String title;
  NewsDetailPage({
    @required this.content,
    this.date,
    this.featuredMedia,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('News'),
      ),
      body: ListView(
        children: <Widget>[
          if (featuredMedia != null)
            CachedNetworkImage(
              imageUrl: featuredMedia,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          if (date != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text(
                DateFormat('dd.MM.yyyy, HH:mm').format(date),
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color),
              ),
            ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HtmlWidget(
              content,
              textStyle: TextStyle(
                  fontSize: 16.0, height: 1.5, fontFamily: 'Roboto Slab'),
              onTapUrl: (url) => url_launcher.launch(url),
            ),
          )
        ],
      ),
    );
  }
}
