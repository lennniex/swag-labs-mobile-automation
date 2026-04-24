"""
Capabilities para ejecución local en simulador/dispositivo iOS (solo macOS).

Uso:
    robot --variablefile config/ios.py --outputdir reports tests/

Overrides vía variables de entorno:
    DEVICE_NAME       — Nombre del simulador (ej. 'iPhone 15')
    PLATFORM_VERSION  — iOS version (ej. '17.2')
    APP_PATH          — Ruta absoluta al .app
    APPIUM_SERVER     — URL del Appium Server (default: http://localhost:4723)
    UDID              — Para dispositivos físicos
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
PLATFORM_NAME = "iOS"
AUTOMATION_NAME = "XCUITest"
APPIUM_SERVER = os.environ.get("APPIUM_SERVER", "http://localhost:4723")

# ---------------------------------------------------------------------------
# Dispositivo
# ---------------------------------------------------------------------------
DEVICE_NAME = os.environ.get("DEVICE_NAME", "iPhone 15")
PLATFORM_VERSION = os.environ.get("PLATFORM_VERSION", "17.2")
UDID = os.environ.get("UDID", "")  # Solo para dispositivos físicos

# ---------------------------------------------------------------------------
# Aplicación bajo prueba (AUT)
# ---------------------------------------------------------------------------
# Coloque el .app (descomprimido) en ./apps/
# Descarga: https://github.com/saucelabs/my-demo-app-rn/releases
APP_PATH = os.environ.get(
    "APP_PATH",
    os.path.join(APPS_DIR, "MyRNDemoApp.app"),
)
BUNDLE_ID = "com.saucelabs.mydemoapp.rn"

# ---------------------------------------------------------------------------
# Comportamiento del driver
# ---------------------------------------------------------------------------
NO_RESET = False
FULL_RESET = False
NEW_COMMAND_TIMEOUT = 300
AUTO_ACCEPT_ALERTS = True
WDA_LAUNCH_TIMEOUT = 120000   # ms
WDA_CONNECTION_TIMEOUT = 120000

# ---------------------------------------------------------------------------
# Timeouts de prueba (en segundos)
# ---------------------------------------------------------------------------
DEFAULT_TIMEOUT = "25s"       # iOS suele ser un poco más lento
SHORT_TIMEOUT = "5s"
LONG_TIMEOUT = "60s"
