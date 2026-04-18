import 'package:dio/dio.dart';

class CharacterService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchCharacters() async {
    try {
      final response = await _dio.get(
        '',
      );
      return response.data['result'];
    } catch(e) {
      throw Exception("Failed to load characters");
    }
  }
}