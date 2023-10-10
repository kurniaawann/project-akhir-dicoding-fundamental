import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/controller/addreview_controller.dart';

class Addreview extends StatelessWidget {
  const Addreview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RestaurantController());
    final restaurantId = Get.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Review"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: controller.nameC,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: controller.riviewC,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Riview Restaurant",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                final name = controller.nameC.text;
                final review = controller.riviewC.text;

                controller.addReview(restaurantId!, name, review);
                Get.back();
              },
              child: const Text("Add Review"),
            ),
          )
        ],
      ),
    );
  }
}
