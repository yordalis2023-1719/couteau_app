class NewsArticle {
  final String title;
  final String excerpt;
  final String link;
  final String date;
  final String? featuredImage;
  final String siteName;

  NewsArticle({
    required this.title,
    required this.excerpt,
    required this.link,
    required this.date,
    this.featuredImage,
    this.siteName = 'WordPress',
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    
    String title = 'Sin título';
    if (json['title'] is Map && json['title']['rendered'] != null) {
      title = _cleanHtml(json['title']['rendered']);
    } else if (json['title'] is String) {
      title = json['title'];
    }

    
    String excerpt = 'No hay descripción disponible.';
    if (json['excerpt'] is Map && json['excerpt']['rendered'] != null) {
      excerpt = _cleanHtml(json['excerpt']['rendered']);
      if (excerpt.isEmpty) {
        excerpt = 'Lee la noticia completa para más información.';
      }
    }

    String? featuredImage;
    if (json['_embedded'] != null && 
        json['_embedded']['wp:featuredmedia'] != null &&
        json['_embedded']['wp:featuredmedia'].isNotEmpty) {
      featuredImage = json['_embedded']['wp:featuredmedia'][0]['source_url'];
    }

    String siteName = 'WordPress';
    final link = json['link'] ?? '';
    if (link.contains('techcrunch')) siteName = 'TechCrunch';
    else if (link.contains('wptavern')) siteName = 'WP Tavern';
    else if (link.contains('wordpress.org')) siteName = 'WordPress News';

    return NewsArticle(
      title: title,
      excerpt: excerpt,
      link: link,
      date: json['date'] ?? DateTime.now().toIso8601String(),
      featuredImage: featuredImage,
      siteName: siteName,
    );
  }

  static String _cleanHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&#8217;', "'")
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#8230;', '...')
        .replaceAll('&amp;', '&')
        .replaceAll('&hellip;', '...')
        .replaceAll('[&hellip;]', '...')
        .trim();
  }

  String getFormattedDate() {
    try {
      final dateTime = DateTime.parse(date);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return 'Hoy';
      } else if (difference.inDays == 1) {
        return 'Ayer';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays} días';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return date;
    }
  }
}
