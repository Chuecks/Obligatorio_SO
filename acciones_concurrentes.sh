#!/bin/bash

# Definir el nombre del pipe y el mutex
PIPE_NAME="pipe_concurrente"
MUTEX="/tmp/mutex"

# Crear el pipe si no existe
if [[ ! -p $PIPE_NAME ]]; then
    mkfifo $PIPE_NAME
fi

# Crear mutex si no existe
if [[ ! -e $MUTEX ]]; then
    touch $MUTEX
fi

# Función para registrar en operaciones.log
log_operation() {
    local operation=$1
    local file=$2
    local result=$3
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local pid=$$
    local user=$USER

    # Bloqueo para sincronizar el acceso a operaciones.log
    (
        flock -x 200
        echo "$timestamp | PID: $pid | Usuario: $user | Operación: $operation | Archivo: $file | Resultado: $result" >> filesystem/operaciones.log
    ) 200>$MUTEX
}

# Función para crear un archivo
crear_archivo() {
    local nombre_archivo=$1
    touch "filesystem/$nombre_archivo"
    log_operation "Crear" "$nombre_archivo" "Éxito"
    echo "Archivo creado por Usuario 1: $nombre_archivo" > $PIPE_NAME
}

# Función para escribir en un archivo
escribir_archivo() {
    local nombre_archivo=$1
    local contenido=$2
    echo "$contenido" > "filesystem/$nombre_archivo"
    log_operation "Escribir" "$nombre_archivo" "Éxito"
    echo "Archivo $nombre_archivo modificado con contenido: $contenido" > $PIPE_NAME
}

# Función para leer un archivo
leer_archivo() {
    local nombre_archivo=$1
    if [[ -f "filesystem/$nombre_archivo" ]]; then
        contenido=$(cat "filesystem/$nombre_archivo")
        log_operation "Leer" "$nombre_archivo" "Éxito"
        echo "Contenido del archivo $nombre_archivo: $contenido" > $PIPE_NAME
    else
        log_operation "Leer" "$nombre_archivo" "Error: No existe"
        echo "Error: El archivo $nombre_archivo no existe" > $PIPE_NAME
    fi
}

# Función para eliminar un archivo
eliminar_archivo() {
    local nombre_archivo=$1
    rm "filesystem/$nombre_archivo"
    log_operation "Eliminar" "$nombre_archivo" "Éxito"
    echo "Archivo $nombre_archivo eliminado" > $PIPE_NAME
}

# Simulación de usuarios
usuario1() {
    crear_archivo "archivo1.txt"
    escribir_archivo "archivo1.txt" "Contenido inicial de archivo1"
    leer_archivo "archivo1.txt"
}

usuario2() {
    sleep 2  # Espera para simular concurrencia
    leer_archivo "archivo1.txt"
    escribir_archivo "archivo1.txt" "Contenido modificado por Usuario 2"
    eliminar_archivo "archivo1.txt"
}

# Ejecución de los procesos en paralelo
usuario1 &
usuario2 &

# Leer mensajes del pipe
while read -r mensaje; do
    echo "Mensaje del pipe: $mensaje"
done < $PIPE_NAME
