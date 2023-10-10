import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:restaurant_app_api/routes/route_name.dart';

class CustomerReview extends StatelessWidget {
  const CustomerReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final List<dynamic>? customerReviews =
        args?['customerReviews'] as List<dynamic>?;

    final String? restaurantId = args?['restaurantId'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Review"),
        actions: [
          IconButton(
            onPressed: () async {
              if (restaurantId != null) {
                await Get.toNamed(RouteName.addreview, arguments: restaurantId);
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: customerReviews?.length ?? 0,
        itemBuilder: (context, index) {
          final review = customerReviews![index];
          return ListTile(
            title: Text(review['name']),
            subtitle: Text(review['review']),
            trailing: Text(review['date']),
          );
        },
      ),
    );
  }
}
