import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RestaurantControllerSearch extends GetxController {
  var foundRestaurants = <Map<String, dynamic>>[].obs;

  Future<void> searchRestaurants(String query) async {
    try {
      final url =
          Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> restaurants =
            List<Map<String, dynamic>>.from(data['restaurants']);
        foundRestaurants.assignAll(restaurants);
      } else {
        throw Exception('Failed to search for restaurants');
      }
    } catch (e) {
      Get.snackbar(
          "Terjadi Kesalahan", "Terjadi Kesalahan Saat Mencari Restoran");
    }
  }
}
