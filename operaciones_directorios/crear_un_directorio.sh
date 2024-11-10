#!/bin/bash

crear_directorio() {
    local directorio=$1

    # Verificar si se especificó un directorio
    if [ -z "$directorio" ]; then
        echo "Error: Debes especificar una ruta de directorio."
        return 1
    fi

    local ruta_completa=$directorio

    # Crear el directorio si no existe
    if [ ! -d "$ruta_completa" ]; then
        mkdir -p "$ruta_completa"
        echo "Directorio '$ruta_completa' creado exitosamente."
        ./log_operation.sh "CREAR_DIR" "$ruta_completa" "Éxito"
        return 0
    else
        echo "Error: El directorio '$ruta_completa' ya existe."
        ./log_operation.sh "CREAR_DIR" "$ruta_completa" "Error: Ya existe."
        return 1
    fi
}

# Validar los argumentos
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 ruta_del_directorio"
    exit 1
fi

# Llamar a la función de creación de directorio
crear_directorio "$1"
