import 'package:get/get.dart';
import 'package:sysqube_intern/data/models/book_model.dart';
import 'package:sysqube_intern/data/repos/favourite_repo.dart';

class BookDetailController extends GetxController {
  final FavouriteRepo _repo = FavouriteRepo();

  late Book book;
  var isFav = false.obs;

  @override
  void onInit(){
    super.onInit();
    book = Get.arguments as Book;
    checkFavourite();
  }

  Future<void> checkFavourite() async {
    isFav.value = await _repo.isFavourite(book.id);
  }
  Future<void> toggleFavourite() async {
    try {
      await _repo.toggleFavourite(book);
      await checkFavourite();

      if (isFav.value){
        Get.snackbar("Success", "Added to faves");
      } else {
        Get.snackbar("Success", "Removed from faves");
      }
    } catch (e){
      Get.snackbar("Error", "Failed to toggle fave: $e");
    }
  }
}