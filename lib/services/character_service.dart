import 'package:dio/dio.dart';

class CharacterService {
  final Dio _dio = Dio();
  Future<List<dynamic>> getAllCharacters() async {
    try {
      final response = await _dio.get("https://rickandmortyapi.com/api/character");
      return response.data["results"];
    } catch (e) {
      throw Exception("Failed to fetch characters: $e");
    }
  }
}