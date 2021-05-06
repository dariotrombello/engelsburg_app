import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/main.dart';
import 'package:engelsburg_app/utils/time_ago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

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
    final Post post,
  }) {
    final renderedContent = HtmlUnescape()
        .convert(post.content.rendered)
        // remove all newlines
        .replaceAll(RegExp(r'[\n]+'), ' ')
        // remove all html tags
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
    final renderedTitle = HtmlUnescape()
        .convert(post.title.rendered)
        .replaceAll(RegExp(r'[\n]+'), ' ')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
    final dateFormat = DateFormat('dd.MM.yyyy, HH:mm', Platform.localeName);
    final featuredMedia = post.embedded.wpFeaturedmedia?.first?.sourceUrl;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 400,
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(4.0),
            onTap: () {
              SharedPrefs.instance.clear();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NewsDetailPage(
                  post: post,
                  dateFormat: dateFormat,
                  featuredMedia: featuredMedia,
                ),
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
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(TimeAgo.format(post.date)),
                      IconButton(
                          tooltip: 'Teilen',
                          icon: Icon(Icons.share),
                          onPressed: () {
                            Share.share(post.link);
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                final post = posts[index];
                return _postCard(
                  post: post,
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
  final Post post;
  final DateFormat dateFormat;
  final String featuredMedia;

  NewsDetailPage({
    @required this.post,
    @required this.dateFormat,
    this.featuredMedia,
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
              post.title.rendered,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          if (post.date != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text(
                dateFormat.format(post.date),
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color),
              ),
            ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HtmlWidget(
              post.content.rendered,
              textStyle: TextStyle(
                  fontSize: 15.0, height: 1.5, fontFamily: 'Roboto Slab'),
              onTapUrl: (url) => url_launcher.launch(url),
            ),
          )
        ],
      ),
    );
  }
}
