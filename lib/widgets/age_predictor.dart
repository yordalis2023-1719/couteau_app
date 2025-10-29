import 'package:flutter/material.dart';
import '../services/age_service.dart';
import '../models/age_model.dart';

class AgePredictor extends StatefulWidget {
  @override
  _AgePredictorState createState() => _AgePredictorState();
}

class _AgePredictorState extends State<AgePredictor> {
  final TextEditingController _nameController = TextEditingController();
  final AgeService _ageService = AgeService();
  AgePrediction? _prediction;
  bool _isLoading = false;
  String _error = '';

  void _predictAge() async {
    if (_nameController.text.isEmpty) {
      setState(() {
        _error = 'Por favor ingresa un nombre';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
      _prediction = null;
    });

    try {
      final prediction = await _ageService.predictAge(_nameController.text);
      setState(() {
        _prediction = prediction;
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

  String _getAgeCategory(int age) {
    if (age < 30) return 'Joven';
    if (age < 60) return 'Adulto';
    return 'Anciano';
  }

  Color _getCategoryColor(int age) {
    if (age < 30) return Colors.green;
    if (age < 60) return Colors.blue;
    return Colors.purple;
  }

  IconData _getCategoryIcon(int age) {
    if (age < 30) return Icons.child_care;
    if (age < 60) return Icons.person;
    return Icons.elderly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predicción de Edad'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Ingresa un nombre para predecir la edad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _predictAge,
              child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Predecir Edad'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            if (_error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            if (_prediction != null) ...[
              SizedBox(height: 30),
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        _getCategoryIcon(_prediction!.age),
                        size: 80,
                        color: _getCategoryColor(_prediction!.age),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Nombre: ${_prediction!.name}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Edad estimada: ${_prediction!.age} años',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(_prediction!.age),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getAgeCategory(_prediction!.age),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Muestras analizadas: ${_prediction!.count}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}