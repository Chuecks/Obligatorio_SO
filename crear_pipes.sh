#!/bin/bash

# Verificar si se proporcionaron los argumentos correctos
if [ "$#" -lt 1 ]; then
    echo "Uso: $0 pipe1 [pipe2 ... pipeN]"
    echo "Ejemplo: $0 pipe1 pipe2 pipe3"
    exit 1
fi

# Crear cada pipe basado en los argumentos
for pipe in "$@"; do
    if [ ! -p "$pipe" ]; then  # Verificar si el pipe ya existe
        mkfifo "$pipe"
        echo "Pipe $pipe creado."
    else
        echo "El pipe $pipe ya existe."
    fi
done
