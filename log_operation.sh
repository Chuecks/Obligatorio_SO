#!/bin/bash

log_operation() {
    local operation=$1
    local file=$2
    local result=$3

    # Obtener timestamp y PID
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local pid=$$

    # Registrar en el archivo de log con ruta absoluta
    echo "$timestamp | PID: $pid | Operación: $operation | Archivo: $file | Resultado: $result" >> /home/jm-so/obligatorio/filesystem/operaciones.log
}
