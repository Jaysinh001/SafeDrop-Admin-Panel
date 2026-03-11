import 'package:hive_ce_flutter/hive_flutter.dart';
import 'hive_boxes.dart';

class HiveInitializer {

  static Future<void> init() async {

    await Hive.initFlutter();

    await Hive.openBox(HiveBoxes.authBox);
    await Hive.openBox(HiveBoxes.userBox);
    await Hive.openBox(HiveBoxes.appBox);

  }
}