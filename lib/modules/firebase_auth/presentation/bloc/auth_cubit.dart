import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entity/user_entity.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(AuthInitial());

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await repository.createUser(
      name: name,
      email: email,
      password: password,
    );

    if (result.user != null) {
      emit(AuthSuccess(result.user!));
    } else {
      emit(AuthError(result.error ?? 'Unknown error'));
    }
  }
}
