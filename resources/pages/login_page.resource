*** Settings ***
Documentation    Page Object — Pantalla de Login.
...              Encapsula locators y acciones atómicas de la página.
...              NO contiene lógica de negocio ni aserciones de escenario.

Resource         ../common.resource


*** Variables ***
# ---------------------------------------------------------------------------
# Locators — orden de preferencia: accessibility_id > id > xpath relativo.
# ---------------------------------------------------------------------------
# NOTA: my-demo-app-rn expone accessibility IDs cross-platform vía testProperties.
# Si alguno no coincide con tu build, abre Appium Inspector y reemplaza UN solo
# valor aquí — el resto del framework no cambia.
# ---------------------------------------------------------------------------
${LOGIN_USERNAME_FIELD}        accessibility_id=Username input field
${LOGIN_PASSWORD_FIELD}        accessibility_id=Password input field
${LOGIN_BUTTON}                accessibility_id=Login button-login-container

# Fallbacks por si el build difiere (útil para el patrón "locator con OR")
${LOGIN_USERNAME_FALLBACK}     xpath=//*[@content-desc="Username input field" or @name="Username input field"]
${LOGIN_PASSWORD_FALLBACK}     xpath=//*[@content-desc="Password input field" or @name="Password input field"]
${LOGIN_BUTTON_FALLBACK}       xpath=//*[@text="Login" or @label="Login" or @name="Login"]


*** Keywords ***
# ---------------------------------------------------------------------------
# Acciones atómicas de la página
# ---------------------------------------------------------------------------
Verificar Que Estoy En Login
    [Documentation]    Verifica que la pantalla de Login esté desplegada.
    Esperar Elemento Visible    ${LOGIN_USERNAME_FIELD}
    Esperar Elemento Visible    ${LOGIN_PASSWORD_FIELD}
    Esperar Elemento Visible    ${LOGIN_BUTTON}

Ingresar Usuario
    [Arguments]    ${usuario}
    Esperar Y Escribir    ${LOGIN_USERNAME_FIELD}    ${usuario}

Ingresar Password
    [Arguments]    ${password}
    Esperar Y Escribir    ${LOGIN_PASSWORD_FIELD}    ${password}
    Hide Keyboard

Presionar Boton Login
    Esperar Y Hacer Clic    ${LOGIN_BUTTON}

Autenticar Con Credenciales
    [Documentation]    Keyword de conveniencia que compone las 3 acciones del login.
    [Arguments]    ${usuario}    ${password}
    Ingresar Usuario    ${usuario}
    Ingresar Password   ${password}
    Presionar Boton Login
