-- Proyecto 4: SQL
-- Aquí van las consultas del proyecto, hechas sobre la base de datos demo
-- de postgrespro (la de reservas de vuelos). Me descargué la versión
-- ligera, el archivo se llamaba demo-20250901-3m.sql.

-- Antes de nada, un par de cosas raras que me encontré al instalar la
-- base de datos, para que no parezca que me he inventado los nombres:
-- - No hay tabla ticket_flights como en los ejemplos que había visto por
--   ahí. Aquí se llaman routes y segments, y hacen más o menos lo mismo.
-- - La tabla de aviones no se llama aircraft_data ni aircrafts_data
--   (que es lo que decía el enunciado), se llama airplanes_data.
-- - Todas las tablas están dentro de un esquema que se llama "bookings",
--   por eso pongo bookings.nombre_tabla delante de todo.


-- 1. Vuelos y su id que estén en estado "On Time"
SELECT flight_id, status
FROM bookings.flights
WHERE status = 'On Time';


-- 2. Todas las reservas (bookings) con un total_amount mayor a 1.000.000
-- Con esta versión ligera de la base de datos no sale ninguna fila,
-- porque la reserva más cara que hay es de unos 915.000. Lo comprobé
-- a parte y es así, no es que la query esté mal, es que con estos datos
-- no llega ninguna reserva a esa cantidad.
SELECT *
FROM bookings.bookings
WHERE total_amount > 1000000;


-- 3. Todos los datos de los modelos de avión
SELECT *
FROM bookings.airplanes_data;


-- 4. Vuelos que volaron con un Boeing 737
-- Aquí me atasqué un rato: el enunciado dice que el código es 733, pero
-- ese código no existe en mi base de datos. Miré la tabla de aviones y el
-- único Boeing 737 que hay es el 7M7 (Boeing 737 MAX 7), así que uso ese.
-- Otra cosa que descubrí probando: no puedo unir flights con routes solo
-- por route_no, porque una misma ruta puede tener aviones distintos según
-- la fecha (el avión de una ruta cambia con el tiempo). Si no filtro
-- también por la fecha de validez me salían vuelos repetidos o con el
-- avión que no tocaba. Por eso añado lo de r.validity @> f.scheduled_departure,
-- que básicamente comprueba que la fecha del vuelo caiga dentro del
-- periodo en que esa ruta usaba ese avión.
SELECT f.flight_id
FROM bookings.flights f
JOIN bookings.routes r
    ON f.route_no = r.route_no
    AND r.validity @> f.scheduled_departure
WHERE r.airplane_code = '7M7';


-- 5. Info completa de los tickets de gente que se llama Irina
SELECT *
FROM bookings.tickets
WHERE passenger_name LIKE 'Irina %';


-- A partir de aquí las opcionales, para practicar más.

-- 6. Ciudades con más de un aeropuerto
SELECT city ->> 'en' AS ciudad, COUNT(*) AS numero_aeropuertos
FROM bookings.airports_data
GROUP BY city ->> 'en'
HAVING COUNT(*) > 1
ORDER BY numero_aeropuertos DESC;

