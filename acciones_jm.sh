#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    echo "Ejemplo: $0 archivo1.txt"
    exit 1
fi

nombre_archivo=$1
pipe="pipe_$nombre_archivo"
semaforo="semaforo_$nombre_archivo"

# Crear el pipe si no existe
if [ ! -p "$pipe" ]; then
    mkfifo "$pipe"
    echo "Pipe $pipe creado."
fi

# Proceso 1: Crear un archivo y escribir en él
echo "Usuario jm-so quiere crear y escribir en $nombre_archivo."
./semaforo.sh $nombre_archivo $semaforo "./crea_un_archivo.sh $nombre_archivo rwx"
./semaforo.sh $nombre_archivo $semaforo "./escribir_en_un_archivo.sh $nombre_archivo 'Contenido inicial por Usuario jm-so'"

# Escribir en el pipe para avisar a tm-so que el archivo fue creado
echo "Archivo creado por Usuario jm-so" > "$pipe"

# Esperar a que tm-so termine de leer y modificar el archivo
read mensaje < "$pipe"
echo "Usuario jm-so recibió del pipe: $mensaje"

# Proceso 2: Eliminar el archivo después de que tm-so haya terminado
echo "Usuario jm-so eliminará $nombre_archivo."
./semaforo.sh $nombre_archivo $semaforo "./eliminar_un_archivo.sh $nombre_archivo"

# Cerrar el pipe
rm -f "$pipe"
