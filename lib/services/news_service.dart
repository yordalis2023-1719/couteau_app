import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  // LISTA DE SITIOS WORDPRESS CON API HABILITADA
  static const List<String> wordpressSites = [
    'https://techcrunch.com/wp-json/wp/v2/posts',          // Noticias de tecnología
    'https://wptavern.com/wp-json/wp/v2/posts',            // Comunidad WordPress
    'https://wordpress.org/news/wp-json/wp/v2/posts',      // Noticias oficiales WordPress
    'https://es.wordpress.org/news/wp-json/wp/v2/posts',   // WordPress en español
  ];

  int _currentSiteIndex = 0;
  bool _isRealData = true;

  Future<List<NewsArticle>> getWordPressNews() async {
    // Intentar con cada sitio hasta que uno funcione
    for (int i = 0; i < wordpressSites.length; i++) {
      _currentSiteIndex = i;
      try {
        final news = await _fetchNewsFromSite(wordpressSites[i]);
        if (news.isNotEmpty) {
          _isRealData = true;
          return news;
        }
      } catch (e) {
        print('Error con sitio ${wordpressSites[i]}: $e');
        continue;
      }
    }
    
    // Si ningún sitio funciona, usar datos de ejemplo
    _isRealData = false;
    return _getExampleNews();
  }

  Future<List<NewsArticle>> _fetchNewsFromSite(String siteUrl) async {
    final response = await http.get(
      Uri.parse('$siteUrl?per_page=3&_embed&_fields=id,title,excerpt,link,date,_links,_embedded')
    ).timeout(Duration(seconds: 10));
    
    print('News API: $siteUrl - Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data.map((json) => NewsArticle.fromJson(json)).toList();
      }
    }
    
    throw Exception('No data from $siteUrl');
  }

  String getCurrentSiteName() {
    final url = wordpressSites[_currentSiteIndex];
    if (url.contains('techcrunch')) return 'TechCrunch';
    if (url.contains('wptavern')) return 'WP Tavern';
    if (url.contains('wordpress.org/news')) return 'WordPress News';
    if (url.contains('es.wordpress.org')) return 'WordPress Español';
    return 'WordPress Site';
  }

  bool get isRealData => _isRealData;

  List<NewsArticle> _getExampleNews() {
    return [
      NewsArticle(
        title: 'Flutter 3.0 Liberado con Soporte Estable para Windows',
        excerpt: 'Google anuncia Flutter 3.0 con soporte nativo para Windows, macOS y Linux, expandiendo las capacidades cross-platform del framework.',
        link: 'https://flutter.dev/whats-new#flutter-30',
        date: DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
      ),
      NewsArticle(
        title: 'WordPress 6.4 "Shirley" Mejora la Experiencia del Editor',
        excerpt: 'La última versión de WordPress introduce mejoras significativas en el editor Gutenberg y nuevas herramientas de diseño para creadores de contenido.',
        link: 'https://wordpress.org/news/2023/11/shirley/',
        date: DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
      ),
      NewsArticle(
        title: 'Tendencias en Desarrollo Mobile para 2024',
        excerpt: 'Análisis de las tecnologías y frameworks que dominarán el desarrollo de aplicaciones móviles el próximo año, incluyendo Flutter y React Native.',
        link: 'https://developer.android.com/',
        date: DateTime.now().subtract(Duration(days: 7)).toIso8601String(),
      ),
    ];
  }
}