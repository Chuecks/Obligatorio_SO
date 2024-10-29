#!/bin/bash

# Verificar si se proporcionó un argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    echo "Ejemplo: $0 archivo.txt"
    exit 1
fi

# Asignar el argumento a una variable
nombre_archivo=$1
usuario=$(whoami)

# Intentar ejecutar el archivo
if [[ -x "filesystem/$nombre_archivo" ]]; then
    bash "filesystem/$nombre_archivo"
    resultado="Éxito"
else
    resultado="Error: Permiso denegado"
    echo "Error: El archivo $nombre_archivo no tiene permisos de ejecución."
fi

# Registrar la operación en operaciones.log
./log_operation.sh "Ejecución" "$nombre_archivo" "$resultado"
