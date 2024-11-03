#!/bin/bash

# Definir la pipe
pipe="mi_pipe"

# Verificar que al menos se hayan pasado los primeros dos argumentos (operación y ruta)
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 operación ruta [permisos/contenido]"
    echo "Ejemplos:"
    echo "  $0 CREAR ruta/ archivo.txt rwx"
    echo "  $0 LEER ruta/archivo.txt"
    echo "  $0 ESCRIBIR ruta/archivo.txt 'contenido a escribir'"
    echo "  $0 ELIMINAR ruta/archivo.txt"
    echo "  $0 CREAR_DIR ruta/nuevo_directorio/"
    echo "  $0 ELIMINAR_DIR ruta/nuevo_directorio/"
    exit 1
fi

# Asignar argumentos a variables
operacion=$1
ruta=$2
tercer_parametro=$3   # Puede ser permisos o contenido
mensaje=""

# Construir la ruta completa
ruta_completa="./filesystem/$ruta"

# Adaptar según la operación
case "$operacion" in
    "CREAR")
        if [ -z "$tercer_parametro" ]; then
            echo "Error: La operación CREAR requiere especificar permisos."
            exit 1
        fi
        permisos="$tercer_parametro"
        mensaje="$operacion $ruta_completa $permisos"
        ;;
    "ESCRIBIR")
        if [ -z "$tercer_parametro" ]; then
            echo "Error: La operación ESCRIBIR requiere contenido para escribir."
            exit 1
        fi
        contenido="$tercer_parametro"
        mensaje="$operacion $ruta_completa \"$contenido\""
        ;;
    "LEER" | "ELIMINAR" | "EJECUTAR")
        mensaje="$operacion $ruta_completa"
        ;;
    "CREAR_DIR" | "ELIMINAR_DIR")
        # CREAR_DIR y ELIMINAR_DIR solo requieren la ruta
        mensaje="$operacion $ruta_completa"
        ;;
    *)
        echo "Operación inválida: $operacion"
        exit 1
        ;;
esac

# Enviar mensaje a la pipe
echo "$mensaje" > "$pipe"
echo "Solicitud de operación enviada: $mensaje"
