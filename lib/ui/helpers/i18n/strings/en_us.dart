import 'translations.dart';

class EnUs implements Translations {
  String get msgEmailInUse => "Email is already in use.";
  String get msgInvalidCredentials => "Invalid credentials.";
  String get msgInvalidField => "Invalid field";
  String get msgRequiredField => "Required field";
  String get msgUnexpectedError => "Something went wrong. Try again later.";

  String get emailLabel => "Email";
  String get nameLabel => "Name";
  String get passwordLabel => "Password";
  String get passwordConfirmationLabel => "Confirm your password";

  String get appTitle => "Hear";
  String get createAccount => "Create account";
  String get enterButtonText => "Enter";
  String get loading => "Loading...";
  String get login => "Login";
}
