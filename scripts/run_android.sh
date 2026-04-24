#!/usr/bin/env bash
# =============================================================================
# Ejecuta la suite en Android (emulador o dispositivo).
# Requiere: Appium server corriendo (appium &) + emulador/dispositivo conectado.
# =============================================================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

cd "$ROOT_DIR"

# Chequeo rápido de prerequisitos
command -v robot   >/dev/null 2>&1 || { echo "❌ 'robot' no está en PATH. Activa tu venv e instala requirements.txt"; exit 1; }
command -v adb     >/dev/null 2>&1 || { echo "⚠️  'adb' no encontrado — asegúrate que Platform Tools esté en PATH"; }

# Verificar que haya un dispositivo/emulador
if command -v adb >/dev/null 2>&1; then
    DEVICES=$(adb devices | grep -v "List of devices" | grep "device$" | wc -l)
    if [ "$DEVICES" -eq 0 ]; then
        echo "❌ No hay dispositivos Android conectados. Inicia un emulador o conecta un dispositivo."
        exit 1
    fi
fi

echo "▶️  Ejecutando suite en Android..."
robot \
    --variablefile config/android.py \
    --outputdir reports \
    --name "Swag Labs Mobile - Android" \
    --loglevel TRACE:INFO \
    tests/

echo ""
echo "✅ Ejecución terminada."
echo "📄 Reporte: $ROOT_DIR/reports/report.html"
echo "📄 Log:     $ROOT_DIR/reports/log.html"
