import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String email;
  final String password;
  const UserEntity({
    required this.userId,
    required this.email,
    required this.password,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'password': password,
    };
  }

  static UserEntity fromDocument(Map<String, dynamic> doc) {
    return UserEntity(
      userId: doc['userId'],
      email: doc['email'],
      password: doc['password'],
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        password,
      ];
}
