#!/bin/bash

# Borrar todos los archivos de la carpeta filesystem
rm -rf filesystem/*

# Vaciar el contenido de operaciones.log
> operaciones.log

# Borrar el pipe si existe
if [ -p "mi_pipe" ]; then
    rm mi_pipe
fi

# Borrar el pipe si existe
if [ -p "pipe_myfile.txt" ]; then
    rm pipe_myfile.txt
fi

echo "Reset completo: todos los archivos de filesystem han sido borrados, operaciones.log ha sido vaciado y mi_pipe ha sido eliminado."
