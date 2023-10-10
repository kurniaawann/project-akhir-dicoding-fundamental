import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/controller/favorite_controller.dart';
import 'package:restaurant_app_api/controller/search_controller.dart';
import './routes/page_route.dart';
import 'package:restaurant_app_api/routes/route_name.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  Get.put(FavoriteController());
  Get.put(RestaurantControllerSearch());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: Myroute.pages,
      initialRoute: RouteName.homePage,
    );
  }
}
