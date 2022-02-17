enum DomainError { unexpected, invalidCredentials }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.unexpected:
        return 'Unexpected error';
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';
      default:
        return 'Erro inesperado.';
    }
  }
}
