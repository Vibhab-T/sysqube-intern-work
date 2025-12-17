import 'package:sysqube_intern/data/models/book_model.dart';
import 'package:sysqube_intern/data/providers/book_api_provider.dart';

/*
I feel this is like Java Beans
you provide your API layer, and the implementations actually happens on the book_api_provider. 
change the implementation there, but the API stays the same - java beans?? not actually 

DECOUPLING

A repo is a middle layer between:
Controllers 
Data Sources

exposes domain level ops
controllers should not care about urls, https, sqlite, json
*/

class BookRepo {
  final BookApiProvider _apiProvider = BookApiProvider();

  Future<List<Book>> getTechBooks() async {
    return await _apiProvider.getTechBooks();
  }

  Future<List<Book>> getBooksByCategory(String category) async {
    return await _apiProvider.getBooksByCategory(category);
  }

  Future<List<Book>> searchBooks(String query) async {
    return await _apiProvider.searchBooks(query);
  }
}