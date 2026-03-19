reportar_error() {
    local mensaje="$1"
    local fun_ayuda="$2"
    echo "$mensaje" >&2
    "$fun_ayuda"
    exit 1    
}
