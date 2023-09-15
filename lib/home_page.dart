import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:language_assignment/components/bottom_sheet.dart';
import 'package:language_assignment/services/api.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedSourceLanguage = 'Select Source Language';
  String selectedTargetLanguage = 'Select Target Language';
  String inputText = '';
  String translatedText = '';
  final TextEditingController _langTranslate = TextEditingController();
  Map<String, dynamic>? responseData;

  void detectLanguage() async {
    String Url =
        'https://google-translate1.p.rapidapi.com/language/translate/v2/detect';

    final Map<String, String> headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'Accept-Encoding': 'application/gzip',
      'X-RapidAPI-Key': 'd1b59db60emsh209f335da640aebp1423edjsn052df688bc78',
      'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com',
    };

    final Map<String, String> requestBody = {
      'q': 'English is hard, but detectably so',
    };

    final response = await http.post(
      Uri.parse(Url),
      headers: headers,
      body: requestBody,
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      print(decodedData);
    } else {
      print('Failed to detect language');
    }
  }

  void translateLanguage() async {
    String Url =
        'https://google-translate1.p.rapidapi.com/language/translate/v2';

    final Map<String, String> headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'Accept-Encoding': 'application/gzip',
      'X-RapidAPI-Key': 'd1b59db60emsh209f335da640aebp1423edjsn052df688bc78',
      'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
    };

    final Map<String, String> requestBody = {
      'q': 'English is hard, but detectably so',
      'target': 'es',
      'source': 'en'
    };

    final response = await http.post(
      Uri.parse(Url),
      headers: headers,
      body: requestBody,
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      print(decodedData);
    } else {
      print('Failed to translate language');
    }
  }

  void _showLanguageListBottomSheet(bool isSourceLanguage) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return LanguageBottomSheet(
            //onLanguageSelected: (selectedLanguage) {
            // setState(() {
            //   if (isSourceLanguage) {
            //     selectedSourceLanguage = selectedLanguage;
            //   } else {
            //     selectedTargetLanguage = selectedLanguage;
            //   }
            // });
            //Navigator.pop(context);
            // },
            );
      },
    );
  }

  void initState() {
    super.initState();
    detectLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Translate App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              onChanged: (text) {
                // Update the input text
              },
              decoration: InputDecoration(
                labelText: 'Enter Text to Translate',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _showLanguageListBottomSheet(true);
                  },
                  child: Text(selectedSourceLanguage),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showLanguageListBottomSheet(false);
                  },
                  child: Text(selectedTargetLanguage),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                translateLanguage();
              },
              child: Text('Translate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Translated Text:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(translatedText),
          ],
        ),
      ),
    );
  }
}
