Feature: Login
  Como um cliente
  Quero poder acessar minha conta e me manter logado
  Para que eu possa ver e responder enquetes de forma rápida para

  Scenario: Credenciais Válidas
    Given que o cliente informou credenciais válidas
    When solicitar para fazer login
    Then o sistema deve enviar o usuário para a tela de pesquisas
    And manter o usuário conectado

  Scenario: Credenciais Inválidas
    Given que o cliente informou credenciais inválidas
    When solicitar para fazer login
    Then o sistema deve retornar uma mensagem de erro
