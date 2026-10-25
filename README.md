# Proyecto 4 - SQL

Consultas SQL sobre la base de datos demo de Postgres Pro, la de reservas de
vuelos (versión ligera, `demo-20250901-3m.sql`). Todo está en un solo
archivo, `IntroBBDD.sql`, con un comentario encima de cada consulta.

## Qué hay dentro

Nueve consultas: las cinco obligatorias del enunciado y cuatro opcionales que
hice para practicar más.

1. Vuelos en estado "On Time"
2. Reservas con un importe total mayor de 1.000.000
3. Todos los modelos de avión
4. Vuelos que volaron con un Boeing 737
5. Billetes de pasajeros que se llaman Irina
6. Ciudades con más de un aeropuerto (`GROUP BY` + `HAVING`)
7. Número de vuelos por modelo de avión (dos `JOIN`)
8. Reservas con más de un billete
9. Vuelos que salieron con más de una hora de retraso (aritmética con `interval`)

## Para probarlo

Hace falta PostgreSQL con la base de datos demo cargada:

```
psql -U postgres -f demo-20250901-3m.sql
psql -U postgres -d demo -f IntroBBDD.sql
```

Todas las tablas están dentro del esquema `bookings`, por eso cada consulta
lleva `bookings.` delante del nombre de la tabla.

## Lo que me costó

- **Los nombres no coincidían con el enunciado.** La tabla de aviones se
  llama `airplanes_data` y no `aircrafts_data`, y en vez de `ticket_flights`
  hay `routes` y `segments`. Lo dejo explicado al principio del archivo.
- **El Boeing 737.** El código `733` del enunciado no existe en esta versión.
  El único 737 que hay es el `7M7` (737 MAX 7), así que uso ese.
- **Unir vuelos con rutas.** Una misma ruta puede usar aviones distintos según
  la fecha, así que no basta con unir por `route_no`. Hay que comprobar
  también que la fecha del vuelo cae dentro del periodo de validez de la ruta:
  `r.validity @> f.scheduled_departure`. Sin eso salían vuelos repetidos.
- **La consulta 2 no devuelve filas.** No es un error: en la versión ligera la
  reserva más cara ronda los 915.000, así que ninguna pasa del millón.

## Autor

Nelson Gómez Sánchez · Estudiante de DAM y del Máster en Data & Analytics
