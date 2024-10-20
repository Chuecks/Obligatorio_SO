#!/bin/bash

leer_archivo() {
    local nombre_archivo=$1

    if grep -q "$nombre_archivo" filesystem/metadatos.txt; then
        contenido=$(grep "$nombre_archivo" filesystem/metadatos.txt | awk '{print $4}')
        echo "Contenido del archivo $nombre_archivo: $contenido"
        ./log_operation.sh "Lectura" "$nombre_archivo" "Éxito"
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
