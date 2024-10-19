#!/bin/bash

leer_archivo() {
    local nombre_archivo=$1

    # Verificar si el archivo existe
    if grep -q "$nombre_archivo" obligatorio/filesystem/metadatos.txt; then
        # Extraer el contenido del archivo
        contenido=$(grep "$nombre_archivo" obligatorio/filesystem/metadatos.txt | awk '{print $4}')
        echo "Contenido del archivo $nombre_archivo: $contenido"
    else
        echo "Error: El archivo $nombre_archivo no existe."
    fi
}
