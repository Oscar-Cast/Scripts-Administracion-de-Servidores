#!/usr/bin/bash

source "$(dirname "$0")/utils.sh"

PAPELERA="$HOME/.basurero"

ayuda() {
    echo "Uso: $(basename "$0") <archivo>"
    echo "Mueve el archivo a la papelera local para su posterior recuperacion."
}

if [ ! -d "$PAPELERA" ]; then
    mkdir -p "$PAPELERA"
fi

archivo="$1"

test "$archivo" || reportar_error "Debes especificar un archivo." ayuda
test -e "$archivo" || reportar_error "El archivo '$archivo' no existe." ayuda

nombre_base=$(basename "$archivo")
ruta_absoluta=$(realpath "$archivo")

echo "$nombre_base|$ruta_absoluta" >> "$PAPELERA/.registro_borrado"

mv "$archivo" "$PAPELERA/"

echo "Archivo '$nombre_base' movido a la papelera ($PAPELERA)."
