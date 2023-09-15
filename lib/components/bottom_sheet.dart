import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:language_assignment/services/api.dart';
import 'package:http/http.dart' as http;

class LanguageBottomSheet extends StatefulWidget {
  //final Function(String) onLanguageSelected;
  const LanguageBottomSheet({
    super.key,
    //required this.onLanguageSelected
  });

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  Map<String, dynamic>? responseData;
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  void initState() {
    super.initState();
    getLanguages();
  }

  Future<void> getLanguages() async {
    String baseUrl =
        'https://google-translate1.p.rapidapi.com/language/translate/v2';
    final Map<String, String> headers = {
      'Accept-Encoding': 'application/gzip',
      'X-RapidAPI-Key': 'd1b59db60emsh209f335da640aebp1423edjsn052df688bc78',
      'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
    };

    final response =
        await http.get(Uri.parse('$baseUrl/languages'), headers: headers);
    print(response.statusCode); // Replace with your API endpoint
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (mounted) {
        setState(() {
          responseData = decodedData['data'];
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to fetch languages');
    }
  }

  @override
  Widget build(BuildContext context) {
    var languages = responseData?['languages'];
    List<dynamic>? filteredLanguages = languages;
    //print(languages);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [IconButton(onPressed: () {}, icon: Icon(Icons.close))],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (value.trim() == '') {
                  setState(() {
                    filteredLanguages = languages;
                  });
                } else {
                  var newList = languages
                      .where((element) => '${element['language']}'
                          .toLowerCase()
                          .contains(value.trim().toLowerCase()))
                      .toList();
                  setState(() {
                    filteredLanguages = newList.isEmpty ? [] : newList;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Search Language',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
          ),
          isLoading
          ? Center(
            child: CircularProgressIndicator(),
          )
         : Expanded(
              child: ListView.builder(
                  itemCount: filteredLanguages?.length ?? 0,
                  itemBuilder: (context , index) {
                    var language = filteredLanguages?[index];
                    return ListTile(
                      title: Text(language?['language']),
                      onTap: (){

                      },
                    );
                  }))
        ],
      ),
    );
  }
}
