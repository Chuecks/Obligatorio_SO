#!/bin/bash
pipe="/home/jm-so/obligatorio/mi_pipe"
mutex="mutex.lock"
nombre_archivo=$1

# Esperar a que el Usuario 2 termine
echo "Usuario 3 (tm-so) esperando a que el Usuario 2 termine..."
read message < "$pipe"
echo "Usuario 3 (tm-so) recibió mensaje: $message"

# Modificar el archivo
echo "Usuario 3 (tm-so) está modificando $nombre_archivo."
flock $mutex -c "./escribir_en_un_archivo.sh $nombre_archivo 'Modificado por Usuario 3 (tm-so)'"
sleep 5

# Notificar que la modificación está completa
echo "Modificación completada por Usuario 3" > "$pipe"
