import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/tesla_auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _clientIdController = TextEditingController(text: 'ownerapi');
  final _redirectUriController = TextEditingController(text: 'https://tuo-dominio.com/callback');
  final _scopeController = TextEditingController(text: 'openid email offline_access');
  
  String? _generatedUrl;
  final TeslaAuthService _authService = TeslaAuthService();

  @override
  void dispose() {
    _clientIdController.dispose();
    _redirectUriController.dispose();
    _scopeController.dispose();
    super.dispose();
  }

  void _generateLoginUrl() {
    final url = _authService.generateLoginUrl(
      clientId: _clientIdController.text,
      redirectUri: _redirectUriController.text,
      scope: _scopeController.text,
    );
    
    setState(() {
      _generatedUrl = url;
    });
  }

  Future<void> _launchUrl() async {
    if (_generatedUrl != null) {
      final uri = Uri.parse(_generatedUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impossibile aprire l\'URL')),
          );
        }
      }
    }
  }

  void _copyToClipboard() {
    if (_generatedUrl != null) {
      Clipboard.setData(ClipboardData(text: _generatedUrl!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL copiato negli appunti')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tesla Connector'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.electric_car, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Benvenuto nel Tesla Connector!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Genera un URL di login Tesla per l\'autenticazione OAuth2',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configurazione OAuth2',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _clientIdController,
                      decoration: const InputDecoration(
                        labelText: 'Client ID',
                        border: OutlineInputBorder(),
                        helperText: 'ID client per l\'API Tesla',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _redirectUriController,
                      decoration: const InputDecoration(
                        labelText: 'Redirect URI',
                        border: OutlineInputBorder(),
                        helperText: 'URL di callback dopo l\'autenticazione',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _scopeController,
                      decoration: const InputDecoration(
                        labelText: 'Scope',
                        border: OutlineInputBorder(),
                        helperText: 'Permessi richiesti',
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _generateLoginUrl,
                        icon: const Icon(Icons.link),
                        label: const Text('Genera URL di Login'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_generatedUrl != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'URL di Login Generato',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: SelectableText(
                          _generatedUrl!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _launchUrl,
                              icon: const Icon(Icons.open_in_browser),
                              label: const Text('Apri nel Browser'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _copyToClipboard,
                              icon: const Icon(Icons.copy),
                              label: const Text('Copia URL'),
                            ),
                          ),
                        ],
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
}