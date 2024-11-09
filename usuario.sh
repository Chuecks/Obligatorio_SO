#!/bin/bash

# Definir la pipe principal y mutex
pipe="mi_pipe"
pid=$$

# Verificar que al menos se hayan pasado los primeros dos argumentos
if [ "$#" -lt 2 ] && [[ "$1" != "BLOQUEAR" && "$1" != "DESBLOQUEAR" ]]; then
    echo "Uso: $0 operación archivo [permisos/contenido]"
    echo "Ejemplos:"
    echo "  $0 CREAR archivo.txt rwx"
    echo "  $0 LEER archivo.txt"
    echo "  $0 ESCRIBIR archivo.txt 'contenido a escribir'"
    echo "  $0 ELIMINAR archivo.txt"
    echo "  $0 EJECUTAR archivo.txt"
    echo "  $0 BLOQUEAR"
    echo "  $0 DESBLOQUEAR"
    exit 1
fi

# Asignar argumentos a variables
operacion=$1
archivo=$2
tercer_parametro=$3
mensaje=""

# Crear el mensaje con el identificador
case "$operacion" in
    "CREAR")
        if [ -z "$tercer_parametro" ]; then
            echo "Error: La operación CREAR requiere permisos."
            exit 1
        fi
        permisos="$tercer_parametro"
        mensaje="$pid $operacion $archivo $permisos"
        ;;
    "ESCRIBIR")
        if [ -z "$tercer_parametro" ]; then
            echo "Error: La operación ESCRIBIR requiere contenido."
            exit 1
        fi
        contenido="$tercer_parametro"
        mensaje="$pid $operacion $archivo \"$contenido\""
        ;;
    "BLOQUEAR"|"DESBLOQUEAR")
        mensaje="$pid $operacion"
        ;;
    *)
        mensaje="$pid $operacion $archivo"
        ;;
esac

# Enviar mensaje a la pipe
echo "$mensaje" > "$pipe"
echo "Solicitud de operación enviada desde PID $pid: $mensaje"

# Leer respuestas de la pipe y filtrar por el PID
while read -r respuesta; do
    if [[ $respuesta == "$pid "* ]]; then
        echo "Respuesta de main para el proceso $pid: ${respuesta#$pid }"
        break
    fi
done < "$pipe"
