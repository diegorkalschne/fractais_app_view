import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/fractal_param_model.dart';

class MandelbrotRepository {
  static Future<File> generateImage(FractalParamModel config) async {
    Map params = {
      'xmin': config.xMin.toStringAsFixed(2),
      'xmax': config.xMax.toStringAsFixed(2),
      'ymin': config.yMin.toStringAsFixed(2),
      'ymax': config.yMax.toStringAsFixed(2),
      'interactions': config.interactionsFactor.toInt(),
      'zoom': config.zoomFactor.toStringAsFixed(2),
      'type': config.type.name,
      'real_part': config.juliaRealPart.toStringAsFixed(3),
      'imag_part': config.juliaImagPart.toStringAsFixed(3),
    };

    const endpoint = 'https://e3a0-45-236-134-211.ngrok-free.app/process';

    final dio = Dio();
    (dio.httpClientAdapter = IOHttpClientAdapter()).createHttpClient = () {
      HttpClient client = HttpClient();

      client.badCertificateCallback = (cert, host, port) => true;
      client.idleTimeout = const Duration(seconds: 60);
      client.connectionTimeout = const Duration(minutes: 2);

      return client;
    };

    final temp = await getTemporaryDirectory();

    final file = File('${temp.path}/${config.type.name}_${DateTime.now().millisecondsSinceEpoch}.png');

    final response = await dio.download(
      endpoint,
      file.path,
      queryParameters: params.cast(),
    );

    if (response.statusCode == 200) {
      return file;
    }

    throw 'Error on request. Status code: ${response.statusCode}';
  }

  static Future<List<int>> downloadHttp({
    required String url,
    http.MultipartFile? file,
    Map? body,
    Map? headers,
    String? method = 'GET',
  }) async {
    String urlRequest;
    urlRequest = url;

    dynamic request;
    if (file != null) {
      request = http.MultipartRequest(method!, Uri.parse(urlRequest));
      request.files.add(file);
    } else {
      request = http.Request(method!, Uri.parse(urlRequest));
    }

    if (request is http.Request) {
      if (body != null) {
        request.bodyFields.addAll(body.cast());
      }
    } else if (request is http.MultipartRequest) {
      if (body != null) {
        request.fields.addAll(body.cast());
      }
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List<int> bytes = [];
      var st = response.stream.listen((value) {
        bytes.addAll(value);
      });

      await st.asFuture();
      return bytes;
    } else {
      throw ("Não foi possível completar a requisição");
    }
  }
}
