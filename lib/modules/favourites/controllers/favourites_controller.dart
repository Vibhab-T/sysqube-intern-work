import 'package:get/get.dart';
import 'package:sysqube_intern/data/models/book_model.dart';
import 'package:sysqube_intern/data/repos/favourite_repo.dart';

class FavouritesController extends GetxController {
  final FavouriteRepo _repo = FavouriteRepo();

  var faves = <Book>[].obs;
  var isLoading = true.obs;

  @override
  void onInit(){
    super.onInit();
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    try{

    } catch (e) {
      Get.snackbar("Error", "Failed to load favourites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> isFavourite(String id) async {
    return await _repo.isFavourite(id);
  }

  Future<void> addFavourite(Book book) async {
    try{

    } catch (e){
      Get.snackbar("Error", "Failed to add to favourites: $e");
    } finally {
      isLoading.value = false;
    }
  }

    Future<void> removeFavorite(String id) async {
    try {
      await _repo.removeFavourite(id);
      await loadFavourites();
      Get.snackbar('Success', 'Removed from favorites');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove favorite: $e');
    }
  }

  Future<void> toggleFavorite(Book book) async {
    try {
      await _repo.toggleFavourite(book);
      await loadFavourites();
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle favorite: $e');
    }
}