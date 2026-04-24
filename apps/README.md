# Carpeta `apps/` — Binarios de la aplicación bajo prueba

Esta carpeta contiene los binarios de **my-demo-app-rn** que serán automatizados.
**Los binarios NO se versionan** (están listados en `.gitignore`).

## Android

1. Descarga el `.apk` desde:
   https://github.com/saucelabs/my-demo-app-rn/releases/tag/v1.3.0
2. Busca el asset: `Android.SauceLabs.Mobile.Sample.app.2.7.1.apk`
   (o el .apk disponible en la última release v1.3.0).
3. Renómbralo a `Android-MyDemoAppRN.apk` **o** ajusta `APP_PATH` en `config/android.py`.
4. Colócalo en esta carpeta: `apps/Android-MyDemoAppRN.apk`

## iOS (solo macOS)

1. Descarga el `.app` (descomprimido) desde la misma release v1.3.0.
2. El asset suele llamarse `MyRNDemoApp.app.zip` — descomprímelo.
3. Colócalo en esta carpeta: `apps/MyRNDemoApp.app`
4. Ajusta el nombre en `config/ios.py` si difiere.

## Override por variable de entorno

Si no quieres renombrar el archivo, puedes pasarlo en la línea de comandos:

```bash
APP_PATH="$(pwd)/apps/mi-apk-con-otro-nombre.apk" \
    robot --variablefile config/android.py --outputdir reports tests/
```
