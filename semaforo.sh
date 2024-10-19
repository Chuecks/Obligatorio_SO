#!/bin/bash

# Verificar si se proporcionaron los argumentos
if [ "$#" -lt 3 ]; then
    echo "Uso: $0 nombre_del_recurso nombre_semaforo comando"
    echo "Ejemplo: $0 archivo.txt archivo.lock 'echo hola'"
    exit 1
fi

# Asignar los argumentos a variables
recurso=$1
semaforo=$2
comando=$3

# Bloquear el recurso con flock y ejecutar el comando
flock -x "$semaforo" -c "$comando"
