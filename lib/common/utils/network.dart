import 'dart:convert';
import 'dart:io';

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
}
