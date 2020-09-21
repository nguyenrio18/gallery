import 'dart:convert';

class User {
  static const String roleUser = 'ROLE_USER';
  static const String roleAdmin = 'ROLE_ADMIN';
  static const String roleMentor = 'ROLE_MENTOR';
  static const String roleMentee = 'ROLE_MENTEE';

  bool activated;
  List<String> authorities;
  String createdBy;
  DateTime createdDate;
  String email;
  String emailMessage;
  String firstName;
  String id;
  String imageUrl;
  String langKey;
  String lastModifiedBy;
  DateTime lastModifiedDate;
  String lastName;
  String login;
  String password;

  User({
    this.activated,
    this.authorities,
    this.createdBy,
    this.createdDate,
    this.email,
    this.emailMessage,
    this.firstName,
    this.id,
    this.imageUrl,
    this.langKey,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.lastName,
    this.login,
    this.password,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'activated': activated,
      'authorities': authorities,
      'createdBy': createdBy,
      'createdDate': createdDate != null ? createdDate.toIso8601String() : null,
      'email': email,
      'emailMessage': emailMessage,
      'firstName': firstName,
      'id': id,
      'imageUrl': imageUrl,
      'langKey': langKey,
      'lastModifiedBy': lastModifiedBy,
      'lastModifiedDate':
          lastModifiedDate != null ? lastModifiedDate.toIso8601String() : null,
      'lastName': lastName,
      'login': login,
      'password': password,
    };
    return map;
  }

  User copyWith({
    bool activated,
    List<String> authorities,
    String createdBy,
    DateTime createdDate,
    String email,
    String emailMessage,
    String firstName,
    String id,
    String imageUrl,
    String langKey,
    String lastModifiedBy,
    DateTime lastModifiedDate,
    String lastName,
    String login,
    String password,
  }) {
    return User(
      activated: activated ?? this.activated,
      authorities: authorities ?? this.authorities,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      email: email ?? this.email,
      emailMessage: emailMessage ?? this.emailMessage,
      firstName: firstName ?? this.firstName,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      langKey: langKey ?? this.langKey,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastName: lastName ?? this.lastName,
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      activated: map['activated'] as bool,
      authorities: (map['authorities'] as List<dynamic>)
          .cast<String>(), // as List<String>,
      createdBy: map['createdBy'] as String,
      createdDate: DateTime.tryParse(map['createdDate'] as String),
      email: map['email'] as String,
      emailMessage: map['emailMessage'] as String,
      firstName: map['firstName'] as String,
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      langKey: map['langKey'] as String,
      lastModifiedBy: map['lastModifiedBy'] as String,
      lastModifiedDate: DateTime.tryParse(map['lastModifiedDate'] as String),
      lastName: map['lastName'] as String,
      login: map['login'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(activated: $activated, authorities: $authorities, createdBy: $createdBy, createdDate: $createdDate, email: $email, emailMessage: $emailMessage, firstName: $firstName, id: $id, imageUrl: $imageUrl, langKey: $langKey, lastModifiedBy: $lastModifiedBy, lastModifiedDate: $lastModifiedDate, lastName: $lastName, login: $login, password: $password)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User &&
        o.activated == activated &&
        o.authorities == authorities &&
        o.createdBy == createdBy &&
        o.createdDate == createdDate &&
        o.email == email &&
        o.emailMessage == emailMessage &&
        o.firstName == firstName &&
        o.id == id &&
        o.imageUrl == imageUrl &&
        o.langKey == langKey &&
        o.lastModifiedBy == lastModifiedBy &&
        o.lastModifiedDate == lastModifiedDate &&
        o.lastName == lastName &&
        o.login == login &&
        o.password == password;
  }

  @override
  int get hashCode {
    return activated.hashCode ^
        authorities.hashCode ^
        createdBy.hashCode ^
        createdDate.hashCode ^
        email.hashCode ^
        emailMessage.hashCode ^
        firstName.hashCode ^
        id.hashCode ^
        imageUrl.hashCode ^
        langKey.hashCode ^
        lastModifiedBy.hashCode ^
        lastModifiedDate.hashCode ^
        lastName.hashCode ^
        login.hashCode ^
        password.hashCode;
  }

  void cleanServerMessage() {
    emailMessage = null;
  }
}
