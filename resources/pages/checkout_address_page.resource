*** Settings ***
Documentation    Page Object — Checkout paso 1: dirección de envío.
...              Este Page ejemplifica el manejo de diferencias entre plataformas:
...              el scroll para llegar al botón "To Payment" difiere en iOS vs Android.

Resource         ../common.resource


*** Variables ***
# ---------------------------------------------------------------------------
# Locators de los inputs de la dirección
# ---------------------------------------------------------------------------
${CHECKOUT_ADDRESS_TITLE}    xpath=//*[@text="Checkout" or @name="Checkout"]

${INPUT_FULL_NAME}           accessibility_id=Full Name* input field
${INPUT_ADDRESS_LINE_1}      accessibility_id=Address Line 1* input field
${INPUT_ADDRESS_LINE_2}      accessibility_id=Address Line 2 input field
${INPUT_CITY}                accessibility_id=City* input field
${INPUT_STATE_REGION}        accessibility_id=State/Region input field
${INPUT_ZIP_CODE}            accessibility_id=Zip Code* input field
${INPUT_COUNTRY}             accessibility_id=Country* input field

${TO_PAYMENT_BUTTON}         accessibility_id=To Payment button
${TO_PAYMENT_BUTTON_FB}      xpath=//*[@text="To Payment" or @label="To Payment" or @name="To Payment"]


*** Keywords ***
Verificar Que Estoy En Checkout Direccion
    Esperar Elemento Visible    ${INPUT_FULL_NAME}    timeout=${LONG_TIMEOUT}

Diligenciar Direccion Envio
    [Documentation]    Llena el formulario de dirección con los datos ficticios provistos.
    [Arguments]    ${nombre}    ${direccion}    ${ciudad}    ${zip}    ${pais}
    ...            ${direccion_2}=    ${region}=
    Esperar Y Escribir    ${INPUT_FULL_NAME}         ${nombre}
    Esperar Y Escribir    ${INPUT_ADDRESS_LINE_1}    ${direccion}
    Run Keyword If    '${direccion_2}' != ''    Esperar Y Escribir    ${INPUT_ADDRESS_LINE_2}    ${direccion_2}
    Esperar Y Escribir    ${INPUT_CITY}              ${ciudad}
    Run Keyword If    '${region}' != ''         Esperar Y Escribir    ${INPUT_STATE_REGION}    ${region}
    Esperar Y Escribir    ${INPUT_ZIP_CODE}          ${zip}
    Esperar Y Escribir    ${INPUT_COUNTRY}           ${pais}
    Hide Keyboard

Continuar A Pago
    [Documentation]    En Android el botón puede quedar debajo del teclado/fold;
    ...                hacemos scroll defensivo antes de presionarlo.
    Scroll Hasta Elemento    ${TO_PAYMENT_BUTTON}    max_intentos=3
    ${ok}=    Run Keyword And Return Status    Click Element    ${TO_PAYMENT_BUTTON}
    IF    not ${ok}
        Esperar Y Hacer Clic    ${TO_PAYMENT_BUTTON_FB}
    END
