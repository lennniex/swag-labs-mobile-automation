*** Settings ***
Documentation    Page Object — Checkout paso 2: información de pago (tarjeta).

Resource         ../common.resource


*** Variables ***
${PAYMENT_FULL_NAME}           accessibility_id=Full Name* input field
${PAYMENT_CARD_NUMBER}         accessibility_id=Card Number* input field
${PAYMENT_EXPIRATION_DATE}     accessibility_id=Expiration Date* input field
${PAYMENT_SECURITY_CODE}       accessibility_id=Security Code* input field
${PAYMENT_BILLING_SAME_CHECKBOX}    accessibility_id=Billing Address Same As Shipping Address

${REVIEW_ORDER_BUTTON}         accessibility_id=Review Order button
${REVIEW_ORDER_BUTTON_FB}      xpath=//*[@text="Review Order" or @label="Review Order" or @name="Review Order"]


*** Keywords ***
Verificar Que Estoy En Checkout Pago
    Esperar Elemento Visible    ${PAYMENT_CARD_NUMBER}    timeout=${LONG_TIMEOUT}

Diligenciar Datos Tarjeta
    [Arguments]    ${nombre}    ${numero_tarjeta}    ${vencimiento}    ${cvv}
    Esperar Y Escribir    ${PAYMENT_FULL_NAME}         ${nombre}
    Esperar Y Escribir    ${PAYMENT_CARD_NUMBER}       ${numero_tarjeta}
    Esperar Y Escribir    ${PAYMENT_EXPIRATION_DATE}   ${vencimiento}
    Esperar Y Escribir    ${PAYMENT_SECURITY_CODE}     ${cvv}
    Hide Keyboard

Revisar Pedido
    Scroll Hasta Elemento    ${REVIEW_ORDER_BUTTON}    max_intentos=3
    ${ok}=    Run Keyword And Return Status    Click Element    ${REVIEW_ORDER_BUTTON}
    IF    not ${ok}
        Esperar Y Hacer Clic    ${REVIEW_ORDER_BUTTON_FB}
    END
