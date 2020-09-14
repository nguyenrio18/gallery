import 'dart:convert';

class ModelPlh {
  String id;
  ModelPlh({
    this.id,
  });

  ModelPlh copyWith({
    String id,
  }) {
    return ModelPlh(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
    };
    return map;
  }

  factory ModelPlh.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ModelPlh(
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelPlh.fromJson(String source) =>
      ModelPlh.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Model(id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ModelPlh && o.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
