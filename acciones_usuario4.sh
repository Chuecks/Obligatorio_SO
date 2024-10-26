#!/bin/bash
pipe="/home/jm-so/obligatorio/mi_pipe"
mutex="mutex.lock"
nombre_archivo=$1

# Esperar a que el Usuario 3 termine
echo "Usuario 4 (jm-so) esperando a que se complete la modificación..."
read message < "$pipe"
echo "Usuario 4 (jm-so) recibió mensaje: $message"

# Leer el archivo
echo "Usuario 4 (jm-so) está leyendo $nombre_archivo."
flock $mutex -c "./leer_un_archivo.sh $nombre_archivo"

# Eliminar el archivo
echo "Usuario 4 (jm-so) está eliminando $nombre_archivo."
flock $mutex -c "./eliminar_un_archivo.sh $nombre_archivo"

# Notificar que el archivo ha sido eliminado
echo "Archivo eliminado por Usuario 4" > "$pipe"
