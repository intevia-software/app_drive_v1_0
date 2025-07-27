import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final List<String> roles;

  const User({required this.email, required this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  bool get isAdmin => roles.contains('ROLE_ADMIN');

  @override
  List<Object> get props => [email, roles];
}
