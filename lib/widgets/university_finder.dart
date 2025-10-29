import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/university_service.dart';
import '../models/university_model.dart';

class UniversityFinder extends StatefulWidget {
  @override
  _UniversityFinderState createState() => _UniversityFinderState();
}

class _UniversityFinderState extends State<UniversityFinder> {
  final TextEditingController _countryController = TextEditingController();
  final UniversityService _universityService = UniversityService();
  List<University> _universities = [];
  bool _isLoading = false;
  String _error = '';

  void _searchUniversities() async {
    if (_countryController.text.isEmpty) {
      setState(() {
        _error = 'Por favor ingresa un país';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
      _universities = [];
    });

    try {
      final universities = await _universityService.getUniversities(_countryController.text);
      setState(() {
        _universities = universities;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchWebsite(String url) async {
    if (url == 'No disponible' || url == 'Sitio web no disponible') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay sitio web disponible para esta universidad')),
      );
      return;
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Universidades'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Ingresa un país en inglés para buscar universidades',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'País (ej: Dominican Republic)',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
                hintText: 'Dominican Republic, United States, etc.',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchUniversities,
              child: _isLoading 
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(width: 10),
                        Text('Buscando...'),
                      ],
                    )
                  : Text('Buscar Universidades'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            if (_error.isNotEmpty)
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            if (_universities.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                '${_universities.length} universidades encontradas en ${_countryController.text}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final university = _universities[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(Icons.school, color: Colors.green),
                        title: Text(
                          university.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              'Sitio web: ${university.website}',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'País: ${university.country}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: university.website != 'No disponible' &&
                                university.website != 'Sitio web no disponible'
                            ? IconButton(
                                icon: Icon(Icons.open_in_new, color: Colors.blue),
                                onPressed: () {
                                  _launchWebsite(university.website);
                                },
                              )
                            : null,
                        onTap: university.website != 'No disponible' &&
                                university.website != 'Sitio web no disponible'
                            ? () {
                                _launchWebsite(university.website);
                              }
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ] else if (!_isLoading && _countryController.text.isNotEmpty && _error.isEmpty) ...[
              SizedBox(height: 40),
              Icon(Icons.school, size: 60, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'No se encontraron universidades para "${_countryController.text}"',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }
}