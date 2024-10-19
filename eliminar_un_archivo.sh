#!/bin/bash

eliminar_archivo() {
    local nombre_archivo=$1

    # Verificar si el archivo existe en los metadatos
    if grep -q "$nombre_archivo" filesystem/metadatos.txt; then
        # Eliminar el archivo real si existe
        if [ -f "filesystem/$nombre_archivo" ]; then
            rm "filesystem/$nombre_archivo"
            echo "Archivo $nombre_archivo eliminado correctamente."
            
            # Registrar que el archivo ha sido eliminado en los metadatos
            local usuario=$(whoami)  # Obtener el nombre del usuario actual
            echo "$nombre_archivo fue eliminado por $usuario." >> filesystem/metadatos.txt
        else
            echo "Error: El archivo $nombre_archivo no existe en el sistema de archivos."
        fi
    else
        echo "Error: El archivo $nombre_archivo no existe en los metadatos."
    fi
}

# Comprobar si se proporcionaron argumentos
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    echo "Ejemplo: $0 archivo.txt"
    exit 1
fi

# Llamar a la función con los argumentos proporcionados
eliminar_archivo "$1"
