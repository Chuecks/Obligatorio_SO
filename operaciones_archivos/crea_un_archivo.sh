#!/bin/bash

crear_archivo() {
    local ruta_completa=$1
    local permisos=$2

    # Obtener el directorio base de la ruta proporcionada
    local directorio_base=$(dirname "$ruta_completa")

    # Crear el directorio base si no existe
    if [ ! -d "$directorio_base" ]; then
        mkdir -p "$directorio_base"
    fi

    # Verificar si el archivo ya existe en el sistema de archivos
    if [ -e "$ruta_completa" ]; then
        echo "Error: El archivo $ruta_completa ya existe."
        bash ./log_operation.sh "Creación" "$ruta_completa" "Error: Ya existe"
        return 1
    fi

    # Crear el archivo
    touch "$ruta_completa"

    # Asignar permisos en base al parámetro ingresado
    case $permisos in
        rwx) octal_permisos=700 ;;
        rw) octal_permisos=600 ;;
        r) octal_permisos=400 ;;
        *) echo "Error: Permisos no válidos."
           bash ./log_operation.sh "Creación" "$ruta_completa" "Error: Permisos no válidos"
           return 1
           ;;
    esac

    chmod $octal_permisos "$ruta_completa"
    bash ./log_operation.sh "Creación" "$ruta_completa" "Éxito"
    echo "Archivo $ruta_completa creado con permisos $permisos."
}

# Validar los argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 ruta_del_archivo permisos"
    exit 1
fi

# Llamar a la función con los argumentos proporcionados
crear_archivo "$1" "$2"
