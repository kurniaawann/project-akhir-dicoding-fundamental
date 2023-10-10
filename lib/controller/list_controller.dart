import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_api/model/restaurant_list.dart';

class RestaurantListController extends GetxController {
  var restaurants = <Map<String, dynamic>>[].obs;
  final List<String> favoriteRestaurants = <String>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurantsList();
  }

  @override
  Future<void> refresh() async {
    await fetchRestaurantsList();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Harap Nyalakan Koneksi Internet Anda",
      );
    }
  }

  Future<void> fetchRestaurantsList() async {
    try {
      final url = Uri.parse('https://restaurant-api.dicoding.dev/list');

      // Gunakan httpClient untuk melakukan permintaan HTTP
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> restaurantList =
            List<Map<String, dynamic>>.from(data['restaurants']);
        restaurants.assignAll(restaurantList);
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Terjadi Kesalahan dalam Mengambil Data",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? getRestaurantInfoById(String restaurantId) {
    try {
      for (var restaurant in restaurants) {
        if (restaurant['id'] == restaurantId) {
          return restaurant;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Restaurant yang anda cari tidak ditemukan",
      );
    }
    return null;
  }

  Future<Restaurant> fetchMockRestaurants(http.Client client) async {
    final response =
        await client.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));

    if (response.statusCode == 200) {
      return Restaurant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
}
