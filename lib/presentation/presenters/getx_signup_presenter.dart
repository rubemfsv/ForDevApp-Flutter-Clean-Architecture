import 'dart:async';
import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/signup/signup.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

class GetxSignUpPresenter extends GetxController
    with
        FormValidationManager,
        LoadingManager,
        EmailErrorManager,
        MainErrorManager,
        PasswordErrorManager,
        NavigationManager
    implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  final _nameError = Rx<UIError>();
  final _passwordConfirmationError = Rx<UIError>();

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;

  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    emailError = _validateField('email');
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    passwordError = _validateField('password');
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  UIError _validateField(String field) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
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
    isFormValid = _nameError.value == null &&
        emailErrorValue == null &&
        passwordErrorValue == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  Future<void> signUp() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await addAccount.add(AddAccountParams(
        name: _name,
        email: _email,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          mainError = UIError.emailInUse;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
      isLoading = false;
    }
  }

  void goToLogin() {
    navigateTo = '/login';
  }
}
