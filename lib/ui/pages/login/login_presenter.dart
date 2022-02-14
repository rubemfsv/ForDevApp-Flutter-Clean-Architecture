abstract class LoginPresenter {
  Stream get emailErrorStream;
  Stream get passwordErrorStream;
  Stream get isFormValidStreamStream;

  void validateEmail(String email);
  void validatePassword(String password);
}
