import 'package:engelsburg_app/src/news/news_card_view.dart';
import 'package:engelsburg_app/src/news/news_service.dart';
import 'package:flutter/material.dart';

import 'dto/wordpress.dart';

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView>
    with AutomaticKeepAliveClientMixin<NewsView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<List<Post>>(
      future: NewsService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data!;

          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return NewsCardView(post);
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
