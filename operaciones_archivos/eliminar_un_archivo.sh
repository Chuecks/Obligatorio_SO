#!/bin/bash

eliminar_archivo() {
    local ruta=$1

    if grep -q "$nombre_archivo" ./operaciones.log; then
        if [ -f "$ruta" ]; then
            rm "$ruta"
            echo "Archivo $nombre_archivo eliminado correctamente."
            ./log_operation.sh "Eliminación" "$nombre_archivo" "Éxito"
        else
            ./log_operation.sh "Eliminación" "$nombre_archivo" "Error: No existe"
            echo "Error: El archivo $nombre_archivo no existe."
        fi
    else
        ./log_operation.sh "Eliminación" "$nombre_archivo" "Error: No registrado"
        echo "Error: El archivo $nombre_archivo no está registrado en operaciones.log."
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    exit 1
fi

eliminar_archivo "$1"
