import 'package:dio/dio.dart';

import '../models/ghibli_film.dart';

class StudioGhibliService {
  StudioGhibliService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  static const String _baseUrl = 'https://ghibliapi.vercel.app';

  final Dio _dio;

  Future<List<GhibliFilm>> fetchFilms() async {
    try {
      final response = await _dio.get<List<dynamic>>('/films');
      final data = response.data;
      if (data == null) {
        throw Exception('Server Studio Ghibli mengembalikan respons kosong.');
      }

      return data
          .map((item) => GhibliFilm.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = error.response?.data ?? error.message;
      throw Exception(
        'Gagal mengambil film Studio Ghibli'
        '${statusCode != null ? ' (status $statusCode)' : ''}. Detail: $message',
      );
    }
  }
}
