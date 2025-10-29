import 'package:flutter/material.dart';
import '../services/gender_service.dart';
import '../models/gender_model.dart';

class GenderPredictor extends StatefulWidget {
  @override
  _GenderPredictorState createState() => _GenderPredictorState();
}

class _GenderPredictorState extends State<GenderPredictor> {
  final TextEditingController _nameController = TextEditingController();
  final GenderService _genderService = GenderService();
  GenderPrediction? _prediction;
  bool _isLoading = false;
  String _error = '';

  void _predictGender() async {
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
      final prediction = await _genderService.predictGender(_nameController.text);
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

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[100]!;
    Color primaryColor = Colors.orange[700]!;
    
    if (_prediction != null) {
      if (_prediction!.gender == 'male') {
        backgroundColor = Colors.blue[50]!;
        primaryColor = Colors.blue;
      } else if (_prediction!.gender == 'female') {
        backgroundColor = Colors.pink[50]!;
        primaryColor = Colors.pink;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Predicción de Género'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Ingresa un nombre para predecir el género',
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
                onPressed: _isLoading ? null : _predictGender,
                child: _isLoading 
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Predecir Género'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
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
                          _prediction!.gender == 'male' 
                              ? Icons.male 
                              : _prediction!.gender == 'female' 
                                  ? Icons.female 
                                  : Icons.question_mark,
                          size: 60,
                          color: primaryColor,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Nombre: ${_prediction!.name}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Género: ${_prediction!.gender == 'male' ? 'Masculino' : _prediction!.gender == 'female' ? 'Femenino' : 'Desconocido'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Probabilidad: ${(_prediction!.probability * 100).toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 16),
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
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}