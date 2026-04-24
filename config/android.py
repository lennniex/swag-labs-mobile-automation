"""
Capabilities para ejecución local en emulador/dispositivo Android.

Uso:
    robot --variablefile config/android.py --outputdir reports tests/

Overrides vía variables de entorno:
    DEVICE_NAME     — Nombre del emulador/dispositivo (ej. 'Pixel_6_API_33')
    APP_PATH        — Ruta absoluta al .apk
    APPIUM_SERVER   — URL del Appium Server (default: http://localhost:4723)
    UDID            — Para dispositivos físicos
"""
import os

# ---------------------------------------------------------------------------
# Rutas base
# ---------------------------------------------------------------------------
CONFIG_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.abspath(os.path.join(CONFIG_DIR, os.pardir))
APPS_DIR = os.path.join(ROOT_DIR, "apps")

# ---------------------------------------------------------------------------
# Plataforma y conexión
# ---------------------------------------------------------------------------
PLATFORM_NAME = "Android"
AUTOMATION_NAME = "UiAutomator2"
APPIUM_SERVER = os.environ.get("APPIUM_SERVER", "http://localhost:4723")

# ---------------------------------------------------------------------------
# Dispositivo
# ---------------------------------------------------------------------------
DEVICE_NAME = os.environ.get("DEVICE_NAME", "Android Emulator")
UDID = os.environ.get("UDID", "")  # Opcional para real device

# ---------------------------------------------------------------------------
# Aplicación bajo prueba (AUT)
# ---------------------------------------------------------------------------
# Coloque el .apk de my-demo-app-rn (v1.3.0) en ./apps/
# Descarga: https://github.com/saucelabs/my-demo-app-rn/releases
APP_PATH = os.environ.get(
    "APP_PATH",
    os.path.join(APPS_DIR, "Android-MyDemoAppRN.apk"),
)
APP_PACKAGE = "com.saucelabs.mydemoapp.rn"
APP_ACTIVITY = "com.saucelabs.mydemoapp.rn.MainActivity"

# ---------------------------------------------------------------------------
# Comportamiento del driver
# ---------------------------------------------------------------------------
NO_RESET = False              # Reinstalar y resetear estado entre corridas
FULL_RESET = False
AUTO_GRANT_PERMISSIONS = True
NEW_COMMAND_TIMEOUT = 300     # segundos
ADB_EXEC_TIMEOUT = 60000      # ms
UIAUTOMATOR2_SERVER_INSTALL_TIMEOUT = 60000

# ---------------------------------------------------------------------------
# Timeouts de prueba (en segundos)
# ---------------------------------------------------------------------------
DEFAULT_TIMEOUT = "20s"
SHORT_TIMEOUT = "5s"
LONG_TIMEOUT = "45s"
