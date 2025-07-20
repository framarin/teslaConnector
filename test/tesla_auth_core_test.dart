import 'package:test/test.dart';
import '../lib/services/tesla_auth_service.dart';

void main() {
  group('TeslaAuthService Tests', () {
    late TeslaAuthService authService;

    setUp(() {
      authService = TeslaAuthService();
    });

    test('generateLoginUrl should create valid Tesla OAuth URL', () {
      const clientId = 'test_client';
      const redirectUri = 'https://example.com/callback';
      const scope = 'openid email offline_access';
      const state = 'test_state';

      final url = authService.generateLoginUrl(
        clientId: clientId,
        redirectUri: redirectUri,
        scope: scope,
        state: state,
      );

      expect(url, contains('https://auth.tesla.com/oauth2/v3/authorize'));
      expect(url, contains('client_id=test_client'));
      expect(url, contains('redirect_uri=https%3A%2F%2Fexample.com%2Fcallback'));
      expect(url, contains('scope=openid%20email%20offline_access'));
      expect(url, contains('state=test_state'));
      expect(url, contains('response_type=code'));
    });

    test('generateCodeVerifier should create valid PKCE verifier', () {
      final verifier = authService.generateCodeVerifier();
      
      expect(verifier.length, greaterThanOrEqualTo(43));
      expect(verifier.length, lessThanOrEqualTo(128));
      expect(verifier, matches(RegExp(r'^[A-Za-z0-9_-]+$')));
    });

    test('generateCodeChallenge should create valid PKCE challenge', () {
      const verifier = 'test_verifier_12345';
      final challenge = authService.generateCodeChallenge(verifier);
      
      expect(challenge.length, equals(43));
      expect(challenge, matches(RegExp(r'^[A-Za-z0-9_-]+$')));
    });

    test('extractAuthCodeFromUrl should extract code from callback URL', () {
      const callbackUrl = 'https://example.com/callback?code=auth_code_123&state=test_state';
      final code = authService.extractAuthCodeFromUrl(callbackUrl);
      
      expect(code, equals('auth_code_123'));
    });

    test('extractStateFromUrl should extract state from callback URL', () {
      const callbackUrl = 'https://example.com/callback?code=auth_code_123&state=test_state';
      final state = authService.extractStateFromUrl(callbackUrl);
      
      expect(state, equals('test_state'));
    });

    test('extractAuthCodeFromUrl should return null for invalid URL', () {
      const invalidUrl = 'https://example.com/callback?error=access_denied';
      final code = authService.extractAuthCodeFromUrl(invalidUrl);
      
      expect(code, isNull);
    });

    test('generatePKCELoginUrl should include PKCE parameters', () {
      const clientId = 'test_client';
      const redirectUri = 'https://example.com/callback';
      const scope = 'openid email offline_access';

      final url = authService.generatePKCELoginUrl(
        clientId: clientId,
        redirectUri: redirectUri,
        scope: scope,
      );

      expect(url, contains('code_challenge='));
      expect(url, contains('code_challenge_method=S256'));
      expect(url, contains('https://auth.tesla.com/oauth2/v3/authorize'));
    });
  });
}