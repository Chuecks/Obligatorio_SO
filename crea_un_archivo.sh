#!/bin/bash

# Obtener el nombre del usuario actual
usuario=$(whoami)

crear_archivo() {
    local nombre_archivo=$1
    local permisos=$2

    # Verificar si el archivo ya existe en los metadatos
    if grep -q "$nombre_archivo" filesystem/metadatos.txt; then
        echo "Error: El archivo $nombre_archivo ya existe en los metadatos."
        return 1
    fi

    # Crear el archivo simulado con tamaño 0 y agregarlo a los metadatos
    echo "$nombre_archivo 0 $permisos \"\"" >> filesystem/metadatos.txt
    touch filesystem/$nombre_archivo
    
    # Convertir permisos de simbólico a octal
    case $permisos in
        rwx) octal_permisos=700 ;;  # Lectura, escritura y ejecución para el propietario
        rw) octal_permisos=600 ;;   # Lectura y escritura para el propietario
        r) octal_permisos=400 ;;    # Solo lectura para el propietario
        *) echo "Error: Permisos no válidos. Usa 'r', 'rw', o 'rwx'."; return 1 ;;
    esac

    chmod $octal_permisos filesystem/$nombre_archivo

    # Registrar la creación en los metadatos
    echo "$nombre_archivo fue creado por $usuario." >> filesystem/metadatos.txt

    echo "Archivo $nombre_archivo creado con permisos $permisos."
}

# Comprobar si se proporcionaron argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 nombre_del_archivo permisos"
    echo "Ejemplo: $0 archivo.txt rw-"
    exit 1
fi

# Llamar a la función con los argumentos proporcionados
crear_archivo "$1" "$2"
