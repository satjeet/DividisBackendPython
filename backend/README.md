# Backend Dividis

## Inicialización automática de la base de datos

- Al levantar el backend con Docker, el contenedor ejecuta automáticamente:
  - Migraciones de Django (`python manage.py migrate`)
  - Carga de todos los fixtures `.json` en `api/fixtures` (solo si la base está vacía)

Esto asegura que siempre tendrás los módulos, misiones y datos iniciales necesarios, tanto en desarrollo como en producción/nube.

## Crear un superusuario

Para acceder al admin de Django, crea un superusuario ejecutando:

```bash
docker-compose exec backend python manage.py createsuperuser
```

Sigue las instrucciones en consola para definir usuario, email y contraseña.

## Archivos estáticos y Django Admin (WhiteNoise)

- El backend está configurado para servir archivos estáticos (CSS/JS) usando [WhiteNoise](https://whitenoise.evans.io/).
- Al construir la imagen Docker, se ejecuta automáticamente `python manage.py collectstatic --noinput` y los archivos se copian a `/app/staticfiles`.
- Esto asegura que el admin de Django y cualquier otro recurso estático se vea correctamente, incluso con `DEBUG=False` y en producción/nube.
- No necesitas configurar nginx para servir los estáticos: WhiteNoise lo hace por ti.

## Resumen de mejoras recientes

- **Persistencia real de datos:** Ahora el backend usa siempre Postgres (no SQLite), y los datos persisten entre reinicios.
- **Migraciones automáticas:** Las migraciones se ejecutan automáticamente al levantar el contenedor.
- **Carga automática de fixtures:** Todos los datos iniciales se cargan si la base está vacía.
- **Limpieza de código frontend:** El flujo de selección de pilares y navegación entre constelaciones es completamente reactivo y controlado por el estado del padre.
- **Solución de errores 400:** Los errores al guardar declaraciones se resolvieron asegurando que los módulos y misiones existan en la base de datos.
- **Admin Django con estilos:** El admin de Django ahora siempre se ve correctamente, sin importar el entorno.

## Consumo de la API desde otros proyectos

- La API de este backend estará disponible en la URL pública configurada en el despliegue (por ejemplo, `https://tu-backend.com/api/`).
- Para consumir la API desde otros proyectos (frontend, microservicios, etc.), asegúrate de agregar el dominio de origen en la variable `CORS_ALLOWED_ORIGINS` del archivo `.env`.
- Ejemplo de configuración para permitir peticiones desde varios orígenes:
  ```
  CORS_ALLOWED_ORIGINS=http://localhost:3000,https://tu-frontend-produccion.com,https://otro-servicio.com
  ```
- Si necesitas exponer la API a servidores externos (Google Cloud, Supabase, etc.), incluye sus URLs aquí.

## Despliegue en Render (producción)

Para desplegar este backend en [Render](https://render.com):

1. Sube tu repositorio a GitHub.
2. En Render, crea un nuevo servicio tipo **Web Service** y selecciona tu repo.
3. Render detectará el `Dockerfile` automáticamente.
4. Configura las variables de entorno en el panel de Render (no uses `.env` en producción):

   - `DEBUG=False`
   - `DJANGO_SECRET_KEY=una-clave-segura`
   - `ALLOWED_HOSTS=dominio-que-te-da-render.com`
   - `CORS_ALLOWED_ORIGINS=https://dividisfront-996639584668.southamerica-west1.run.app`
   - `DB_NAME=dividis`
   - `DB_USER=usuario_postgres`
   - `DB_PASSWORD=contraseña_postgres`
   - `DB_HOST=host_postgres_render`
   - `DB_PORT=5432`

5. Si usas base de datos de Render, crea el servicio Postgres y copia los datos de conexión.
6. El frontend debe consumir la API usando la URL pública de Render.

**Importante:**  
En producción, solo permite el dominio del frontend productivo en `CORS_ALLOWED_ORIGINS` para mayor seguridad.

## Notas

- Si necesitas reiniciar todo desde cero, ejecuta:
  ```
  docker-compose down -v
  docker-compose up --build
  ```
  Esto borrará la base de datos y recargará los datos iniciales.

- Si agregas nuevos fixtures `.json` en `api/fixtures`, se cargarán automáticamente la próxima vez que la base esté vacía.

## Lecciones de refactorización y buenas prácticas

- **Modularización:** Separar los serializers por dominio (usuario, perfil, módulos, etc.) facilita el mantenimiento y la escalabilidad.
- **Evitar relaciones inversas inexistentes:** Siempre verifica la relación real entre modelos antes de usar `obj.x_set.all()`. Prefiere filtrar explícitamente por usuario.
- **Compatibilidad legacy:** Mantener un `serializers.py` que reexporta desde el paquete permite migraciones progresivas y evita romper endpoints existentes.
- **Pruebas tras refactor:** Cada cambio estructural debe ir acompañado de pruebas manuales y automáticas de los endpoints críticos (login, perfil, módulos).
- **Documentación:** Toda decisión de arquitectura y lección aprendida debe quedar registrada en este README para futuros desarrolladores.
