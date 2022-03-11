import '../helpers.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.translations.msgRequiredField;
      case UIError.invalidField:
        return R.translations.msgInvalidField;
      case UIError.invalidCredentials:
        return R.translations.msgInvalidCredentials;
      case UIError.emailInUse:
        return R.translations.msgEmailInUse;
      default:
        return R.translations.msgUnexpectedError;
    }
  }
}
