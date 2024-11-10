#!/bin/bash

ejecutar_archivo() {
    local ruta_completa=$1

    # Verificar si el archivo tiene permisos de ejecución y existe
    if [[ -x $ruta_completa ]]; then
        bash "$ruta_completa"  
        echo "Archivo $ruta_completa ejecutado satisfactoriamente."
        ./log_operation.sh "Ejecución" "$ruta_completa" "Éxito"
        return 0
    else
        echo "Error: El archivo $ruta_completa no tiene permisos de ejecución o no existe."
        ./log_operation.sh "Ejecución" "$ruta_completa" "Error: Permiso denegado"
        return 1
    fi
}

# Validar los argumentos
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 ruta_del_archivo"
    exit 1
fi

# Llamar a la función de ejecución
ejecutar_archivo "$1"
