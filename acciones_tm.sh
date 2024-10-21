#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    echo "Ejemplo: $0 archivo1.txt"
    exit 1
fi

nombre_archivo=$1
pipe="pipe_$nombre_archivo"
semaforo="semaforo_$nombre_archivo"

# Esperar a que el primer proceso cree el archivo
read mensaje < "$pipe"
echo "Usuario tm-so recibió del pipe: $mensaje"

# Proceso 1: Leer el archivo
echo "Usuario tm-so está leyendo $nombre_archivo."
./semaforo.sh $nombre_archivo $semaforo "./leer_un_archivo.sh $nombre_archivo"

# Proceso 2: Modificar el archivo
for i in {1..5}; do
    echo "Usuario tm-so quiere editar $nombre_archivo."
    ./semaforo.sh $nombre_archivo $semaforo "./escribir_en_un_archivo.sh $nombre_archivo 'Modificado por Usuario tm-so - iteración $i'"
    sleep 1
done

# Avisar a jm-so que tm-so ha terminado las modificaciones
echo "Modificaciones de Usuario tm-so completas" > "$pipe"
