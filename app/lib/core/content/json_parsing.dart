String requiredString(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value is String && value.isNotEmpty) {
    return value;
  }

  throw FormatException('Missing required string field: $key');
}

String? optionalString(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value == null) {
    return null;
  }

  if (value is String && value.isNotEmpty) {
    return value;
  }

  throw FormatException('Invalid optional string field: $key');
}

List<String> optionalStringList(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value == null) {
    return const [];
  }

  if (value is! List) {
    throw FormatException('Expected list field: $key');
  }

  return List.unmodifiable(
    value.map((item) {
      if (item is String) {
        return item;
      }

      throw FormatException('Expected string item in list field: $key');
    }),
  );
}

List<String> requiredStringList(Map<String, Object?> json, String key) {
  final value = optionalStringList(json, key);

  if (value.isEmpty) {
    throw FormatException('Missing required string list field: $key');
  }

  return value;
}

List<T> requiredList<T>(
  Map<String, Object?> json,
  String key,
  T Function(Map<String, Object?> json) fromJson,
) {
  final value = json[key];

  if (value is! List) {
    throw FormatException('Missing required list field: $key');
  }

  return List.unmodifiable(
    value.map((item) {
      if (item is Map<String, Object?>) {
        return fromJson(item);
      }

      if (item is Map) {
        return fromJson(Map<String, Object?>.from(item));
      }

      throw FormatException('Invalid item in list field: $key');
    }),
  );
}

Map<String, Object?> requiredMap(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value is Map<String, Object?>) {
    return value;
  }

  if (value is Map) {
    return Map<String, Object?>.from(value);
  }

  throw FormatException('Missing required object field: $key');
}

bool listEquals<T>(List<T> left, List<T> right) {
  if (identical(left, right)) {
    return true;
  }

  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
}
