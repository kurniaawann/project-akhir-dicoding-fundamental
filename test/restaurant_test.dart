import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app_api/controller/list_controller.dart';
import 'package:restaurant_app_api/model/restaurant_list.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient client;
  setUp(() {
    sqflite_ffi.databaseFactory = sqflite_ffi.databaseFactoryFfi;
    Get.testMode = true;
    client = MockClient();
  });

  test('Test ListView and Favorite Icon', () async {
    final listController = RestaurantListController();

    when(() =>
            client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
        .thenAnswer(
      (_) async => http.Response(
          '{"error":false, "message":"success", "count": 0, "restaurants":[]}',
          200),
    );

    expect(await listController.fetchMockRestaurants(client), isA<Welcome>());
  });
}
