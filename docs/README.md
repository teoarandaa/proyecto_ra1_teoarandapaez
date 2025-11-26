# Proyecto RA1 - Big Data: ETL y Datawarehouse para Viviendas en Barcelona

**Autor:** Teo Aranda Páez  
**Fecha:** Diciembre 2024

---

## 📋 Descripción del Proyecto

Este proyecto implementa un proceso completo de ETL (Extract, Transform, Load) para limpiar y transformar datos de viviendas en Barcelona, creando un Datawarehouse estructurado con modelo dimensional (Star Schema). El proyecto utiliza tanto **Pandas** como **PySpark** para procesar los datos, demostrando diferentes enfoques de procesamiento de datos.

### Objetivos

- Realizar exploración y limpieza exhaustiva de datos de viviendas
- Implementar procesos ETL con Pandas y PySpark
- Crear un Datawarehouse con modelo dimensional (1 tabla de hechos + 6 tablas de dimensiones)
- Generar DDLs para la estructura del Datawarehouse
- Documentar todo el proceso y resultados

---

## 🗂️ Estructura de Carpetas

```
proyecto_ra1_teoarandapaez/
├── data/                          # Datos del proyecto
│   ├── housing-barcelona.csv      # Dataset original
│   ├── housing-barcelona-clean.csv           # Dataset limpio (Pandas)
│   └── housing-barcelona-clean-pyspark.csv  # Dataset limpio (PySpark)
│
├── notebooks/                     # Notebooks Jupyter
│   ├── 01_pandas.ipynb           # ETL con Pandas
│   └── 02_pyspark.ipynb          # ETL con PySpark
│
├── warehouse/                     # Datawarehouse
│   ├── warehouse_pandas.db       # Base de datos SQLite (Pandas)
│   ├── warehouse_pyspark.db     # Base de datos SQLite (PySpark)
│   ├── modelo_datawarehouse_pandas.sql    # DDL del modelo (Pandas)
│   └── modelo_datawarehouse_pyspark.sql   # DDL del modelo (PySpark)
│
├── docker/                        # Configuración Docker
│   ├── Dockerfile                 # Imagen Docker
│   ├── docker-compose.yml        # Orquestación de contenedores
│   ├── requirements.txt          # Dependencias Python
│   └── start-jupyter.sh         # Script de inicio Jupyter
│
└── docs/                         # Documentación
    ├── README.md                 # Este archivo
    └── diagrama.drawio           # Diagrama del modelo dimensional
```

---

## 🛠️ Herramientas Utilizadas

### Lenguajes y Frameworks
- **Python 3.11**: Lenguaje de programación principal
- **Pandas**: Biblioteca para manipulación y análisis de datos
- **PySpark 4.0.1**: Framework para procesamiento distribuido de datos
- **SQLite**: Base de datos relacional para el Datawarehouse
- **SQLAlchemy**: ORM para conexión con SQLite

### Herramientas de Desarrollo
- **Jupyter Notebook/Lab**: Entorno de desarrollo interactivo
- **Docker**: Contenedorización del entorno de desarrollo
- **Docker Compose**: Orquestación de contenedores
- **draw.io**: Creación de diagramas

### Librerías Python Principales
- `pandas`: Manipulación de DataFrames
- `pyspark`: Procesamiento distribuido
- `numpy`: Operaciones numéricas
- `sqlalchemy`: Conexión a bases de datos
- `sqlite3`: Interfaz para SQLite
- `re`: Expresiones regulares para limpieza de datos

---

## 📊 Explicación de Cada Fase

### Fase 1: Exploración y Limpieza con Pandas (`01_pandas.ipynb`)

**Objetivo:** Explorar y limpiar el dataset usando Pandas.

**Proceso:**
1. **Carga de datos**: Lectura del CSV original (`housing-barcelona.csv`)
2. **Análisis exploratorio**: 
   - Análisis de tipos de datos
   - Detección de valores faltantes y duplicados
   - Identificación de valores problemáticos
3. **Limpieza de datos**:
   - Eliminación de espacios (strip)
   - Conversión de valores vacíos a NaN
   - Transformación de tipos de datos
   - Relleno de valores faltantes (strings con "X empty", números con medias)

**Resultado:** Dataset limpio guardado en `housing-barcelona-clean.csv`

---

### Fase 2: Procesamiento con PySpark (`02_pyspark.ipynb`)

**Objetivo:** Replicar el proceso ETL usando PySpark para procesamiento distribuido.

**Proceso:**
1. **Creación de SparkSession**: Inicialización del contexto Spark
2. **Carga de datos**: Lectura del CSV con `spark.read.csv()`
3. **Transformaciones**:
   - **Filtrado**: `.filter()` para identificar valores problemáticos
   - **Selección**: `.select()` para trabajar con columnas específicas
   - **Nuevas columnas**: `.withColumn()` para transformaciones (trim, cast, UDFs)
   - **Agregaciones**: `.agg()` para calcular medias y estadísticas
4. **Limpieza**: Similar a Pandas pero usando funciones de PySpark

**Resultado:** Dataset limpio guardado en `housing-barcelona-clean-pyspark.csv`

---

### Fase 3: Proceso ETL Completo con Pandas

**Objetivo:** Implementar el ciclo completo ETL y cargar en SQLite.

**Proceso:**

1. **EXTRACT (Extracción)**:
   ```python
   df_raw = pd.read_csv("../data/housing-barcelona.csv")
   ```

2. **TRANSFORM (Transformación)**:
   - Limpieza de espacios
   - Conversión de tipos
   - Relleno de valores faltantes
   - Normalización de datos

3. **LOAD (Carga)**:
   - Creación de tablas dimensionales desde los datos limpios
   - Guardado en SQLite usando `to_sql()`:
     ```python
     df_dim_district.to_sql('dim_district', engine, if_exists='replace', index=False)
     df_fact_housing.to_sql('fact_housing', engine, if_exists='replace', index=False)
     ```

**Resultado:** Base de datos SQLite `warehouse_pandas.db` con todas las tablas del Datawarehouse.

---

### Fase 4: Proceso ETL Completo con PySpark

**Objetivo:** Implementar el ciclo completo ETL con PySpark y cargar en SQLite.

**Proceso:**

1. **EXTRACT (Extracción)**:
   ```python
   df_raw = spark.read.csv("../data/housing-barcelona.csv", header=True)
   ```

2. **TRANSFORM (Transformación)**:
   - Filtrado con `.filter()`
   - Agrupaciones con `.groupBy()` y `.agg()`
   - Transformaciones con `.withColumn()` y UDFs
   - Conversión de tipos con `.cast()`

3. **LOAD (Carga)**:
   - Conversión a Pandas: `df_pandas_clean = df_clean.toPandas()`
   - Guardado en SQLite usando `to_sql()`:
     ```python
     df_fact_housing.to_sql('fact_housing', engine, if_exists='replace', index=False)
     ```

**Resultado:** Base de datos SQLite `warehouse_pyspark.db` con todas las tablas del Datawarehouse.

---

### Fase 5: Modelo de Data Warehouse

**Objetivo:** Definir la estructura del Datawarehouse con DDLs.

**Archivos generados:**
- `warehouse/modelo_datawarehouse_pandas.sql`
- `warehouse/modelo_datawarehouse_pyspark.sql`

**Estructura del modelo:**

#### Tabla de Hechos
- **`fact_housing`**: Contiene todas las métricas y medidas de las viviendas
  - Clave primaria: `listing_id`
  - Claves foráneas hacia todas las dimensiones
  - Medidas: `surface_m2`, `rooms`, `bathrooms`, `price_eur`, `price_per_m2`, `latitude`, `longitude`
  - Atributos descriptivos: `address`, `floor`, `elevator`, `balcony`, `furnished`, `has_parking`

#### Tablas Dimensionales (6 tablas)
1. **`dim_district`**: Distritos de Barcelona
2. **`dim_neighborhood`**: Barrios (con relación a distritos)
3. **`dim_operation`**: Tipos de operación (alquiler, venta, etc.)
4. **`dim_agency`**: Agencias inmobiliarias
5. **`dim_condition`**: Condiciones de la vivienda
6. **`dim_energy_certificate`**: Certificados energéticos

**Relaciones:**
- `fact_housing` → `dim_operation` (operation_id)
- `fact_housing` → `dim_district` (district_id)
- `fact_housing` → `dim_neighborhood` (neighborhood_id)
- `fact_housing` → `dim_agency` (agency_id)
- `fact_housing` → `dim_condition` (condition_id)
- `fact_housing` → `dim_energy_certificate` (energy_certificate_id)
- `dim_neighborhood` → `dim_district` (district_id)

---

### Fase 6: Docker

**Objetivo:** Contenedorizar el entorno de desarrollo.

**Archivos en `docker/`:**
- **`Dockerfile`**: Define la imagen con Python, Jupyter, Pandas, PySpark y SQLAlchemy
- **`docker-compose.yml`**: Orquesta el contenedor con volúmenes montados
- **`requirements.txt`**: Dependencias de Python
- **`start-jupyter.sh`**: Script de inicio de Jupyter sin autenticación

**Características:**
- Base: `python:3.11-slim`
- Instalación de librerías Python: pandas, pyspark, jupyter, sqlalchemy
- Java JDK para PySpark
- Volúmenes montados: notebooks, data, warehouse
- Puerto 8888 expuesto para Jupyter

---

### Fase 7: Documentación

**Objetivo:** Documentar todo el proyecto.

**Contenido:**
- Este README.md con toda la información del proyecto
- Diagrama del modelo dimensional en `diagrama.drawio`
- Explicación de cada fase del proceso
- Instrucciones de ejecución
- Consultas SQL de ejemplo

---

## 🚀 Instrucciones de Ejecución

### Opción 1: Con Docker (Recomendado)

1. **Navegar al directorio docker**:
   ```bash
   cd docker
   ```

2. **Construir y ejecutar el contenedor**:
   ```bash
   docker-compose up --build
   ```

3. **Acceder a Jupyter**:
   - Abrir navegador en: `http://localhost:8888`
   - Los notebooks estarán disponibles en `/app/notebooks`

4. **Ejecutar los notebooks**:
   - Abrir `01_pandas.ipynb` y ejecutar todas las celdas
   - Abrir `02_pyspark.ipynb` y ejecutar todas las celdas

### Opción 2: Sin Docker (Instalación Local)

1. **Instalar dependencias**:
   ```bash
   pip install jupyter pandas pyspark sqlalchemy
   ```

2. **Instalar Java JDK** (requerido para PySpark):
   ```bash
   # macOS
   brew install openjdk
   
   # Linux
   sudo apt-get install default-jdk
   ```

3. **Configurar variables de entorno**:
   ```bash
   export JAVA_HOME=/usr/lib/jvm/default-java
   export PATH=$PATH:$JAVA_HOME/bin
   ```

4. **Iniciar Jupyter**:
   ```bash
   jupyter notebook
   ```

5. **Ejecutar los notebooks**:
   - Abrir `notebooks/01_pandas.ipynb`
   - Abrir `notebooks/02_pyspark.ipynb`

---

## 🔄 Explicación Breve de Cada ETL

### ETL con Pandas (`01_pandas.ipynb`)

**Ventajas:**
- Sintaxis simple e intuitiva
- Ideal para datasets que caben en memoria
- Procesamiento rápido para datos pequeños/medianos

**Proceso:**
1. **Extracción**: `pd.read_csv()` carga el dataset completo en memoria
2. **Transformación**: 
   - Operaciones vectorizadas de Pandas (muy eficientes)
   - Uso de `.str.strip()`, `.fillna()`, `.astype()`
   - Funciones personalizadas con `apply()`
3. **Carga**: 
   - Guardado directo en SQLite con `to_sql()`
   - Creación automática de tablas

**Resultado:** Dataset limpio y Datawarehouse en `warehouse_pandas.db`

---

### ETL con PySpark (`02_pyspark.ipynb`)

**Ventajas:**
- Procesamiento distribuido (escalable)
- Ideal para datasets grandes
- Optimización automática de consultas

**Proceso:**
1. **Extracción**: `spark.read.csv()` carga datos de forma distribuida
2. **Transformación**:
   - Operaciones lazy evaluation (se ejecutan cuando es necesario)
   - UDFs (User Defined Functions) para transformaciones complejas
   - Transformaciones inmutables con `.withColumn()`
   - Agregaciones con `.agg()` y `.groupBy()`
3. **Carga**:
   - Conversión a Pandas: `toPandas()` (para datasets pequeños)
   - Guardado en SQLite con `to_sql()`

**Resultado:** Dataset limpio y Datawarehouse en `warehouse_pyspark.db`

**Diferencias clave:**
- PySpark usa evaluación diferida (lazy evaluation)
- PySpark es inmutable (cada transformación crea un nuevo DataFrame)
- PySpark puede procesar datos más grandes que la memoria disponible

---

## 💾 Cómo se Cargaron los Datos en SQLite

### Proceso de Carga

#### 1. Preparación de Tablas Dimensionales

**Para Pandas:**
```python
# Extraer valores únicos para cada dimensión
df_dim_district = pd.DataFrame({
    'district_name': df_clean['district'].unique()
}).dropna()

# Filtrar valores "empty"
df_dim_district = df_dim_district[
    df_dim_district['district_name'] != 'district empty'
]
```

**Para PySpark:**
```python
# Convertir a Pandas primero
df_pandas_clean = df_clean.toPandas()

# Luego crear dimensiones igual que en Pandas
df_dim_district = pd.DataFrame({
    'district_name': df_pandas_clean['district'].unique()
}).dropna()
```

#### 2. Creación de Conexión SQLite

```python
from sqlalchemy import create_engine

db_path = "../warehouse/warehouse_pandas.db"  # o warehouse_pyspark.db
engine = create_engine(f'sqlite:///{db_path}', echo=False)
```

#### 3. Guardado de Tablas

```python
# Guardar tablas dimensionales
df_dim_district.to_sql('dim_district', engine, if_exists='replace', index=False)
df_dim_neighborhood.to_sql('dim_neighborhood', engine, if_exists='replace', index=False)
df_dim_operation.to_sql('dim_operation', engine, if_exists='replace', index=False)
df_dim_agency.to_sql('dim_agency', engine, if_exists='replace', index=False)
df_dim_condition.to_sql('dim_condition', engine, if_exists='replace', index=False)
df_dim_energy_certificate.to_sql('dim_energy_certificate', engine, if_exists='replace', index=False)

# Guardar tabla de hechos
df_fact_housing = df_clean.copy()  # o df_pandas_clean.copy()
df_fact_housing.to_sql('fact_housing', engine, if_exists='replace', index=False)
```

#### 4. Estructura Final en SQLite

Cada base de datos SQLite contiene:
- **1 tabla de hechos**: `fact_housing` (10,000 filas)
- **6 tablas dimensionales**: 
  - `dim_district` (~14 distritos únicos)
  - `dim_neighborhood` (~14 barrios únicos)
  - `dim_operation` (~7 tipos de operación)
  - `dim_agency` (~7 agencias)
  - `dim_condition` (~7 condiciones)
  - `dim_energy_certificate` (~8 certificados)

---

## 📐 Diagrama del Modelo Dimensional

El diagrama del modelo dimensional está disponible en `docs/diagrama.drawio`. Este diagrama muestra:

- **Modelo Star Schema**: Una tabla de hechos central (`fact_housing`) rodeada de tablas dimensionales
- **Relaciones**: Claves foráneas desde la tabla de hechos hacia las dimensiones
- **Cardinalidades**: Relaciones uno-a-muchos entre hechos y dimensiones

### Estructura Visual:

```
                    fact_housing
                         |
        +----------------+----------------+
        |                |                |
   dim_district    dim_neighborhood   dim_operation
        |                |                |
   dim_agency      dim_condition   dim_energy_certificate
```

**Nota:** El diagrama completo con todas las relaciones y campos está disponible en `docs/diagrama.drawio`. Puede abrirse con [draw.io](https://app.diagrams.net/) o cualquier editor compatible.

---

## 🔍 Consultas y Queries que se Pueden Realizar

### Consultas Básicas

#### 1. Obtener todas las viviendas con sus dimensiones
```sql
SELECT 
    f.listing_id,
    f.price_eur,
    f.surface_m2,
    f.rooms,
    d.district_name,
    n.neighborhood_name,
    o.operation_type,
    a.agency_name
FROM fact_housing f
JOIN dim_district d ON f.district_id = d.district_id
JOIN dim_neighborhood n ON f.neighborhood_id = n.neighborhood_id
JOIN dim_operation o ON f.operation_id = o.operation_id
JOIN dim_agency a ON f.agency_id = a.agency_id
LIMIT 10;
```

#### 2. Precio promedio por distrito
```sql
SELECT 
    d.district_name,
    AVG(f.price_eur) as precio_promedio,
    COUNT(*) as total_viviendas
FROM fact_housing f
JOIN dim_district d ON f.district_id = d.district_id
GROUP BY d.district_name
ORDER BY precio_promedio DESC;
```

#### 3. Viviendas por tipo de operación
```sql
SELECT 
    o.operation_type,
    COUNT(*) as cantidad,
    AVG(f.price_eur) as precio_promedio
FROM fact_housing f
JOIN dim_operation o ON f.operation_id = o.operation_id
GROUP BY o.operation_type;
```

#### 4. Distribución por certificado energético
```sql
SELECT 
    e.certificate_type,
    COUNT(*) as cantidad,
    AVG(f.price_eur) as precio_promedio,
    AVG(f.surface_m2) as superficie_promedio
FROM fact_housing f
JOIN dim_energy_certificate e ON f.energy_certificate_id = e.certificate_id
GROUP BY e.certificate_type
ORDER BY cantidad DESC;
```

#### 5. Top 10 barrios más caros
```sql
SELECT 
    n.neighborhood_name,
    d.district_name,
    AVG(f.price_eur) as precio_promedio,
    AVG(f.price_per_m2) as precio_m2_promedio,
    COUNT(*) as total_viviendas
FROM fact_housing f
JOIN dim_neighborhood n ON f.neighborhood_id = n.neighborhood_id
JOIN dim_district d ON n.district_id = d.district_id
GROUP BY n.neighborhood_name, d.district_name
ORDER BY precio_promedio DESC
LIMIT 10;
```

#### 6. Viviendas con características específicas
```sql
SELECT 
    f.listing_id,
    f.price_eur,
    f.surface_m2,
    f.rooms,
    f.bathrooms,
    f.elevator,
    f.balcony,
    f.has_parking,
    c.condition_type,
    e.certificate_type
FROM fact_housing f
JOIN dim_condition c ON f.condition_id = c.condition_id
JOIN dim_energy_certificate e ON f.energy_certificate_id = e.certificate_id
WHERE f.elevator = 1 
  AND f.balcony = 1 
  AND f.has_parking = 1
  AND f.rooms >= 3
ORDER BY f.price_eur;
```

#### 7. Análisis por agencia inmobiliaria
```sql
SELECT 
    a.agency_name,
    COUNT(*) as total_propiedades,
    AVG(f.price_eur) as precio_promedio,
    MIN(f.price_eur) as precio_minimo,
    MAX(f.price_eur) as precio_maximo,
    AVG(f.surface_m2) as superficie_promedio
FROM fact_housing f
JOIN dim_agency a ON f.agency_id = a.agency_id
GROUP BY a.agency_name
ORDER BY total_propiedades DESC;
```

#### 8. Relación precio/superficie por condición
```sql
SELECT 
    c.condition_type,
    AVG(f.price_per_m2) as precio_m2_promedio,
    AVG(f.surface_m2) as superficie_promedio,
    COUNT(*) as cantidad
FROM fact_housing f
JOIN dim_condition c ON f.condition_id = c.condition_id
WHERE f.price_per_m2 IS NOT NULL
GROUP BY c.condition_type
ORDER BY precio_m2_promedio DESC;
```

### Consultas Avanzadas

#### 9. Análisis comparativo por distrito y operación
```sql
SELECT 
    d.district_name,
    o.operation_type,
    COUNT(*) as cantidad,
    AVG(f.price_eur) as precio_promedio,
    AVG(f.surface_m2) as superficie_promedio,
    AVG(f.rooms) as habitaciones_promedio
FROM fact_housing f
JOIN dim_district d ON f.district_id = d.district_id
JOIN dim_operation o ON f.operation_id = o.operation_id
GROUP BY d.district_name, o.operation_type
ORDER BY d.district_name, precio_promedio DESC;
```

#### 10. Viviendas más económicas por m² en cada distrito
```sql
SELECT 
    d.district_name,
    f.listing_id,
    f.price_eur,
    f.surface_m2,
    f.price_per_m2,
    n.neighborhood_name
FROM fact_housing f
JOIN dim_district d ON f.district_id = d.district_id
JOIN dim_neighborhood n ON f.neighborhood_id = n.neighborhood_id
WHERE f.price_per_m2 IS NOT NULL
  AND f.price_per_m2 = (
    SELECT MIN(f2.price_per_m2)
    FROM fact_housing f2
    WHERE f2.district_id = f.district_id
      AND f2.price_per_m2 IS NOT NULL
  )
ORDER BY d.district_name;
```

---

## 📊 Ejecutar Consultas en SQLite

### Desde Python

```python
import sqlite3
import pandas as pd

# Conectar a la base de datos
conn = sqlite3.connect('../warehouse/warehouse_pandas.db')

# Ejecutar consulta
query = """
SELECT 
    d.district_name,
    AVG(f.price_eur) as precio_promedio,
    COUNT(*) as total_viviendas
FROM fact_housing f
JOIN dim_district d ON f.district_id = d.district_id
GROUP BY d.district_name
ORDER BY precio_promedio DESC;
"""

df_result = pd.read_sql_query(query, conn)
print(df_result)

conn.close()
```

### Desde línea de comandos

```bash
# Abrir SQLite
sqlite3 warehouse/warehouse_pandas.db

# Ejecutar consulta
SELECT district_name, COUNT(*) 
FROM dim_district 
GROUP BY district_name;
```

---

## 🎓 Conclusiones y Aprendizajes

### Conclusiones Técnicas

1. **Pandas vs PySpark**:
   - **Pandas** es más rápido para datasets pequeños/medianos que caben en memoria
   - **PySpark** es mejor para datasets grandes y procesamiento distribuido
   - La sintaxis de Pandas es más intuitiva, pero PySpark ofrece más escalabilidad

2. **Limpieza de Datos**:
   - La detección de valores problemáticos es crucial antes de la transformación
   - El rellenado de valores faltantes debe hacerse según el tipo de dato
   - La normalización de tipos es esencial para análisis posteriores

3. **Modelo Dimensional**:
   - El modelo Star Schema facilita las consultas analíticas
   - Las claves foráneas aseguran la integridad referencial
   - Las tablas dimensionales permiten análisis multidimensionales eficientes

4. **SQLite como Datawarehouse**:
   - SQLite es adecuado para proyectos pequeños/medianos
   - `to_sql()` de Pandas facilita la carga de datos
   - Las consultas SQL son eficientes para análisis

### Aprendizajes del Proyecto

1. **ETL Completo**:
   - Entendimiento profundo del proceso ETL completo
   - Diferencia entre procesamiento en memoria (Pandas) y distribuido (PySpark)
   - Importancia de la validación de datos en cada etapa

2. **Datawarehouse**:
   - Diseño de modelos dimensionales (Star Schema)
   - Creación de DDLs para estructuras de base de datos
   - Relaciones entre tablas de hechos y dimensiones

3. **Docker**:
   - Contenedorización de entornos de desarrollo
   - Configuración de volúmenes para persistencia de datos
   - Simplificación del despliegue y colaboración

4. **Documentación**:
   - Importancia de documentar cada paso del proceso
   - Creación de diagramas para visualizar estructuras
   - Documentación de consultas y casos de uso

### Desafíos Encontrados y Soluciones

1. **Problema**: Valores faltantes en diferentes formatos (`?`, `N/A`, `NULL`, etc.)
   - **Solución**: Normalización de todos los valores vacíos a `NaN` antes del procesamiento

2. **Problema**: Tipos de datos inconsistentes (números como strings, texto como números)
   - **Solución**: Funciones personalizadas para extraer y convertir valores (`extract_number`, `text_to_number`)

3. **Problema**: PySpark crea directorios en lugar de archivos CSV únicos
   - **Solución**: Uso de `coalesce(1)` y conversión a Pandas para guardar como archivo único

4. **Problema**: Permisos de escritura en Docker
   - **Solución**: Configuración de permisos en Dockerfile y script de inicio

5. **Problema**: Conflicto entre funciones de Python y PySpark (`sum`, `round`, `col`)
   - **Solución**: Uso de `builtins.sum()` y `builtins.round()` para funciones de Python

### Mejoras Futuras

1. **Escalabilidad**: Migrar a Spark Cluster para datasets más grandes
2. **Automatización**: Crear scripts de ETL automatizados con Airflow o similar
3. **Validación**: Implementar tests unitarios para validar transformaciones
4. **Monitoreo**: Agregar logging y métricas de calidad de datos
5. **Visualización**: Crear dashboards con los datos del Datawarehouse

---

## 📚 Referencias

- [Documentación de Pandas](https://pandas.pydata.org/docs/)
- [Documentación de PySpark](https://spark.apache.org/docs/latest/api/python/)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Docker Documentation](https://docs.docker.com/)
- [Data Warehouse Concepts](https://en.wikipedia.org/wiki/Data_warehouse)

---

## 👤 Autor

**Teo Aranda Páez**  
Proyecto RA1 - Big Data  
Diciembre 2024

---

## 📝 Licencia

Este proyecto es parte de un trabajo académico para la Universidad La Salle.

