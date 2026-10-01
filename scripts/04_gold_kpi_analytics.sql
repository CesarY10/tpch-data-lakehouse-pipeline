-- Consultas analíticas para Dashboards (parámetro dinámico :parameter)

-- 1. Ventas mensuales
SELECT 
  TRUNC(fecha_pedido, 'MM') AS mes,
  SUM(precio_neto) AS venta_totales_netas,
  COUNT(DISTINCT pedido_id) AS total_pedidos,
  AVG(cantidad) AS promedio_items_pedido     
FROM workspace.default.fact_ventas_gold
WHERE anio_pedido = :parameter 
GROUP BY TRUNC(fecha_pedido, 'MM') 
ORDER BY TRUNC(fecha_pedido, 'MM') ASC;

-- 2. Ventas por País
SELECT 
    initcap(n.n_name) AS pais,
    SUM(fv.precio_neto) AS ventas_totales
FROM workspace.default.fact_ventas_gold AS fv
JOIN samples.tpch.customer AS c ON fv.cliente_id = c.c_custkey
JOIN samples.tpch.nation AS n ON c.c_nationkey = n.n_nationkey
WHERE anio_pedido = :parameter 
GROUP BY n.n_name
ORDER BY ventas_totales DESC;

-- 3. Top 10 Proveedores
SELECT 
    s.s_name AS proveedor,
    SUM(fv.precio_neto) AS ventas_generadas
FROM workspace.default.fact_ventas_gold AS fv
JOIN samples.tpch.supplier AS s ON fv.proveedor_id = s.s_suppkey
WHERE anio_pedido = :parameter 
GROUP BY s.s_name
ORDER BY ventas_generadas DESC
LIMIT 10;