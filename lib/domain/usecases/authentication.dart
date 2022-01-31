import 'package:meta/meta.dart';
import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    @required String this.email, 
    @required String this.password
  });

  Map toJson() => {'email': email, 'password': password};
}
