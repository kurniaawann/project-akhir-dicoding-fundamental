import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/controller/buttom_controller.dart';
import 'package:restaurant_app_api/controller/favorite_controller.dart';

import 'package:restaurant_app_api/model/restaurant_list.dart';
import 'package:restaurant_app_api/routes/route_name.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteC = Get.find<FavoriteController>();
    final ButtomController controllerB = Get.put(ButtomController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Restaurants"),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final favoriteRestaurants = favoriteC.favoriteRestaurants;
        return ListView.builder(
          itemCount: favoriteRestaurants.length,
          itemBuilder: (context, index) {
            final restaurantInfo = favoriteRestaurants[index];
            final imageUrl =
                'https://restaurant-api.dicoding.dev/images/large/${restaurantInfo.pictureId}';
            return InkWell(
              onTap: () {
                Get.toNamed(RouteName.detailInformasi,
                    arguments: restaurantInfo.id);
              },
              child: Card(
                shadowColor: Colors.blue,
                borderOnForeground: false,
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  title: Text(
                    restaurantInfo.name,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        restaurantInfo.description,
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
                            restaurantInfo.city,
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
                        restaurantInfo.rating.toString(),
                      ),
                      Obx(() {
                        return IconButton(
                          onPressed: () {
                            final restaurantId = restaurantInfo.id;
                            if (favoriteC.isRestaurantFavorite(restaurantId)) {
                              favoriteC.removeFavoriteRestaurant(restaurantId);
                            } else {
                              final Restaurant newFavorite = Restaurant(
                                  id: restaurantId,
                                  name: restaurantInfo.name,
                                  description: restaurantInfo.description,
                                  pictureId: restaurantInfo.pictureId,
                                  city: restaurantInfo.city,
                                  rating: restaurantInfo.rating.toDouble());
                              favoriteC.addFavoriteRestaurant(newFavorite);
                            }
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: favoriteC
                                    .isRestaurantFavorite(restaurantInfo.id)
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
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
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
                  color:
                      controllerB.currentIndex.value == 0 ? Colors.blue : null,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color:
                      controllerB.currentIndex.value == 1 ? Colors.blue : null,
                ),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color:
                      controllerB.currentIndex.value == 2 ? Colors.blue : null,
                ),
                label: 'Settings',
              ),
            ],
          )),
    );
  }
}
