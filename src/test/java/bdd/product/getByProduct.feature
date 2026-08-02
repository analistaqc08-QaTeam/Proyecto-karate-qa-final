Feature: Obtener producto
  Background:
    * def apilogin = call read('classpath:bdd/auth/loginAuth.feature@login')
    #* def apilogin = callonce read('classpath:bdd/auth/loginAuth.feature@login')
    * def token = apilogin.token

    * def producto = callonce read('classpath:bdd/product/registerProduct.feature@RegistroProducto')
    * print karate.pretty(producto)
    * def idproducto = producto.idproducto

    Given url  urlBase
    * def tokenAuth = 'Bearer '+ token
    * print tokenAuth
    * print idproducto


  Scenario: CP01-Obtener listado de producto por ID
    * print tokenAuth
    Given path "/api/v1/producto/" + idproducto
    And header Authorization = tokenAuth
    When method get
    Then status 200
    And match response.nombre != null
    And match response.id == idproducto
    And match response contains
      """
      {
         nombre: 'Laptop HP',
         marca: 'Generico',
         categoria: 'Repuestos'
      }
      """

  Scenario: CP02-Obtener listado de producto por ID errado
    Given path "/api/v1/producto/"
    And header Authorization = tokenAuth
    When method get
    Then status 404
    And match response.error contains 'Producto no encontrado'
    And match response.id  == idproducto
