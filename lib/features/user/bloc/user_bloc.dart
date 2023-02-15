import 'dart:async';

import 'package:flutter_platzi_trips/features/user/model/user_model.dart';
import 'package:flutter_platzi_trips/features/user/repository/auth_api.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserBloc implements Bloc {
  Stream<UserModel> streamAuth = AuthApi.authApiEndpoint();
  Stream<UserModel> get authStatus => streamAuth;

  @override
  void dispose() {}
}
