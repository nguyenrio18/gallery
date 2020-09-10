class User {
  static const String roleUser = 'ROLE_USER';
  static const String roleAdmin = 'ROLE_ADMIN';
  static const String roleMentor = 'ROLE_MENTOR';
  static const String roleMentee = 'ROLE_MENTEE';

  bool activated;
  var authorities = List<String>.filled(0, null, growable: true);
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

  Map<String, dynamic> toMap() {
    var map = {
      'activated': true,
      'authorities': authorities,
      'createdBy': createdBy,
      'createdDate': createdDate != null ? createdDate.toIso8601String() : null,
      'email': email,
      'firstName': firstName,
      'id': id,
      'imageUrl': imageUrl,
      'langKey': langKey,
      'lastModifiedBy': lastModifiedBy,
      'lastModifiedDate':
          lastModifiedDate != null ? lastModifiedDate.toIso8601String() : null,
      'lastName': lastName,
      'login': login,
      'password': password
    };
    return map;
  }

  void cleanServerMessage() {
    emailMessage = null;
  }
}
