#!/bin/bash

# Definir la pipe y el archivo mutex
pipe="mi_pipe"
mutex="mutex.lock"

# Crear la pipe si no existe
if [ ! -p "$pipe" ]; then
    mkfifo "$pipe"
fi

# Función para procesar las instrucciones de usuario.sh
procesar_instruccion() {
    local pid=$1
    local operacion=$2
    local archivo=$3
    local permisos=$4
    local contenido=$5

    # Verificar si el sistema está bloqueado
    if [ -f "$mutex" ] && [[ "$operacion" != "DESBLOQUEAR" ]]; then
        echo "$pid Error: El sistema está bloqueado. Desbloquéalo antes de realizar otras operaciones." > "$pipe"
        return
    fi

    # Ejecutar la operación solicitada
    case "$operacion" in
        "CREAR")
            if [ -n "$permisos" ]; then
                ./operaciones_archivos/crea_un_archivo.sh "$archivo" "$permisos"
                echo "$pid Operación CREAR realizada con éxito." > "$pipe"
            else
                echo "$pid Error: La operación CREAR requiere permisos." > "$pipe"
            fi
            ;;
        "LEER")
            ./operaciones_archivos/leer_un_archivo.sh "$archivo"
            echo "$pid Operación LEER realizada con éxito." > "$pipe"
            ;;
        "ESCRIBIR")
            if [ -n "$contenido" ]; then
                ./operaciones_archivos/escribir_en_un_archivo.sh "$archivo" "$contenido"
                echo "$pid Operación ESCRIBIR realizada con éxito." > "$pipe"
            else
                echo "$pid Error: La operación ESCRIBIR requiere contenido." > "$pipe"
            fi
            ;;
        "ELIMINAR")
            ./operaciones_archivos/eliminar_un_archivo.sh "$archivo"
            echo "$pid Operación ELIMINAR realizada con éxito." > "$pipe"
            ;;
        "EJECUTAR")
            ./operaciones_archivos/ejecutar_un_archivo.sh "$archivo"
            echo "$pid Operación EJECUTAR realizada con éxito." > "$pipe"
            ;;
        "BLOQUEAR")
            touch "$mutex"
            echo "$pid Sistema bloqueado exitosamente." > "$pipe"
            ;;
        "DESBLOQUEAR")
            if [ -f "$mutex" ]; then
                rm "$mutex"
                echo "$pid Sistema desbloqueado exitosamente." > "$pipe"
            else
                echo "$pid Error: No hay ningún bloqueo activo." > "$pipe"
            fi
            ;;
        *)
            echo "$pid Operación inválida: $operacion" > "$pipe"
            ;;
    esac
}

# Bucle para leer y procesar mensajes de la pipe
echo "Control de concurrencia iniciado. Esperando mensajes en $pipe..."
while true; do
    # Leer la instrucción desde la pipe
    if read -r instruccion < "$pipe"; then
        # Dividir la instrucción en PID, operación, archivo, permisos y contenido
        pid=$(echo "$instruccion" | awk '{print $1}')
        operacion=$(echo "$instruccion" | awk '{print $2}')
        archivo=$(echo "$instruccion" | awk '{print $3}')
        permisos=$(echo "$instruccion" | awk '{print $4}')
        contenido=$(echo "$instruccion" | cut -d" " -f5-)

        echo "Main recibió: $instruccion - Ejecutando operación."

        # Procesar la instrucción
        procesar_instruccion "$pid" "$operacion" "$archivo" "$permisos" "$contenido"
    fi
done
