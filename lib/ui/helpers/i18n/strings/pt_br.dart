import 'translations.dart';

class PtBr implements Translations {
  // General messages
  String get msgEmailInUse => "Email já está em uso.";
  String get msgInvalidCredentials => "Credenciais inválidas.";
  String get msgInvalidField => "Campo inválido";
  String get msgRequiredField => "Campo obrigatório";
  String get msgUnexpectedError =>
      "Algo errado aconteceu. Tente novamente em breve.";

  // Label texts
  String get emailLabel => "Email";
  String get nameLabel => "Nome";
  String get passwordLabel => "Senha";
  String get passwordConfirmationLabel => "Confirmar senha";

  // Button texts
  String get enterButtonText => "Entrar";
  String get reloadButtonText => "Recarregar";

  // Other texts
  String get appTitle => "Hear";
  String get createAccount => "Criar conta";
  String get loading => "Aguarde...";
  String get login => "Login";
  String get surveys => "Enquetes";
}
