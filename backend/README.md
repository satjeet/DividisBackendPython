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

## Configuración de entornos: local vs producción

Este backend soporta configuración diferenciada para desarrollo local y producción en la nube (Google Cloud, Supabase, Render, etc.) usando la variable `ENV`:

- En local, usa `ENV=local` y una base de datos Postgres local (servicio `db` de docker-compose).
- En producción, usa `ENV=production` y variables de entorno reales (nunca subas `.env` real al repositorio).

**Ejemplo de `.env` local:**
```
ENV=local
DJANGO_SECRET_KEY=clave-secreta-local
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
DB_NAME=dividis
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=db
DB_PORT=5432
```

**Ejemplo de `.env` producción (solo en entorno cloud, nunca en el repo):**
```
ENV=production
DJANGO_SECRET_KEY=clave-secreta-produccion
DEBUG=False
ALLOWED_HOSTS=dominio-backend.com
CORS_ALLOWED_ORIGINS=https://southamerica-west1.run.app
DB_NAME=postgres
DB_USER=postgres
DB_PASSWORD=tu-contraseña-supabase
DB_HOST=db.mhdwksztdotokkmpgccg.supabase.co
DB_PORT=5432
```

**Recomendaciones:**
- Usa Google Secret Manager, Render o el panel de variables de entorno de tu proveedor cloud para definir los secretos.
- Nunca subas datos reales ni `.env` de producción a GitHub.
- El backend detecta el entorno automáticamente según la variable `ENV`.


## Consumo de la API desde otros proyectos

- La API de este backend estará disponible en la URL pública configurada en el despliegue (por ejemplo, `https://dividis-backend-996639584668.southamerica-west1.run.app/api/schema/swagger-ui/`).
- Para consumir la API desde otros proyectos (frontend, microservicios, etc.), asegúrate de agregar el dominio de origen en la variable `CORS_ALLOWED_ORIGINS` del archivo `.env`.
- Ejemplo de configuración para permitir peticiones desde varios orígenes:
  ```
  CORS_ALLOWED_ORIGINS=http://localhost:3000,https://tu-frontend-produccion.com,https://otro-servicio.com
  ```
- Si necesitas exponer la API a servidores externos (Google Cloud, Supabase, etc.), incluye sus URLs aquí.




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
