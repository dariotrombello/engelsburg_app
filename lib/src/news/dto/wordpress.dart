import 'dart:convert';

List<Post> postsFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postsToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  Post({
    required this.id,
    this.date,
    this.dateGmt,
    required this.modified,
    required this.modifiedGmt,
    required this.slug,
    required this.status,
    required this.type,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.author,
    required this.featuredMedia,
    required this.commentStatus,
    required this.pingStatus,
    required this.sticky,
    required this.template,
    required this.format,
    required this.categories,
    required this.tags,
    required this.embedded,
  });

  final int id;
  final DateTime? date;
  final DateTime? dateGmt;
  final DateTime modified;
  final DateTime modifiedGmt;
  final String slug;
  final String status;
  final String type;
  final String link;
  final Title title;
  final Content content;
  final Content excerpt;
  final int author;
  final int featuredMedia;
  final String commentStatus;
  final String pingStatus;
  final bool sticky;
  final String template;
  final String format;
  final List<int> categories;
  final List<int> tags;
  final Embedded embedded;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        date: DateTime.tryParse(json["date"]),
        dateGmt: DateTime.tryParse(json["date_gmt"]),
        modified: DateTime.parse(json["modified"]),
        modifiedGmt: DateTime.parse(json["modified_gmt"]),
        slug: json["slug"],
        status: json["status"],
        type: json["type"],
        link: json["link"],
        title: Title.fromJson(json["title"]),
        content: Content.fromJson(json["content"]),
        excerpt: Content.fromJson(json["excerpt"]),
        author: json["author"],
        featuredMedia: json["featured_media"],
        commentStatus: json["comment_status"],
        pingStatus: json["ping_status"],
        sticky: json["sticky"],
        template: json["template"],
        format: json["format"],
        categories: List<int>.from(json["categories"].map((x) => x)),
        tags: List<int>.from(json["tags"].map((x) => x)),
        embedded: Embedded.fromJson(json["_embedded"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date?.toIso8601String(),
        "date_gmt": dateGmt?.toIso8601String(),
        "modified": modified.toIso8601String(),
        "modified_gmt": modifiedGmt.toIso8601String(),
        "slug": slug,
        "status": status,
        "type": type,
        "link": link,
        "title": title.toJson(),
        "content": content.toJson(),
        "excerpt": excerpt.toJson(),
        "author": author,
        "featured_media": featuredMedia,
        "comment_status": commentStatus,
        "ping_status": pingStatus,
        "sticky": sticky,
        "template": template,
        "format": format,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "_embedded": embedded.toJson(),
      };
}

class Content {
  Content({
    required this.rendered,
    required this.protected,
  });

  final String rendered;
  final bool protected;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
        "protected": protected,
      };
}

class Embedded {
  Embedded({
    required this.author,
    required this.wpFeaturedmedia,
  });

  final List<EmbeddedAuthor> author;
  final List<WpFeaturedmedia> wpFeaturedmedia;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        author: List<EmbeddedAuthor>.from(
            json["author"].map((x) => EmbeddedAuthor.fromJson(x))),
        wpFeaturedmedia: List<WpFeaturedmedia>.from(
            (json["wp:featuredmedia"] ?? [])
                .map((x) => WpFeaturedmedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "author": List<dynamic>.from(author.map((x) => x.toJson())),
        "wp:featuredmedia":
            List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
      };
}

class EmbeddedAuthor {
  EmbeddedAuthor({
    required this.code,
    required this.message,
    required this.data,
  });

  final String code;
  final String message;
  final Data data;

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) => EmbeddedAuthor(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.status,
  });

  final int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class WpFeaturedmedia {
  WpFeaturedmedia({
    required this.id,
    required this.date,
    required this.slug,
    required this.type,
    required this.link,
    required this.title,
    required this.author,
    required this.caption,
    required this.altText,
    required this.mediaType,
    required this.mimeType,
    required this.mediaDetails,
    required this.sourceUrl,
    required this.links,
  });

  final int id;
  final DateTime date;
  final String slug;
  final String type;
  final String link;
  final Title title;
  final int author;
  final Title caption;
  final String altText;
  final String mediaType;
  final String mimeType;
  final MediaDetails mediaDetails;
  final String sourceUrl;
  final WpFeaturedmediaLinks links;

  factory WpFeaturedmedia.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmedia(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        slug: json["slug"],
        type: json["type"],
        link: json["link"],
        title: Title.fromJson(json["title"]),
        author: json["author"],
        caption: Title.fromJson(json["caption"]),
        altText: json["alt_text"],
        mediaType: json["media_type"],
        mimeType: json["mime_type"],
        mediaDetails: MediaDetails.fromJson(json["media_details"]),
        sourceUrl: json["source_url"],
        links: WpFeaturedmediaLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date.toIso8601String(),
        "slug": slug,
        "type": type,
        "link": link,
        "title": title.toJson(),
        "author": author,
        "caption": caption.toJson(),
        "alt_text": altText,
        "media_type": mediaType,
        "mime_type": mimeType,
        "media_details": mediaDetails.toJson(),
        "source_url": sourceUrl,
        "_links": links.toJson(),
      };
}

class Title {
  Title({
    required this.rendered,
  });

  final String rendered;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        rendered: json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
      };
}

class WpFeaturedmediaLinks {
  WpFeaturedmediaLinks({
    required this.self,
    required this.collection,
    required this.about,
    required this.author,
    required this.replies,
  });

  final List<About> self;
  final List<About> collection;
  final List<About> about;
  final List<ReplyElement> author;
  final List<ReplyElement> replies;

  factory WpFeaturedmediaLinks.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmediaLinks(
        self: List<About>.from(json["self"].map((x) => About.fromJson(x))),
        collection:
            List<About>.from(json["collection"].map((x) => About.fromJson(x))),
        about: List<About>.from(json["about"].map((x) => About.fromJson(x))),
        author: List<ReplyElement>.from(
            json["author"].map((x) => ReplyElement.fromJson(x))),
        replies: List<ReplyElement>.from(
            json["replies"].map((x) => ReplyElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
        "about": List<dynamic>.from(about.map((x) => x.toJson())),
        "author": List<dynamic>.from(author.map((x) => x.toJson())),
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class About {
  About({
    required this.href,
  });

  final String href;

  factory About.fromJson(Map<String, dynamic> json) => About(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class ReplyElement {
  ReplyElement({
    required this.embeddable,
    required this.href,
  });

  final bool embeddable;
  final String href;

  factory ReplyElement.fromJson(Map<String, dynamic> json) => ReplyElement(
        embeddable: json["embeddable"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "embeddable": embeddable,
        "href": href,
      };
}

class MediaDetails {
  MediaDetails({
    required this.width,
    required this.height,
    required this.file,
    required this.sizes,
    required this.imageMeta,
    required this.optimus,
  });

  final int width;
  final int height;
  final String file;
  final Sizes sizes;
  final ImageMeta imageMeta;
  final Optimus optimus;

  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
        width: json["width"],
        height: json["height"],
        file: json["file"],
        sizes: Sizes.fromJson(json["sizes"]),
        imageMeta: ImageMeta.fromJson(json["image_meta"]),
        optimus: Optimus.fromJson(json["optimus"]),
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "file": file,
        "sizes": sizes.toJson(),
        "image_meta": imageMeta.toJson(),
        "optimus": optimus.toJson(),
      };
}

class ImageMeta {
  ImageMeta({
    required this.aperture,
    required this.credit,
    required this.camera,
    required this.caption,
    required this.createdTimestamp,
    required this.copyright,
    required this.focalLength,
    required this.iso,
    required this.shutterSpeed,
    required this.title,
    required this.orientation,
    required this.keywords,
  });

  final String aperture;
  final String credit;
  final String camera;
  final String caption;
  final String createdTimestamp;
  final String copyright;
  final String focalLength;
  final String iso;
  final String shutterSpeed;
  final String title;
  final String orientation;
  final List<String> keywords;

  factory ImageMeta.fromJson(Map<String, dynamic> json) => ImageMeta(
        aperture: json["aperture"],
        credit: json["credit"],
        camera: json["camera"],
        caption: json["caption"],
        createdTimestamp: json["created_timestamp"],
        copyright: json["copyright"],
        focalLength: json["focal_length"],
        iso: json["iso"],
        shutterSpeed: json["shutter_speed"],
        title: json["title"],
        orientation: json["orientation"],
        keywords: List<String>.from(json["keywords"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "aperture": aperture,
        "credit": credit,
        "camera": camera,
        "caption": caption,
        "created_timestamp": createdTimestamp,
        "copyright": copyright,
        "focal_length": focalLength,
        "iso": iso,
        "shutter_speed": shutterSpeed,
        "title": title,
        "orientation": orientation,
        "keywords": List<dynamic>.from(keywords.map((x) => x)),
      };
}

class Optimus {
  Optimus({
    required this.profit,
    required this.quantity,
    required this.webp,
  });

  final String profit;
  final int quantity;
  final int webp;

  factory Optimus.fromJson(Map<String, dynamic> json) => Optimus(
        profit: json["profit"],
        quantity: json["quantity"],
        webp: json["webp"],
      );

  Map<String, dynamic> toJson() => {
        "profit": profit,
        "quantity": quantity,
        "webp": webp,
      };
}

class Sizes {
  Sizes({
    this.medium,
    this.large,
    this.thumbnail,
    this.mediumLarge,
    this.sidebarFeatured,
    this.homePost,
    this.crpThumbnail,
    this.full,
  });

  final CrpThumbnail? medium;
  final CrpThumbnail? large;
  final CrpThumbnail? thumbnail;
  final CrpThumbnail? mediumLarge;
  final CrpThumbnail? sidebarFeatured;
  final CrpThumbnail? homePost;
  final CrpThumbnail? crpThumbnail;
  final CrpThumbnail? full;

  factory Sizes.fromJson(Map<String, dynamic> json) => Sizes(
        medium: json["medium"] == null
            ? null
            : CrpThumbnail.fromJson(json["medium"]),
        large:
            json["large"] == null ? null : CrpThumbnail.fromJson(json["large"]),
        thumbnail: CrpThumbnail.fromJson(json["thumbnail"]),
        mediumLarge: json["medium_large"] == null
            ? null
            : CrpThumbnail.fromJson(json["medium_large"]),
        sidebarFeatured: CrpThumbnail.fromJson(json["sidebar-featured"]),
        homePost: json["home-post"] == null
            ? null
            : CrpThumbnail.fromJson(json["home-post"]),
        crpThumbnail: json["crp_thumbnail"] == null
            ? null
            : CrpThumbnail.fromJson(json["crp_thumbnail"]),
        full: json["full"] == null ? null : CrpThumbnail.fromJson(json["full"]),
      );

  Map<String, dynamic> toJson() => {
        "medium": medium?.toJson(),
        "large": large?.toJson(),
        "thumbnail": thumbnail?.toJson(),
        "medium_large": mediumLarge?.toJson(),
        "sidebar-featured": sidebarFeatured?.toJson(),
        "home-post": homePost?.toJson(),
        "crp_thumbnail": crpThumbnail?.toJson(),
        "full": full?.toJson(),
      };
}

class CrpThumbnail {
  CrpThumbnail({
    required this.file,
    required this.width,
    required this.height,
    required this.mimeType,
    required this.sourceUrl,
  });

  final String file;
  final int width;
  final int height;
  final String mimeType;
  final String sourceUrl;

  factory CrpThumbnail.fromJson(Map<String, dynamic> json) => CrpThumbnail(
        file: json["file"],
        width: json["width"],
        height: json["height"],
        mimeType: json["mime_type"],
        sourceUrl: json["source_url"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "width": width,
        "height": height,
        "mime_type": mimeType,
        "source_url": sourceUrl,
      };
}
