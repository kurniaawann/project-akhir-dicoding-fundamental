import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:get/get.dart';
import 'package:restaurant_app_api/utils/background_services.dart';
import 'package:restaurant_app_api/utils/date_time_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulingController extends GetxController {
  final RxBool _isScheduled = false.obs;
  SharedPreferences? _prefs;

  @override
  void onInit() {
    _loadIsScheduledFromPrefs();
    super.onInit();
  }

  bool get isScheduled => _isScheduled.value;

  // Fungsi untuk memuat nilai isScheduled dari shared preferences
  Future<void> _loadIsScheduledFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isScheduled.value = _prefs?.getBool('isScheduled') ?? false;
    update();
  }

  // Fungsi untuk menyimpan nilai isScheduled ke shared preferences
  Future<void> _saveIsScheduledToPrefs(bool value) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs?.setBool('isScheduled', value);
  }

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled.value = value;
    await _saveIsScheduledToPrefs(value);
    if (isScheduled) {
      update();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      update();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
