import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/instance_manager.dart';
import 'package:sysqube_intern/app/routes/app_routes.dart';
import 'package:sysqube_intern/modules/book_detail/controllers/book_detail_controller.dart';
import 'package:sysqube_intern/modules/book_detail/views/book_detail_view.dart';
import 'package:sysqube_intern/modules/favourites/controllers/favourites_controller.dart';
import 'package:sysqube_intern/modules/home/controllers/home_controller.dart';
import 'package:sysqube_intern/modules/home/views/home_view.dart';

/*
 GetX recommended structure:
  Modules
    -Example
      --views
      --controllers

  yaa nera ni same pattern for home and faves


  this entire class is a route registry for GetX
  used by GetMaterialApp(getPages: AppPages.pages)

  tells that yaa chai mero routes haru cha ani esari baneko cha
*/

class AppPages {
  static final pages = [

    /*
    GetPage(
      name: routeName,
      page: () => Widget(),
      binding: Bindings() === controllers to inject 
    ) defines a single route

    */

    GetPage(
      name: AppRoutes.HOME, 
      page: () => const HomeView(),
      binding: BindingsBuilder((){
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => FavouritesController());
      }) 
    ),

    GetPage(
      name: AppRoutes.BOOK_DETAIL,
      page: () => const BookDetailView(),
      binding: BindingsBuilder((){
        Get.lazyPut(()=>BookDetailController());
      })
    )
  ];
}


/*
AT RUNTIME
when calling 
Get.toNamed(AppRoutes.home) -->
finds matching GetPage, because main ma getPages vanera yo class lai dekhako cha
executes binding - vannale controller banaucha becasue lazy put, stores controller in mem
builds HomeView
ani UI can acess controller
*/