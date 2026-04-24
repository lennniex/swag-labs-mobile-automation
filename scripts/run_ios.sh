#!/usr/bin/env bash
# =============================================================================
# Ejecuta la suite en iOS (simulador — solo macOS).
# Requiere: Appium server corriendo (appium &) + simulador/dispositivo disponible.
# =============================================================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

cd "$ROOT_DIR"

# Chequeos rápidos
command -v robot      >/dev/null 2>&1 || { echo "❌ 'robot' no está en PATH. Activa tu venv e instala requirements.txt"; exit 1; }

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "⚠️  iOS requiere macOS. Si estás en Linux/Windows, omite esta ejecución (el reto lo permite)."
    exit 1
fi

command -v xcrun      >/dev/null 2>&1 || { echo "❌ 'xcrun' no encontrado — ¿Xcode instalado?"; exit 1; }

echo "▶️  Ejecutando suite en iOS..."
robot \
    --variablefile config/ios.py \
    --outputdir reports \
    --name "Swag Labs Mobile - iOS" \
    --loglevel TRACE:INFO \
    tests/

echo ""
echo "✅ Ejecución terminada."
echo "📄 Reporte: $ROOT_DIR/reports/report.html"
echo "📄 Log:     $ROOT_DIR/reports/log.html"
