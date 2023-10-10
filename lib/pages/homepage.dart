import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/controller/buttom_controller.dart';
import 'package:restaurant_app_api/controller/favorite_controller.dart';
import 'package:restaurant_app_api/controller/list_controller.dart';
import 'package:restaurant_app_api/model/restaurant_list.dart';

import 'package:restaurant_app_api/routes/route_name.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final RestaurantListController controller =
      Get.put(RestaurantListController());
  final ButtomController controllerB = Get.put(ButtomController());
  final FavoriteController favoriteC = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteName.search);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refresh();
        },
        child: Obx(() {
          controller.checkInternetConnection();
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildRestaurantList();
          }
        }),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          showSelectedLabels: true,
          currentIndex: controllerB.currentIndex.value,
          onTap: (int index) {
            controllerB.changeCurrentIndex(index);
            if (index == 1) {
              Get.toNamed(RouteName.favorite);
            } else if (index == 2) {
              Get.toNamed(RouteName.setting);
            } else {
              Get.offAllNamed(RouteName.homePage);
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: controllerB.currentIndex.value == 0 ? Colors.blue : null,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: controllerB.currentIndex.value == 1 ? Colors.blue : null,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: controllerB.currentIndex.value == 2 ? Colors.blue : null,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantList() {
    return ListView.builder(
      itemCount: controller.restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = controller.restaurants[index];
        final imageUrl =
            'https://restaurant-api.dicoding.dev/images/large/${restaurant['pictureId']}';

        return InkWell(
          onTap: () {
            Get.toNamed(
              RouteName.detailInformasi,
              arguments: restaurant['id'].toString(),
            );
          },
          child: Card(
            shadowColor: Colors.blue,
            borderOnForeground: false,
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              title: Text(
                restaurant['name'],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    restaurant['description'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        restaurant['city'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              leading: Image.network(
                imageUrl,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 16.0,
                  ),
                  Text(
                    restaurant['rating'].toString(),
                  ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
