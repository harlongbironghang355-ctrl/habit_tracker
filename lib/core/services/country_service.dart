import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryService {
  static Future<List<String>> fetchCountries() async {
    final response = await http.get(
      Uri.parse(
        'https://countriesnow.space/api/v0.1/countries',
      ),
    );

    print("STATUS CODE: ${response.statusCode}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded =
          jsonDecode(response.body);

      final List<dynamic> data = decoded['data'];

      List<String> countries = data
          .map((country) => country['country'].toString())
          .toList();

      countries.sort();

      return countries;
    } else {
      throw Exception(
        "Failed to load countries: ${response.statusCode}",
      );
    }
  }
}