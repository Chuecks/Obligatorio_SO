#!/bin/bash

# Nombre del directorio se pasa como primer argumento
directorio=$1

# Verificar si se especificó un directorio
if [ -z "$directorio" ]; then
    echo "Error: Debes especificar una ruta de directorio."
    exit 1
fi

# Definir el directorio dentro de la carpeta "filesystem"
ruta_completa=$directorio

# Eliminar el directorio si existe y está vacío
if [ -d "$ruta_completa" ]; then
    rmdir "$ruta_completa" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Directorio '$ruta_completa' eliminado exitosamente."
        ./log_operation.sh "ELIMINAR_DIR" "$ruta_completa" "Éxito"
    else
        echo "Error: El directorio '$ruta_completa' no está vacío."
        ./log_operation.sh "ELIMINAR_DIR" "$ruta_completa" "Error: No vacío."
    fi
else
    echo "Error: El directorio '$ruta_completa' no existe."
    ./log_operation.sh "ELIMINAR_DIR" "$ruta_completa" "Error: No existe."
fi
