class User {
  final String email;
  final List<String> roles;

  User({required this.email, required this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      roles: List<String>.from(json['roles']),
    );
  }

  bool get isAdmin => roles.contains('ROLE_ADMIN');
}