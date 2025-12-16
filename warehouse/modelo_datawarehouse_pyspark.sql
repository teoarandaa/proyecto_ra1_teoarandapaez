-- ============================================
-- DDL para Datawarehouse - Housing Barcelona
-- Generado desde ETL con PySpark
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
    neighborhood_name TEXT NOT NULL,
    district_id INTEGER NOT NULL,
    address TEXT,
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

-- Tabla dimensional: dim_localization
CREATE TABLE IF NOT EXISTS dim_localization (
    localization_id INTEGER PRIMARY KEY AUTOINCREMENT,
    longitude REAL,
    latitude REAL
);

-- Tabla dimensional: dim_optionals
CREATE TABLE IF NOT EXISTS dim_optionals (
    optional_id INTEGER PRIMARY KEY AUTOINCREMENT,
    elevator BOOLEAN,
    has_parking BOOLEAN,
    furnished BOOLEAN,
    balcony BOOLEAN
);

-- Tabla dimensional: dim_characteristics
CREATE TABLE IF NOT EXISTS dim_characteristics (
    characteristics_id INTEGER PRIMARY KEY AUTOINCREMENT,
    floor TEXT,
    surface_m2 REAL,
    bathrooms INTEGER,
    rooms INTEGER
);

-- Tabla dimensional: dim_price
CREATE TABLE IF NOT EXISTS dim_price (
    price_id INTEGER PRIMARY KEY AUTOINCREMENT,
    price_eur REAL
);

-- Tabla dimensional: dim_tiempo
CREATE TABLE IF NOT EXISTS dim_tiempo (
    tiempo_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fecha DATE,
    hora TIME
);

-- ============================================
-- TABLA DE HECHOS
-- ============================================

-- Tabla de hechos: fact_housing
CREATE TABLE IF NOT EXISTS fact_housing (
    listing_id TEXT PRIMARY KEY,
    operation_id INTEGER,
    district_id INTEGER,
    neighborhood_id INTEGER,
    condition_id INTEGER,
    certificate_id INTEGER,
    agency_id INTEGER,
    characteristics_id INTEGER,
    price_id INTEGER,
    localization_id INTEGER,
    optional_id INTEGER,
    tiempo_id INTEGER,
    price_per_m2 REAL,
    FOREIGN KEY (operation_id) REFERENCES dim_operation(operation_id),
    FOREIGN KEY (district_id) REFERENCES dim_district(district_id),
    FOREIGN KEY (neighborhood_id) REFERENCES dim_neighborhood(neighborhood_id),
    FOREIGN KEY (condition_id) REFERENCES dim_condition(condition_id),
    FOREIGN KEY (certificate_id) REFERENCES dim_energy_certificate(certificate_id),
    FOREIGN KEY (agency_id) REFERENCES dim_agency(agency_id),
    FOREIGN KEY (characteristics_id) REFERENCES dim_characteristics(characteristics_id),
    FOREIGN KEY (price_id) REFERENCES dim_price(price_id),
    FOREIGN KEY (localization_id) REFERENCES dim_localization(localization_id),
    FOREIGN KEY (optional_id) REFERENCES dim_optionals(optional_id),
    FOREIGN KEY (tiempo_id) REFERENCES dim_tiempo(tiempo_id)
);

-- ============================================
-- ÍNDICES
-- ============================================

-- Índices para mejorar el rendimiento de consultas
CREATE INDEX IF NOT EXISTS idx_fact_operation ON fact_housing(operation_id);
CREATE INDEX IF NOT EXISTS idx_fact_district ON fact_housing(district_id);
CREATE INDEX IF NOT EXISTS idx_fact_neighborhood ON fact_housing(neighborhood_id);
CREATE INDEX IF NOT EXISTS idx_fact_price ON fact_housing(price_id);
CREATE INDEX IF NOT EXISTS idx_fact_localization ON fact_housing(localization_id);
CREATE INDEX IF NOT EXISTS idx_neighborhood_district ON dim_neighborhood(district_id);
