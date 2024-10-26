#!/bin/bash

nombre_archivo=$1
pipe="/home/jm-so/obligatorio/mi_pipe"
semaforo="semaforo_$nombre_archivo"

# Esperar hasta que Usuario 1 libere el archivo
echo "Usuario 2 (otro_usuario) esperando para leer $nombre_archivo..."
read mensaje < "$pipe"

# Intentar leer y editar el archivo
echo "Usuario 2 (otro_usuario) está editando $nombre_archivo."
./escribir_en_un_archivo.sh $nombre_archivo "Modificado por Usuario 2 (otro_usuario)"

# Liberar el archivo y notificar a otros usuarios
echo "Usuario 2 (otro_usuario) ha terminado de modificar el archivo." > "$pipe"
echo "Usuario 2 (otro_usuario) terminó."
