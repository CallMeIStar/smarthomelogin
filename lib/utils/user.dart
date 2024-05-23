class User {
  String id;
  String email;
  String uid;
  bool isValidated;
  bool isStolen;

  User({
    required this.id,
    required this.email,
    required this.uid,
    required this.isValidated,
    required this.isStolen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      uid: json['uid'],
      isValidated: json['isValidated'],
      isStolen: json['isStolen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'uid': uid,
      'isValidated': isValidated,
      'isStolen': isStolen,
    };
  }
}
