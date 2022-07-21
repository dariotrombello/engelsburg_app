import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/common/url_launcher_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

import 'dto/wordpress.dart';
import 'utils/unescape.dart';

class NewsDetailPage extends StatelessWidget {
  final Post post;
  final DateFormat dateFormat;
  final String? featuredMedia;

  const NewsDetailPage({
    Key? key,
    required this.post,
    required this.dateFormat,
    required this.featuredMedia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('News'),
      ),
      body: ListView(
        children: <Widget>[
          if (featuredMedia != null)
            Hero(
              tag: featuredMedia!,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: featuredMedia!,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              UnescapeHtml.fromString(post.title.rendered),
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          if (post.date != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text(
                dateFormat.format(post.date!),
              ),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HtmlWidget(
              post.content.rendered,
              textStyle: const TextStyle(fontSize: 15.0, height: 1.5),
              onTapUrl: (url) => UrlLauncherService.launchUrlString(url),
            ),
          )
        ],
      ),
    );
  }
}
