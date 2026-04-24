# Swag Labs Mobile Automation · Robot Framework + Appium + POM

Suite de automatización mobile multiplataforma (Android / iOS) del flujo E2E de compra
en la aplicación [**my-demo-app-rn**](https://github.com/saucelabs/my-demo-app-rn/releases) de Sauce Labs.

> **Framework:** Robot Framework 7.x
> **Librería principal:** AppiumLibrary 2.x
> **Patrón:** Page Object Model (POM)
> **Sintaxis de negocio:** Gherkin (Given / When / And / Then)
> **Plataformas:** Android (UiAutomator2) + iOS (XCUITest) mediante capabilities dinámicas.

---

## 1. Estructura del proyecto

```
swag-labs-mobile-automation/
├── README.md
├── PLAN.md                         # Plan de ejecución paso a paso
├── requirements.txt                # Dependencias Python
├── .gitignore
│
├── config/                         # Capabilities dinámicas por plataforma
│   ├── android.py
│   └── ios.py
│
├── resources/
│   ├── common.resource             # Setup/Teardown, keywords transversales
│   ├── keywords/
│   │   └── bdd_steps.resource      # Keywords Gherkin (Given / When / Then)
│   └── pages/                      # Page Object Model
│       ├── login_page.resource
│       ├── products_page.resource
│       ├── product_details_page.resource
│       ├── cart_page.resource
│       ├── checkout_address_page.resource
│       ├── checkout_payment_page.resource
│       ├── checkout_review_page.resource
│       └── checkout_complete_page.resource
│
├── tests/
│   └── checkout_flow.robot         # Escenario Gherkin E2E
│
├── apps/                           # Depositar aquí el binario (.apk / .app)
│   └── README.md
│
├── reports/                        # Salida: report.html + log.html
│   └── .gitkeep
│
└── scripts/
    ├── run_android.sh
    └── run_ios.sh
```

### ¿Por qué esta estructura?

| Capa            | Responsabilidad                                                              |
| --------------- | ---------------------------------------------------------------------------- |
| `tests/`        | Escenarios en lenguaje de negocio (Gherkin). Sin selectores, sin lógica.     |
| `resources/keywords/` | Traducción Gherkin → acciones POM. Aísla los *steps* del test.         |
| `resources/pages/`    | POM: cada Page tiene sus **locators** y sus **acciones**.              |
| `resources/common.resource` | Cross-cutting: apertura/cierre de app, esperas, logs.            |
| `config/`       | Capabilities por plataforma. Cambiar de Android ↔ iOS = 1 flag (`--variablefile`). |
| `apps/`         | Binarios fuera del control de versiones (`.gitignore`).                      |

---

## 2. Requisitos previos

### 2.1. Software

| Componente                    | Versión recomendada        |
| ----------------------------- | -------------------------- |
| Python                        | 3.10+                      |
| Node.js                       | 18.x LTS+                  |
| Appium Server                 | 2.11.x+                    |
| Appium UiAutomator2 driver    | 3.x                        |
| Appium XCUITest driver (iOS)  | 7.x                        |
| Android SDK + Platform Tools  | API 30+                    |
| Android Emulator / Real device| Android 10+                |
| Xcode (solo iOS / macOS)      | 15+                        |

### 2.2. Instalación rápida

```bash
# 1) Appium Server + drivers
npm install -g appium@latest
appium driver install uiautomator2
# (solo macOS) appium driver install xcuitest

# 2) Python + Robot Framework
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt

# 3) Descarga el APK y colócalo en ./apps/
#    https://github.com/saucelabs/my-demo-app-rn/releases  (v1.3.0)
#    Renombrar a: Android-MyDemoAppRN.apk  (o ajustar config/android.py)
```

### 2.3. Verificar entorno

```bash
appium --version                 # >= 2.11
adb devices                      # debe listar tu emulador/dispositivo
robot --version                  # Robot Framework 7.x
```

---

## 3. Ejecución

### 3.1. Android (emulador local)

En una **terminal #1**: levantar Appium:

```bash
appium
```

En una **terminal #2**: correr las pruebas:

```bash
# macOS / Linux
bash scripts/run_android.sh

# Windows (Git Bash o PowerShell)
robot --variablefile config/android.py --outputdir reports tests/
```

Al terminar, abrir `reports/report.html` y `reports/log.html`.

### 3.2. iOS (simulador - solo macOS)

```bash
bash scripts/run_ios.sh
# Equivalente:
robot --variablefile config/ios.py --outputdir reports tests/
```

### 3.3. Ejecución con dispositivo diferente

Override por variables de entorno (sin tocar código):

```bash
DEVICE_NAME="Pixel_6_API_33" APP_PATH="./apps/my-demo-app.apk" \
robot --variablefile config/android.py --outputdir reports tests/
```

---

## 4. Estrategia de selectores

Se prioriza **Accessibility ID** (cross-platform en React Native) y se evita XPath absoluto.

| Orden de preferencia | Estrategia                    | Ejemplo                                          |
| -------------------- | ----------------------------- | ------------------------------------------------ |
| 1                    | `accessibility_id`            | `accessibility_id=test-Username`                 |
| 2                    | `id` nativo (resource-id)     | `id=com.saucelabs.mydemoapp.rn:id/cart_counter` |
| 3                    | XPath **relativo** por texto  | `xpath=//*[@text='Sauce Labs Backpack']`        |
| ❌                   | XPath absoluto                | NUNCA (fragilidad absoluta)                      |

Los selectores viven **únicamente** en `resources/pages/*.resource`, nunca en los tests.

---

## 5. Manejo de esperas

**Cero `Sleep` fijos.** Todas las sincronizaciones son explícitas:

```robot
Wait Until Element Is Visible    ${LOGIN_BUTTON}    timeout=${DEFAULT_TIMEOUT}
Wait Until Page Contains Element  ${CART_BADGE}      timeout=15s
```

El timeout por defecto (`${DEFAULT_TIMEOUT}`) está centralizado en `resources/common.resource`
para ajustar la tolerancia de toda la suite en un único punto.

---

## 6. Escalabilidad multiplataforma

Para agregar una nueva plataforma (p.ej. **Android Real Device** en BrowserStack):

1. Copiar `config/android.py` → `config/android_bs.py`.
2. Ajustar `APPIUM_SERVER`, `DEVICE_NAME`, `APP_PATH` y credenciales BS.
3. `robot --variablefile config/android_bs.py tests/` — **sin tocar** páginas ni tests.

### Elementos que aparecen solo en una plataforma

Ver `resources/pages/checkout_address_page.resource` — patrón `Run Keyword If` sobre
`${PLATFORM_NAME}` para manejar, p.ej., el scroll de iOS vs Android cuando difieren.

---

## 7. Entregables del reto

- [x] **Código fuente:** este repositorio.
- [x] **requirements.txt** incluido.
- [x] **Evidencia de ejecución:** `reports/report.html` + `reports/log.html`.
- [x] **Arquitectura multiplataforma:** capabilities en `config/` + selectores compartidos.
- [x] **Gherkin en .robot:** ver `tests/checkout_flow.robot`.

---

## 8. Sustentación técnica — puntos clave

**Lógica de la estructura de carpetas:**
Separación estricta de 3 capas (tests → BDD steps → POM) + 1 capa de configuración.
Esto permite que un QA funcional lea `tests/checkout_flow.robot` y entienda el negocio
sin ver una sola línea técnica.

**Elemento solo presente en una plataforma:**
Dos estrategias según el caso:
- *Diferencia de UI:* `Run Keyword If    '${PLATFORM_NAME}' == 'iOS'    ...`
  dentro del Page Object (patrón ya implementado en `checkout_address_page.resource`).
- *Elemento inexistente:* Variable de selector por plataforma, cargada desde `config/*.py`.

**Trade-offs:**
- Robot Framework sobre pyATest/pytest-bdd: elegido por el **reporting nativo**
  (`report.html`/`log.html` con evidencia automática) y por el requisito explícito del reto.
- AppiumLibrary sobre Appium-Python-Client puro: mayor expresividad Gherkin y menos
  código glue; a cambio de algo menos de control fino sobre el WebDriver.
