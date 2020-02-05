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

  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() {
    setState(() {
      _posts = _wordPress.fetchPosts(
        postParams: wp.ParamsPostList(
          context: wp.WordPressContext.view,
          pageNum: 1,
          perPage: 20,
          order: wp.Order.desc,
          orderBy: wp.PostOrderBy.date,
        ),
      );
    });
    return _posts;
  }

  Widget _buildPostCard({
    final String content,
    final String title,
    wp.Media featuredMedia,
  }) {
    final String renderedContent =
        HtmlUnescape().convert(content).replaceAll(RegExp(r'<[^>]*>'), '');
    final String renderedTitle =
        HtmlUnescape().convert(title).replaceAll(RegExp(r'<[^>]*>'), '');
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        NewsPageIndepth(renderedTitle, content)));
              },
              title: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Text(renderedTitle)),
              subtitle: Text(renderedContent,
                  maxLines: 5, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<wp.Post>>(
      future: _posts,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.isEmpty)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: fetchPosts,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final String title = snapshot.data[index].title.rendered;
                final String content = snapshot.data[index].content.rendered;
                return _buildPostCard(
                  title: title,
                  content: content,
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
                  onPressed: () {
                    fetchPosts();
                  },
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
  final renderedTitle;
  NewsPageIndepth(this.renderedTitle, this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngelsburgAppBar(
        text: renderedTitle,
        withBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Html(
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
