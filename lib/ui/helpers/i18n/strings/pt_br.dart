import 'translations.dart';

class PtBr implements Translations {
  String get msgRequiredField => "Campo obrigatório";
  String get msgInvalidField => "Campo inválido";
  String get msgInvalidCredentials => "Credenciais inválidas.";
  String get msgUnexpectedError =>
      "Algo errado aconteceu. Tente novamente em breve.";

  String get appTitle => "Hear";
  String get createAccount => "Criar conta";
  String get emailLabel => "Email";
  String get enterButtonText => "Entrar";
  String get loading => "Aguarde...";
  String get login => "Login";
  String get passwordLabel => "Senha";
}
