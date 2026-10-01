-- DDL, INSERT OVERWRITE y patrón UPSERT (MERGE INTO)

-- Creación y prueba de sobrescritura Delta
CREATE OR REPLACE TABLE demo_insert (id INT, nombre STRING);
INSERT INTO demo_insert VALUES (1,'Juan'), (2,'Pedro'), (3,'Maria');

INSERT OVERWRITE demo_insert
SELECT c_custkey, c_name
FROM samples.tpch.customer
WHERE c_mktsegment = 'MACHINERY';

-- Implementación de MERGE INTO (Upsert)
CREATE OR REPLACE TABLE clientes_silver (
    id INT, 
    nombre STRING, 
    email STRING, 
    ultima_actualizacion DATE
);

INSERT INTO clientes_silver VALUES 
  (1, 'Juan Perez', 'juan@old.com', '2023-01-01'),
  (2, 'Ana Lopez', 'ana@old.com', '2023-01-01');

CREATE OR REPLACE TEMP VIEW novedades_dia AS VALUES
(1, 'Juan Perez', 'juan.perez@new.com', current_date()),
(3, 'Carlos Ruiz', 'carlos@new.com', current_date())
AS tab(id, nombre, email, fecha);

MERGE INTO clientes_silver AS t
USING novedades_dia AS s
ON t.id = s.id
WHEN MATCHED THEN 
  UPDATE SET t.email = s.email, t.ultima_actualizacion = s.fecha
WHEN NOT MATCHED THEN
  INSERT (id, nombre, email, ultima_actualizacion)
  VALUES (s.id, s.nombre, s.email, s.fecha);