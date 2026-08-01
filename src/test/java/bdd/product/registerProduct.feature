Feature: Registro de producto
  Background:
    * def apilogin = call read('classpath:bdd/auth/loginAuth.feature@login')
    * def token = apilogin.token
    Given url  urlBase
    * def tokenAuth = 'Bearer '+ token


  Scenario: CP01-Registro de producto Exitoso

    * print tokenAuth
    Given path "/api/v1/producto"
    And header Authorization = tokenAuth
    And request
     """
  {
    "codigo": "CP0A04",
    "nombre": "Laptop HP",
    "medida": "UND ",
    "marca": "Generico",
    "categoria": "Repuestos",
    "precio": "3500.00",
    "stock": "48",
    "estado": "3",
    "descripcion": "Ploma 14 pulgadas"
}
    """
    When method post
    Then status 200
    And match response contains {"nombre": "Laptop HP"}

  Scenario: CP02-Registro de producto fallido
    Given path "/api/v1/producto"
    And header Authorization = tokenAuth
    And request
     """
  {
    "codigo": "CP0A04",
    "nombre": "Laptop HP",
    "medida": "UND ",
    "marca": "Generico",
    "categoria": "Repuestos",
    "precio": "3500.00",
    "stock": "48",
    "estado": "3",
    "descripcion": "Ploma 14 pulgadas"
}
    """
    When method post
    Then status 500
