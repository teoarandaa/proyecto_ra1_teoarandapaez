FROM python:3.11-slim

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    default-jdk \
    && rm -rf /var/lib/apt/lists/*

# Configurar variables de entorno para Java (detecta automáticamente la arquitectura)
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH=$PATH:$JAVA_HOME/bin

# Establecer directorio de trabajo
WORKDIR /app

# Crear directorios necesarios con permisos adecuados
RUN mkdir -p /app/warehouse && \
    chmod 777 /app/warehouse

# Copiar requirements si existe (opcional)
COPY requirements.txt* ./

# Instalar dependencias de Python
RUN pip install --no-cache-dir \
    jupyter \
    pandas \
    pyspark \
    sqlalchemy

# Copiar script de inicio
COPY start-jupyter.sh /usr/local/bin/start-jupyter.sh
RUN chmod +x /usr/local/bin/start-jupyter.sh

# Exponer puerto de Jupyter
EXPOSE 8888

# Comando por defecto para iniciar Jupyter (sin autenticación)
CMD ["/usr/local/bin/start-jupyter.sh"]