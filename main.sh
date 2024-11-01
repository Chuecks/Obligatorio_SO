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

# Función para leer y procesar mensajes de la pipe
control_concurrencia() {
    echo "Control de concurrencia iniciado. Esperando mensajes en $pipe..."

    while true; do
        # Leer el primer mensaje de la `pipe`
        if read -r mensaje < "$pipe"; then
            # Desbloquear el mutex para permitir una operación
            exec 200>"$mutex"
            flock 200
            echo "Main recibió: $mensaje - Permitido ejecutar operación."

            # Procesamiento de la operación
            sleep 1  # Pausa para simular procesamiento

            # Notificar y liberar el mutex
            echo "Operación completada y limpiada: $mensaje"
            flock -u 200
        fi
    done
}

# Iniciar el control de concurrencia
control_concurrencia
