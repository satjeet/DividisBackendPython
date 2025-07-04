# Integración de Módulos Frontend-Backend

## Objetivo

Centralizar la documentación de cada módulo nuevo, sus endpoints asociados y los contratos de integración entre frontend y backend. Facilita que el backend sepa qué exponer y el frontend qué consumir.

---

## Buenas Prácticas

- Documenta cada módulo nuevo con nombre, propósito y endpoints asociados.
- Usa ejemplos de request/response y contratos de datos.
- Registra cambios y actualizaciones en el banco de memoria.
- Mantén checklist de integración para cada módulo.
- Versiona endpoints si hay cambios incompatibles.
- Sincroniza la documentación con Swagger/OpenAPI.

---

## Formato de Registro

```markdown
### Módulo: [Nombre del módulo]

- **Frontend:** [Ruta o componente principal]
- **Backend Endpoint(s):** [Método y ruta, ej: GET /api/modules/ejemplo/]
- **Payload esperado:** [Estructura de datos enviada]
- **Respuesta:** [Estructura de datos recibida]
- **Notas:** [Reglas de negocio, requisitos de autenticación, dependencias, etc.]
```

---

## Checklist de Integración

- [ ] Documentado en banco de memoria
- [ ] Endpoints expuestos y descritos en Swagger
- [ ] Contrato de datos validado
- [ ] Pruebas de integración realizadas
- [ ] Comunicación de cambios registrada

---

## Ejemplo

### Módulo: Salud Mental

- **Frontend:** `/modules/salud-mental`
- **Backend Endpoint:** `GET /api/modules/salud-mental/`
- **Payload esperado:** `{ user_id, fecha }`
- **Respuesta:** `{ progreso, hábitos, misiones }`
- **Notas:** Requiere autenticación JWT. Solo accesible si el usuario ha completado el módulo "Salud".

---

Actualiza este archivo cada vez que se agregue o modifique un módulo relevante.
