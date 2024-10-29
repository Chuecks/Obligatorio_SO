#!/bin/bash

# Obtener el nombre del usuario actual
usuario=$(whoami)

escribir_archivo() {
    local nombre_archivo=$1
    local nuevo_contenido=$2

    if grep -q "$nombre_archivo" ./operaciones.log; then
        echo "$nuevo_contenido" > filesystem/$nombre_archivo

        if [ -f "filesystem/$nombre_archivo" ]; then
            ./log_operation.sh "Escritura" "$nombre_archivo" "Éxito"
            echo "Contenido del archivo $nombre_archivo actualizado."
        else
            echo "Error: No se pudo encontrar $nombre_archivo en filesystem."
            ./log_operation.sh "Escritura" "$nombre_archivo" "Error: No existe el archivo físico"
            exit 1
        fi
    else
        ./log_operation.sh "Escritura" "$nombre_archivo" "Error: No registrado"
        echo "Error: El archivo $nombre_archivo no está registrado en operaciones.log."
        exit 1
    fi
}

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 nombre_del_archivo 'nuevo_contenido'"
    exit 1
fi

escribir_archivo "$1" "$2"
