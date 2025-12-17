import 'package:get/state_manager.dart';

class ThemeController extends GetxController{
  var isDarkMode = true.obs;

  void toggleTheme(){
    isDarkMode.value = !isDarkMode.value;
  }
}