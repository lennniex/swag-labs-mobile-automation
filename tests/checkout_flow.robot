*** Settings ***
Documentation    Suite E2E: Flujo de compra exitosa en Swag Labs Mobile App.
...              Escenarios escritos en sintaxis Gherkin (Given/When/And/Then)
...              sobre la app my-demo-app-rn de Sauce Labs.

Resource         ../resources/common.resource
Resource         ../resources/keywords/bdd_steps.resource

Suite Setup      Abrir Aplicacion
Suite Teardown   Cerrar Aplicacion

Test Tags        mobile    e2e    checkout


*** Test Cases ***
Compra exitosa de Sauce Labs Backpack
    [Documentation]    Un usuario autenticado puede seleccionar un producto,
    ...                completar el checkout con datos válidos y recibir la
    ...                pantalla de confirmación de compra exitosa.
    [Tags]             happy-path    smoke    P1
    Given que el usuario está en la pantalla de Login
    When el usuario ingresa las credenciales válidas    bob@example.com    10203040
    And selecciona el producto "Sauce Labs Backpack" para añadirlo al carrito
    And completa el proceso de Checkout con datos ficticios
    Then el sistema debe mostrar una pantalla de confirmación con el mensaje de éxito
