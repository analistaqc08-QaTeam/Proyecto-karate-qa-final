Feature: Registro de producto
  Background:
    * def apilogin = call read('classpath:bdd/auth/loginAuth.feature@login')
    * def token = apilogin.token
    Given url  urlBase
    * def tokenAuth = 'Bearer '+ token
    * def random = new java.util.Random().nextInt(90) + 10
    * def codigo = 'CP0A' + random
    * def codigo1 = 'CPBA' + random

  @RegistroProducto @automation-api
  Scenario: CP01-Registro de producto Exitoso

    * print tokenAuth
    Given path "/api/v1/producto"
    And header Authorization = tokenAuth
    And request
     """
  {
    "codigo": "#(codigo)",
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
    * def idproducto = response.id
    * print idproducto

  @automation-api
  Scenario Outline: CP02-Registro de producto desde un archivo CSV
    Given path "/api/v1/producto"
    And header Authorization = tokenAuth
    And request { codigo: '#(codigo1)', nombre: '#(nombre)', medida: '#(medida)', marca: '#(marca)', categoria: '#(categoria)', precio: '#(precio)', stock: '#(stock)', estado: '#(estado)', descripcion: '#(descripcion)' }
    * print codigo
    * print nombre
    When method post
    Then status 200
    And match response contains {"nombre": "Laptop HP"}

    Examples:
      | read('classpath:resources/csv/auth/dataProducts.csv') |

  @automation-api
  Scenario: CP03-Registro de producto con codigo existente
    Given path "/api/v1/producto"
    And header Authorization = tokenAuth
    And request
     """
  {
    "codigo": "CP0A09",
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

  @automation-api
  Scenario: CP04-Registro de producto sin nombre
    Given path "/api/v1/producto"
    And header Authorization = tokenAuth
    And request
     """
  {
    "codigo": "CP0A05",
    "nombre": " ",
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
    And match response.nombre contains 'The nombre field is required.'


  @automation-api
  Scenario Outline: CP06-Registro de producto con token invalido
    Given path "/api/v1/producto"
    And header Authorization = "uJxAHeBosEHudNtz5Git544qiPLkayt1Y"
    And request { codigo: '#(codigo)', nombre: '#(nombre)', medida: '#(medida)', marca: '#(marca)', categoria: '#(categoria)', precio: '#(precio)', stock: '#(stock)', estado: '#(estado)', descripcion: '#(descripcion)' }
    When method post
    Then status 200
    And match response contains {"nombre": "Laptop HP"}

    Examples:
      | read('classpath:resources/csv/auth/dataProducts.csv') |

  @automation-api
  Scenario: CP07-Registro de producto fallido con validacion de campo
    Given path "/api/v1/producto"
    And header Authorization = tokenAuth
    And request
     """
  {
    "codigo": "CP0A05",
    "nombre": "Laptop HP",
    "medida": "UND ",
    "marca": "Generico",
    "categoria": "Repuestos",
    "precio": "precio",
    "stock": "48",
    "estado": "3",
    "descripcion": "Ploma 14 pulgadas"
}
    """
    When method post
    Then status 500
    And match response.precio contains 'The precio must be a number.'

