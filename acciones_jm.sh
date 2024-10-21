#!/bin/bash

# Nombre del archivo y del pipe
nombre_archivo=$1
pipe="pipe_$nombre_archivo.txt"

# Verificar si el pipe ya existe, si no, crearlo
if [ ! -p "$pipe" ]; then
    mkfifo "$pipe"
    echo "Pipe $pipe creado."
fi

# Usuario jm-so crea el archivo
echo "Usuario jm-so quiere crear y escribir en $nombre_archivo."
./crea_un_archivo.sh "$nombre_archivo" rwx

# Enviar mensaje al pipe para indicar que el archivo ha sido creado
echo "Archivo creado por Usuario jm-so" > "$pipe"
