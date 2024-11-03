#!/bin/bash

# Verificar si se proporcionó un argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 ruta_del_archivo"
    echo "Ejemplo: $0 carpeta1/subcarpeta/archivo.txt"
    exit 1
fi

# Asignar el argumento a una variable
ruta_completa=$1

# Intentar ejecutar el archivo
if [[ -x $ruta_completa ]]; then
    bash "$ruta_completa"  
    echo "Archivo $ruta_completa ejecutado satisfactoriamente"
    resultado="Éxito"
else
    resultado="Error: Permiso denegado"
    echo "Error: El archivo $ruta_completa no tiene permisos de ejecución o no existe."
fi

# Registrar la operación en operaciones.log
./log_operation.sh "Ejecución" "$ruta_completa" "$resultado"
