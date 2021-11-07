import 'dart:convert';

List<Post> postsFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postsToJson(List<Post> data) =>
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

  final int id;
  final DateTime date;
  final DateTime dateGmt;
  final Guid guid;
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
  final Meta meta;
  final List<int> categories;
  final List<int> tags;
  final PostLinks links;
  final Embedded embedded;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        date: DateTime.parse(json['date']),
        dateGmt: DateTime.parse(json['date_gmt']),
        guid: Guid.fromJson(json['guid']),
        modified: DateTime.parse(json['modified']),
        modifiedGmt: DateTime.parse(json['modified_gmt']),
        slug: json['slug'],
        status: json['status'],
        type: json['type'],
        link: json['link'],
        title: Title.fromJson(json['title']),
        content: Content.fromJson(json['content']),
        excerpt: Content.fromJson(json['excerpt']),
        author: json['author'],
        featuredMedia: json['featured_media'],
        commentStatus: json['comment_status'],
        pingStatus: json['ping_status'],
        sticky: json['sticky'],
        template: json['template'],
        format: json['format'],
        meta: Meta.fromJson(json['meta']),
        categories: List<int>.from(json['categories'].map((x) => x)),
        tags: List<int>.from(json['tags'].map((x) => x)),
        links: PostLinks.fromJson(json['_links']),
        embedded: Embedded.fromJson(json['_embedded']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'date_gmt': dateGmt.toIso8601String(),
        'guid': guid.toJson(),
        'modified': modified.toIso8601String(),
        'modified_gmt': modifiedGmt.toIso8601String(),
        'slug': slug,
        'status': status,
        'type': type,
        'link': link,
        'title': title.toJson(),
        'content': content.toJson(),
        'excerpt': excerpt.toJson(),
        'author': author,
        'featured_media': featuredMedia,
        'comment_status': commentStatus,
        'ping_status': pingStatus,
        'sticky': sticky,
        'template': template,
        'format': format,
        'meta': meta.toJson(),
        'categories': List<dynamic>.from(categories.map((x) => x)),
        'tags': List<dynamic>.from(tags.map((x) => x)),
        '_links': links.toJson(),
        '_embedded': embedded.toJson(),
      };
}

class Content {
  Content({
    this.rendered,
    this.protected,
  });

  final String rendered;
  final bool protected;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json['rendered'],
        protected: json['protected'],
      );

  Map<String, dynamic> toJson() => {
        'rendered': rendered,
        'protected': protected,
      };
}

class Embedded {
  Embedded({
    this.author,
    this.wpFeaturedmedia,
    this.wpTerm,
  });

  final List<EmbeddedAuthor> author;
  final List<WpFeaturedmedia> wpFeaturedmedia;
  final List<List<EmbeddedWpTerm>> wpTerm;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        author: List<EmbeddedAuthor>.from(
            json['author'].map((x) => EmbeddedAuthor.fromJson(x))),
        wpFeaturedmedia: json['wp:featuredmedia'] == null
            ? null
            : List<WpFeaturedmedia>.from(json['wp:featuredmedia']
                .map((x) => WpFeaturedmedia.fromJson(x))),
        wpTerm: List<List<EmbeddedWpTerm>>.from(json['wp:term'].map((x) =>
            List<EmbeddedWpTerm>.from(
                x.map((x) => EmbeddedWpTerm.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        'author': List<dynamic>.from(author.map((x) => x.toJson())),
        'wp:featuredmedia': wpFeaturedmedia == null
            ? null
            : List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
        'wp:term': List<dynamic>.from(
            wpTerm.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class EmbeddedAuthor {
  EmbeddedAuthor({
    this.code,
    this.message,
    this.data,
  });

  final String code;
  final String message;
  final Data data;

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) => EmbeddedAuthor(
        code: json['code'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data.toJson(),
      };
}

class Data {
  Data({
    this.status,
  });

  final int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
      };
}

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
        id: json['id'],
        date: DateTime.parse(json['date']),
        slug: json['slug'],
        type: json['type'],
        link: json['link'],
        title: Title.fromJson(json['title']),
        author: json['author'],
        caption: Title.fromJson(json['caption']),
        altText: json['alt_text'],
        mediaType: json['media_type'],
        mimeType: json['mime_type'],
        mediaDetails: MediaDetails.fromJson(json['media_details']),
        sourceUrl: json['source_url'],
        links: WpFeaturedmediaLinks.fromJson(json['_links']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'slug': slug,
        'type': type,
        'link': link,
        'title': title.toJson(),
        'author': author,
        'caption': caption.toJson(),
        'alt_text': altText,
        'media_type': mediaType,
        'mime_type': mimeType,
        'media_details': mediaDetails.toJson(),
        'source_url': sourceUrl,
        '_links': links.toJson(),
      };
}

class Title {
  Title({
    this.rendered,
  });

  final String rendered;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        rendered: json['rendered'],
      );

  Map<String, dynamic> toJson() => {
        'rendered': rendered,
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

  final List<About> self;
  final List<About> collection;
  final List<About> about;
  final List<ReplyElement> author;
  final List<ReplyElement> replies;

  factory WpFeaturedmediaLinks.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmediaLinks(
        self: List<About>.from(json['self'].map((x) => About.fromJson(x))),
        collection:
            List<About>.from(json['collection'].map((x) => About.fromJson(x))),
        about: List<About>.from(json['about'].map((x) => About.fromJson(x))),
        author: List<ReplyElement>.from(
            json['author'].map((x) => ReplyElement.fromJson(x))),
        replies: List<ReplyElement>.from(
            json['replies'].map((x) => ReplyElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'self': List<dynamic>.from(self.map((x) => x.toJson())),
        'collection': List<dynamic>.from(collection.map((x) => x.toJson())),
        'about': List<dynamic>.from(about.map((x) => x.toJson())),
        'author': List<dynamic>.from(author.map((x) => x.toJson())),
        'replies': List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class About {
  About({
    this.href,
  });

  final String href;

  factory About.fromJson(Map<String, dynamic> json) => About(
        href: json['href'],
      );

  Map<String, dynamic> toJson() => {
        'href': href,
      };
}

class ReplyElement {
  ReplyElement({
    this.embeddable,
    this.href,
  });

  final bool embeddable;
  final String href;

  factory ReplyElement.fromJson(Map<String, dynamic> json) => ReplyElement(
        embeddable: json['embeddable'],
        href: json['href'],
      );

  Map<String, dynamic> toJson() => {
        'embeddable': embeddable,
        'href': href,
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

  final int width;
  final int height;
  final String file;
  final Sizes sizes;
  final ImageMeta imageMeta;
  final Optimus optimus;

  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
        width: json['width'],
        height: json['height'],
        file: json['file'],
        sizes: Sizes.fromJson(json['sizes']),
        imageMeta: ImageMeta.fromJson(json['image_meta']),
        optimus: Optimus.fromJson(json['optimus']),
      );

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'file': file,
        'sizes': sizes.toJson(),
        'image_meta': imageMeta.toJson(),
        'optimus': optimus.toJson(),
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
        aperture: json['aperture'],
        credit: json['credit'],
        camera: json['camera'],
        caption: json['caption'],
        createdTimestamp: json['created_timestamp'],
        copyright: json['copyright'],
        focalLength: json['focal_length'],
        iso: json['iso'],
        shutterSpeed: json['shutter_speed'],
        title: json['title'],
        orientation: json['orientation'],
        keywords: List<String>.from(json['keywords'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'aperture': aperture,
        'credit': credit,
        'camera': camera,
        'caption': caption,
        'created_timestamp': createdTimestamp,
        'copyright': copyright,
        'focal_length': focalLength,
        'iso': iso,
        'shutter_speed': shutterSpeed,
        'title': title,
        'orientation': orientation,
        'keywords': List<dynamic>.from(keywords.map((x) => x)),
      };
}

class Optimus {
  Optimus({
    this.profit,
    this.quantity,
    this.webp,
  });

  final String profit;
  final int quantity;
  final int webp;

  factory Optimus.fromJson(Map<String, dynamic> json) => Optimus(
        profit: json['profit'],
        quantity: json['quantity'],
        webp: json['webp'],
      );

  Map<String, dynamic> toJson() => {
        'profit': profit,
        'quantity': quantity,
        'webp': webp,
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

  final CrpThumbnail medium;
  final CrpThumbnail large;
  final CrpThumbnail thumbnail;
  final CrpThumbnail mediumLarge;
  final CrpThumbnail sidebarFeatured;
  final CrpThumbnail homePost;
  final CrpThumbnail crpThumbnail;
  final CrpThumbnail full;

  factory Sizes.fromJson(Map<String, dynamic> json) => Sizes(
        medium: CrpThumbnail.fromJson(json['medium']),
        large:
            json['large'] == null ? null : CrpThumbnail.fromJson(json['large']),
        thumbnail: CrpThumbnail.fromJson(json['thumbnail']),
        mediumLarge: json['medium_large'] == null
            ? null
            : CrpThumbnail.fromJson(json['medium_large']),
        sidebarFeatured: CrpThumbnail.fromJson(json['sidebar-featured']),
        homePost: json['home-post'] == null
            ? null
            : CrpThumbnail.fromJson(json['home-post']),
        crpThumbnail: CrpThumbnail.fromJson(json['crp_thumbnail']),
        full: CrpThumbnail.fromJson(json['full']),
      );

  Map<String, dynamic> toJson() => {
        'medium': medium.toJson(),
        'large': large == null ? null : large.toJson(),
        'thumbnail': thumbnail.toJson(),
        'medium_large': mediumLarge == null ? null : mediumLarge.toJson(),
        'sidebar-featured': sidebarFeatured.toJson(),
        'home-post': homePost == null ? null : homePost.toJson(),
        'crp_thumbnail': crpThumbnail.toJson(),
        'full': full.toJson(),
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

  final String file;
  final int width;
  final int height;
  final String mimeType;
  final String sourceUrl;

  factory CrpThumbnail.fromJson(Map<String, dynamic> json) => CrpThumbnail(
        file: json['file'],
        width: json['width'],
        height: json['height'],
        mimeType: json['mime_type'],
        sourceUrl: json['source_url'],
      );

  Map<String, dynamic> toJson() => {
        'file': file,
        'width': width,
        'height': height,
        'mime_type': mimeType,
        'source_url': sourceUrl,
      };
}

class EmbeddedWpTerm {
  EmbeddedWpTerm({
    this.id,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.links,
  });

  final int id;
  final String link;
  final String name;
  final String slug;
  final String taxonomy;
  final WpTermLinks links;

  factory EmbeddedWpTerm.fromJson(Map<String, dynamic> json) => EmbeddedWpTerm(
        id: json['id'],
        link: json['link'],
        name: json['name'],
        slug: json['slug'],
        taxonomy: json['taxonomy'],
        links: WpTermLinks.fromJson(json['_links']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'link': link,
        'name': name,
        'slug': slug,
        'taxonomy': taxonomy,
        '_links': links.toJson(),
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

  final List<About> self;
  final List<About> collection;
  final List<About> about;
  final List<About> wpPostType;
  final List<Cury> curies;

  factory WpTermLinks.fromJson(Map<String, dynamic> json) => WpTermLinks(
        self: List<About>.from(json['self'].map((x) => About.fromJson(x))),
        collection:
            List<About>.from(json['collection'].map((x) => About.fromJson(x))),
        about: List<About>.from(json['about'].map((x) => About.fromJson(x))),
        wpPostType: List<About>.from(
            json['wp:post_type'].map((x) => About.fromJson(x))),
        curies: List<Cury>.from(json['curies'].map((x) => Cury.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'self': List<dynamic>.from(self.map((x) => x.toJson())),
        'collection': List<dynamic>.from(collection.map((x) => x.toJson())),
        'about': List<dynamic>.from(about.map((x) => x.toJson())),
        'wp:post_type': List<dynamic>.from(wpPostType.map((x) => x.toJson())),
        'curies': List<dynamic>.from(curies.map((x) => x.toJson())),
      };
}

class Cury {
  Cury({
    this.name,
    this.href,
    this.templated,
  });

  final String name;
  final String href;
  final bool templated;

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
        name: json['name'],
        href: json['href'],
        templated: json['templated'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'href': href,
        'templated': templated,
      };
}

class Guid {
  Guid({
    this.rendered,
  });

  final String rendered;

  factory Guid.fromJson(Map<String, dynamic> json) => Guid(
        rendered: json['rendered'],
      );

  Map<String, dynamic> toJson() => {
        'rendered': rendered,
      };
}

class PostLinks {
  PostLinks({
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
    this.versionHistory,
    this.wpFeaturedmedia,
    this.wpAttachment,
    this.wpTerm,
    this.curies,
  });

  final List<About> self;
  final List<About> collection;
  final List<About> about;
  final List<ReplyElement> author;
  final List<ReplyElement> replies;
  final List<VersionHistory> versionHistory;
  final List<ReplyElement> wpFeaturedmedia;
  final List<About> wpAttachment;
  final List<LinksWpTerm> wpTerm;
  final List<Cury> curies;

  factory PostLinks.fromJson(Map<String, dynamic> json) => PostLinks(
        self: List<About>.from(json['self'].map((x) => About.fromJson(x))),
        collection:
            List<About>.from(json['collection'].map((x) => About.fromJson(x))),
        about: List<About>.from(json['about'].map((x) => About.fromJson(x))),
        author: List<ReplyElement>.from(
            json['author'].map((x) => ReplyElement.fromJson(x))),
        replies: List<ReplyElement>.from(
            json['replies'].map((x) => ReplyElement.fromJson(x))),
        versionHistory: List<VersionHistory>.from(
            json['version-history'].map((x) => VersionHistory.fromJson(x))),
        wpFeaturedmedia: json['wp:featuredmedia'] == null
            ? null
            : List<ReplyElement>.from(
                json['wp:featuredmedia'].map((x) => ReplyElement.fromJson(x))),
        wpAttachment: List<About>.from(
            json['wp:attachment'].map((x) => About.fromJson(x))),
        wpTerm: List<LinksWpTerm>.from(
            json['wp:term'].map((x) => LinksWpTerm.fromJson(x))),
        curies: List<Cury>.from(json['curies'].map((x) => Cury.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'self': List<dynamic>.from(self.map((x) => x.toJson())),
        'collection': List<dynamic>.from(collection.map((x) => x.toJson())),
        'about': List<dynamic>.from(about.map((x) => x.toJson())),
        'author': List<dynamic>.from(author.map((x) => x.toJson())),
        'replies': List<dynamic>.from(replies.map((x) => x.toJson())),
        'version-history':
            List<dynamic>.from(versionHistory.map((x) => x.toJson())),
        'wp:featuredmedia': wpFeaturedmedia == null
            ? null
            : List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
        'wp:attachment':
            List<dynamic>.from(wpAttachment.map((x) => x.toJson())),
        'wp:term': List<dynamic>.from(wpTerm.map((x) => x.toJson())),
        'curies': List<dynamic>.from(curies.map((x) => x.toJson())),
      };
}

class VersionHistory {
  VersionHistory({
    this.count,
    this.href,
  });

  final int count;
  final String href;

  factory VersionHistory.fromJson(Map<String, dynamic> json) => VersionHistory(
        count: json['count'],
        href: json['href'],
      );

  Map<String, dynamic> toJson() => {
        'count': count,
        'href': href,
      };
}

class LinksWpTerm {
  LinksWpTerm({
    this.taxonomy,
    this.embeddable,
    this.href,
  });

  final String taxonomy;
  final bool embeddable;
  final String href;

  factory LinksWpTerm.fromJson(Map<String, dynamic> json) => LinksWpTerm(
        taxonomy: json['taxonomy'],
        embeddable: json['embeddable'],
        href: json['href'],
      );

  Map<String, dynamic> toJson() => {
        'taxonomy': taxonomy,
        'embeddable': embeddable,
        'href': href,
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

  final bool genesisHideTitle;
  final bool genesisHideBreadcrumbs;
  final bool genesisHideSingularImage;
  final bool genesisHideFooterWidgets;
  final String genesisCustomBodyClass;
  final String genesisCustomPostClass;
  final String genesisLayout;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        genesisHideTitle: json['_genesis_hide_title'],
        genesisHideBreadcrumbs: json['_genesis_hide_breadcrumbs'],
        genesisHideSingularImage: json['_genesis_hide_singular_image'],
        genesisHideFooterWidgets: json['_genesis_hide_footer_widgets'],
        genesisCustomBodyClass: json['_genesis_custom_body_class'],
        genesisCustomPostClass: json['_genesis_custom_post_class'],
        genesisLayout: json['_genesis_layout'],
      );

  Map<String, dynamic> toJson() => {
        '_genesis_hide_title': genesisHideTitle,
        '_genesis_hide_breadcrumbs': genesisHideBreadcrumbs,
        '_genesis_hide_singular_image': genesisHideSingularImage,
        '_genesis_hide_footer_widgets': genesisHideFooterWidgets,
        '_genesis_custom_body_class': genesisCustomBodyClass,
        '_genesis_custom_post_class': genesisCustomPostClass,
        '_genesis_layout': genesisLayout,
      };
}
