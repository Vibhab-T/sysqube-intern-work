import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysqube_intern/app/routes/app_routes.dart';
import 'package:sysqube_intern/modules/favourites/controllers/favourites_controller.dart';
import 'package:sysqube_intern/widgets/loading_widget.dart';

class FavouritesView extends StatelessWidget {
  const FavouritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavouritesController controller = Get.put(FavouritesController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(height: 400);
        }

        if (controller.faves.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No Favourites Yet",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  "Start adding to your favourites..",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.faves.length,
          itemBuilder: (context, index) {
            final book = controller.faves[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: book.thumbnail != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book.thumbnail!,
                          width: 50,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 50,
                            height: 70,
                            color: Colors.grey[800],
                            child: const Icon(Icons.book),
                          ),
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.book),
                      ),
                title: Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  book.authors.join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => controller.removeFavorite(book.id),
                ),
                onTap: () => Get.toNamed(
                  AppRoutes.BOOK_DETAIL,
                  arguments: book,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
