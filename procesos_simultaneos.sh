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
pipe="pipe_$nombre_archivo"  # Pipe único para este archivo

# Crear el pipe si no existe
if [ ! -p "$pipe" ]; then
    mkfifo "$pipe"
    echo "Pipe $pipe creado."
fi

# Proceso 1: Crear un archivo y escribir en él
usuario1() {
    echo "Usuario 1 (jm-so) quiere crear y escribir en $nombre_archivo."
    sudo -u jm-so ./semaforo.sh $nombre_archivo $semaforo "./crea_un_archivo.sh $nombre_archivo rwx"
    sudo -u jm-so ./semaforo.sh $nombre_archivo $semaforo "./escribir_en_un_archivo.sh $nombre_archivo 'Contenido inicial por Usuario 1 (jm-so)'"

    # Escribir al pipe cuando el archivo ha sido creado
    echo "Archivo creado por Usuario 1 (jm-so)" > "$pipe"
}

# Proceso 2: Editar (escribir nuevo contenido) en el archivo
usuario2() {
    # Leer del pipe para asegurarse de que el archivo ha sido creado
    read mensaje < "$pipe"
    echo "Usuario 2 (otro_usuario) recibió del pipe: $mensaje"

    for i in {1..5}; do
        echo "Usuario 2 (otro_usuario) quiere editar $nombre_archivo."
        sudo -u otro_usuario ./semaforo.sh $nombre_archivo $semaforo "./escribir_en_un_archivo.sh $nombre_archivo 'Modificado por Usuario 2 (otro_usuario) - iteración $i'"
        sleep 1
    done

    # Escribir al pipe cuando haya terminado de modificar
    echo "Modificaciones de Usuario 2 (otro_usuario) completas" > "$pipe"
}

# Proceso 3: Leer el archivo para verificar su contenido
usuario3() {
    # Leer del pipe para asegurarse de que Usuario 2 terminó sus modificaciones
    read mensaje < "$pipe"
    echo "Usuario 3 (jm-so) recibió del pipe: $mensaje"

    for i in {1..5}; do
        echo "Usuario 3 (jm-so) está leyendo $nombre_archivo."
        sudo -u jm-so ./semaforo.sh $nombre_archivo $semaforo "./leer_un_archivo.sh $nombre_archivo"
        sleep 1
    done
}

# Ejecutar el proceso de creación primero
usuario1 &

# Ejecutar los procesos de modificación y lectura en paralelo
usuario2 &
usuario3 &

# Esperar a que todos los procesos terminen
wait

# Proceso 4: Eliminar el archivo después de que los otros procesos hayan terminado
usuario4() {
    echo "Usuario 4 (otro_usuario) eliminará $nombre_archivo."
    sudo -u otro_usuario ./semaforo.sh $nombre_archivo $semaforo "./eliminar_un_archivo.sh $nombre_archivo"

    # Eliminar el pipe al finalizar
    rm -f "$pipe"
}

usuario4
