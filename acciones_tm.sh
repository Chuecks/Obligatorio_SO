#!/bin/bash

# Nombre del archivo y del pipe
nombre_archivo=$1
pipe="pipe_$nombre_archivo.txt"

# Verificar si el pipe ya existe, si no, crearlo
if [ ! -p "$pipe" ]; then
    mkfifo "$pipe"
    echo "Pipe $pipe creado."
fi

# Leer mensaje del pipe
mensaje=$(cat "$pipe")
echo "Usuario tm-so recibió del pipe: $mensaje"

# Usuario tm-so lee el archivo
echo "Usuario tm-so está leyendo $nombre_archivo."
./leer_un_archivo.sh "$nombre_archivo"

# Usuario tm-so modifica el archivo
for i in {1..5}; do
    echo "Usuario tm-so quiere editar $nombre_archivo."
    ./escribir_en_un_archivo.sh "$nombre_archivo" "Modificado por Usuario tm-so - iteración $i"
    sleep 1
done
