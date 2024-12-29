import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

abstract final class Network {
  static Future<String?> downloadFile(String url) {
    final client = HttpClient();
    return client
        .getUrl(Uri.parse(url))
        .then((value) => value.close())
        .then(
          (value) => value.statusCode == 200
              ? value.transform(utf8.decoder).join()
              : Future.value(null),
        )
        .whenComplete(client.close);
  }

  static Future<Uint8List?> downloadBytes(String url) {
    final client = HttpClient();

    Future<Uint8List?> parseResponse(HttpClientResponse value) {
      if (value.statusCode != 200) return Future.value(null);
      return value
          .toList()
          .then((value) => value.expand((l) => l))
          .then((value) => Uint8List.fromList(value.toList()));
    }

    return client
        .getUrl(Uri.parse(url))
        .then((value) => value.close())
        .then(parseResponse)
        .whenComplete(client.close);
  }
}
