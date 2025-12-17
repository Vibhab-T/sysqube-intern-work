import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysqube_intern/app/themes/theme_controller.dart';
import 'package:sysqube_intern/modules/favourites/views/favourites_views.dart';
import 'package:sysqube_intern/modules/home/controllers/home_controller.dart';
import 'package:sysqube_intern/utils/constants.dart';
import 'package:sysqube_intern/widgets/book_card.dart';
import 'package:sysqube_intern/widgets/error_widget.dart';
import 'package:sysqube_intern/widgets/loading_widget.dart';

class HomeView extends StatelessWidget{
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final themeController = Get.find<ThemeController>();

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
          return const FavouritesView();
        }
      }),
      bottomNavigationBar: Obx(()=>BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index){
          controller.changeTab(index);
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

  Widget _buildPopularSection(HomeController controller){
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Popular Picks",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          )
        ),
        Obx((){
          if (controller.isLoadingPopular.value){
            return const LoadingWidget(height: 280);
          }

          if (controller.error.value.isNotEmpty && controller.popularBooks.isEmpty){
            return CustomErrorWidget(
              message: controller.error.value,
              onRetry: ()=> controller.fetchPopularBooks()
            );
          }

          return SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.popularBooks.length,
              itemBuilder: (context, index){
                final book = controller.popularBooks[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: BookCard(
                    book: book,
                    width: 160
                  )
                );
              },
            )
          );
        })
      ],
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
}