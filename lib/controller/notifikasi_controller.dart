import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:restaurant_app_api/routes/route_name.dart';
import 'dart:convert';
// import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationController extends GetxController {
  var restaurants = <String>[].obs;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    fetchAndSetRestaurants();
    scheduleNotification();
  }

  Future<Map<String, dynamic>> showNotifikasi() async {
    final response =
        await http.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> restaurantList = data['restaurants'];
      final List<String> restaurantNames =
          restaurantList.map((item) => item['name'].toString()).toList();
      return {
        'success': true,
        'data': restaurantNames,
      };
    } else {
      return {
        'success': false,
        'error': 'Gagal mengambil data restaurant dari API',
      };
    }
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    tz.initializeTimeZones();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        dynamic payload = details.notificationResponseType;

        if (payload != null && payload.isNotEmpty) {
          final restaurantId = payload.split(':')[1];

          Get.toNamed(RouteName.detailInformasi, arguments: restaurantId);
        }
      },
    );
  }

  void cancelAlarm() {
    AndroidAlarmManager.cancel(0);
  }

  Future<void> fetchAndSetRestaurants() async {
    try {
      final result = await showNotifikasi();
      if (result['success'] == true) {
        final restaurantNames = result['data'] as List<String>;
        restaurants.assignAll(restaurantNames);
      } else {
        print('Error fetching restaurant data: ${result['error']}');
      }
    } catch (e) {
      print('Error fetching restaurant data: $e');
    }
  }

  Future<void> scheduleNotification() async {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);

    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      0,
      showNotification,
      startAt: scheduledTime,
      exact: true,
      wakeup: true,
    );
  }

  Future<void> showNotification() async {
    final List<String> restaurantNames = restaurants;
    final Random random = Random();
    final int randomIndex = random.nextInt(restaurantNames.length);
    final String randomRestaurantName = restaurantNames[randomIndex];
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Restaurant',
      'Restaurant belum dibuka',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      2,
      randomRestaurantName,
      'Restaurant Sudah Di buka',
      platformChannelSpecifics,
      payload: 'Data tambahan yang ingin Anda sertakan',
    );
  }
}
