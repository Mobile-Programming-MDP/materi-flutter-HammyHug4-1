//8b6169c2e3df18eac2a12de5d12c6315
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '8b6169c2e3df18eac2a12de5d12c6315';

  // 1. Mengambil daftar film yang tayang saat ini
  Future<List<Map<String, dynamic>>> getAllMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // 2. Mengambil List movie yang trending minggu ini
  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  // 3. Mengambil list pupular movie
  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // 4. Mengambil list movie melalui pencarian
  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/movie?query=$query&api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to search movies');
    }
  }
}