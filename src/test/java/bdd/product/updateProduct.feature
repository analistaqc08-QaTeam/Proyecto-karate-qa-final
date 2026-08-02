Feature: Actualizar producto
  Background:
    * def apilogin = call read('classpath:bdd/auth/loginAuth.feature@login')
    #* def apilogin = callonce read('classpath:bdd/auth/loginAuth.feature@login')
    * def token = apilogin.token

    * def producto = callonce read('classpath:bdd/product/registerProduct.feature@RegistroProducto')
    * print karate.pretty(producto)
    * def idproducto = producto.idproducto

    Given url  urlBase
    * def tokenAuth = 'Bearer '+ token


  Scenario: CP01-Actualizar producto Exitoso

    Given path "/api/v1/producto/" + idproducto
    And header Authorization = tokenAuth

    And request
     """
     {
       "codigo": "CP0A06",
    "nombre": "Laptop HP",
    "medida": "UND ",
    "marca": "Generico",
    "categoria": "Repuestos",
    "precio": "900.00",
    "stock": "50",
    "estado": "3",
    "descripcion": "Negra 16 pulgadas"
    }
    """
    When method put
    Then status 200
    And match response contains {"nombre": "Laptop HP"}



  Scenario: CP02-Actualizar producto sin enviar valor del token

    Given path "/api/v1/producto/" + idproducto
    And header Authorization = tokenAuth + "3502|FHm1"

    And request
     """
     {
       "codigo": "CP0A06",
    "nombre": "Laptop HP",
    "medida": "UND ",
    "marca": "Generico",
    "categoria": "Repuestos",
    "precio": "900.00",
    "stock": "50",
    "estado": "3",
    "descripcion": "Negro 16 pulgadas"
    }
    """
    When method put
    Then status 401
    And match response contains {"message": "Unauthenticated."}


