# Sell Assistant - Home Assistant Add-On
![Addon Icon](icon.png)
![Banner](banner.png)
![UI Mockup](screenshot.png)

Sell Assistant es un addon de Home Assistant que te ayuda a vender artículos usados más rápido usando IA.

## Características

- **📸 Captura de Fotos**: Subí fotos desde tu celular con acceso directo a la cámara
- **🎤 Descripción por Voz**: Describí tu artículo usando el reconocimiento de voz (español uruguayo)
- **🤖 Análisis con IA**: Google Gemini genera automáticamente título, descripción y precio sugerido
- **📊 Exportación a Google Sheets**: Guardá toda la información en tu hoja de cálculo
- **🇺🇾 Interfaz en Español**: Completamente localizado para Uruguay

## Instalación

1. Agregá este repositorio a Home Assistant:
   - Andá a **Supervisor** → **Add-on Store** → **⋮** (menú) → **Repositories**
   - Agregá: `https://github.com/guiman87/addon-sell-assistant`

2. Buscá "Sell Assistant" en la lista de addons

3. Hacé clic en **INSTALL**

## Configuración

Antes de usar el addon, necesitás configurar las credenciales de Google:

### 1. Google Service Account (para Drive y Sheets)

Seguí las instrucciones en el [setup_guide.md](https://github.com/guiman87/sell-assistant/blob/main/setup_guide.md) del repositorio principal para crear:
- Service Account
- Archivo JSON con credenciales
- Hoja de Google Sheets compartida con el service account
- Carpeta de Google Drive compartida con el service account

### 2. Gemini API Key

1. Andá a [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Creá una API key
3. Copiala para usarla en la configuración

### 3. Configuración del Addon

En la pestaña **Configuration** del addon, completá:

```yaml
google_client_email: "tu-service-account@project.iam.gserviceaccount.com"
google_private_key: "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
google_spreadsheet_id: "ID_de_tu_hoja_de_google_sheets"
google_drive_folder_id: "ID_de_tu_carpeta_de_drive"
gemini_api_key: "tu_api_key_de_gemini"
repository_url: "https://github.com/guiman87/sell-assistant.git"
```

**Nota**: El `google_private_key` debe incluir los saltos de línea como `\n`

## Uso

1. Iniciá el addon
2. Abrí la interfaz web (http://homeassistant.local:3000 o desde el botón "OPEN WEB UI")
3. Hacé clic en **"Empezar a Vender"**
4. **Paso 1**: Subí fotos de tu artículo
5. **Paso 2**: Describí el artículo (por voz o texto)
6. **Paso 3**: Revisá y editá el análisis de IA
7. Guardá en Google Sheets

## Arquitectura

El addon:
- Clona el repositorio de Next.js
- Inyecta las variables de entorno desde la configuración del addon
- Instala dependencias y construye la app
- Inicia el servidor en el puerto 3000

## Troubleshooting

### El addon no inicia
- Verificá que todas las credenciales estén correctas
- Chequeá los logs del addon

### "Service Accounts do not have storage quota"
- Asegurate de haber compartido la **carpeta de Drive** con el service account como **Editor**
- Verificá que el `google_drive_folder_id` sea correcto

### Análisis de IA falla
- Verificá que el `gemini_api_key` sea válido
- Chequeá que no hayas excedido el límite de rate del tier gratuito

## Desarrollo

Para contribuir o modificar el addon:

```bash
git clone https://github.com/guiman87/addon-sell-assistant.git
cd addon-sell-assistant
# Modificá los archivos en sell-assistant/
```

## Licencia

MIT License

## Créditos

Desarrollado por Guillermo Dutra usando:
- Next.js
- Google Gemini AI
- Google Drive API
- Google Sheets API
- Web Speech API
