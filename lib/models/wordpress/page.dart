class WpPage {
  WpPage({
    this.content,
  });

  final Content? content;

  factory WpPage.fromJson(Map<String, dynamic> json) => WpPage(
        content: Content.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content?.toJson(),
      };
}

class Content {
  Content({
    this.rendered,
    this.protected,
  });

  final String? rendered;
  final bool? protected;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
        "protected": protected,
      };
}
