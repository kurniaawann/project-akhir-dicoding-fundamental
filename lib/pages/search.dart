import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/controller/favorite_controller.dart';
import 'package:restaurant_app_api/routes/route_name.dart';
import '../controller/search_controller.dart';
import 'package:restaurant_app_api/model/restaurant_list.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final RestaurantControllerSearch restaurantController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Serch Restaurant"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Temukan Restaurant",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _SearchField(),
              const SizedBox(height: 16),
              Obx(() {
                final foundRestaurants = restaurantController.foundRestaurants;
                if (foundRestaurants.isEmpty) {
                  return const Center(
                    child: Text("Hasil pencarian Tidak Di Temukan"),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: foundRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = foundRestaurants[index];
                      return _RestaurantCard(
                        restaurant: restaurant,
                      );
                    },
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final TextEditingController _searchController = TextEditingController();
  final RestaurantControllerSearch _restaurantController = Get.find();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: _searchController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: "Search",
        hintText: "Cari restoran...",
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            final query = _searchController.text.trim();
            if (query.isNotEmpty) {
              _restaurantController.searchRestaurants(query);
            }
          },
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        'https://restaurant-api.dicoding.dev/images/medium/${restaurant['pictureId']}';
    final FavoriteController favoriteC = Get.find<FavoriteController>();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(
          'Name: ${restaurant['name']}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lokasi: ${restaurant['city']}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  'Rating: ${restaurant['rating']}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.star,
                  color: Colors.green,
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
                }),
              ],
            ),
            Text(
              restaurant['description'],
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ],
        ),
        onTap: () {
          Get.toNamed(RouteName.detailInformasi, arguments: restaurant['id']);
        },
      ),
    );
  }
}
