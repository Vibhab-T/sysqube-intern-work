import 'dart:convert';

import 'package:sysqube_intern/data/models/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:sysqube_intern/utils/constants.dart';

/*
the network layer, paila service file vanera banako thyo 

talks to the api and converts the responses into Book objects using the fromJson factory method

uri provided by constant file
*/

class BookApiProvider {
  //fetch a predefined list of tech books
  //convert them into book objects
  Future<List<Book>> getTechBooks() async {
    try{
      final response = await http.get(Uri.parse(AppConstants.getTechBooks()));

      if (response.statusCode == 200){
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? []; //sometimes returns no items
        return items.map((json) => Book.fromJson(json)).toList(); //json string to dart Mao<String, dynamic>, but then returned as List<Book>
      } else {
        throw Exception("Failed to load books");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  //fetch books by category,
  Future<List<Book>> getBooksByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.getBooksBySubject(category))
      );

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? [];
        return items.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load books by category");
      }
    }catch (e){
      throw Exception("Error: $e");
    }
  }

  //search a particular book
  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.searchBooks(query))
      );

      if (response.statusCode == 200){
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? [];
        return items.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception("Failed to search books");
      }
    } catch (e){
      throw Exception("Error: $e");
    }
  }
}