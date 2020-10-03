import 'dart:convert';

class User {
  static const int memberTypeMentor = 1;
  static const int memberTypeMentee = 2;

  String id;
  String username;
  String password;
  String email;
  String emailMessage;
  String provider;
  bool confirmed;
  bool blocked;
  String phoneNumber;
  int memberType;
  String fullName;
  DateTime dateOfBirth;
  DateTime dateStart;
  double rate;
  String description;
  int priority;

  User({
    this.id,
    this.username,
    this.password,
    this.email,
    this.provider,
    this.confirmed,
    this.blocked,
    this.phoneNumber,
    this.memberType,
    this.fullName,
    this.dateOfBirth,
    this.dateStart,
    this.rate,
    this.description,
    this.priority,
  });

  User copyWith({
    String id,
    String username,
    String password,
    String email,
    String provider,
    bool confirmed,
    bool blocked,
    String phoneNumber,
    int memberType,
    String fullName,
    DateTime dateOfBirth,
    DateTime dateStart,
    double rate,
    String description,
    int priority,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      provider: provider ?? this.provider,
      confirmed: confirmed ?? this.confirmed,
      blocked: blocked ?? this.blocked,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      memberType: memberType ?? this.memberType,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dateStart: dateStart ?? this.dateStart,
      rate: rate ?? this.rate,
      description: description ?? this.description,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'provider': provider,
      'confirmed': confirmed,
      'blocked': blocked,
      'phoneNumber': phoneNumber,
      'memberType': memberType,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth != null ? dateOfBirth.toIso8601String() : null,
      'dateStart': dateStart != null ? dateStart.toIso8601String() : null,
      'rate': rate,
      'description': description,
      'priority': priority,
    };
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      provider: map['provider'] as String,
      confirmed: map['confirmed'] as bool,
      blocked: map['blocked'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      memberType: map['memberType'] as int,
      fullName: map['fullName'] as String,
      dateOfBirth: DateTime.tryParse(map['dateOfBirth'] as String),
      dateStart: DateTime.tryParse(map['dateStart'] as String),
      rate: map['rate'] != null ? map['rate'] * 1.0 as double : null,
      description: map['description'] as String,
      priority: map['priority'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, password: $password, email: $email, provider: $provider, confirmed: $confirmed, blocked: $blocked, phoneNumber: $phoneNumber, memberType: $memberType, fullName: $fullName, dateOfBirth: $dateOfBirth, dateStart: $dateStart, rate: $rate, description: $description, priority: $priority)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User &&
        o.id == id &&
        o.username == username &&
        o.password == password &&
        o.email == email &&
        o.provider == provider &&
        o.confirmed == confirmed &&
        o.blocked == blocked &&
        o.phoneNumber == phoneNumber &&
        o.memberType == memberType &&
        o.fullName == fullName &&
        o.dateOfBirth == dateOfBirth &&
        o.dateStart == dateStart &&
        o.rate == rate &&
        o.description == description &&
        o.priority == priority;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        password.hashCode ^
        email.hashCode ^
        provider.hashCode ^
        confirmed.hashCode ^
        blocked.hashCode ^
        phoneNumber.hashCode ^
        memberType.hashCode ^
        fullName.hashCode ^
        dateOfBirth.hashCode ^
        dateStart.hashCode ^
        rate.hashCode ^
        description.hashCode ^
        priority.hashCode;
  }

  void cleanServerMessage() {
    emailMessage = null;
  }
}
