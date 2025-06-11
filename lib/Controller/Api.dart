import 'dart:convert';
import 'dart:io';

import '../utils/support.dart';

enum UrlRequest { POST, PUT, GET, DELETE }

Future<String> apiRequest(
  String urlPassed,
  Map<String, dynamic> jsonMap,
  UrlRequest type,
) async {
  final localServer = "http://192.168.10.16:4501$urlPassed";
  final fallbackServer =
      "http://attivacostruzioni.marconisoftware.com:4501$urlPassed"; // 🔁 Sostituisci con il tuo IP pubblico

  Future<String> makeRequest(String url) async {
    print(url);
    final uri = Uri.parse(url);
    final httpClient = HttpClient();
    HttpClientRequest request;

    switch (type) {
      case UrlRequest.POST:
        request = await httpClient.postUrl(uri);
        break;
      case UrlRequest.PUT:
        request = await httpClient.putUrl(uri);
        break;
      case UrlRequest.GET:
        request = await httpClient.getUrl(uri);
        break;
      case UrlRequest.DELETE:
        request = await httpClient.deleteUrl(uri);
        break;
    }

    print(jsonMap);
    request.headers.contentType = ContentType.json;
    request.add(utf8.encode(json.encode(jsonMap)));

    final response = await request.close();

    if (response.statusCode == HttpStatus.unauthorized) {
      Log.error("Errore di autenticazione: ${response.statusCode}");
      return "error";
    }

    final reply = await response.transform(utf8.decoder).join();
    return reply;
  }

  print("sono qui");
  try {
    return await makeRequest(localServer);
  } catch (e1) {
    print("IP locale non raggiungibile: $e1. Provo con l'IP pubblico...");
    try {
      return await makeRequest(fallbackServer);
    } catch (e2, stackTrace) {
      print("Errore con l'IP pubblico: $e2\n$stackTrace");
      return "error";
    }
  } finally {
    HttpClient().close();
  }
}

bool parseSingleJson(String value) {
  final valueMap = json.decode(value) as Map<String, dynamic>;
  final parsed = valueMap['return'];

  if (parsed is bool) {
    return parsed;
  } else if (parsed is String) {
    return parsed.toLowerCase() == 'true';
  } else {
    return false;
  }
}

String parseSingleJsonToString(String value) {
  final valueMap = json.decode(value) as Map<String, dynamic>;
  final parsed = valueMap['return'];
  return parsed;
}
