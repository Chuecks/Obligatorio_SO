#!/bin/bash

# Nombre del directorio se pasa como primer argumento
directorio=$1

# Verificar si se especificó un directorio
if [ -z "$directorio" ]; then
    echo "Error: Debes especificar una ruta de directorio."
    exit 1
fi

ruta_completa=$directorio

# Crear el directorio si no existe
if [ ! -d "$ruta_completa" ]; then
    mkdir -p "$ruta_completa"
    echo "Directorio '$ruta_completa' creado exitosamente."
    ./log_operation.sh "CREAR_DIR" "$ruta_completa" "Éxito"
else
    echo "El directorio '$ruta_completa' ya existe."
    ./log_operation.sh "CREAR_DIR" "$ruta_completa" "Error: Ya existe."
fi
