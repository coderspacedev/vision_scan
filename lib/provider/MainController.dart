import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends GetxController {
  final box = GetStorage();
  RxString selectedLanguage = "".obs;
  RxString selectedTheme = "dark".obs;
  RxBool isPremium = false.obs;
  Rx<Locale> locale = Locale('en').obs;

  @override
  void onInit() {
    selectedTheme.value = box.read("theme") ?? "dark";
    selectedLanguage.value = box.read("language") ?? "en";
    isPremium.value = box.read("isPremium") ?? false;
    changeLanguage(selectedLanguage.value);
    changeTheme(selectedTheme.value);
    if (selectedLanguage.value.isNotEmpty) {
      locale.value = Locale(selectedLanguage.value);
    }
    super.onInit();
  }

  Future<void> setPremium(bool premium) async {
    isPremium.value = premium;
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languageCode.isEmpty) return;
    selectedLanguage.value = languageCode;
    box.write("language", languageCode);
    locale.value = Locale(languageCode);
    Get.updateLocale(locale.value);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
  }

  void changeTheme(String theme) {
    selectedTheme.value = theme;
    box.write("theme", theme);

    if (theme == "light") {
      Get.changeThemeMode(ThemeMode.light);
    } else if (theme == "dark") {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }
}
