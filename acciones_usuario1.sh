#!/bin/bash

nombre_archivo=$1
pipe="/home/jm-so/obligatorio/mi_pipe"
semaforo="semaforo_$nombre_archivo"

# Esperar señal de la pipe
echo "Usuario 1 (jm-so) esperando señal de la pipe para iniciar la creación..."
read mensaje < "$pipe"

echo "Usuario 1 (jm-so) está creando $nombre_archivo y reteniéndolo por 10 segundos."
./crea_un_archivo.sh $nombre_archivo rwx
./escribir_en_un_archivo.sh $nombre_archivo "Contenido inicial por Usuario 1 (jm-so)"

# Retener el archivo por 10 segundos para simular una operación larga
sleep 10

# Liberar el archivo y notificar a otros usuarios
echo "Usuario 1 (jm-so) ha creado y soltado el archivo." > "$pipe"
echo "Usuario 1 (jm-so) terminó."
