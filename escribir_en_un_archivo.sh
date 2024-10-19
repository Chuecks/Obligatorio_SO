#!/bin/bash

# Obtener el nombre del usuario actual
usuario=$(whoami)

escribir_archivo() {
    local nombre_archivo=$1
    local nuevo_contenido=$2

    # Verificar si el archivo existe en los metadatos
    if grep -q "$nombre_archivo" filesystem/metadatos.txt; then
        # Escribir en el archivo real
        echo "$nuevo_contenido" > filesystem/$nombre_archivo

        # Obtener el tamaño del archivo en bytes usando 'stat'
        if [ -f "filesystem/$nombre_archivo" ]; then
            nuevo_tamaño=$(stat -c%s "filesystem/$nombre_archivo")  # Obtener el tamaño en bytes correctamente
            echo "Tamaño actual de $nombre_archivo: $nuevo_tamaño bytes"  # Mensaje de depuración
        else
            echo "Error: No se pudo encontrar $nombre_archivo en filesystem."
            exit 1
        fi

        # Actualizar el tamaño y el contenido en los metadatos, evitando duplicados
        sed -i "/$nombre_archivo/s/[0-9]\{1,\}/$nuevo_tamaño/" filesystem/metadatos.txt  # Actualizar el tamaño
        sed -i "/$nombre_archivo/s/\".*\"/\"$nuevo_contenido\"/" filesystem/metadatos.txt  # Actualizar el contenido

        # Registrar la modificación solo una vez
        if ! grep -q "$nombre_archivo fue modificado por $usuario" filesystem/metadatos.txt; then
            echo "$nombre_archivo fue modificado por $usuario." >> filesystem/metadatos.txt
        fi

        echo "Contenido del archivo $nombre_archivo actualizado."
    else
        echo "Error: El archivo $nombre_archivo no existe en los metadatos."
    fi
}

# Comprobar si se proporcionaron argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 nombre_del_archivo 'nuevo_contenido'"
    echo "Ejemplo: $0 archivo2.txt 'Este es el nuevo contenido.'"
    exit 1
fi

# Llamar a la función con los argumentos proporcionados
escribir_archivo "$1" "$2"
