#!/usr/bin/env bash

source "$(dirname "$0")/utils.sh"

PAPELERA="$HOME/.basurero"
REGISTRO="$PAPELERA/.registro_borrado"

ayuda() {
    echo "Uso: $(basename "$0") <nombre_archivo>"
    echo "Recupera un archivo desde la papelera a su ubicacion original."
}

archivo_a_buscar="$1"

test "$archivo_a_buscar" || reportar_error "Indica el nombre del archivo a recuperar." ayuda
test -f "$REGISTRO" || reportar_error "No hay registros de archivos borrados." ayuda

linea_registro=$(grep "^$archivo_a_buscar|" "$REGISTRO" | tail -n 1)

if [ -z "$linea_registro" ]; then
    reportar_error "No se encontro '$archivo_a_buscar' en la papelera." ayuda
fi

ruta_original=$(echo "$linea_registro" | cut -d'|' -f2)
directorio_original=$(dirname "$ruta_original")

if [ -f "$PAPELERA/$archivo_a_buscar" ]; then
    mkdir -p "$directorio_original"
    
    mv "$PAPELERA/$archivo_a_buscar" "$ruta_original"
    
    grep -v "^$archivo_a_buscar|$ruta_original" "$REGISTRO" > "$REGISTRO.tmp" && mv "$REGISTRO.tmp" "$REGISTRO"
    
    echo "Archivo recuperado exitosamente en: $ruta_original"
else
    reportar_error "El archivo no esta fisicamente en la papelera." ayuda
fi
