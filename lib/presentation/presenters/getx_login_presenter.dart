import 'dart:async';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/login/login_presenter.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

class GetxLoginPresenter extends GetxController
    with
        FormValidationManager,
        LoadingManager,
        EmailErrorManager,
        MainErrorManager,
        PasswordErrorManager,
        NavigationManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    emailError = _validateField('email');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    passwordError = _validateField('password');
    _validateForm();
  }

  UIError _validateField(String field) {
    final formData = {
      'email': _email,
      'password': _password,
    };
    final error = validation.validate(field: field, input: formData);

    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    isFormValid = emailErrorValue == null &&
        passwordErrorValue == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await authentication.auth(AuthenticationParams(
        email: _email,
        password: _password,
      ));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
      isLoading = false;
    }
  }

  void dispose() {}

  void goToSignUp() {
    navigateTo = '/signup';
  }
}
