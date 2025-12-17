import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysqube_intern/app/routes/app_pages.dart';
import 'package:sysqube_intern/app/routes/app_routes.dart';
import 'package:sysqube_intern/app/themes/app_theme.dart';
import 'package:sysqube_intern/app/themes/theme_controller.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(()=>GetMaterialApp(
      title: "SysQube Books",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.pages,
    ));
  }
}