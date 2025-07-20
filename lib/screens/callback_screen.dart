import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/tesla_auth_service.dart';

class CallbackScreen extends StatefulWidget {
  final String callbackUrl;
  
  const CallbackScreen({
    super.key,
    required this.callbackUrl,
  });

  @override
  State<CallbackScreen> createState() => _CallbackScreenState();
}

class _CallbackScreenState extends State<CallbackScreen> {
  final TeslaAuthService _authService = TeslaAuthService();
  String? _authCode;
  String? _state;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  void _processCallback() {
    try {
      final uri = Uri.parse(widget.callbackUrl);
      
      if (uri.queryParameters.containsKey('error')) {
        setState(() {
          _error = uri.queryParameters['error'] ?? 'Errore sconosciuto';
        });
        return;
      }

      final authCode = _authService.extractAuthCodeFromUrl(widget.callbackUrl);
      final state = _authService.extractStateFromUrl(widget.callbackUrl);

      setState(() {
        _authCode = authCode;
        _state = state;
      });
    } catch (e) {
      setState(() {
        _error = 'Errore nel processare l\'URL di callback: $e';
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copiato negli appunti')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Callback OAuth2'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _error != null 
                          ? Icons.error 
                          : Icons.check_circle,
                      size: 64,
                      color: _error != null 
                          ? Colors.red 
                          : Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _error != null 
                          ? 'Errore di Autenticazione' 
                          : 'Autenticazione Completata!',
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error != null 
                          ? 'Si è verificato un errore durante l\'autenticazione.'
                          : 'Il codice di autorizzazione è stato ricevuto con successo.',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dettagli Errore',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: SelectableText(
                          _error!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_authCode != null) ...[
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Codice di Autorizzazione',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                _authCode!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _copyToClipboard(_authCode!),
                              icon: const Icon(Icons.copy),
                              tooltip: 'Copia codice',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_state != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Parametro State',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                _state!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _copyToClipboard(_state!),
                              icon: const Icon(Icons.copy),
                              tooltip: 'Copia state',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'URL di Callback Completo',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              widget.callbackUrl,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _copyToClipboard(widget.callbackUrl),
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copia URL',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Torna alla Home'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}