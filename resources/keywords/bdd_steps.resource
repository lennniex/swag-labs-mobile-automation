*** Settings ***
Documentation    Capa BDD: traduce los pasos Gherkin de alto nivel a
...              acciones atómicas sobre los Page Objects.
...
...              Esta capa existe para que los .robot de tests se lean como negocio
...              puro y NO tengan que invocar métodos de los Page Objects directamente.

Resource         ../common.resource
Resource         ../pages/login_page.resource
Resource         ../pages/products_page.resource
Resource         ../pages/product_details_page.resource
Resource         ../pages/cart_page.resource
Resource         ../pages/checkout_address_page.resource
Resource         ../pages/checkout_payment_page.resource
Resource         ../pages/checkout_review_page.resource
Resource         ../pages/checkout_complete_page.resource


*** Keywords ***
# ===========================================================================
# GIVEN
# ===========================================================================
que el usuario está en la pantalla de Login
    Verificar Que Estoy En Login

# ===========================================================================
# WHEN / AND
# ===========================================================================
el usuario ingresa las credenciales válidas
    [Documentation]    Autentica con el usuario estándar del reto.
    [Arguments]    ${usuario}    ${password}
    Autenticar Con Credenciales    ${usuario}    ${password}
    Verificar Que Estoy En Catalogo

selecciona el producto "${nombre_producto}" para añadirlo al carrito
    [Documentation]    Seleccionar el producto desde el catálogo, abrir su detalle
    ...                y añadirlo al carrito. Valida el contador del cart badge.
    Seleccionar Producto Por Nombre    ${nombre_producto}
    Verificar Que Estoy En Detalle Producto
    Agregar Al Carrito

completa el proceso de Checkout con datos ficticios
    [Documentation]    Recorre los 3 pasos del checkout con datos ficticios.
    ...                Datos controlados en un único punto aquí (podrían moverse a
    ...                un variables/test_data.yaml si crecen).
    # Ir al carrito desde el catálogo
    Abrir Carrito
    Verificar Que Estoy En Carrito
    Verificar Que El Carrito Contiene    Sauce Labs Backpack
    Ir A Checkout

    # Paso 1: dirección
    Verificar Que Estoy En Checkout Direccion
    Diligenciar Direccion Envio
    ...    nombre=Lennin Martinez
    ...    direccion=Calle 100 #15-20
    ...    ciudad=Bogota
    ...    zip=110111
    ...    pais=Colombia

    Continuar A Pago

    # Paso 2: pago
    Verificar Que Estoy En Checkout Pago
    Diligenciar Datos Tarjeta
    ...    nombre=Lennin Martinez
    ...    numero_tarjeta=4111111111111111
    ...    vencimiento=12/30
    ...    cvv=123
    Revisar Pedido

    # Paso 3: revisión → confirmar
    Verificar Que Estoy En Review Order
    Colocar Pedido

# ===========================================================================
# THEN
# ===========================================================================
el sistema debe mostrar una pantalla de confirmación con el mensaje de éxito
    [Documentation]    Aserción final del escenario: pantalla "Checkout Complete".
    Verificar Confirmacion De Compra Exitosa
