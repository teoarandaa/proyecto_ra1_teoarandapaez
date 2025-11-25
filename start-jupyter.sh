#!/bin/bash
# Script para iniciar Jupyter sin autenticación

# Crear directorio de configuración si no existe
mkdir -p /root/.jupyter

# Crear archivo de configuración completo
cat > /root/.jupyter/jupyter_notebook_config.py << EOF
c = get_config()

# Desactivar token
c.NotebookApp.token = ''
c.NotebookApp.password = ''

# Desactivar verificación XSRF
c.NotebookApp.disable_check_xsrf = True

# Configuración de red
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.allow_root = True
c.NotebookApp.notebook_dir = '/app/notebooks'
EOF

# Iniciar Jupyter
exec jupyter notebook --config=/root/.jupyter/jupyter_notebook_config.py



