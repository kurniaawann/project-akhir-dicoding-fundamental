import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/common/navigation.dart';
import 'package:restaurant_app_api/controller/favorite_controller.dart';
import 'package:restaurant_app_api/controller/search_controller.dart';
import 'package:restaurant_app_api/utils/background_services.dart';
import 'package:restaurant_app_api/utils/notification_helper.dart';
import './routes/page_route.dart';
import 'package:restaurant_app_api/routes/route_name.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

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
      navigatorKey: navigatorKey,
    );
  }
}
