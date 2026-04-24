# Plan de ejecución — Prueba Técnica Automatizador Mobile

> **Deadline:** mañana 7:00 AM. **Tiempo total estimado:** 2h 45min — 4h.
> El framework ya está construido. Lo que sigue es **instalación, ajuste y entrega**.

---

## 📋 Checklist rápido

- [ ] Paso 1 — Entorno local (Node, Python, Appium)
- [ ] Paso 2 — Android SDK + emulador
- [ ] Paso 3 — Descargar APK y colocarlo en `apps/`
- [ ] Paso 4 — Instalar dependencias Python
- [ ] Paso 5 — Validar selectores con Appium Inspector (⚠️ crítico)
- [ ] Paso 6 — Primera corrida: `robot`
- [ ] Paso 7 — Ajustar lo que falle (selectores puntuales)
- [ ] Paso 8 — Corrida final estable → `report.html` + `log.html`
- [ ] Paso 9 — Crear repo en GitHub y subir
- [ ] Paso 10 — Enviar entregable

---

## ⏱️ Paso 1 — Entorno local (30–45 min)

> Si ya tienes Appium 2.x instalado de otros proyectos, salta a Paso 3.

### Node + Appium

```bash
# Node 18+ ya lo tienes si has usado Playwright recientemente.
node --version

# Appium Server 2.x
npm install -g appium@latest
appium --version                     # debe dar >= 2.11

# Driver Android
appium driver install uiautomator2
appium driver list --installed       # confirma que aparece
```

### Python + venv

```bash
python3 --version                    # >= 3.10

cd swag-labs-mobile-automation/
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
robot --version                      # Robot Framework 7.x
```

---

## ⏱️ Paso 2 — Android SDK + emulador (20–40 min)

**Si ya tienes Android Studio + un AVD creado, salta.**

Si no:

1. Instala **Android Studio** (o solo los Command Line Tools).
2. En `Tools → Device Manager`, crea un AVD:
   - **Recomendado:** Pixel 5 o Pixel 6, Android 13 (API 33).
   - **Alternativa rápida:** Pixel 3 API 30 (más liviano, arranca más rápido).
3. Arranca el emulador desde Device Manager.
4. Verifica: `adb devices` debe listarlo como `device`.

**Variables de entorno** (si no están):

```bash
# macOS / Linux — añadir a ~/.zshrc o ~/.bashrc
export ANDROID_HOME="$HOME/Library/Android/sdk"          # macOS
# export ANDROID_HOME="$HOME/Android/Sdk"                # Linux
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
```

---

## ⏱️ Paso 3 — Descargar APK (5 min)

1. Ve a: https://github.com/saucelabs/my-demo-app-rn/releases/tag/v1.3.0
2. Descarga el `.apk` (asset de Android).
3. Renómbralo a `Android-MyDemoAppRN.apk`.
4. Cópialo a `./apps/`.

```bash
# Ejemplo
mv ~/Downloads/Android.SauceLabs.Mobile.Sample.app.*.apk \
   ./apps/Android-MyDemoAppRN.apk
```

---

## ⏱️ Paso 4 — Ya cubierto en Paso 1 ✅

---

## ⏱️ Paso 5 — Validar selectores con Appium Inspector (15–30 min) ⚠️

**Este paso es crítico.** Los `accessibility_id` que usé son los estándar públicos
de Sauce Labs, pero cada build puede diferir. Mejor invertir 20 min aquí que debuggear
tests fallidos después.

### 5.1. Instala Appium Inspector

https://github.com/appium/appium-inspector/releases

### 5.2. Configura la sesión

Con Appium corriendo (`appium`) y el emulador arriba, en el Inspector:

- **Remote Host:** `127.0.0.1`
- **Remote Port:** `4723`
- **Remote Path:** `/`
- **Desired Capabilities (JSON):**

```json
{
  "platformName": "Android",
  "appium:automationName": "UiAutomator2",
  "appium:deviceName": "Android Emulator",
  "appium:app": "/ruta/absoluta/a/apps/Android-MyDemoAppRN.apk",
  "appium:autoGrantPermissions": true
}
```

### 5.3. Verifica estos 10 selectores (contra la columna `content-desc`)

| Página            | Locator usado en el código                       | Verificar que exista             |
| ----------------- | ------------------------------------------------ | -------------------------------- |
| Login             | `Username input field`                           | ✅ o anota el real               |
| Login             | `Password input field`                           | ✅ o anota el real               |
| Login             | `Login button-login-container`                   | ✅ o anota el real               |
| Catálogo          | `cart badge`                                     | ✅ o anota el real               |
| Catálogo          | `cart container`                                 | ✅ o anota el real               |
| Detalle producto  | `Add To Cart button`                             | ✅ o anota el real               |
| Checkout addr     | `Full Name* input field`                         | ✅ o anota el real               |
| Checkout addr     | `To Payment button`                              | ✅ o anota el real               |
| Checkout pago     | `Review Order button`                            | ✅ o anota el real               |
| Confirmación      | Texto "Checkout Complete" / "Thank you..."       | ✅                               |

**Si algún `content-desc` difiere** → actualiza únicamente el locator en el Page
Object correspondiente (`resources/pages/*.resource`). El resto del framework no
se toca. Cada Page ya tiene **fallback XPath por texto** como red de seguridad.

---

## ⏱️ Paso 6 — Primera corrida (10 min)

**Terminal 1:**
```bash
appium
```

**Terminal 2:**
```bash
source .venv/bin/activate
bash scripts/run_android.sh
```

---

## ⏱️ Paso 7 — Ajuste de fallos (30–60 min, según qué falle)

### Si falla el login
- Revisa los 3 selectores de `login_page.resource` contra Appium Inspector.
- Verifica que no haya un splash/onboarding previo que se esté saltando.

### Si falla el "Add To Cart"
- En algunos builds el botón aparece después de un scroll. Ya está manejado
  con `Scroll Hasta Elemento`, pero verifica el `accessibility_id`.

### Si el test pasa la dirección pero falla en "To Payment"
- Típico problema de teclado que tapa el botón. Ya está `Hide Keyboard` +
  `Scroll Hasta Elemento`. Si persiste, aumenta `max_intentos=5` en
  `Continuar A Pago`.

### Si el teclado no se oculta y bloquea interacciones
Añade un keyword a `common.resource`:
```robot
Ocultar Teclado Seguro
    ${is_visible}=    Run Keyword And Return Status    Is Keyboard Shown
    IF    ${is_visible}    Hide Keyboard
```

---

## ⏱️ Paso 8 — Corrida final (10 min)

Una vez que pase en verde:
- `reports/report.html` — **este es el entregable principal**.
- `reports/log.html` — con evidencia detallada y screenshots.
- `reports/*.png` — screenshot de la pantalla de éxito.

Borra ejecuciones anteriores fallidas de `reports/` antes de la corrida final
para que el entregable sea limpio.

---

## ⏱️ Paso 9 — Publicar en GitHub (10 min)

```bash
cd swag-labs-mobile-automation/
git init
git add .
git commit -m "feat: automatización E2E Swag Labs Mobile con Robot Framework + Appium + POM"
git branch -M main

# Crear repo en GitHub (web) → swag-labs-mobile-automation
git remote add origin https://github.com/lennniex/swag-labs-mobile-automation.git
git push -u origin main
```

> **Importante:** verifica que `reports/report.html` y `reports/log.html` SÍ se
> suban (no están en `.gitignore` — el `.gitignore` solo filtra ejecuciones en
> desarrollo, no el entregable final). Si los filtraste, haz `git add -f reports/`.

---

## ⏱️ Paso 10 — Entregable (5 min)

Responde el correo de la empresa con:

1. **Enlace al repositorio:** `https://github.com/lennniex/swag-labs-mobile-automation`
2. **Reportes de ejecución:** dentro del repo en `reports/report.html` y `reports/log.html`.
3. **Breve resumen técnico** (plantilla abajo).

### Plantilla de correo de entrega

> Buenos días,
>
> Adjunto la entrega de la prueba técnica para el cargo de Dev Automatizador QA.
>
> - **Repositorio:** https://github.com/lennniex/swag-labs-mobile-automation
> - **Evidencia de ejecución (Android):** `/reports/report.html` y `/reports/log.html`
>   dentro del repo.
> - **Stack:** Robot Framework 7.1 + AppiumLibrary 2.1 + Appium 2.x
>   (UiAutomator2 driver) sobre Python 3.10+.
> - **Patrón:** Page Object Model con separación estricta en 3 capas:
>   tests Gherkin → keywords BDD → Page Objects.
> - **Arquitectura multiplataforma:** capabilities en archivos Python por
>   plataforma (`config/android.py`, `config/ios.py`) cargados en tiempo de
>   ejecución vía `--variablefile`. Los Page Objects son compartidos y usan
>   `accessibility_id` para portabilidad Android/iOS.
> - **Manejo de plataforma única:** patrón implementado en `common.resource`
>   (builder de capabilities con `IF ${PLATFORM_NAME} == 'Android'`) y listo
>   para replicar en Page Objects (ejemplo en el README sección 8).
> - **Nota:** la ejecución iOS no se adjunta por no contar con macOS, pero el
>   código está estructurado para soportarlo (ver `config/ios.py` y
>   `scripts/run_ios.sh`).
>
> Quedo atento a la sesión de sustentación técnica.
>
> Saludos,
> Lennin Alexander Martínez

---

## 🔧 Comandos útiles de recuperación rápida

```bash
# Reiniciar emulador colgado
adb -s emulator-5554 emu kill
# y reabrirlo desde Device Manager

# Reinstalar el APK limpio
adb uninstall com.saucelabs.mydemoapp.rn

# Matar Appium si queda colgado
pkill -f appium

# Ejecutar un solo test case con más detalle
robot --variablefile config/android.py --loglevel TRACE --outputdir reports \
      --test "Compra exitosa*" tests/
```

---

## 🎯 Puntos fuertes para la sustentación (15-20 min)

El entrevistador te va a preguntar sobre:

1. **Lógica de la estructura de carpetas** → Separación en 3 capas:
   - `tests/` habla lenguaje de negocio (Gherkin) — lo podría leer un PO.
   - `resources/keywords/bdd_steps.resource` es la traducción → Page Objects.
   - `resources/pages/` contiene SOLO locators + acciones atómicas (POM puro).
   - `config/` aísla TODA diferencia de plataforma.

2. **Elemento presente en una sola plataforma:** dos tácticas:
   - Si la UI difiere (ej. botón "Continue" en Android vs flecha en iOS):
     `Run Keyword If '${PLATFORM_NAME}' == 'iOS' ...` dentro del Page Object.
   - Si el elemento no existe en una plataforma: mover el selector a
     `config/android.py` o `config/ios.py` y hacer al Page Object
     agnóstico al valor.

3. **Por qué accessibility_id > XPath:** estable ante cambios de layout,
   cross-platform (en React Native un solo testProperties sirve para iOS y
   Android), y es la estrategia oficialmente recomendada por Appium y Sauce Labs.

4. **Por qué `Wait Until Element Is Visible` > `Sleep 3s`:** el sleep es
   determinista solo en timing; la espera explícita es determinista en estado.
   Un `Sleep` que funciona en tu máquina puede fallar en CI por carga mayor.
