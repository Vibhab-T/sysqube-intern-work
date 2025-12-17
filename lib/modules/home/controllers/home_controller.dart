import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysqube_intern/data/models/book_model.dart';
import 'package:sysqube_intern/data/repos/book_repo.dart';
import 'package:sysqube_intern/utils/constants.dart';

/*
Controllers:
Holds UI state
contains the logic, 
talks to repos, which in turn talks to the database
does not talk directly to sql or http requests/responeses

UI/Views:
Observes the controller
renders the widgets
calls the controllers methods
*/

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final BookRepo _repo =  BookRepo();

  var popularBooks = <Book>[].obs;
  var categoryBooks = <String, List<Book>>{}.obs;
  var isLoadingPopular = true.obs;
  var isLoadingCategories = true.obs;
  var error = ''.obs;
  var selectedIndex = 0.obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: AppConstants.categories.length, vsync: this);
    fetchPopularBooks();
    fetchCategoryBooks();
  }

  void changeTab(int index){
    selectedIndex.value = index;
  }

  Future<void> fetchPopularBooks() async {
    try {
      isLoadingPopular.value = true;
      error.value = '';
      final books = await _repo.getTechBooks();
      popularBooks.value = books.take(3).toList();
    } catch (e) {
      error.value = "failed to load popular books: $e";
    } finally {
      isLoadingPopular.value = false;
    }
  }

  Future<void> fetchCategoryBooks() async {
    try{
      isLoadingCategories.value = true;
      error.value = '';

      for (String cat in AppConstants.categories){
        final books = await _repo.getBooksByCategory(cat);
        categoryBooks[cat] = books;
      }
    } catch (e){
      error.value = "Failed to fetch cat books: $e";
    } finally {
      isLoadingCategories.value = false;
    }
  }

  @override
  void onClose(){
    tabController.dispose();
    super.onClose();
  }

}