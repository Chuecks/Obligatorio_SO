#!/bin/bash

log_operation() {
    local operation=$1
    local file=$2
    local result=$3
    local pid=$$  # PID del proceso log_operation.sh

    # Obtener timestamp y usuario
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local usuario=$(whoami)

    # Registrar en el archivo de log
    echo "$timestamp | PID: $pid | Usuario: $usuario | Operación: $operation | Archivo: $file | Resultado: $result" >> operaciones.log
}

# Llamar a la función con los parámetros
log_operation "$1" "$2" "$3"
