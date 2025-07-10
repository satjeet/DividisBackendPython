# Despliegue Backend Dividis en Google Cloud Run

Sigue estos pasos para desplegar el backend en Cloud Run usando la imagen de contenedor y variables de entorno ya configuradas:

## Comandos para construir y subir la imagen Docker

```bash
# 1. Autentica Docker con Artifact Registry
gcloud auth configure-docker southamerica-west1-docker.pkg.dev

# 2. Construye la imagen Docker desde la raíz del proyecto
docker build -t southamerica-west1-docker.pkg.dev/dividisfront/dividis-backend/api:latest -f backend/Dockerfile .

# 3. Sube la imagen al Artifact Registry
docker push southamerica-west1-docker.pkg.dev/dividisfront/dividis-backend/api:latest
```

## 1. Verifica la imagen del contenedor

Asegúrate de que la imagen `southamerica-west1-docker.pkg.dev/dividisfront/dividis-backend/api` contiene la última versión del backend que deseas desplegar.

## 2. Accede a Google Cloud Console

Ingresa a [Google Cloud Console](https://console.cloud.google.com/) y selecciona tu proyecto.

## 3. Ve a Cloud Run

En el menú de navegación, selecciona **Cloud Run**.

## 4. Crea o actualiza el servicio

- Haz clic en **Crear servicio** o selecciona el servicio existente para editarlo.

## 5. Configura la imagen del contenedor

En el campo **URL de la imagen del contenedor**, ingresa:

```
southamerica-west1-docker.pkg.dev/dividisfront/dividis-backend/api
```

## 6. Configura las variables de entorno

En la sección **Variables de entorno, secretos y conexiones**, asegúrate de que todas las variables necesarias (`ENV`, `DJANGO_SECRET_KEY`, `DB_HOST`, etc.) estén correctamente configuradas.

## 7. Configura la región y plataforma

Selecciona la región `southamerica-west1` y la plataforma **totalmente gestionada**.

## 8. Permisos y acceso

En **Configuración de autenticación**, selecciona **Permitir invocaciones no autenticadas** si quieres que la API sea pública.

## 9. Despliega el servicio

Haz clic en **Crear** o **Guardar** para desplegar la nueva versión.

## 10. Verifica el despliegue

Una vez desplegado, accede a la URL pública que te entrega Cloud Run para probar el backend.

---
