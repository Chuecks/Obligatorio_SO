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

# Función para verificar si el archivo o directorio existe en la ruta
verificar_existencia() {
    local ruta="$1"
    if [ ! -e "$ruta" ]; then
        local error_message="Error: No se encontró '$ruta'."
        echo "$error_message"
        
        # Registrar el error en operaciones.log usando log_operation.sh
        ./log_operation.sh "VERIFICAR" "$ruta" "No se encontró."
        return 1
    fi
    return 0
}

# Función para procesar las instrucciones de usuario.sh
procesar_instruccion() {
    local operacion=$1
    local ruta=$2
    local permisos_o_contenido=$3

    # Bloqueo de concurrencia con mutex
    exec 200>"$mutex"
    flock -w 5 200

    # Ejecutar la operación solicitada
    case "$operacion" in
        "CREAR")
            if [ -n "$permisos_o_contenido" ]; then
                ./operaciones_archivos/crea_un_archivo.sh "$ruta" "$permisos_o_contenido"
            else
                echo "Error: La operación CREAR requiere especificar permisos."
            fi
            ;;
        "LEER")
            if verificar_existencia "$ruta"; then
                ./operaciones_archivos/leer_un_archivo.sh "$ruta"
            fi
            ;;
        "ESCRIBIR")
            if verificar_existencia "$ruta"; then
                if [ -n "$permisos_o_contenido" ]; then
                    ./operaciones_archivos/escribir_en_un_archivo.sh "$ruta" "$permisos_o_contenido"
                else
                    echo "Error: La operación ESCRIBIR requiere contenido para escribir."
                    ./log_operation.sh "ESCRIBIR" "$ruta" "Error: Falta contenido."
                fi
            fi
            ;;
        "ELIMINAR")
            if verificar_existencia "$ruta"; then
                ./operaciones_archivos/eliminar_un_archivo.sh "$ruta"
                ./log_operation.sh "ELIMINAR" "$ruta" "Éxito"
            fi
            ;;
        "EJECUTAR")
            if verificar_existencia "$ruta"; then
                ./operaciones_archivos/ejecutar_un_archivo.sh "$ruta"
                ./log_operation.sh "EJECUTAR" "$ruta" "Éxito"
            fi
            ;;
        "CREAR_DIR")
            ./operaciones_directorios/crear_un_directorio.sh "$ruta"
            ;;
        "ELIMINAR_DIR")
            ./operaciones_directorios/eliminar_un_directorio.sh "$ruta"
            ;;
        *)
            echo "Operación inválida: $operacion"
            ./log_operation.sh "INVÁLIDO" "$ruta" "Operación inválida."
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
        # Dividir la instrucción en operación, ruta, permisos/contenido
        operacion=$(echo "$instruccion" | awk '{print $1}')
        ruta=$(echo "$instruccion" | awk '{print $2}')
        permisos_o_contenido=$(echo "$instruccion" | cut -d' ' -f3-)

        # Remover las comillas alrededor del contenido, si existen
        permisos_o_contenido="${permisos_o_contenido//\"/}"  # Elimina comillas dobles

        # Verificar la validez de la instrucción
        if [[ -n "$operacion" && -n "$ruta" ]]; then
            echo "Main recibió: $instruccion - Ejecutando operación."
            procesar_instruccion "$operacion" "$ruta" "$permisos_o_contenido"
        else
            echo "Mensaje inválido o incompleto: $instruccion"
        fi
    fi
done
