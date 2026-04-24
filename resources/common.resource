*** Settings ***
Documentation    Configuración transversal de la suite:
...              - Setup/Teardown con capabilities dinámicas por plataforma.
...              - Keywords reutilizables para esperas y acciones robustas.
...              Carga variables desde config/android.py o config/ios.py
...              según el archivo pasado con --variablefile.

Library          AppiumLibrary    timeout=${DEFAULT_TIMEOUT}    run_on_failure=Capture Page Screenshot
Library          Collections
Library          OperatingSystem


*** Variables ***
# Valores por defecto — sobreescribibles por el archivo de capabilities.
${DEFAULT_TIMEOUT}    20s
${SHORT_TIMEOUT}      5s
${LONG_TIMEOUT}       45s


*** Keywords ***
# ---------------------------------------------------------------------------
# Suite lifecycle
# ---------------------------------------------------------------------------
Abrir Aplicacion
    [Documentation]    Abre la app con capabilities dinámicas según ${PLATFORM_NAME}.
    ...                Falla temprano con mensaje claro si falta configuración.
    Validar Configuracion
    ${capabilities}=    Construir Capabilities
    Log Dictionary    ${capabilities}    level=INFO
    Open Application    ${APPIUM_SERVER}    &{capabilities}
    Set Appium Timeout    ${DEFAULT_TIMEOUT}

Cerrar Aplicacion
    [Documentation]    Cierra la sesión Appium aun si la prueba falló.
    Run Keyword And Ignore Error    Close Application

Validar Configuracion
    [Documentation]    Verifica que las variables mínimas existan y que el binario esté accesible.
    Should Not Be Empty    ${PLATFORM_NAME}      PLATFORM_NAME no está definido — ¿olvidó --variablefile?
    Should Not Be Empty    ${APPIUM_SERVER}      APPIUM_SERVER no está definido.
    Should Not Be Empty    ${APP_PATH}           APP_PATH no está definido.
    ${msg_binario}=    Catenate    SEPARATOR=${SPACE}
    ...    El binario no existe en: ${APP_PATH}.
    ...    Descargue el .apk/.app desde https://github.com/saucelabs/my-demo-app-rn/releases
    ...    y colóquelo en ./apps/
    File Should Exist    ${APP_PATH}    ${msg_binario}

Construir Capabilities
    [Documentation]    Construye el diccionario de capabilities según la plataforma.
    ...                Centraliza TODAS las diferencias Android/iOS en un solo punto.
    ${caps}=    Create Dictionary
    ...    platformName=${PLATFORM_NAME}
    ...    automationName=${AUTOMATION_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_PATH}
    ...    newCommandTimeout=${NEW_COMMAND_TIMEOUT}
    ...    noReset=${NO_RESET}
    ...    fullReset=${FULL_RESET}

    IF    '${PLATFORM_NAME}' == 'Android'
        Set To Dictionary    ${caps}
        ...    appPackage=${APP_PACKAGE}
        ...    appActivity=${APP_ACTIVITY}
        ...    autoGrantPermissions=${AUTO_GRANT_PERMISSIONS}
        ...    adbExecTimeout=${ADB_EXEC_TIMEOUT}
        ...    uiautomator2ServerInstallTimeout=${UIAUTOMATOR2_SERVER_INSTALL_TIMEOUT}
    ELSE IF    '${PLATFORM_NAME}' == 'iOS'
        Set To Dictionary    ${caps}
        ...    bundleId=${BUNDLE_ID}
        ...    platformVersion=${PLATFORM_VERSION}
        ...    autoAcceptAlerts=${AUTO_ACCEPT_ALERTS}
        ...    wdaLaunchTimeout=${WDA_LAUNCH_TIMEOUT}
        ...    wdaConnectionTimeout=${WDA_CONNECTION_TIMEOUT}
    END

    # UDID solo si viene definido (real device)
    ${udid_defined}=    Run Keyword And Return Status    Variable Should Exist    ${UDID}
    IF    ${udid_defined} and '${UDID}' != ''
        Set To Dictionary    ${caps}    udid=${UDID}
    END

    RETURN    ${caps}

# ---------------------------------------------------------------------------
# Esperas explícitas — cero Sleep fijos
# ---------------------------------------------------------------------------
Esperar Y Hacer Clic
    [Documentation]    Espera a que el elemento sea visible y lo presiona.
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Click Element    ${locator}

Esperar Y Escribir
    [Documentation]    Espera a que el input sea visible y escribe el texto.
    [Arguments]    ${locator}    ${texto}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Clear Text    ${locator}
    Input Text    ${locator}    ${texto}

Esperar Texto En Elemento
    [Documentation]    Verifica que el elemento contenga el texto esperado.
    [Arguments]    ${locator}    ${texto_esperado}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Element Should Contain Text    ${locator}    ${texto_esperado}

Esperar Elemento Visible
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}

Esperar Pagina Contiene Elemento
    [Arguments]    ${locator}    ${timeout}=${DEFAULT_TIMEOUT}
    Wait Until Page Contains Element    ${locator}    timeout=${timeout}

# ---------------------------------------------------------------------------
# Gestos — scroll cross-platform
# ---------------------------------------------------------------------------
Scroll Hasta Elemento
    [Documentation]    Scroll robusto cross-platform hasta hacer visible el elemento.
    [Arguments]    ${locator}    ${max_intentos}=5
    FOR    ${i}    IN RANGE    ${max_intentos}
        ${visible}=    Run Keyword And Return Status    Expect Element    ${locator}    visible
        IF    ${visible}    RETURN
        Swipe By Percent    50    75    50    25    duration=800
    END
    Expect Element    ${locator}    visible
    ...    message=Elemento ${locator} no encontrado luego de ${max_intentos} swipes.
