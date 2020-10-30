import 'package:json_annotation/json_annotation.dart';

import 'about.dart';
import 'cury.dart';
import 'term.dart';
import 'replyelement.dart';
import 'versionhistory.dart';

part 'postlinks.g.dart';

@JsonSerializable()
class PostLinks {
  PostLinks(
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
    this.versionHistory,
    this.wpAttachment,
    this.wpTerm,
    this.curies,
    this.wpFeaturedmedia,
  );

  final List<About> self;
  final List<About> collection;
  final List<About> about;
  final List<ReplyElement> author;
  final List<ReplyElement> replies;

  @JsonKey(name: 'version-history')
  final List<VersionHistory> versionHistory;

  @JsonKey(name: 'wp:attachment')
  final List<About> wpAttachment;

  @JsonKey(name: 'wp:term')
  final List<Term> wpTerm;

  final List<Cury> curies;

  @JsonKey(name: 'wp:featuredmedia')
  final List<ReplyElement> wpFeaturedmedia;

  factory PostLinks.fromJson(Map<String, dynamic> json) =>
      _$PostLinksFromJson(json);

  Map<String, dynamic> toJson() => _$PostLinksToJson(this);
}
