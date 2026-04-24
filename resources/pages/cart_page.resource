*** Settings ***
Documentation    Page Object — Pantalla del Carrito (My Cart).

Resource         ../common.resource


*** Variables ***
${CART_SCREEN_TITLE}               xpath=//*[@text="My Cart" or @name="My Cart"]
${CART_ITEM_BY_NAME}               xpath=//*[@text="{name}" or @label="{name}" or @name="{name}"]
${PROCEED_TO_CHECKOUT_BUTTON}      accessibility_id=Proceed To Checkout button
${PROCEED_TO_CHECKOUT_FB}          xpath=//*[@text="Proceed To Checkout" or @label="Proceed To Checkout" or @name="Proceed To Checkout"]


*** Keywords ***
Verificar Que Estoy En Carrito
    [Documentation]    Confirma que la pantalla del carrito esté cargada.
    Esperar Elemento Visible    ${CART_SCREEN_TITLE}    timeout=${LONG_TIMEOUT}

Verificar Que El Carrito Contiene
    [Documentation]    Valida la presencia de un producto por su nombre.
    [Arguments]    ${nombre_producto}
    ${locator}=    Set Variable    xpath=//*[@text="${nombre_producto}" or @label="${nombre_producto}" or @name="${nombre_producto}"]
    Esperar Elemento Visible    ${locator}

Ir A Checkout
    ${encontrado}=    Run Keyword And Return Status    Click Element    ${PROCEED_TO_CHECKOUT_BUTTON}
    IF    not ${encontrado}
        Esperar Y Hacer Clic    ${PROCEED_TO_CHECKOUT_FB}
    END
