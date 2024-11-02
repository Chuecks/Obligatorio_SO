#!/bin/bash

# Definir la pipe
pipe="mi_pipe"

# Verificar que al menos se hayan pasado los primeros dos argumentos
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 operación archivo [permisos/contenido]"
    echo "Ejemplos:"
    echo "  $0 CREAR archivo.txt rwx"
    echo "  $0 LEER archivo.txt"
    echo "  $0 ESCRIBIR archivo.txt 'contenido a escribir'"
    echo "  $0 ELIMINAR archivo.txt"
    echo "  $0 EJECUTAR archivo.txt"
    exit 1
fi

# Asignar argumentos a variables
operacion=$1
archivo=$2
tercer_parametro=$3   # Puede ser permisos o contenido
mensaje=""

# Adaptar según la operación
case "$operacion" in
    "CREAR")
        if [ -z "$tercer_parametro" ]; then
            echo "Error: La operación CREAR requiere especificar permisos."
            exit 1
        fi
        permisos="$tercer_parametro"
        mensaje="$operacion $archivo $permisos"
        ;;
    "ESCRIBIR")
        if [ -z "$tercer_parametro" ]; then
            echo "Error: La operación ESCRIBIR requiere contenido para escribir."
            exit 1
        fi
        contenido="$tercer_parametro"
        mensaje="$operacion $archivo \"$contenido\""
        ;;
    *)
        # Para LEER, ELIMINAR, y EJECUTAR, solo operacion y archivo son necesarios
        mensaje="$operacion $archivo"
        ;;
esac

# Enviar mensaje a la pipe
echo "$mensaje" > "$pipe"
echo "Solicitud de operación enviada: $mensaje"
