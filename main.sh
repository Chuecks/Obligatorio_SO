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
        local permisos_contenido=$4

        # Verificar si el sistema está bloqueado
        if [ -f "$mutex" ] && [[ "$operacion" != "DESBLOQUEAR" ]]; then
            echo "$pid Error: El sistema está bloqueado. Desbloquéalo antes de realizar otras operaciones." > "$pipe"
            return
        fi

        # Ejecutar la operación solicitada
        case "$operacion" in
        
        "CREAR")
                if [ -n "$permisos_contenido" ]; then
                    mensaje=$(./operaciones_archivos/crea_un_archivo.sh "$archivo" "$permisos_contenido")
                    echo "$pid $mensaje" > "$pipe"
                else
                    echo "$pid Error: La operación CREAR requiere permisos." > "$pipe"
                fi
                ;;

            "LEER")
                mensaje=$(./operaciones_archivos/leer_un_archivo.sh "$archivo")
                echo "$pid $mensaje" > "$pipe"
                ;;

            "ESCRIBIR")
                if [ -n "$permisos_contenido" ]; then
                    mensaje=$(./operaciones_archivos/escribir_en_un_archivo.sh "$archivo" "$permisos_contenido")
                    echo "$pid $mensaje" > "$pipe"
                else
                    echo "$pid Error: La operación ESCRIBIR requiere contenido." > "$pipe"
                fi
                ;;

            "ELIMINAR")
                mensaje=$(./operaciones_archivos/eliminar_un_archivo.sh "$archivo")
                echo "$pid $mensaje" > "$pipe"
                ;;

            "EJECUTAR")
                mensaje=$(./operaciones_archivos/ejecutar_un_archivo.sh "$archivo")
                echo "$pid $mensaje" > "$pipe"
                ;;
            
            "CREAR_DIR")
                mensaje=$(./operaciones_directorios/crear_un_directorio.sh "$archivo")
                echo "$pid $mensaje" > "$pipe"
                ;;
            
            "ELIMINAR_DIR")
                mensaje=$(./operaciones_directorios/eliminar_un_directorio.sh "$archivo")
                echo "$pid $mensaje" > "$pipe"
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
            permisos_contenido=$(echo "$instruccion" | awk '{print $4}')

            echo "Main recibió: $instruccion - Ejecutando operación."

            # Procesar la instrucción
            procesar_instruccion "$pid" "$operacion" "$archivo" "$permisos_contenido" 
        fi
    done
