// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  Post({
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
  });

  int id;
  DateTime date;
  DateTime dateGmt;
  Guid guid;
  DateTime modified;
  DateTime modifiedGmt;
  String slug;
  Status status;
  Type type;
  String link;
  Guid title;
  Content content;
  Content excerpt;
  int author;
  int featuredMedia;
  CommentStatus commentStatus;
  String pingStatus;
  bool sticky;
  String template;
  Format format;
  Meta meta;
  List<int> categories;
  List<int> tags;
  PostLinks links;
  Embedded embedded;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"] == null ? null : json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        dateGmt:
            json["date_gmt"] == null ? null : DateTime.parse(json["date_gmt"]),
        guid: json["guid"] == null ? null : Guid.fromJson(json["guid"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
        modifiedGmt: json["modified_gmt"] == null
            ? null
            : DateTime.parse(json["modified_gmt"]),
        slug: json["slug"] == null ? null : json["slug"],
        status:
            json["status"] == null ? null : statusValues.map[json["status"]],
        type: json["type"] == null ? null : typeValues.map[json["type"]],
        link: json["link"] == null ? null : json["link"],
        title: json["title"] == null ? null : Guid.fromJson(json["title"]),
        content:
            json["content"] == null ? null : Content.fromJson(json["content"]),
        excerpt:
            json["excerpt"] == null ? null : Content.fromJson(json["excerpt"]),
        author: json["author"] == null ? null : json["author"],
        featuredMedia:
            json["featured_media"] == null ? null : json["featured_media"],
        commentStatus: json["comment_status"] == null
            ? null
            : commentStatusValues.map[json["comment_status"]],
        pingStatus: json["ping_status"] == null ? null : json["ping_status"],
        sticky: json["sticky"] == null ? null : json["sticky"],
        template: json["template"] == null ? null : json["template"],
        format:
            json["format"] == null ? null : formatValues.map[json["format"]],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        categories: json["categories"] == null
            ? null
            : List<int>.from(json["categories"].map((x) => x)),
        tags: json["tags"] == null
            ? null
            : List<int>.from(json["tags"].map((x) => x)),
        links:
            json["_links"] == null ? null : PostLinks.fromJson(json["_links"]),
        embedded: json["_embedded"] == null
            ? null
            : Embedded.fromJson(json["_embedded"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "date": date == null ? null : date.toIso8601String(),
        "date_gmt": dateGmt == null ? null : dateGmt.toIso8601String(),
        "guid": guid == null ? null : guid.toJson(),
        "modified": modified == null ? null : modified.toIso8601String(),
        "modified_gmt":
            modifiedGmt == null ? null : modifiedGmt.toIso8601String(),
        "slug": slug == null ? null : slug,
        "status": status == null ? null : statusValues.reverse[status],
        "type": type == null ? null : typeValues.reverse[type],
        "link": link == null ? null : link,
        "title": title == null ? null : title.toJson(),
        "content": content == null ? null : content.toJson(),
        "excerpt": excerpt == null ? null : excerpt.toJson(),
        "author": author == null ? null : author,
        "featured_media": featuredMedia == null ? null : featuredMedia,
        "comment_status": commentStatus == null
            ? null
            : commentStatusValues.reverse[commentStatus],
        "ping_status": pingStatus == null ? null : pingStatus,
        "sticky": sticky == null ? null : sticky,
        "template": template == null ? null : template,
        "format": format == null ? null : formatValues.reverse[format],
        "meta": meta == null ? null : meta.toJson(),
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories.map((x) => x)),
        "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
        "_links": links == null ? null : links.toJson(),
        "_embedded": embedded == null ? null : embedded.toJson(),
      };
}

enum CommentStatus { CLOSED }

final commentStatusValues = EnumValues({"closed": CommentStatus.CLOSED});

class Content {
  Content({
    this.rendered,
    this.protected,
  });

  String rendered;
  bool protected;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json["rendered"] == null ? null : json["rendered"],
        protected: json["protected"] == null ? null : json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered == null ? null : rendered,
        "protected": protected == null ? null : protected,
      };
}

class Embedded {
  Embedded({
    this.author,
    this.wpTerm,
    this.wpFeaturedmedia,
  });

  List<EmbeddedAuthor> author;
  List<List<EmbeddedWpTerm>> wpTerm;
  List<WpFeaturedmedia> wpFeaturedmedia;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        author: json["author"] == null
            ? null
            : List<EmbeddedAuthor>.from(
                json["author"].map((x) => EmbeddedAuthor.fromJson(x))),
        wpTerm: json["wp:term"] == null
            ? null
            : List<List<EmbeddedWpTerm>>.from(json["wp:term"].map((x) =>
                List<EmbeddedWpTerm>.from(
                    x.map((x) => EmbeddedWpTerm.fromJson(x))))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null
            ? null
            : List<WpFeaturedmedia>.from(json["wp:featuredmedia"]
                .map((x) => WpFeaturedmedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "author": author == null
            ? null
            : List<dynamic>.from(author.map((x) => x.toJson())),
        "wp:term": wpTerm == null
            ? null
            : List<dynamic>.from(wpTerm
                .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "wp:featuredmedia": wpFeaturedmedia == null
            ? null
            : List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
      };
}

class EmbeddedAuthor {
  EmbeddedAuthor({
    this.code,
    this.message,
    this.data,
  });

  Code code;
  Message message;
  Data data;

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) => EmbeddedAuthor(
        code: json["code"] == null ? null : codeValues.map[json["code"]],
        message:
            json["message"] == null ? null : messageValues.map[json["message"]],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : codeValues.reverse[code],
        "message": message == null ? null : messageValues.reverse[message],
        "data": data == null ? null : data.toJson(),
      };
}

enum Code { REST_USER_INVALID_ID }

final codeValues =
    EnumValues({"rest_user_invalid_id": Code.REST_USER_INVALID_ID});

class Data {
  Data({
    this.status,
  });

  int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
      };
}

enum Message { UNGLTIGE_BENUTZER_ID }

final messageValues =
    EnumValues({"Ungültige Benutzer-ID.": Message.UNGLTIGE_BENUTZER_ID});

class WpFeaturedmedia {
  WpFeaturedmedia({
    this.id,
    this.date,
    this.slug,
    this.type,
    this.link,
    this.title,
    this.author,
    this.caption,
    this.altText,
    this.mediaType,
    this.mimeType,
    this.mediaDetails,
    this.sourceUrl,
    this.links,
  });

  int id;
  DateTime date;
  String slug;
  String type;
  String link;
  Guid title;
  int author;
  Guid caption;
  String altText;
  String mediaType;
  MimeType mimeType;
  MediaDetails mediaDetails;
  String sourceUrl;
  WpFeaturedmediaLinks links;

  factory WpFeaturedmedia.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmedia(
        id: json["id"] == null ? null : json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        slug: json["slug"] == null ? null : json["slug"],
        type: json["type"] == null ? null : json["type"],
        link: json["link"] == null ? null : json["link"],
        title: json["title"] == null ? null : Guid.fromJson(json["title"]),
        author: json["author"] == null ? null : json["author"],
        caption:
            json["caption"] == null ? null : Guid.fromJson(json["caption"]),
        altText: json["alt_text"] == null ? null : json["alt_text"],
        mediaType: json["media_type"] == null ? null : json["media_type"],
        mimeType: json["mime_type"] == null
            ? null
            : mimeTypeValues.map[json["mime_type"]],
        mediaDetails: json["media_details"] == null
            ? null
            : MediaDetails.fromJson(json["media_details"]),
        sourceUrl: json["source_url"] == null ? null : json["source_url"],
        links: json["_links"] == null
            ? null
            : WpFeaturedmediaLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "date": date == null ? null : date.toIso8601String(),
        "slug": slug == null ? null : slug,
        "type": type == null ? null : type,
        "link": link == null ? null : link,
        "title": title == null ? null : title.toJson(),
        "author": author == null ? null : author,
        "caption": caption == null ? null : caption.toJson(),
        "alt_text": altText == null ? null : altText,
        "media_type": mediaType == null ? null : mediaType,
        "mime_type": mimeType == null ? null : mimeTypeValues.reverse[mimeType],
        "media_details": mediaDetails == null ? null : mediaDetails.toJson(),
        "source_url": sourceUrl == null ? null : sourceUrl,
        "_links": links == null ? null : links.toJson(),
      };
}

class Guid {
  Guid({
    this.rendered,
  });

  String rendered;

  factory Guid.fromJson(Map<String, dynamic> json) => Guid(
        rendered: json["rendered"] == null ? null : json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered == null ? null : rendered,
      };
}

class WpFeaturedmediaLinks {
  WpFeaturedmediaLinks({
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
  });

  List<About> self;
  List<About> collection;
  List<About> about;
  List<ReplyElement> author;
  List<ReplyElement> replies;

  factory WpFeaturedmediaLinks.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmediaLinks(
        self: json["self"] == null
            ? null
            : List<About>.from(json["self"].map((x) => About.fromJson(x))),
        collection: json["collection"] == null
            ? null
            : List<About>.from(
                json["collection"].map((x) => About.fromJson(x))),
        about: json["about"] == null
            ? null
            : List<About>.from(json["about"].map((x) => About.fromJson(x))),
        author: json["author"] == null
            ? null
            : List<ReplyElement>.from(
                json["author"].map((x) => ReplyElement.fromJson(x))),
        replies: json["replies"] == null
            ? null
            : List<ReplyElement>.from(
                json["replies"].map((x) => ReplyElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection.map((x) => x.toJson())),
        "about": about == null
            ? null
            : List<dynamic>.from(about.map((x) => x.toJson())),
        "author": author == null
            ? null
            : List<dynamic>.from(author.map((x) => x.toJson())),
        "replies": replies == null
            ? null
            : List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class About {
  About({
    this.href,
  });

  String href;

  factory About.fromJson(Map<String, dynamic> json) => About(
        href: json["href"] == null ? null : json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href == null ? null : href,
      };
}

class ReplyElement {
  ReplyElement({
    this.embeddable,
    this.href,
  });

  bool embeddable;
  String href;

  factory ReplyElement.fromJson(Map<String, dynamic> json) => ReplyElement(
        embeddable: json["embeddable"] == null ? null : json["embeddable"],
        href: json["href"] == null ? null : json["href"],
      );

  Map<String, dynamic> toJson() => {
        "embeddable": embeddable == null ? null : embeddable,
        "href": href == null ? null : href,
      };
}

class MediaDetails {
  MediaDetails({
    this.width,
    this.height,
    this.file,
    this.sizes,
    this.imageMeta,
    this.optimus,
  });

  int width;
  int height;
  String file;
  Sizes sizes;
  ImageMeta imageMeta;
  Optimus optimus;

  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        file: json["file"] == null ? null : json["file"],
        sizes: json["sizes"] == null ? null : Sizes.fromJson(json["sizes"]),
        imageMeta: json["image_meta"] == null
            ? null
            : ImageMeta.fromJson(json["image_meta"]),
        optimus:
            json["optimus"] == null ? null : Optimus.fromJson(json["optimus"]),
      );

  Map<String, dynamic> toJson() => {
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "file": file == null ? null : file,
        "sizes": sizes == null ? null : sizes.toJson(),
        "image_meta": imageMeta == null ? null : imageMeta.toJson(),
        "optimus": optimus == null ? null : optimus.toJson(),
      };
}

class ImageMeta {
  ImageMeta({
    this.aperture,
    this.credit,
    this.camera,
    this.caption,
    this.createdTimestamp,
    this.copyright,
    this.focalLength,
    this.iso,
    this.shutterSpeed,
    this.title,
    this.orientation,
    this.keywords,
  });

  String aperture;
  String credit;
  String camera;
  String caption;
  String createdTimestamp;
  String copyright;
  String focalLength;
  String iso;
  String shutterSpeed;
  String title;
  String orientation;
  List<String> keywords;

  factory ImageMeta.fromJson(Map<String, dynamic> json) => ImageMeta(
        aperture: json["aperture"] == null ? null : json["aperture"],
        credit: json["credit"] == null ? null : json["credit"],
        camera: json["camera"] == null ? null : json["camera"],
        caption: json["caption"] == null ? null : json["caption"],
        createdTimestamp: json["created_timestamp"] == null
            ? null
            : json["created_timestamp"],
        copyright: json["copyright"] == null ? null : json["copyright"],
        focalLength: json["focal_length"] == null ? null : json["focal_length"],
        iso: json["iso"] == null ? null : json["iso"],
        shutterSpeed:
            json["shutter_speed"] == null ? null : json["shutter_speed"],
        title: json["title"] == null ? null : json["title"],
        orientation: json["orientation"] == null ? null : json["orientation"],
        keywords: json["keywords"] == null
            ? null
            : List<String>.from(json["keywords"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "aperture": aperture == null ? null : aperture,
        "credit": credit == null ? null : credit,
        "camera": camera == null ? null : camera,
        "caption": caption == null ? null : caption,
        "created_timestamp": createdTimestamp == null ? null : createdTimestamp,
        "copyright": copyright == null ? null : copyright,
        "focal_length": focalLength == null ? null : focalLength,
        "iso": iso == null ? null : iso,
        "shutter_speed": shutterSpeed == null ? null : shutterSpeed,
        "title": title == null ? null : title,
        "orientation": orientation == null ? null : orientation,
        "keywords": keywords == null
            ? null
            : List<dynamic>.from(keywords.map((x) => x)),
      };
}

class Optimus {
  Optimus({
    this.profit,
    this.quantity,
    this.webp,
    this.error,
  });

  String profit;
  int quantity;
  int webp;
  String error;

  factory Optimus.fromJson(Map<String, dynamic> json) => Optimus(
        profit: json["profit"] == null ? null : json["profit"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        webp: json["webp"] == null ? null : json["webp"],
        error: json["error"] == null ? null : json["error"],
      );

  Map<String, dynamic> toJson() => {
        "profit": profit == null ? null : profit,
        "quantity": quantity == null ? null : quantity,
        "webp": webp == null ? null : webp,
        "error": error == null ? null : error,
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

  CrpThumbnail medium;
  CrpThumbnail large;
  CrpThumbnail thumbnail;
  CrpThumbnail mediumLarge;
  CrpThumbnail sidebarFeatured;
  CrpThumbnail homePost;
  CrpThumbnail crpThumbnail;
  CrpThumbnail full;

  factory Sizes.fromJson(Map<String, dynamic> json) => Sizes(
        medium: json["medium"] == null
            ? null
            : CrpThumbnail.fromJson(json["medium"]),
        large:
            json["large"] == null ? null : CrpThumbnail.fromJson(json["large"]),
        thumbnail: json["thumbnail"] == null
            ? null
            : CrpThumbnail.fromJson(json["thumbnail"]),
        mediumLarge: json["medium_large"] == null
            ? null
            : CrpThumbnail.fromJson(json["medium_large"]),
        sidebarFeatured: json["sidebar-featured"] == null
            ? null
            : CrpThumbnail.fromJson(json["sidebar-featured"]),
        homePost: json["home-post"] == null
            ? null
            : CrpThumbnail.fromJson(json["home-post"]),
        crpThumbnail: json["crp_thumbnail"] == null
            ? null
            : CrpThumbnail.fromJson(json["crp_thumbnail"]),
        full: json["full"] == null ? null : CrpThumbnail.fromJson(json["full"]),
      );

  Map<String, dynamic> toJson() => {
        "medium": medium == null ? null : medium.toJson(),
        "large": large == null ? null : large.toJson(),
        "thumbnail": thumbnail == null ? null : thumbnail.toJson(),
        "medium_large": mediumLarge == null ? null : mediumLarge.toJson(),
        "sidebar-featured":
            sidebarFeatured == null ? null : sidebarFeatured.toJson(),
        "home-post": homePost == null ? null : homePost.toJson(),
        "crp_thumbnail": crpThumbnail == null ? null : crpThumbnail.toJson(),
        "full": full == null ? null : full.toJson(),
      };
}

class CrpThumbnail {
  CrpThumbnail({
    this.file,
    this.width,
    this.height,
    this.mimeType,
    this.sourceUrl,
  });

  String file;
  int width;
  int height;
  MimeType mimeType;
  String sourceUrl;

  factory CrpThumbnail.fromJson(Map<String, dynamic> json) => CrpThumbnail(
        file: json["file"] == null ? null : json["file"],
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        mimeType: json["mime_type"] == null
            ? null
            : mimeTypeValues.map[json["mime_type"]],
        sourceUrl: json["source_url"] == null ? null : json["source_url"],
      );

  Map<String, dynamic> toJson() => {
        "file": file == null ? null : file,
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "mime_type": mimeType == null ? null : mimeTypeValues.reverse[mimeType],
        "source_url": sourceUrl == null ? null : sourceUrl,
      };
}

enum MimeType { IMAGE_JPEG }

final mimeTypeValues = EnumValues({"image/jpeg": MimeType.IMAGE_JPEG});

class EmbeddedWpTerm {
  EmbeddedWpTerm({
    this.id,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.links,
  });

  int id;
  String link;
  String name;
  String slug;
  Taxonomy taxonomy;
  WpTermLinks links;

  factory EmbeddedWpTerm.fromJson(Map<String, dynamic> json) => EmbeddedWpTerm(
        id: json["id"] == null ? null : json["id"],
        link: json["link"] == null ? null : json["link"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        taxonomy: json["taxonomy"] == null
            ? null
            : taxonomyValues.map[json["taxonomy"]],
        links: json["_links"] == null
            ? null
            : WpTermLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "link": link == null ? null : link,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "taxonomy": taxonomy == null ? null : taxonomyValues.reverse[taxonomy],
        "_links": links == null ? null : links.toJson(),
      };
}

class WpTermLinks {
  WpTermLinks({
    this.self,
    this.collection,
    this.about,
    this.wpPostType,
    this.curies,
  });

  List<About> self;
  List<About> collection;
  List<About> about;
  List<About> wpPostType;
  List<Cury> curies;

  factory WpTermLinks.fromJson(Map<String, dynamic> json) => WpTermLinks(
        self: json["self"] == null
            ? null
            : List<About>.from(json["self"].map((x) => About.fromJson(x))),
        collection: json["collection"] == null
            ? null
            : List<About>.from(
                json["collection"].map((x) => About.fromJson(x))),
        about: json["about"] == null
            ? null
            : List<About>.from(json["about"].map((x) => About.fromJson(x))),
        wpPostType: json["wp:post_type"] == null
            ? null
            : List<About>.from(
                json["wp:post_type"].map((x) => About.fromJson(x))),
        curies: json["curies"] == null
            ? null
            : List<Cury>.from(json["curies"].map((x) => Cury.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection.map((x) => x.toJson())),
        "about": about == null
            ? null
            : List<dynamic>.from(about.map((x) => x.toJson())),
        "wp:post_type": wpPostType == null
            ? null
            : List<dynamic>.from(wpPostType.map((x) => x.toJson())),
        "curies": curies == null
            ? null
            : List<dynamic>.from(curies.map((x) => x.toJson())),
      };
}

class Cury {
  Cury({
    this.name,
    this.href,
    this.templated,
  });

  Name name;
  Href href;
  bool templated;

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
        name: json["name"] == null ? null : nameValues.map[json["name"]],
        href: json["href"] == null ? null : hrefValues.map[json["href"]],
        templated: json["templated"] == null ? null : json["templated"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : nameValues.reverse[name],
        "href": href == null ? null : hrefValues.reverse[href],
        "templated": templated == null ? null : templated,
      };
}

enum Href { HTTPS_API_W_ORG_REL }

final hrefValues =
    EnumValues({"https://api.w.org/{rel}": Href.HTTPS_API_W_ORG_REL});

enum Name { WP }

final nameValues = EnumValues({"wp": Name.WP});

enum Taxonomy { CATEGORY, POST_TAG }

final taxonomyValues =
    EnumValues({"category": Taxonomy.CATEGORY, "post_tag": Taxonomy.POST_TAG});

enum Format { STANDARD }

final formatValues = EnumValues({"standard": Format.STANDARD});

class PostLinks {
  PostLinks({
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
  });

  List<About> self;
  List<About> collection;
  List<About> about;
  List<ReplyElement> author;
  List<ReplyElement> replies;
  List<VersionHistory> versionHistory;
  List<About> wpAttachment;
  List<LinksWpTerm> wpTerm;
  List<Cury> curies;
  List<ReplyElement> wpFeaturedmedia;

  factory PostLinks.fromJson(Map<String, dynamic> json) => PostLinks(
        self: json["self"] == null
            ? null
            : List<About>.from(json["self"].map((x) => About.fromJson(x))),
        collection: json["collection"] == null
            ? null
            : List<About>.from(
                json["collection"].map((x) => About.fromJson(x))),
        about: json["about"] == null
            ? null
            : List<About>.from(json["about"].map((x) => About.fromJson(x))),
        author: json["author"] == null
            ? null
            : List<ReplyElement>.from(
                json["author"].map((x) => ReplyElement.fromJson(x))),
        replies: json["replies"] == null
            ? null
            : List<ReplyElement>.from(
                json["replies"].map((x) => ReplyElement.fromJson(x))),
        versionHistory: json["version-history"] == null
            ? null
            : List<VersionHistory>.from(
                json["version-history"].map((x) => VersionHistory.fromJson(x))),
        wpAttachment: json["wp:attachment"] == null
            ? null
            : List<About>.from(
                json["wp:attachment"].map((x) => About.fromJson(x))),
        wpTerm: json["wp:term"] == null
            ? null
            : List<LinksWpTerm>.from(
                json["wp:term"].map((x) => LinksWpTerm.fromJson(x))),
        curies: json["curies"] == null
            ? null
            : List<Cury>.from(json["curies"].map((x) => Cury.fromJson(x))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null
            ? null
            : List<ReplyElement>.from(
                json["wp:featuredmedia"].map((x) => ReplyElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection.map((x) => x.toJson())),
        "about": about == null
            ? null
            : List<dynamic>.from(about.map((x) => x.toJson())),
        "author": author == null
            ? null
            : List<dynamic>.from(author.map((x) => x.toJson())),
        "replies": replies == null
            ? null
            : List<dynamic>.from(replies.map((x) => x.toJson())),
        "version-history": versionHistory == null
            ? null
            : List<dynamic>.from(versionHistory.map((x) => x.toJson())),
        "wp:attachment": wpAttachment == null
            ? null
            : List<dynamic>.from(wpAttachment.map((x) => x.toJson())),
        "wp:term": wpTerm == null
            ? null
            : List<dynamic>.from(wpTerm.map((x) => x.toJson())),
        "curies": curies == null
            ? null
            : List<dynamic>.from(curies.map((x) => x.toJson())),
        "wp:featuredmedia": wpFeaturedmedia == null
            ? null
            : List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
      };
}

class VersionHistory {
  VersionHistory({
    this.count,
    this.href,
  });

  int count;
  String href;

  factory VersionHistory.fromJson(Map<String, dynamic> json) => VersionHistory(
        count: json["count"] == null ? null : json["count"],
        href: json["href"] == null ? null : json["href"],
      );

  Map<String, dynamic> toJson() => {
        "count": count == null ? null : count,
        "href": href == null ? null : href,
      };
}

class LinksWpTerm {
  LinksWpTerm({
    this.taxonomy,
    this.embeddable,
    this.href,
  });

  Taxonomy taxonomy;
  bool embeddable;
  String href;

  factory LinksWpTerm.fromJson(Map<String, dynamic> json) => LinksWpTerm(
        taxonomy: json["taxonomy"] == null
            ? null
            : taxonomyValues.map[json["taxonomy"]],
        embeddable: json["embeddable"] == null ? null : json["embeddable"],
        href: json["href"] == null ? null : json["href"],
      );

  Map<String, dynamic> toJson() => {
        "taxonomy": taxonomy == null ? null : taxonomyValues.reverse[taxonomy],
        "embeddable": embeddable == null ? null : embeddable,
        "href": href == null ? null : href,
      };
}

class Meta {
  Meta({
    this.genesisHideTitle,
    this.genesisHideBreadcrumbs,
    this.genesisHideSingularImage,
    this.genesisHideFooterWidgets,
    this.genesisCustomBodyClass,
    this.genesisCustomPostClass,
    this.genesisLayout,
  });

  bool genesisHideTitle;
  bool genesisHideBreadcrumbs;
  bool genesisHideSingularImage;
  bool genesisHideFooterWidgets;
  String genesisCustomBodyClass;
  String genesisCustomPostClass;
  String genesisLayout;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        genesisHideTitle: json["_genesis_hide_title"] == null
            ? null
            : json["_genesis_hide_title"],
        genesisHideBreadcrumbs: json["_genesis_hide_breadcrumbs"] == null
            ? null
            : json["_genesis_hide_breadcrumbs"],
        genesisHideSingularImage: json["_genesis_hide_singular_image"] == null
            ? null
            : json["_genesis_hide_singular_image"],
        genesisHideFooterWidgets: json["_genesis_hide_footer_widgets"] == null
            ? null
            : json["_genesis_hide_footer_widgets"],
        genesisCustomBodyClass: json["_genesis_custom_body_class"] == null
            ? null
            : json["_genesis_custom_body_class"],
        genesisCustomPostClass: json["_genesis_custom_post_class"] == null
            ? null
            : json["_genesis_custom_post_class"],
        genesisLayout:
            json["_genesis_layout"] == null ? null : json["_genesis_layout"],
      );

  Map<String, dynamic> toJson() => {
        "_genesis_hide_title":
            genesisHideTitle == null ? null : genesisHideTitle,
        "_genesis_hide_breadcrumbs":
            genesisHideBreadcrumbs == null ? null : genesisHideBreadcrumbs,
        "_genesis_hide_singular_image":
            genesisHideSingularImage == null ? null : genesisHideSingularImage,
        "_genesis_hide_footer_widgets":
            genesisHideFooterWidgets == null ? null : genesisHideFooterWidgets,
        "_genesis_custom_body_class":
            genesisCustomBodyClass == null ? null : genesisCustomBodyClass,
        "_genesis_custom_post_class":
            genesisCustomPostClass == null ? null : genesisCustomPostClass,
        "_genesis_layout": genesisLayout == null ? null : genesisLayout,
      };
}

enum Status { PUBLISH }

final statusValues = EnumValues({"publish": Status.PUBLISH});

enum Type { POST }

final typeValues = EnumValues({"post": Type.POST});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
