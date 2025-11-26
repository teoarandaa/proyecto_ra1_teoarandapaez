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

-- ============================================
-- TABLA DE HECHOS
-- ============================================

-- Tabla de hechos: fact_housing
CREATE TABLE IF NOT EXISTS fact_housing (
    listing_id TEXT PRIMARY KEY,
    operation_id INTEGER,
    FOREIGN KEY (operation_id) REFERENCES dim_operation(operation_id),
    district_id INTEGER,
    FOREIGN KEY (district_id) REFERENCES dim_district(district_id),
    neighborhood_id INTEGER,
    FOREIGN KEY (neighborhood_id) REFERENCES dim_neighborhood(neighborhood_id),
    address TEXT,
    surface_m2 REAL,
    rooms INTEGER,
    bathrooms INTEGER,
    price_eur REAL,
    price_per_m2 REAL,
    floor TEXT,
    elevator BOOLEAN,
    balcony BOOLEAN,
    furnished BOOLEAN,
    condition_id INTEGER,
    FOREIGN KEY (condition_id) REFERENCES dim_condition(condition_id),
    energy_certificate_id INTEGER,
    FOREIGN KEY (energy_certificate_id) REFERENCES dim_energy_certificate(certificate_id),
    has_parking BOOLEAN,
    latitude REAL,
    longitude REAL,
    agency_id INTEGER,
    FOREIGN KEY (agency_id) REFERENCES dim_agency(agency_id)
);

-- Índices para mejorar el rendimiento de consultas
CREATE INDEX IF NOT EXISTS idx_fact_price ON fact_housing(price_eur);
CREATE INDEX IF NOT EXISTS idx_fact_surface ON fact_housing(surface_m2);