import 'dart:convert';

import 'package:http/http.dart' as http;

class LanguageApi {
  List<dynamic>?languages;
  final String baseUrl =
      'https://google-translate1.p.rapidapi.com/language/translate/v2';

  Future<List<dynamic>?> getLanguages() async {
    final Map<String, String> headers = {
      'Accept-Encoding': 'application/gzip',
      'X-RapidAPI-Key': 'd1b59db60emsh209f335da640aebp1423edjsn052df688bc78',
      'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
    };

    final response = await http.get(Uri.parse('$baseUrl/languages'),
        headers: headers); 
     print(response.statusCode);   // Replace with your API endpoint
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      languages = responseData?['data']['languages'];
      return languages;

    } else {
      throw Exception('Failed to fetch languages');
    }
  }
}
