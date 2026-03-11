


import 'package:hive_ce_flutter/hive_flutter.dart';
import 'hive_boxes.dart';
import 'local_storage_service.dart';

class LocalStorageServiceImpl implements LocalStorageService {

  @override
  Future<void> write({
    required String box,
    required String key,
    required dynamic value,
  }) async {

    final hiveBox = Hive.box(box);
    await hiveBox.put(key, value);

  }

@override
T? read<T>({
  required String box,
  required String key,
}) {

  final hiveBox = Hive.box(box);
  return hiveBox.get(key) as T?;

}

  @override
  Future<void> delete({
    required String box,
    required String key,
  }) async {

    final hiveBox = Hive.box(box);
    await hiveBox.delete(key);

  }

  @override
  Future<void> clearBox(String box) async {

    final hiveBox = Hive.box(box);
    await hiveBox.clear();

  }

@override
Future<void> clearAll() async {

  for (final boxName in HiveBoxes.allBoxes) {
    await Hive.box(boxName).clear();
  }

}

Future<void> deleteAll() async {

  for (final boxName in HiveBoxes.allBoxes) {
    await Hive.box(boxName).deleteFromDisk();
  }

}

}