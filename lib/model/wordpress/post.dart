import 'package:json_annotation/json_annotation.dart';

import 'content.dart';
import 'embedded.dart';
import 'guid.dart';
import 'meta.dart';
import 'postlinks.dart';
part 'post.g.dart';

@JsonSerializable()
class Post {
  Post(
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.commentStatus,
    this.pingStatus,
    this.sticky,
    this.template,
    this.format,
    this.meta,
    this.categories,
    this.tags,
    this.links,
    this.embedded,
  );

  final int id;
  final DateTime date;

  @JsonKey(name: 'date_gmt')
  final DateTime dateGmt;

  final Guid guid;
  final DateTime modified;

  @JsonKey(name: 'modified_gmt')
  final DateTime modifiedGmt;

  final String slug;
  final String status;
  final String type;
  final String link;
  final Guid title;
  final Content content;
  final Content excerpt;
  final int author;

  @JsonKey(name: 'featured_media')
  final int featuredMedia;

  @JsonKey(name: 'comment_status')
  final String commentStatus;

  @JsonKey(name: 'ping_status')
  final String pingStatus;

  final bool sticky;
  final String template;
  final String format;
  final Meta meta;
  final List<int> categories;
  final List<int> tags;

  @JsonKey(name: '_links')
  final PostLinks links;

  @JsonKey(name: '_embedded')
  final Embedded embedded;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
