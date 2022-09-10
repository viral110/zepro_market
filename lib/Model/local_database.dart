const String tableNotes = 'product';

class LocalFieldStore {
  static final List<String> values = [id, productId, time];

  static const String id = '_id';
  static const String productId = 'productId';
  static const String time = 'time';
}

class LocalStoreProductId {
  final int id;
  final String productId;
  final DateTime createdTime;

  LocalStoreProductId({this.id, this.productId, this.createdTime});

  LocalStoreProductId copy({int id, String productId, DateTime createdTime}) =>
      LocalStoreProductId(
          id: id ?? this.id,
          productId: productId ?? this.productId,
          createdTime: createdTime ?? this.createdTime);

  static LocalStoreProductId fromJson(Map<String, Object> json) {
    return LocalStoreProductId(
        id: json[LocalFieldStore.id] as int,
        productId: json[LocalFieldStore.productId] as String,
        createdTime: DateTime.parse(json[LocalFieldStore.time] as String));
  }

  Map<String, Object> toJson() => {
        LocalFieldStore.id: id,
        LocalFieldStore.productId: productId,
        LocalFieldStore.time: createdTime.toIso8601String(),
      };
}
