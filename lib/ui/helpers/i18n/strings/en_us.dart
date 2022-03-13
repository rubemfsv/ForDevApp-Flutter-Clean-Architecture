import 'translations.dart';

class EnUs implements Translations {
  // General messages
  String get msgEmailInUse => "Email is already in use.";
  String get msgInvalidCredentials => "Invalid credentials.";
  String get msgInvalidField => "Invalid field";
  String get msgRequiredField => "Required field";
  String get msgUnexpectedError => "Something went wrong. Try again later.";

  // Label texts
  String get emailLabel => "Email";
  String get nameLabel => "Name";
  String get passwordLabel => "Password";
  String get passwordConfirmationLabel => "Confirm your password";

  // Button texts
  String get enterButtonText => "Enter";
  String get reloadButtonText => "Reload";

  // Other texts
  String get appTitle => "Hear";
  String get createAccount => "Create account";
  String get loading => "Loading...";
  String get login => "Login";
  String get surveys => "Surveys";
}
