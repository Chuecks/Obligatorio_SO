#!/bin/bash

# Obtener el nombre del usuario actual
usuario=$(whoami)

escribir_archivo() {
    local nombre_archivo=$1
    local nuevo_contenido=$2

    if grep -q "$nombre_archivo" filesystem/metadatos.txt; then
        echo "$nuevo_contenido" > filesystem/$nombre_archivo
        nuevo_tamaño=$(stat -c%s "filesystem/$nombre_archivo")
        sed -i "/$nombre_archivo/s/[0-9]\{1,\}/$nuevo_tamaño/" filesystem/metadatos.txt
        sed -i "/$nombre_archivo/s/\".*\"/\"$nuevo_contenido\"/" filesystem/metadatos.txt

        if ! grep -q "$nombre_archivo fue modificado por $usuario" filesystem/metadatos.txt; then
            echo "$nombre_archivo fue modificado por $usuario." >> filesystem/metadatos.txt
        fi

        ./log_operation.sh "Escritura" "$nombre_archivo" "Éxito"
        echo "Contenido del archivo $nombre_archivo actualizado."
    else
        ./log_operation.sh "Escritura" "$nombre_archivo" "Error: No existe"
        echo "Error: El archivo $nombre_archivo no existe."
    fi
}

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 nombre_del_archivo 'nuevo_contenido'"
    exit 1
fi

escribir_archivo "$1" "$2"
