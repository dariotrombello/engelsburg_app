import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

import 'dart:async';

import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'main.dart';

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin<NewsPage> {
  static wp.WordPress _wordPress =
      wp.WordPress(baseUrl: 'https://engelsburg.smmp.de');
  final Future<List<wp.Post>> _fetchPosts = _wordPress.fetchPosts(
    postParams: wp.ParamsPostList(
      context: wp.WordPressContext.view,
      pageNum: 1,
      perPage: 20,
      order: wp.Order.desc,
      orderBy: wp.PostOrderBy.date,
    ),
    /* fetchFeaturedMedia: true */
  );

  Widget _buildPostCard({
    final String content,
    final String title,
    /* wp.Media featuredMedia */
  }) {
    final String renderedContent = HtmlUnescape()
        .convert(content)
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
    final String renderedTitle =
        HtmlUnescape().convert(title).replaceAll(RegExp(r'<[^>]*>'), '').trim();
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  NewsPageIndepth(renderedTitle, content)));
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* if (featuredMedia.mediaDetails.sizes.mediumLarge.sourceUrl !=
                  null)
                Image.network(
                    featuredMedia.mediaDetails.sizes.mediumLarge.sourceUrl), */
              Text(
                renderedTitle,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  renderedContent,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<wp.Post>>(
      future: _fetchPosts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () => _fetchPosts,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final String title = snapshot.data[index].title.rendered;
                final String content = snapshot.data[index].content.rendered;
                /* final wp.Media featuredMedia =
                    snapshot.data[index].featuredMedia; */
                return _buildPostCard(
                  title: title,
                  content: content,
                  /* featuredMedia: featuredMedia */
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

  @override
  bool get wantKeepAlive => true;
}

class NewsPageIndepth extends StatelessWidget {
  final content;
  final title;
  NewsPageIndepth(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(
        title: "News",
        withBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Html(
            style: {
              "html": Style.fromTextStyle(
                TextStyle(
                    fontFamily: "Montserrat", fontSize: 16.0, height: 1.5),
              ),
            },
            onLinkTap: (link) => url_launcher.launch(link),
            data: content,
          )
        ],
      ),
    );
  }
}
