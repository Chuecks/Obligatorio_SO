#!/bin/bash

# Pipe y mutex
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
    if ! grep -q "Creación | Archivo: $archivo | Resultado: Éxito" filesystem/operaciones.log; then
        ./crea_un_archivo.sh "$archivo" "$permisos"
    fi
}

# Extraer los últimos tres archivos creados de operaciones.log
obtener_ultimos_archivos() {
    tail -n 50 filesystem/operaciones.log | grep "Creación" | grep "Resultado: Éxito" | awk '{print $6}' | tail -n 3 | sed 's/Archivo: //g'
}

# Función de operación aleatoria
operacion_aleatoria() {
    local archivo=$1
    local operacion=$((RANDOM % 5))

    exec 200>"$mutex"
    flock -w 5 200

    case $operacion in
        0) ./crea_un_archivo.sh "$archivo" rwx ;;
        1) ./leer_un_archivo.sh "$archivo" ;;
        2) ./escribir_en_un_archivo.sh "$archivo" "Contenido aleatorio $(date +%s)" ;;
        3) ./eliminar_un_archivo.sh "$archivo" ;;
        4) ./ejecutar_un_archivo.sh "$archivo" ;;
    esac

    echo "Operación $operacion realizada en $archivo" > "$pipe"
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

    for archivo in "${ultimos_archivos[@]}"; do
        operacion_aleatoria "$archivo" &
    done

    sleep 1
done
