-- 1. Auditoría de PK/FK y detección de nulos en ORDERS y LINEITEM
SELECT 
    'ORDERS' AS tabla,
    COUNT(*) AS total_registros,
    COUNT(DISTINCT o_orderkey) AS llaves_unicas,
    SUM(CASE WHEN o_orderkey IS NULL THEN 1 ELSE 0 END) AS nulos_pk,
    SUM(CASE WHEN o_custkey IS NULL THEN 1 ELSE 0 END) AS nulos_fk_cliente
FROM samples.tpch.orders

UNION ALL

SELECT 
    'LINEITEM' AS tabla,
    COUNT(*) AS total_registros,
    COUNT(DISTINCT l_orderkey, l_linenumber) AS llaves_unicas,
    SUM(CASE WHEN l_orderkey IS NULL THEN 1 ELSE 0 END) AS nulos_pk,
    0 AS nulos_fk_cliente
FROM samples.tpch.lineitem;

-- 2. Integridad referencial: Detección de líneas huérfanas
SELECT 
    COUNT(l.l_orderkey) AS lineas_huerfanas
FROM samples.tpch.lineitem l
LEFT JOIN samples.tpch.orders o ON l.l_orderkey = o.o_orderkey
WHERE o.o_orderkey IS NULL;