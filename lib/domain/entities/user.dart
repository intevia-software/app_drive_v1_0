import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String? isBlock;
  final List<String> roles;
  final bool? isAccepted; // nullable bool

  const User({
    required this.email,
    required this.roles,
    this.isAccepted, 
    this.isBlock, // optionnel dans le constructeur
  });

  factory User.fromJson(Map<String, dynamic> json) {
    //print(json);
    return User(
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      isAccepted: json['isAccepted'], // peut être true, false ou null
      isBlock: json['confirmationToken'], // peut être true, false ou null
    );
  }

  bool get isAdmin => roles.contains('ROLE_ADMIN');

  // Getter pratique pour tester si accepté (true seulement si vrai)
  bool get accepted => isAccepted == true;
  String? get block => isBlock;

  @override
  List<Object?> get props => [email, roles, isAccepted, isBlock];
}
