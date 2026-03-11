abstract class LocalStorageService {

  /// WRITE
  Future<void> write({
    required String box,
    required String key,
    required dynamic value,
  });

  /// READ
  T? read<T>({
    required String box,
    required String key,
  });

  /// DELETE
  Future<void> delete({
    required String box,
    required String key,
  });

  /// CLEAR BOX
  Future<void> clearBox(String box);

  /// CLEAR ALL
  Future<void> clearAll();

}