import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/controller/buttom_controller.dart';
import 'package:restaurant_app_api/controller/notifikasi_controller.dart';
import 'package:restaurant_app_api/controller/switch_controller.dart';
import 'package:restaurant_app_api/routes/route_name.dart';

class Settings extends StatelessWidget {
  final ButtomController controllerB = Get.put(ButtomController());
  final SwitchController switchC = Get.put(SwitchController());
  final NotificationController notifC = Get.put(NotificationController());

  Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Pengingat Restaurant: ${switchC.isSwitched.value ? 'ON' : 'OFF'}',
                style: const TextStyle(fontSize: 18),
              ),
              Switch(
                value: switchC.isSwitched.value,
                onChanged: (value) {
                  switchC.toggleSwitch();
                  if (value) {
                    notifC.scheduleNotification();
                  } else {
                    notifC.cancelAlarm();
                  }
                },
              ),
            ],
          ),
        ),
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
}
