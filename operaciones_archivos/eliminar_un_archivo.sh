#!/bin/bash

eliminar_archivo() {
    local ruta=$1
    local nombre_archivo=$(basename "$ruta")

    # Verificar si el archivo está registrado en operaciones.log
    if grep -q "$nombre_archivo" ./operaciones.log; then
        # Verificar si el archivo existe físicamente
        if [ -f "$ruta" ]; then
            rm "$ruta"
            echo "Archivo $nombre_archivo eliminado correctamente."
            ./log_operation.sh "Eliminación" "$nombre_archivo" "Éxito"
            return 0
        else
            ./log_operation.sh "Eliminación" "$nombre_archivo" "Error: No existe"
            echo "Error: El archivo $nombre_archivo no existe."
            return 1
        fi
    else
        ./log_operation.sh "Eliminación" "$nombre_archivo" "Error: No registrado"
        echo "Error: El archivo $nombre_archivo no está registrado en operaciones.log."
        return 1
    fi
}

# Validar los argumentos
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    exit 1
fi

# Llamar a la función de eliminación
eliminar_archivo "$1"
