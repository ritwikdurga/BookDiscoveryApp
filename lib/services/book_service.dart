import 'package:dio/dio.dart';

class BookService {
  static final Dio _dio = Dio();

  static Future<List<dynamic>> fetchBooks(int page, String query) async {
    try {
      final response = await _dio.get(
        'https://gutendex.com/books/',
        queryParameters: {
          'page': page,
          if (query.isNotEmpty) 'search': query,
        },
      );

      // Check for valid response with results
      if (response.data != null && response.data['results'] != null) {
        return response.data['results'];
      }

      // If the API returns no results, return an empty list
      return [];
    } catch (e) {
      // Handle errors gracefully
      throw Exception('Failed to load books. Please check the API or your connection.');
    }
  }
}
