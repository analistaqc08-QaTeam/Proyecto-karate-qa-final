Feature: Registro de usuario

  Background:

    Given url urlBase

  @automation-api
  Scenario: CP01-Registro de usuario Exitoso
    * def data =
    """
    {
    "email": "Test05qateam@gmail.com",
    "password": "12345678",
    "nombre": "Analista 05-QA",
    "tipo_usuario_id": 1,
    "estado": 1
}
    """
    And path "/api/register"
    And request data
    When method post
    Then status 200

  @automation-api
  Scenario: CP02-Usuario existente
    * def data =
    """
    {
    "email": "Test04qateam@gmail.com",
    "password": "12345678",
    "nombre": "Analista 04-QA",
    "tipo_usuario_id": 1,
    "estado": 1
}
    """
    And path "/api/register"
    And request data
    When method post
    Then status 500
    And match response.email contains 'The email has already been taken.'
