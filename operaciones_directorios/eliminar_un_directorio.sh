#!/bin/bash

eliminar_directorio() {
    local directorio=$1

    # Verificar si se especificó un directorio
    if [ -z "$directorio" ]; then
        echo "Error: Debes especificar una ruta de directorio."
        return 1
    fi

    local ruta_completa=$directorio

    # Eliminar el directorio si existe y está vacío
    if [ -d "$ruta_completa" ]; then
        rmdir "$ruta_completa" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Directorio '$ruta_completa' eliminado exitosamente."
            ./log_operation.sh "ELIMINAR_DIR" "$ruta_completa" "Éxito"
            return 0
        else
            echo "Error: El directorio '$ruta_completa' no está vacío."
            ./log_operation.sh "ELIMINAR_DIR" "$ruta_completa" "Error: No vacío."
            return 1
        fi
    else
        echo "Error: El directorio '$ruta_completa' no existe."
        ./log_operation.sh "ELIMINAR_DIR" "$ruta_completa" "Error: No existe."
        return 1
    fi
}

# Validar los argumentos
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 ruta_del_directorio"
    exit 1
fi

# Llamar a la función de eliminación de directorio
eliminar_directorio "$1"