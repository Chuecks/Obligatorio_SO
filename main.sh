#!/bin/bash

# Definir la pipe y el mutex
pipe="mi_pipe"
mutex="mutex.lock"

# Crear la pipe y el mutex si no existen
if [ ! -p "$pipe" ]; then
    mkfifo "$pipe"
fi
if [ ! -f "$mutex" ]; then
    touch "$mutex"
fi

# Función para verificar si el archivo existe
verificar_archivo() {
    local archivo=$1
    if [ ! -e "filesystem/$archivo" ]; then
        local error_message="Error: No se encontró el archivo '$archivo'."
        echo "$error_message"
        
        # Registrar el error en operaciones.log usando log_operation.sh
        ./log_operation.sh "VERIFICAR" "$archivo" "No se encontró el archivo."
        return 1
    fi
    return 0
}

# Función para procesar las instrucciones de usuario.sh
procesar_instruccion() {
    local operacion=$1
    local archivo=$2
    local permisos=$3
    local contenido=$4

    # Bloqueo de concurrencia con mutex
    exec 200>"$mutex"
    flock -w 5 200

    # Ejecutar la operación solicitada
    case "$operacion" in
        "CREAR")
            if [ -n "$permisos" ]; then
                ./operaciones_archivos/crea_un_archivo.sh "$archivo" "$permisos"
            else
                echo "Error: La operación CREAR requiere especificar permisos."
            fi
            ;;
        "LEER")
            if verificar_archivo "$archivo"; then
                ./operaciones_archivos/leer_un_archivo.sh "$archivo"
            fi
            ;;
        "ESCRIBIR")
            if verificar_archivo "$archivo"; then
                if [ -n "$contenido" ]; then
                    ./operaciones_archivos/escribir_en_un_archivo.sh "$archivo" "$contenido"
                else
                    echo "Error: La operación ESCRIBIR requiere contenido para escribir."
                    ./log_operation.sh "ESCRIBIR" "$archivo" "Error: Falta contenido."
                fi
            fi
            ;;
        "ELIMINAR")
            if verificar_archivo "$archivo"; then
                ./operaciones_archivos/eliminar_un_archivo.sh "$archivo"
                ./log_operation.sh "ELIMINAR" "$archivo" "Éxito"
            fi
            ;;
        "EJECUTAR")
            if verificar_archivo "$archivo"; then
                ./operaciones_archivos/ejecutar_un_archivo.sh "$archivo"
                ./log_operation.sh "EJECUTAR" "$archivo" "Éxito"
            fi
            ;;
        *)
            echo "Operación inválida: $operacion"
            ./log_operation.sh "INVÁLIDO" "$archivo" "Operación inválida."
            ;;
    esac

    # Liberar el mutex
    flock -u 200
}

# Bucle para leer y procesar mensajes de la pipe
echo "Control de concurrencia iniciado. Esperando mensajes en $pipe..."
while true; do
    # Leer la instrucción desde la pipe
    if read -r instruccion < "$pipe"; then
        # Dividir la instrucción en operación, archivo, permisos, y contenido
        operacion=$(echo "$instruccion" | awk '{print $1}')
        archivo=$(echo "$instruccion" | awk '{print $2}')
        permisos=$(echo "$instruccion" | awk '{print $3}')
        contenido=$(echo "$instruccion" | cut -d' ' -f4-)

        # Remover las comillas alrededor del contenido, si existen
        contenido="${contenido//\"/}"  # Elimina comillas dobles

        # Verificar la validez de la instrucción
        if [[ -n "$operacion" && -n "$archivo" ]]; then
            echo "Main recibió: $instruccion - Ejecutando operación."
            procesar_instruccion "$operacion" "$archivo" "$permisos" "$contenido"
        else
            echo "Mensaje inválido o incompleto: $instruccion"
        fi
    fi
done
