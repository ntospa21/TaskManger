import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String password;

  const MyUser({
    required this.email,
    required this.password,
    required this.userId,
  });

  static const empty = MyUser(
    email: '',
    password: '',
    userId: '',
  );

  MyUser copyWith({String? userId, String? email, String? password}) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email, // Corrected to use email
      password: password ?? this.password,
    );
  }

  UserEntity toEntity() {
    return UserEntity(userId: userId, email: email, password: password);
  }

  @override
  List<Object?> get props => [
        email,
        password,
        userId,
      ];
}
