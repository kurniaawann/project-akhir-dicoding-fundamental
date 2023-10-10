import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchController extends GetxController {
  var isSwitched = false.obs;

  @override
  void onInit() {
    loadSwitchStatus();
    super.onInit();
  }

  void toggleSwitch() async {
    isSwitched.value = !isSwitched.value;
    await saveSwitchStatus(isSwitched.value);
  }

  Future<void> saveSwitchStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switch_status', status);
  }

  Future<void> loadSwitchStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final switchStatus = prefs.getBool('switch_status') ?? false;
    isSwitched.value = switchStatus;
  }
}
