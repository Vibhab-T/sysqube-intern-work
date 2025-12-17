import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysqube_intern/app/routes/app_routes.dart';
import 'package:sysqube_intern/app/themes/theme_controller.dart';
import 'package:sysqube_intern/modules/favourites/controllers/favourites_controller.dart';
import 'package:sysqube_intern/modules/home/controllers/home_controller.dart';
import 'package:sysqube_intern/utils/constants.dart';

class HomeView extends StatelessWidget{
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final ThemeController themeController = Get.find<ThemeController>();
    final FavouritesController favController = Get.put(FavouritesController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(()=>Text(
          controller.selectedIndex.value == 0 ? "Home" : "Favourites",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        )),
        centerTitle: true,
        actions: [
          Obx(() => 
            IconButton(
              onPressed: ()=>themeController.toggleTheme(), 
              icon: Icon(themeController.isDarkMode.value ? Icons.light_mode : Icons.dark_mode)
            )
          )
        ],
      ),
      body: Obx((){
        if (controller.selectedIndex.value == 0) {
          return _buildHomeTab(controller);
        } else {
          return _buildFavouritesTab(favController);
        }
      }),
      bottomNavigationBar: Obx(()=>BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index){
          controller.changeTab(index);
          if (index ==1){
            favController.loadFavourites();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: "Favs"
          )
         ]
        )
      ),
    );
  }


  Widget _buildHomeTab(HomeController controller){
    return RefreshIndicator(
      onRefresh: () async{
        await controller.fetchPopularBooks();
        await controller.fetchCategoryBooks();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _buildPopularSection(controller),
            const SizedBox(height: 20,),
            _buildCategoriesSection(controller),
          ],
        ),
      ),
    );
  }



  Widget _buildCategoriesSection(HomeController controller){
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              const Text("Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(0)
                ),
                child: const Row(
                  children: [
                    Text("Dropdown", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, size: 16),
                  ],
                ),
              ),
            ],
          )
        ),
        const SizedBox(height: 16),
        Obx((){
          if (controller.isLoadingCategories.value){
            return const LoadingWidget(height: 300);
          }

          return Column(
            children: [
              TabBar(
                controller: controller.tabController,
                isScrollable: true,
                tabs: AppConstants.categories.map((cat)=>Tab(text: cat)).toList()
              ),
              SizedBox(
                height: 350,
                child: TabBarView(
                  controller: controller.tabController,
                  children: AppConstants.categories.map((cat){
                    final books = controller.categoryBooks[cat] ?? [];

                    if (books.isEmpty){
                      return const Center(child: Text("No books found"));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16
                      ), 
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return BookCard(book: books[index]);
                      }
                    );
                  }).toList(),
                )
              )
            ],
          );
        })
      ],
    );
  }

  Widget _buildFavouritesTab(FavouritesController controller){
    return Obx((){
      if (controller.isLoading.value){
        return const LoadingWidget(height: 400);
      }

      if (controller.faves.isEmpty){
        return const Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16,),
              Text(
                "No Favourites Yet",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8,),
              Text(
                "Start adding to your favourites..",
                style: TextStyle(fontSize: 24, color: Colors.grey),
              )
            ],
          )
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.faves.length,
        itemBuilder: (context, index){
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
                        child: const Icon(Icons.book)
                      ),
                    ),
                  ) 
                  : Container(
                    width: 50,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: const Icon(Icons.book)
                  ),
              title: Text(
                book.title, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis, 
                style: TextStyle(fontWeight: FontWeight.bold)
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
                arguments: book
              ),
            )
          );
        },
      );
    });
  }
}