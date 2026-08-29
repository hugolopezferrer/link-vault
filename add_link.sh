#!/usr/bin/env bash
set -e

# =====================================================
# script para agregar nuevo enlace a la app de enlaces
# =====================================================

# determinar el workspace
WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

url=""
nota=""

# leer argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--url) url="$2"; shift 2 ;;
        -n|--note) nota="$2"; shift 2 ;;
        -h|--help)
            echo "uso: $0 -u <url> -n <nota>"
            echo "  o:  $0 <url> <nota>"
            exit 0
            ;;
        *) break ;;
    esac
done

# si no se pasaron argumentos, leer de linea de comandos
if [[ -z "$url" || -z "$nota" ]]; then
    if [[ $# -eq 2 ]]; then
        url="${1:-}"
        nota="${2:-}"
    fi
fi

# validar que se recibieron url y nota
if [[ -z "$url" || -z "$nota" ]]; then
    echo "error: se requiere url y nota" >&2
    echo "uso: $0 -u <url> -n <nota>" >&2
    echo "  o:  $0 <url> <nota>" >&2
    exit 1
fi

# validar formato url basico
if [[ ! "$url" =~ ^https?:// ]]; then
    echo "error: la url debe comenzar con http:// o https://" >&2
    exit 1
fi

# obtener fecha y hora actuales
fecha=$(date +%F)   # 2026-08-28
hora=$(date +%H%M%S)
timestamp=$(date "+%Y-%m-%d - %H:%M:%S")

# crear directorio por fecha
dir="$LINK_DIR/$fecha"
mkdir -p "$dir"

# crear archivo unico por hora+minuto+segundo
file="$dir/link_$hora.txt"

# escribir contenido
cat > "$file" << EOF
Enlace: $url
Nota: $nota
Fecha: $timestamp
EOF

echo "enlace guardado: $file"
echo "  url: $url"
echo "  nota: $nota"
