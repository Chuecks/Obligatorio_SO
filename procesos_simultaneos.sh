#!/bin/bash

# Verificar si se proporcionó un argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 nombre_del_archivo"
    echo "Ejemplo: $0 archivo1.txt"
    exit 1
fi

# Asignar el argumento a una variable
nombre_archivo=$1
semaforo="semaforo_$nombre_archivo"  # Nombre único para el semáforo

# Proceso 1: Crear un archivo y escribir en él
usuario1() {
    echo "Usuario 1 quiere crear y escribir en $nombre_archivo."
    ./semaforo.sh $nombre_archivo $semaforo "./crea_un_archivo.sh $nombre_archivo rwx"
    ./semaforo.sh $nombre_archivo $semaforo "./escribir_en_un_archivo.sh $nombre_archivo 'Contenido inicial por Usuario 1'"
}

# Proceso 2: Editar (escribir nuevo contenido) en el archivo
usuario2() {
    sleep 2  # Asegurar que el archivo haya sido creado antes de editar
    for i in {1..5}; do
        echo "Usuario 2 quiere editar $nombre_archivo."
        ./semaforo.sh $nombre_archivo $semaforo "./escribir_en_un_archivo.sh $nombre_archivo 'Modificado por Usuario 2 - iteración $i'"
        sleep 1
    done
}

# Proceso 3: Leer el archivo para verificar su contenido
usuario3() {
    sleep 2  # Asegurar que el archivo haya sido creado antes de leer
    for i in {1..5}; do
        echo "Usuario 3 está leyendo $nombre_archivo."
        ./semaforo.sh $nombre_archivo $semaforo "./leer_un_archivo.sh $nombre_archivo"
        sleep 1
    done
}

# Ejecutar el proceso de creación primero
usuario1

# Ejecutar los procesos de modificación y lectura en paralelo
usuario2 &
usuario3 &

# Esperar a que todos los procesos terminen
wait

# Proceso 4: Eliminar el archivo después de que los otros procesos hayan terminado
usuario4() {
    echo "Usuario 4 eliminará $nombre_archivo."
    ./semaforo.sh $nombre_archivo $semaforo "./eliminar_un_archivo.sh $nombre_archivo"
}

usuario4
