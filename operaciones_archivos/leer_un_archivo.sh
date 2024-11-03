#!/bin/bash

leer_archivo() {
    local ruta=$1
    local nombre_archivo=$(basename "$ruta")

    if grep -q "$nombre_archivo" ./operaciones.log; then
        if [ -f "$ruta" ]; then
            contenido=$(cat "$ruta")
            echo "Contenido del archivo $nombre_archivo: \"$contenido\""
            ./log_operation.sh "Lectura" "$nombre_archivo" "Éxito"
        else
            echo "Error: El archivo $nombre_archivo no se encuentra en el sistema de archivos."
            ./log_operation.sh "Lectura" "$nombre_archivo" "Error: No se encontró el archivo real"
        fi
    else
        ./log_operation.sh "Lectura" "$nombre_archivo" "Error: No existe"
        echo "Error: El archivo $nombre_archivo no existe."
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    exit 1
fi

leer_archivo "$1"
