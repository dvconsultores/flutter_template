import 'package:flutter/material.dart';

import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/routes/user/model/user_model.dart';
import 'package:flutter_detextre4/routes/user/repository/auth_api_interface.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class AuthApi implements AuthApiInterface {
  AuthApi(this.context);
  final BuildContext context;

  late final _userBloc = BlocProvider.of<UserBloc>(context);

  @override
  Future<void> signIn() async {
    // ? just for showcase - when go work uncomment other lines and delete this
    final value = UserModel.fromJson({
      "uid": 1,
      "name": "herian",
      "email": "detextre4@gmail.com",
      "photoURL": "unafotoahi"
    });
    _userBloc.addData = value;

    // final response = await FetchConfig.get(
    //   Uri.parse('${FetchConfig.baseUrl}/endpoint/'),
    //   headers: FetchConfig.headersWithoutAuth,
    //   showRequest: true,
    //   showResponse: true,
    //   requestRef: "endpoint",
    // );

    // _userBloc.addData = UserModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<UserModel> signUp() {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    _userBloc.closeSession;
  }
}
