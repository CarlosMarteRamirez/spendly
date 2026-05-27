import 'dart:convert';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;

/// Reads bank notification emails via Gmail API (user must sign in).
class GmailService {
  GmailService({GoogleSignIn? signIn})
    : _signIn =
          signIn ??
          GoogleSignIn(
            scopes: const [gmail.GmailApi.gmailReadonlyScope],
          );

  final GoogleSignIn _signIn;

  Future<bool> get isSignedIn => _signIn.isSignedIn();

  Future<void> signIn() async {
    await _signIn.signIn();
    final granted = await _signIn.requestScopes(
      const [gmail.GmailApi.gmailReadonlyScope],
    );
    if (!granted) {
      throw StateError('Gmail permission was not granted.');
    }
  }

  Future<void> ensureSignedIn() async {
    final account = _signIn.currentUser ?? await _signIn.signInSilently();
    if (account == null) {
      await signIn();
      return;
    }
    final granted = await _signIn.requestScopes(
      const [gmail.GmailApi.gmailReadonlyScope],
    );
    if (!granted) {
      throw StateError('Gmail permission was not granted.');
    }
  }

  Future<void> signOut() async {
    await _signIn.signOut();
  }

  /// Fetches recent messages from configured bank senders.
  Future<List<GmailBankMessage>> fetchBankMessages({
    required List<String> senderFilters,
    int maxResults = 25,
  }) async {
    final account = _signIn.currentUser ?? await _signIn.signInSilently();
    if (account == null) {
      throw StateError('Sign in to Gmail first.');
    }
    final granted = await _signIn.requestScopes(
      const [gmail.GmailApi.gmailReadonlyScope],
    );
    if (!granted) {
      throw StateError('Missing Gmail read permission (gmail.readonly).');
    }

    final client = await _signIn.authenticatedClient();
    if (client == null) {
      throw StateError('Could not authenticate with Gmail.');
    }

    final api = gmail.GmailApi(client);
    final query = _buildQuery(senderFilters);
    final list = await api.users.messages.list(
      'me',
      q: query,
      maxResults: maxResults,
    );

    final messages = <GmailBankMessage>[];
    for (final ref in list.messages ?? const []) {
      final id = ref.id;
      if (id == null) continue;

      final full = await api.users.messages.get(
        'me',
        id,
        format: 'full',
      );
      final payload = _decodeMessage(full);
      if (payload.body.trim().isEmpty && payload.subject.trim().isEmpty) {
        continue;
      }
      messages.add(payload);
    }
    return messages;
  }

  String _buildQuery(List<String> senderFilters) {
    if (senderFilters.isEmpty) {
      return 'newer_than:30d';
    }
    final fromClause = senderFilters
        .map((f) {
          final trimmed = f.trim();
          if (trimmed.contains('@')) {
            return 'from:$trimmed';
          }
          return 'from:*@$trimmed';
        })
        .join(' OR ');
    return '($fromClause) newer_than:30d';
  }

  GmailBankMessage _decodeMessage(gmail.Message message) {
    final headers = message.payload?.headers ?? const [];
    String? subject;
    String? from;
    for (final h in headers) {
      if (h.name?.toLowerCase() == 'subject') {
        subject = h.value;
      }
      if (h.name?.toLowerCase() == 'from') {
        from = h.value;
      }
    }

    final body = _extractBody(message.payload);
    return GmailBankMessage(
      id: message.id ?? '',
      subject: subject ?? '',
      from: from ?? '',
      body: body,
    );
  }

  String _extractBody(gmail.MessagePart? part) {
    if (part == null) return '';

    if (part.body?.data != null) {
      return _decodeBase64(part.body!.data!);
    }

    final parts = part.parts ?? const [];
    final buffer = StringBuffer();
    for (final child in parts) {
      final mime = child.mimeType?.toLowerCase() ?? '';
      if (mime.contains('text/plain') || mime.contains('text/html')) {
        buffer.writeln(_extractBody(child));
      }
    }
    return buffer.toString();
  }

  String _decodeBase64(String data) {
    final normalized = data.replaceAll('-', '+').replaceAll('_', '/');
    return utf8.decode(base64.decode(normalized));
  }
}

class GmailBankMessage {
  const GmailBankMessage({
    required this.id,
    required this.subject,
    required this.from,
    required this.body,
  });

  final String id;
  final String subject;
  final String from;
  final String body;
}
