#!/bin/bash

# Obtener el nombre del usuario actual
usuario=$(whoami)

crear_archivo() {
    local nombre_archivo=$1
    local permisos=$2

    # Verificar si el archivo ya existe en el sistema de archivos
    if [ -e "filesystem/$nombre_archivo" ]; then
        echo "Error: El archivo $nombre_archivo ya existe."
        bash ./log_operation.sh "Creación" "$nombre_archivo" "Error: Ya existe"
        return 1
    fi

    touch filesystem/$nombre_archivo

    case $permisos in
        rwx) octal_permisos=700 ;;
        rw) octal_permisos=600 ;;
        r) octal_permisos=400 ;;
        *) echo "Error: Permisos no válidos."
           bash ./log_operation.sh "Creación" "$nombre_archivo" "Error: Permisos no válidos"
           return 1
           ;;
    esac

    chmod $octal_permisos filesystem/$nombre_archivo
    bash ./log_operation.sh "Creación" "$nombre_archivo" "Éxito"
    echo "Archivo $nombre_archivo creado con permisos $permisos."
}

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 nombre_del_archivo permisos"
    exit 1
fi

crear_archivo "$1" "$2"
