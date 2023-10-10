import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RestaurantDetailController extends GetxController {
  var restaurantDetail = {}.obs;

  Future<void> fetchRestaurantDetail(String restaurantId) async {
    try {
      final url =
          Uri.parse('https://restaurant-api.dicoding.dev/detail/$restaurantId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic> restaurant = data['restaurant'];
        restaurantDetail.assignAll(restaurant);
      } else {
        throw Exception('Failed to load restaurant detail');
      }
    } catch (e) {
      Get.snackbar(
          "Terjadi Kesalahan", "Terjadi Kesalahan Saat Mengambil Data");
    }
  }
}
