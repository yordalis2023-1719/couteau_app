import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/icon/icon.png'),
              backgroundColor: Colors.grey[300],
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading icon: $exception');
              },
              child: Icon(Icons.person, size: 50, color: Colors.grey),
            ),
            
            SizedBox(height: 20),
            
            Text(
              ' Yordalis Herrera', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Matrícula: 2023-1719', 
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Desarrollador Flutter',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            
            SizedBox(height: 30),
            
            
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildContactItem(
                      context,
                      Icons.email,
                      'Email',
                      'herrerayordalis@gmail.com', 
                      Colors.blue,
                      () => _launchEmail(context, 'herrerayordalis@gmail.com'),
                    ),
                    Divider(),
                    _buildContactItem(
                      context,
                      Icons.phone,
                      'Teléfono',
                      '+1 (809) 994-0927', 
                      Colors.green,
                      () => _launchPhone(context, '+18099940927'),
                    ),
                    Divider(),
                    _buildContactItem(
                      context,
                      Icons.link,
                      'GitHub',
                      'https://github.com/yordalis2023-1719', 
                      Colors.purple,
                      () => _launchUrl(context, 'https://github.com/yordalis2023-1719'),
                    ),
                    Divider(),
                    _buildContactItem(
                      context,
                      Icons.work,
                      'LinkedIn',
                      'https://linkedin.com/in/yordalisherrera', 
                      Colors.blue[800]!,
                      () => _launchUrl(context, 'https://linkedin.com/in/yordalisherrera'),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
            
            Text(
              'Couteau - Herramientas Múltiples',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Aplicación desarrollada con Flutter que incluye múltiples herramientas y funcionalidades útiles para demostración de habilidades de desarrollo.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            
      
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Habilidades Técnicas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Dart')),
                        Chip(label: Text('APIs REST')),
                        Chip(label: Text('Firebase')),
                        Chip(label: Text('Git')),
                        Chip(label: Text('UI/UX')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
          
            Text(
              'Versión 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '© 2024 - Todos los derechos reservados',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(Icons.send, color: color),
        onPressed: onTap,
      ),
      onTap: onTap,
    );
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri uri = Uri.parse('mailto:$email?subject=Contacto desde Couteau App&body=Hola, me interesa contactarte...');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnackBar(context, 'No se pudo abrir el email');
    }
  }

  Future<void> _launchPhone(BuildContext context, String phone) async {
    final Uri uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnackBar(context, 'No se pudo realizar la llamada');
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnackBar(context, 'No se pudo abrir el enlace');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
