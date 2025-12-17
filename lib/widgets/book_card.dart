import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysqube_intern/app/routes/app_routes.dart';
import 'package:sysqube_intern/data/models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final double? width;

  const BookCard({
    super.key,
    required this.book,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.BOOK_DETAIL,
        arguments: book,
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover Image
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: book.thumbnail != null
                      ? CachedNetworkImage(
                          imageUrl: book.thumbnail!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[400],
                            child: const Icon(
                              Icons.book,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.book,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                        ),
                ),
              ),
              // Book Details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Authors
                      Expanded(
                        child: Text(
                          book.authors.isNotEmpty
                              ? book.authors.first
                              : 'Unknown Author',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
