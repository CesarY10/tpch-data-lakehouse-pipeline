-- DDL, Particionamiento y Carga de la Tabla de Hechos Gold
CREATE OR REPLACE TABLE fact_ventas_gold (
    pedido_id BIGINT,
    cliente_id BIGINT,
    parte_id BIGINT,
    proveedor_id BIGINT,
    fecha_pedido DATE,
    anio_pedido INT,
    cantidad DOUBLE,
    precio_bruto DOUBLE,
    precio_neto DOUBLE,
    prioridad_pedido STRING
)
USING DELTA
PARTITIONED BY (anio_pedido);

INSERT INTO fact_ventas_gold
WITH ventas_detalladas AS (
    SELECT 
        l.l_orderkey, o.o_custkey, l.l_partkey, l.l_suppkey, 
        o.o_orderdate, YEAR(o.o_orderdate) AS anio_pedido, l.l_quantity, 
        l.l_extendedprice, (l.l_extendedprice * (1 - l.l_discount)) AS precio_neto, 
        o.o_orderpriority
    FROM samples.tpch.lineitem l
    JOIN samples.tpch.orders o ON l.l_orderkey = o.o_orderkey
    WHERE YEAR(o.o_orderdate) IN (1997,1998)
)
SELECT 
    l_orderkey, o_custkey, l_partkey, l_suppkey, 
    o_orderdate, anio_pedido, l_quantity, 
    l_extendedprice, precio_neto, o_orderpriority 
FROM ventas_detalladas;

-- Optimización de física y recolección de estadísticas
OPTIMIZE fact_ventas_gold ZORDER BY (cliente_id, parte_id);
ANALYZE TABLE fact_ventas_gold COMPUTE STATISTICS;