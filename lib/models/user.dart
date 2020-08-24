import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String token;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phoneNumber;

  User({
    this.token,
    this.name,
    this.phoneNumber,
  });
}
