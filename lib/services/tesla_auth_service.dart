import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class TeslaAuthService {
  static const String _baseUrl = 'https://auth.tesla.com/oauth2/v3/authorize';
  
  /// Generates a Tesla OAuth2 login URL with the provided parameters
  String generateLoginUrl({
    required String clientId,
    required String redirectUri,
    required String scope,
    String? state,
  }) {
    final effectiveState = state ?? _generateRandomState();
    
    final params = {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': scope,
      'state': effectiveState,
    };
    
    final queryString = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    return '$_baseUrl?$queryString';
  }
  
  /// Generates a PKCE code verifier for enhanced security
  String generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
  
  /// Generates a PKCE code challenge from the verifier
  String generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }
  
  /// Generates an enhanced OAuth2 URL with PKCE for better security
  String generatePKCELoginUrl({
    required String clientId,
    required String redirectUri,
    required String scope,
    String? state,
  }) {
    final codeVerifier = generateCodeVerifier();
    final codeChallenge = generateCodeChallenge(codeVerifier);
    final effectiveState = state ?? _generateRandomState();
    
    final params = {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': scope,
      'state': effectiveState,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    };
    
    final queryString = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    return '$_baseUrl?$queryString';
  }
  
  /// Extracts authorization code from callback URL
  String? extractAuthCodeFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['code'];
  }
  
  /// Extracts state parameter from callback URL for validation
  String? extractStateFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['state'];
  }
  
  /// Generates a random state parameter for OAuth2 security
  String _generateRandomState() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }
}