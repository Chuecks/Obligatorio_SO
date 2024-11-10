#!/bin/bash

escribir_archivo() {
    local ruta=$1
    local nuevo_contenido=$2
    local nombre_archivo=$(basename "$ruta")  # Obtener solo el nombre del archivo

    # Verificar si el archivo está registrado en operaciones.log
    if grep -q "$nombre_archivo" ./operaciones.log; then
        # Intentar escribir el contenido en el archivo
        echo "$nuevo_contenido" > "$ruta"

        # Verificar si el archivo existe y se ha podido escribir en él
        if [ -f "$ruta" ]; then
            ./log_operation.sh "Escritura" "$nombre_archivo" "Éxito"
            echo "Contenido del archivo $nombre_archivo actualizado."
            return 0
        else
            ./log_operation.sh "Escritura" "$nombre_archivo" "Error: No existe el archivo físico"
            echo "Error: No se pudo encontrar $nombre_archivo en filesystem."
            return 1
        fi
    else
        ./log_operation.sh "Escritura" "$nombre_archivo" "Error: No registrado"
        echo "Error: El archivo $nombre_archivo no está registrado en operaciones.log."
        return 1
    fi
}

# Validar los argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 ruta_del_archivo 'nuevo_contenido'"
    exit 1
fi

# Llamar a la función con los argumentos proporcionados
escribir_archivo "$1" "$2"
