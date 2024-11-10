#!/bin/bash

leer_archivo() {
    local ruta=$1
    local nombre_archivo=$(basename "$ruta")

    # Verificar si el archivo está registrado en operaciones.log
    if grep -q "$nombre_archivo" ./operaciones.log; then
        # Verificar si el archivo existe físicamente en el sistema
        if [ -f "$ruta" ]; then
            local contenido=$(cat "$ruta")
            echo "Contenido del archivo $nombre_archivo: \"$contenido\""
            ./log_operation.sh "Lectura" "$nombre_archivo" "Éxito"
            return 0
        else
            echo "Error: El archivo $nombre_archivo no se encuentra en el sistema de archivos."
            ./log_operation.sh "Lectura" "$nombre_archivo" "Error: No se encontró el archivo real"
            return 1
        fi
    else
        ./log_operation.sh "Lectura" "$nombre_archivo" "Error: No existe"
        echo "Error: El archivo $nombre_archivo no existe."
        return 1
    fi
}

# Validar los argumentos
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    exit 1
fi

# Llamar a la función de lectura con el argumento proporcionado
leer_archivo "$1"
exit $?
