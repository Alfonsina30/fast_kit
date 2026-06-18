import 'package:fast_kit/modules/firebase_auth/firebase_auth_files.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email, super.name});

  UserEntity modelToEntity() => UserEntity(id: id, email: email, name: name);
}
