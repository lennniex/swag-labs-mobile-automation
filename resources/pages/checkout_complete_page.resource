*** Settings ***
Documentation    Page Object — Pantalla de confirmación final post-compra.
...              Es la pantalla que valida el Then del escenario Gherkin.

Resource         ../common.resource


*** Variables ***
# my-demo-app-rn muestra "Checkout Complete" como título y
# "Thank you for your order" como mensaje principal.
${CHECKOUT_COMPLETE_TITLE}     xpath=//*[@text="Checkout Complete" or @name="Checkout Complete"]
${THANK_YOU_MESSAGE}           xpath=//*[contains(@text,"Thank you for your order") or contains(@name,"Thank you for your order") or contains(@label,"Thank you for your order")]
${CONTINUE_SHOPPING_BUTTON}    accessibility_id=Continue Shopping button


*** Keywords ***
Verificar Confirmacion De Compra Exitosa
    [Documentation]    Valida tanto el título de la pantalla como el mensaje de éxito.
    ...                Doble aserción para dar evidencia robusta en el report.html.
    Esperar Elemento Visible    ${CHECKOUT_COMPLETE_TITLE}    timeout=${LONG_TIMEOUT}
    Esperar Elemento Visible    ${THANK_YOU_MESSAGE}          timeout=${DEFAULT_TIMEOUT}
    Capture Page Screenshot     filename=checkout_exitoso.png

Obtener Mensaje De Confirmacion
    [Documentation]    Retorna el texto del título para aserciones de negocio.
    ${texto}=    Get Text    ${CHECKOUT_COMPLETE_TITLE}
    RETURN    ${texto}
