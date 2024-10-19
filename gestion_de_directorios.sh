#!/bin/bash

crear_directorio() {
    local nombre_directorio=$1

    # Verificar si el directorio ya existe
    if [ -d "filesystem/$nombre_directorio" ]; then
        echo "Error: El directorio $nombre_directorio ya existe."
    else
        # Crear el directorio
        mkdir filesystem/$nombre_directorio
        echo "Directorio $nombre_directorio creado correctamente."
    fi
}

eliminar_directorio() {
    local nombre_directorio=$1

    # Verificar si el directorio existe
    if [ -d "filesystem/$nombre_directorio" ]; then
        # Eliminar el directorio
        rmdir filesystem/$nombre_directorio
        echo "Directorio $nombre_directorio eliminado correctamente."
    else
        echo "Error: El directorio $nombre_directorio no existe."
    fi
}

# Comprobar si se proporcionaron argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 crear|eliminar nombre_del_directorio"
    echo "Ejemplo: $0 crear mi_directorio"
    echo "Ejemplo: $0 eliminar mi_directorio"
    exit 1
fi

# Llamar a las funciones según el argumento de acción
accion=$1
nombre_directorio=$2

case $accion in
    crear)
        crear_directorio "$nombre_directorio"
        ;;
    eliminar)
        eliminar_directorio "$nombre_directorio"
        ;;
    *)
        echo "Acción no válida. Usa 'crear' o 'eliminar'."
        exit 1
        ;;
esac
