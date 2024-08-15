import 'package:blogify/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required super.email, required super.name, required super.id})
      : super();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        id: json['id'] ?? '');
  }

  UserModel copyWith({String? email, String? name, String? id}) {
    return UserModel(
        email: email ?? this.email, name: name ?? this.name, id: id ?? this.id);
  }
}
