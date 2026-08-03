Feature: Ingreso de usuario

  Background:

    Given url  urlBase

  @login @automation-api
  Scenario: CP01-Inicio de session exitoso
    * def data =
    """
    {
    "email": "Test04qateam@gmail.com",
    "password": "12345678",
  }
    """
    And path "/api/login"
    And request data
    When method post
    Then status 200
    * def token = response.access_token
    * print token

  @automation-api
  Scenario: CP02-login Fallido
    * def data =
    """
    {
    "email": "karate123@gmail.com",
    "password": "12345678",
  }
    """
    And path "/api/login"
    And request data
    When method post
    Then status 401
    * print response
    And match response.message contains 'Datos incorrectos'