import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/news/dto/wordpress.dart';
import 'package:engelsburg_app/src/news/utils/unescape.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/time_ago.dart';
import 'news_detail_view.dart';

class NewsCardView extends StatelessWidget {
  final Post post;

  NewsCardView(this.post, {Key? key}) : super(key: key);

  final dateFormat = DateFormat('dd.MM.yyyy, HH:mm', Platform.localeName);

  @override
  Widget build(BuildContext context) {
    final featuredMedia = post.embedded.wpFeaturedmedia.isEmpty
        ? null
        : post.embedded.wpFeaturedmedia.first.sourceUrl;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => NewsDetailPage(
            post: post,
            dateFormat: dateFormat,
            featuredMedia: featuredMedia,
          ),
        ));
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 400,
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (featuredMedia != null)
                Hero(
                  tag: featuredMedia,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: CachedNetworkImage(
                      imageUrl: featuredMedia,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  UnescapeHtml.fromString(post.title.rendered),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  UnescapeHtml.fromString(post.excerpt.rendered),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(height: 1.5),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (post.date != null) Text(TimeAgo.format(post.date!)),
                  IconButton(
                      tooltip: 'Teilen',
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        Share.share(post.link);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
