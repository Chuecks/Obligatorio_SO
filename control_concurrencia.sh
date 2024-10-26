#!/bin/bash

pipe="mi_pipe"
mutex="mutex.lock"

# Crear el mutex si no existe
if [ ! -f "$mutex" ]; then
    touch "$mutex"
fi

# Función para obtener los últimos tres archivos creados
obtener_ultimos_archivos() {
    tail -n 50 filesystem/operaciones.log | grep "Creación" | grep "Resultado: Éxito" | awk '{print $6}' | tail -n 3 | sed 's/Archivo: //g'
}

# Función para operaciones aleatorias
operacion_aleatoria() {
    local archivo=$1
    local operacion=$((RANDOM % 5))

    exec 200>"$mutex"
    flock 200

    case $operacion in
        0) ./crea_un_archivo.sh "$archivo" rwx ;;
        1) ./leer_un_archivo.sh "$archivo" ;;
        2) ./escribir_en_un_archivo.sh "$archivo" "Contenido aleatorio $(date +%s)" ;;
        3) ./eliminar_un_archivo.sh "$archivo" ;;
        4) ./ejecutar_un_archivo.sh "$archivo" ;;
    esac

    echo "Operación $operacion realizada en $archivo por control_concurrencia" > "$pipe"
    flock -u 200
}

# Bucle infinito para operaciones aleatorias en los últimos tres archivos
while true; do
    ultimos_archivos=($(obtener_ultimos_archivos))

    if [ ${#ultimos_archivos[@]} -ge 3 ]; then
        archivo_seleccionado=${ultimos_archivos[$((RANDOM % 3))]}
        operacion_aleatoria "$archivo_seleccionado"
    fi

    sleep 2
done

