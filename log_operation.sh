#!/bin/bash

log_operation() {
    local operation=$1
    local file=$2
    local result=$3

    # Obtener timestamp, PID, y usuario
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local pid=$$
    local usuario=$(whoami)  # Obtener el usuario que ejecuta la operación

    # Registrar en el archivo de log
    echo "$timestamp | PID: $pid | Usuario: $usuario | Operación: $operation | Archivo: $file | Resultado: $result" >> /home/jm-so/obligatorio/filesystem/operaciones.log
}

# Llamar a la función con los parámetros
log_operation "$1" "$2" "$3"
