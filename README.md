# ms-consumption-db

Repositorio de **base de datos** del dominio de Monitoreo de Consumo (BC-04) de **Sy Water**. Administra el schema `monitoring` de `sy-water-db` con **Liquibase**. consumption-service solo se conecta, no crea tablas.

Tiene la misma estructura que `ms-iam-db`, `ms-places-db` y `ms-device-db` (`01-ddl` … `06-releases`).

## Requisitos

- `ms-iam-db`, `ms-places-db` y `ms-device-db` aplicados (este repo tiene FKs a `places.places` y `devices.devices`).
- Contenedor `sy_water_db_dev` arriba (puerto 1433).

## Puesta en marcha

```powershell
Copy-Item .env.example .env        # fill in passwords (same sa as ms-iam-db)
docker compose up                  # sqlserver-init + liquibase update
```

## Releases

| Tag | Contenido |
|-----|-----------|
| `v1.0-baseline` | `monitoring.readings` (lecturas crudas, únicas por dispositivo + hora), `monitoring.consumption_hourly` (litros por lugar y hora UTC), FKs, índice de la última lectura, rol `monitoring_rw` |

## Reglas

- No editar un changeset ya aplicado. Todo cambio nuevo va en `06-releases/vX.Y/`.
- Nunca subir `.env`.
