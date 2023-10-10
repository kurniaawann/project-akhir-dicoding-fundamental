import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/controller/favorite_controller.dart';

import '../controller/list_controller.dart';
import 'package:restaurant_app_api/controller/detail.controller.dart';
import 'package:restaurant_app_api/routes/route_name.dart';
import 'package:restaurant_app_api/model/restaurant_list.dart';

class DetailInformasi extends StatelessWidget {
  final RestaurantDetailController _controller =
      Get.put(RestaurantDetailController());
  final RestaurantListController controller =
      Get.put(RestaurantListController());
  final FavoriteController favoriteC = Get.find();
  DetailInformasi({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> checkInternetConnection() async {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        Get.snackbar(
            "Terjadi Kesalahan", "Harap Nyalakan Koneksi Internet Anda");
      }
    }

    final String restaurantId = Get.arguments.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchRestaurantDetail(restaurantId);
      // print(restaurantId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Restaurant"),
      ),
      body: Obx(() {
        checkInternetConnection();
        if (_controller.restaurantDetail.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final restaurant = _controller.restaurantDetail;
          final imageUrl =
              'https://restaurant-api.dicoding.dev/images/large/${restaurant['pictureId']}';
          final foods = restaurant['menus']['foods'];
          final drinks = restaurant['menus']['drinks'];

          return ListView(
            children: <Widget>[
              Image.network(imageUrl),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Rating: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    restaurant['rating'].toString(),
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  const Spacer(),
                  Obx(() {
                    return IconButton(
                      onPressed: () {
                        final restaurantId = restaurant['id'];
                        if (favoriteC.isRestaurantFavorite(restaurantId)) {
                          favoriteC.removeFavoriteRestaurant(restaurantId);
                        } else {
                          final Restaurant newFavorite = Restaurant(
                            id: restaurantId,
                            name: restaurant['name'],
                            description: restaurant['description'],
                            pictureId: restaurant['pictureId'],
                            city: restaurant['city'],
                            rating: restaurant['rating']?.toDouble() ?? 0.0,
                          );
                          favoriteC.addFavoriteRestaurant(newFavorite);
                        }
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: favoriteC.isRestaurantFavorite(restaurant['id'])
                            ? Colors
                                .red // Ubah warna jika sudah dalam daftar favorit
                            : Colors.grey,
                      ),
                    );
                  })
                  // IconButton(onPressed: (){}, icon: Icon(Icons.favorite))
                ],
              ),
              Center(
                child: Text(
                  restaurant['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                restaurant['description'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Makanan:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: foods.map<Widget>((food) {
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 88, 170, 238),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            food['name'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Minuman",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: drinks.map<Widget>((drinks) {
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 88, 170, 238),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            drinks['name'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Text(
                    "Categori: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    restaurant['categories']
                        .map((category) => category['name'].toString())
                        .join(' '),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Address:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Icon(Icons.location_on_outlined),
                  Text(
                    restaurant['address'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    restaurant['city'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(
                    RouteName.customerReview,
                    arguments: {
                      'restaurantId': restaurant['id'],
                      'customerReviews': restaurant['customerReviews'],
                    },
                  );
                },
                child: const Text("Cek Review"),
              )
            ],
          );
        }
      }),
    );
  }
}
