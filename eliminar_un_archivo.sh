#!/bin/bash

eliminar_archivo() {
    local nombre_archivo=$1

    if grep -q "$nombre_archivo" filesystem/metadatos.txt; then
        if [ -f "filesystem/$nombre_archivo" ]; then
            rm "filesystem/$nombre_archivo"
            echo "Archivo $nombre_archivo eliminado correctamente."
            echo "$nombre_archivo fue eliminado por $usuario." >> filesystem/metadatos.txt
            ./log_operation.sh "Eliminación" "$nombre_archivo" "Éxito"
        else
            ./log_operation.sh "Eliminación" "$nombre_archivo" "Error: No existe"
            echo "Error: El archivo $nombre_archivo no existe."
        fi
    else
        ./log_operation.sh "Eliminación" "$nombre_archivo" "Error: No en metadatos"
        echo "Error: El archivo $nombre_archivo no existe en los metadatos."
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    exit 1
fi

eliminar_archivo "$1"
