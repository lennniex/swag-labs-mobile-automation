*** Settings ***
Documentation    Page Object — Pantalla de detalle de un producto.
...              Donde se agrega el item al carrito.

Resource         ../common.resource


*** Variables ***
# ---------------------------------------------------------------------------
# Locators
# ---------------------------------------------------------------------------
${PRODUCT_DETAILS_TITLE}            xpath=//*[@content-desc="product description" or @name="product description"]
${ADD_TO_CART_BUTTON}               accessibility_id=Add To Cart button
${ADD_TO_CART_BUTTON_FALLBACK}      xpath=//*[@text="Add To Cart" or @label="Add To Cart" or @name="Add To Cart"]

${BACK_BUTTON}                      accessibility_id=container header
${COUNTER_PLUS}                     accessibility_id=counter plus button
${COUNTER_MINUS}                    accessibility_id=counter minus button
${COUNTER_AMOUNT}                   accessibility_id=counter amount


*** Keywords ***
Verificar Que Estoy En Detalle Producto
    [Documentation]    Confirma que estamos en el detalle (aparece el CTA "Add To Cart").
    ${visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${ADD_TO_CART_BUTTON}    timeout=${DEFAULT_TIMEOUT}
    IF    not ${visible}
        Wait Until Element Is Visible    ${ADD_TO_CART_BUTTON_FALLBACK}    timeout=${DEFAULT_TIMEOUT}
    END

Agregar Al Carrito
    [Documentation]    Presiona el botón "Add To Cart". Usa el fallback si el
    ...                accessibility_id principal no está presente en este build.
    ${encontrado}=    Run Keyword And Return Status    Click Element    ${ADD_TO_CART_BUTTON}
    IF    not ${encontrado}
        Esperar Y Hacer Clic    ${ADD_TO_CART_BUTTON_FALLBACK}
    END
