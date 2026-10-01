# ⚡ TPC-H Data Lakehouse Pipeline & Data Quality Audit

Pipeline de datos **End-to-End** construido sobre **Databricks (Delta Lake)** aplicando **Medallion Architecture**, auditoría de **Data Quality**, optimización física (**Z-Ordering**) y consultas analíticas parametrizadas.

---

## 🏗️ Arquitectura del Proyecto

1. **Bronze / Source:** Dataset comercial TPC-H (`samples.tpch`).
2. **Silver:** Limpieza, deduplicación e ingesta incremental mediante patrón **Upsert (`MERGE INTO`)**.
3. **Gold:** Modelo dimensional particionado por año (`fact_ventas_gold`) optimizado con **Z-Ordering** (`cliente_id`, `parte_id`).
4. **Data Quality Audit:** Validación de unicidad de llaves primarias y detección de registros huérfanos.

---

## 📊 Auditoría de Calidad de Datos

Métricas de validación de unicidad e integridad referencial ejecutadas sobre las tablas `ORDERS` y `LINEITEM`:

![Data Quality Chart](data/visualization%20(1).png)

> **Resultado:** 100% de unicidad en llaves primarias y 0 líneas huérfanas en la prueba de integridad referencial.

---

## 📈 Dashboard Ejecutivo de Ventas (BI Layer)

A partir de la capa Gold (`fact_ventas_gold`), se construyó un Dashboard interactivo en **Databricks SQL Dashboards** alimentado por consultas analíticas parametrizadas por año (`:parameter`):

![Databricks Executive Sales Dashboard](data/Dashboard%20Databricks.png)

### Métricas Clave Representadas:
* **KPIs Directos:** Ventas Netas Totales, Órdenes Totales y Promedio de Ítems por Pedido.
* **Tendencia Mensual:** Comportamiento temporal de ingresos netos.
* **Análisis Geográfico y Proveedores:** Distribución por país del cliente y ranking Top 10 de proveedores.

---

## 🛠️ Tecnologías Utilizadas
* **Engine:** Apache Spark / Databricks SQL Engine
* **Format:** Delta Lake
* **Pattern:** Medallion Architecture (Silver/Gold), CTEs, Upserts
* **Optimization:** `PARTITIONED BY`, `OPTIMIZE`, `ZORDER BY`, `ANALYZE TABLE`

---
✍️ **Desarrollado por Cesar Ynes**