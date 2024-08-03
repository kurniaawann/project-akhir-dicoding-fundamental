import 'dart:math';

import '../model/restaurant_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  Future<Restaurant> randomRestaurant() async {
    final url = Uri.parse('https://restaurant-api.dicoding.dev/list');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final random = Random();
      List<Restaurant> restaurantList =
          Welcome.fromJson(jsonDecode(response.body)).restaurants;
      Restaurant restaurant =
          restaurantList[random.nextInt(restaurantList.length)];
      return restaurant;
    } else {
      throw Exception('Failed Load List Restaurant');
    }
  }
}
