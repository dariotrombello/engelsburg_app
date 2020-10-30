import 'package:json_annotation/json_annotation.dart';

import 'about.dart';
import 'replyelement.dart';
part 'featuredmedialinks.g.dart';

@JsonSerializable()
class FeaturedMediaLinks {
  FeaturedMediaLinks(
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
  );

  final List<About> self;
  final List<About> collection;
  final List<About> about;
  final List<ReplyElement> author;
  final List<ReplyElement> replies;

  factory FeaturedMediaLinks.fromJson(Map<String, dynamic> json) =>
      _$FeaturedMediaLinksFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedMediaLinksToJson(this);
}
