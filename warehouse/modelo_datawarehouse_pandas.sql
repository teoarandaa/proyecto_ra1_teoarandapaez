-- ============================================
-- DDL para Datawarehouse - Housing Barcelona
-- Generado desde ETL con Pandas
-- ============================================

-- ============================================

-- TABLA DE HECHOS

-- ============================================

-- ============================================

-- TABLAS DIMENSIONALES

-- ============================================

-- Tabla dimensional: dim_district
CREATE TABLE IF NOT EXISTS dim_district (
    district_id INTEGER PRIMARY KEY AUTOINCREMENT,
    district_name TEXT UNIQUE NOT NULL
);

-- Tabla dimensional: dim_neighborhood
CREATE TABLE IF NOT EXISTS dim_neighborhood (
    neighborhood_id INTEGER PRIMARY KEY AUTOINCREMENT,
    neighborhood_name TEXT UNIQUE NOT NULL,
    district_id INTEGER,
    FOREIGN KEY (district_id) REFERENCES dim_district(district_id)
);

-- Tabla dimensional: dim_operation
CREATE TABLE IF NOT EXISTS dim_operation (
    operation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    operation_type TEXT UNIQUE NOT NULL
);

-- Tabla dimensional: dim_agency
CREATE TABLE IF NOT EXISTS dim_agency (
    agency_id INTEGER PRIMARY KEY AUTOINCREMENT,
    agency_name TEXT UNIQUE NOT NULL
);

-- Tabla dimensional: dim_condition
CREATE TABLE IF NOT EXISTS dim_condition (
    condition_id INTEGER PRIMARY KEY AUTOINCREMENT,
    condition_type TEXT UNIQUE NOT NULL
);

-- Tabla dimensional: dim_energy_certificate
CREATE TABLE IF NOT EXISTS dim_energy_certificate (
    certificate_id INTEGER PRIMARY KEY AUTOINCREMENT,
    certificate_type TEXT UNIQUE NOT NULL
);

-- Índices para mejorar el rendimiento de consultas
CREATE INDEX IF NOT EXISTS idx_fact_price ON fact_housing(price_eur);
CREATE INDEX IF NOT EXISTS idx_fact_surface ON fact_housing(surface_m2);