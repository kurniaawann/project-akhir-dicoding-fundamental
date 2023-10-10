import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:mockito/mockito.dart';
import 'package:restaurant_app_api/controller/list_controller.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import 'package:restaurant_app_api/controller/favorite_controller.dart';
import 'package:restaurant_app_api/controller/search_controller.dart';
import 'package:restaurant_app_api/model/restaurant_list.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient client;
  setUp(() {
    sqflite_ffi.databaseFactory = sqflite_ffi.databaseFactoryFfi;
    Get.put(FavoriteController());
    Get.put(RestaurantControllerSearch());
    Get.testMode = true;
    client = MockClient();

    expect(client, isNotNull); // Remove the parentheses
  });

  test('Test ListView and Favorite Icon', () async {
    final favoriteController = FavoriteController();
    final listController = RestaurantListController();

    when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
        .thenAnswer((_) async => http.Response(
            '{"eror":false, "message":"success", "restaurant":[]}', 200));

    expect(
        await listController.fetchMockRestaurants(client), isA<Restaurant>());

    // // Initialize controllers with mock data
    // favoriteController.addFavoriteRestaurant(Restaurant(
    //   id: '1',
    //   name: 'Restaurant 1',
    //   description: 'Description 1',
    //   city: 'City 1',
    //   rating: 4.5.toDouble(),
    //   pictureId: '1.jpg',
    // ));

    // // Verify that the HTTP client is called as expected
    // verify(client.post(Uri.parse('https://restaurant-api.dicoding.dev/list')))
    //     .called(1);

    // // Fetch and test the data from listController.fetchRestaurantsList()
    // List<Restaurant> restaurants = [];

    // await listController.fetchRestaurantsList();
    // restaurants = listController.restaurants
    //     .map((data) => Restaurant.fromJson(data))
    //     .toList();

    // expect(
    //     restaurants.length, 1); // Seharusnya ada 1 restaurant dalam data palsu
    // expect(restaurants[0].name, 'Restaurant 1');
    // expect(restaurants[0].description, 'Description 1');
  });
}
