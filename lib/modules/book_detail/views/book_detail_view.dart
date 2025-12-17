import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysqube_intern/modules/book_detail/controllers/book_detail_controller.dart';

class BookDetailView extends StatelessWidget {
  const BookDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final BookDetailController controller = Get.put(BookDetailController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 300,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: controller.book.thumbnail != null
                      ? CachedNetworkImage(
                          imageUrl: controller.book.thumbnail!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.book,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.book,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ),
            // Book Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    controller.book.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Authors
                  Text(
                    'Authors',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.book.authors.isNotEmpty
                        ? controller.book.authors.join(', ')
                        : 'Unknown Author',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  // Published Date
                  if (controller.book.publishedDate != null) ...[
                    Text(
                      'Published Date',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.book.publishedDate!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Description
                  if (controller.book.description != null) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.book.description!,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Favorite Button
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: Obx(() => ElevatedButton.icon(
                onPressed: () => controller.toggleFavourite(),
                icon: Icon(
                  controller.isFav.value ? Icons.favorite : Icons.favorite_outline,
                ),
                label: Text(
                  controller.isFav.value ? 'Remove from Favorites' : 'Add to Favorites',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isFav.value ? Colors.red : Colors.blue,
                  foregroundColor: Colors.white,
                ),
              )),
        ),
      ),
    );
  }
}