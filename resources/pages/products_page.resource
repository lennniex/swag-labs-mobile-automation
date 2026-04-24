*** Settings ***
Documentation    Page Object — Pantalla de Catálogo / Productos.
...              Listado de swag items + botón de añadir al carrito + contador del cart.

Resource         ../common.resource


*** Variables ***
# ---------------------------------------------------------------------------
# Locators
# ---------------------------------------------------------------------------
# Header del catálogo (confirma que estamos en esta pantalla)
${PRODUCTS_HEADER}            xpath=//*[@text="Products" or @name="Products"]

# Cada tarjeta de producto (usado como ancla para llegar al detalle)
# El testID en my-demo-app-rn es "store item text" sobre el título.
${PRODUCT_ITEM_BY_NAME}       xpath=//*[@content-desc="store item text" or @name="store item text"][@text="{name}" or @label="{name}"]
${PRODUCT_BACKPACK}           xpath=//*[@text="Sauce Labs Backpack" or @label="Sauce Labs Backpack" or @name="Sauce Labs Backpack"]

# Cart icon (presente en el header de la mayoría de pantallas)
${CART_BADGE}                 accessibility_id=cart badge
${CART_ICON}                  accessibility_id=cart container

# Menu hamburguesa (si se necesita en otros flujos)
${MENU_BUTTON}                accessibility_id=tab bar menu button


*** Keywords ***
Verificar Que Estoy En Catalogo
    [Documentation]    Confirma que la pantalla de catálogo se cargó correctamente.
    Esperar Elemento Visible    ${PRODUCTS_HEADER}    timeout=${LONG_TIMEOUT}

Seleccionar Producto Por Nombre
    [Documentation]    Hace tap en la tarjeta del producto indicado para abrir el detalle.
    [Arguments]    ${nombre_producto}
    ${locator}=    Set Variable    xpath=//*[@text="${nombre_producto}" or @label="${nombre_producto}" or @name="${nombre_producto}"]
    Scroll Hasta Elemento    ${locator}
    Esperar Y Hacer Clic     ${locator}

Verificar Contador De Carrito
    [Documentation]    Valida que el contador del cart badge muestre el valor esperado.
    [Arguments]    ${cantidad_esperada}
    Esperar Texto En Elemento    ${CART_BADGE}    ${cantidad_esperada}

Abrir Carrito
    Esperar Y Hacer Clic    ${CART_ICON}
