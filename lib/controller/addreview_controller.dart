import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RestaurantController extends GetxController {
  var reviewResult = {}.obs;
  var customerReviews = <dynamic>[].obs;

  final TextEditingController nameC = TextEditingController();
  final TextEditingController riviewC = TextEditingController();
  final TextEditingController ymdC = TextEditingController();

  Future<void> addReview(
      String restaurantId, String name, String review) async {
    try {
      final url = Uri.parse('https://restaurant-api.dicoding.dev/review');
      final headers = {'Content-Type': 'application/json'};
      final body =
          json.encode({'id': restaurantId, 'name': name, 'review': review});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        reviewResult.value = data;
        customerReviews.add(data);

        update();
      }
    } catch (e) {
      Get.snackbar("disini salahnnya", "Terjadi Kesalahan Saat Mengambil Data");
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    riviewC.dispose();
    ymdC.dispose();
    super.dispose();
  }
}
