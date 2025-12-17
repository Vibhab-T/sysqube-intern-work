import 'package:sysqube_intern/data/models/book_model.dart';
import 'package:sysqube_intern/db/db_helper.dart';

class FavouriteRepo {
  final DbHelper _dbHelper = DbHelper.instance;

  Future<List<Book>> getFavourites() async {
    return await _dbHelper.getFavourites();
  }

  Future<bool> isFavourite(String id) async {
    return await _dbHelper.isFavourite(id);
  }

  Future<void> addFavourite(Book book) async {
    await _dbHelper.addFavourite(book);
  }

  Future<void> removeFavourite(String id) async {
    await _dbHelper.removeFavourite(id);
  }

  Future<void> toggleFavourite(Book book) async {
    final isFav = await isFavourite(book.id);
    if (isFav) {
      await removeFavourite(book.id);
    } else {
      await addFavourite(book);
    }
  }
}