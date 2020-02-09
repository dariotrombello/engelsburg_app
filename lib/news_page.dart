import 'package:flutter/material.dart';

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
  Future<List<wp.Post>> _posts;
  static wp.WordPress _wordPress =
      wp.WordPress(baseUrl: 'https://engelsburg.smmp.de');

  Future<void> _fetchPosts() {
    setState(() {
      _posts = _wordPress.fetchPosts(
        postParams: wp.ParamsPostList(
          context: wp.WordPressContext.view,
          pageNum: 1,
          perPage: 20,
          order: wp.Order.desc,
          orderBy: wp.PostOrderBy.date,
        ),
        /* fetchFeaturedMedia: true */
      );
    });
    return _posts;
  }

  @override
  void initState() {
    super.initState();
    _posts = _fetchPosts();
  }

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
      future: _posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () => _posts,
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
        } else if (snapshot.hasError) {
          // Wenn die Nachrichten nicht geladen werden können, wird die Schaltfläche zum Neuladen angezeigt.
          return Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.red),
                  )),
              SizedBox(
                height: 50,
                width: 200,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  onPressed: () => _posts,
                ),
              )
            ],
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
            defaultTextStyle: TextStyle(
                fontFamily: "Montserrat", fontSize: 16.0, height: 1.5),
            onLinkTap: (link) => url_launcher.launch(link),
            data: content,
            useRichText: true,
            renderNewlines: true,
          )
        ],
      ),
    );
  }
}
