#!/bin/bash

# Definir el pipe y el mutex
pipe="mi_pipe"
mutex="mutex.lock"

# Crear el pipe y el mutex si no existen
if [ ! -p "$pipe" ]; then
    mkfifo "$pipe"
fi
if [ ! -f "$mutex" ]; then
    touch "$mutex"
fi

# Crear un archivo si no existe en operaciones.log
crear_archivo_si_no_existe() {
    local archivo=$1
    local permisos=$2
    if [ ! -e "filesystem/$archivo" ]; then
        ./operaciones_archivos/crea_un_archivo.sh "$archivo" "$permisos"
    fi
}

# Extraer los últimos tres archivos creados de operaciones.log
obtener_ultimos_archivos() {
    tail -n 50 ./operaciones.log | grep "Creación" | grep "Resultado: Éxito" | sed -E 's/.*Archivo: ([^ ]+).*/\1/' | tail -n 3
}

# Función de operación aleatoria en un archivo 
operacion_aleatoria() {
    local archivo=$1
    local operacion=$((RANDOM % 4))  # Ahora solo 4 operaciones: leer, escribir, eliminar, ejecutar
    local terminal_id=$(ps -p $$ -o tty=)  # Obtener el ID de la terminal actual

    # Bloqueo con mutex
    exec 200>"$mutex"
    flock -w 5 200
    
    # Realizar la operación aleatoria y registrar en el pipe
    case $operacion in
        0) 
            ./operaciones_archivos/leer_un_archivo.sh "$archivo"
            echo "Operación LEER realizada en $archivo desde terminal $terminal_id" > "$pipe"
            ;;
        1) 
            ./operaciones_archivos/escribir_en_un_archivo.sh "$archivo" "Contenido aleatorio $(date +%s)"
            echo "Operación ESCRIBIR realizada en $archivo desde terminal $terminal_id" > "$pipe"
            ;;
        2) 
            ./operaciones_archivos/eliminar_un_archivo.sh "$archivo"
            echo "Operación ELIMINAR realizada en $archivo desde terminal $terminal_id" > "$pipe"
            ;;
        3) 
            ./operaciones_archivos/ejecutar_un_archivo.sh "$archivo"
            echo "Operación EJECUTAR realizada en $archivo desde terminal $terminal_id" > "$pipe"
            ;;
    esac

    # Liberar el mutex
    flock -u 200
}

# Bucle infinito para realizar operaciones aleatorias en los últimos archivos creados
while true; do
    ultimos_archivos=($(obtener_ultimos_archivos))

    # Crear los archivos iniciales con permisos si no existen en operaciones.log
    if [ ${#ultimos_archivos[@]} -lt 3 ]; then
        crear_archivo_si_no_existe "archivo1.txt" "rwx"
        crear_archivo_si_no_existe "archivo2.txt" "rw"
        crear_archivo_si_no_existe "archivo3.txt" "r"
        ultimos_archivos=("archivo1.txt" "archivo2.txt" "archivo3.txt")
    fi

    # Ejecutar operaciones aleatorias en paralelo para cada archivo
    for archivo in "${ultimos_archivos[@]}"; do
        operacion_aleatoria "$archivo" &
    done

    # Pausa de un segundo entre iteraciones
    sleep 1
done
