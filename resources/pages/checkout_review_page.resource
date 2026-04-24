*** Settings ***
Documentation    Page Object — Checkout paso 3: revisión del pedido y confirmación.

Resource         ../common.resource


*** Variables ***
${REVIEW_SCREEN_TITLE}       xpath=//*[@text="Review Order" or @name="Review Order"]
${PLACE_ORDER_BUTTON}        accessibility_id=Place Order button
${PLACE_ORDER_BUTTON_FB}     xpath=//*[@text="Place Order" or @label="Place Order" or @name="Place Order"]


*** Keywords ***
Verificar Que Estoy En Review Order
    Esperar Elemento Visible    ${REVIEW_SCREEN_TITLE}    timeout=${LONG_TIMEOUT}

Colocar Pedido
    Scroll Hasta Elemento    ${PLACE_ORDER_BUTTON}    max_intentos=3
    ${ok}=    Run Keyword And Return Status    Click Element    ${PLACE_ORDER_BUTTON}
    IF    not ${ok}
        Esperar Y Hacer Clic    ${PLACE_ORDER_BUTTON_FB}
    END
