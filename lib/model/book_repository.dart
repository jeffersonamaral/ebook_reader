import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ebook_reader/util/constants.dart';

import 'book_model.dart';

class BookRepository {

  const BookRepository();

  Future<List<BookModel>> findAll() async {
    var response = await http.get(Uri.parse(apiBaseUrl));

    if (response.statusCode == 200) {
      List<BookModel> tempBooks = [];

      var jsonResponse = json.decode(response.body);

      for (Map<String, dynamic> mapBooks in jsonResponse) {
        tempBooks.add(BookModel.fromMap(mapBooks));
      }

      return tempBooks;
    } else {
      throw(response);
    }
  }

}