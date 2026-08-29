#!/usr/bin/env bash
set -e

# =====================================================
# Script para agregar nuevo enlace a la app de enlaces
# =====================================================

# Determinar el workspace
WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

url=""
nota=""

# Leer argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--url) url="$2"; shift 2 ;;
        -n|--note) nota="$2"; shift 2 ;;
        -h|--help)
            echo "Uso: $0 -u <url> -n <nota>"
            echo "  O:  $0 <url> <nota>"
            echo ""
            echo "Si la URL no incluye http:// o https://, se agregará https:// automáticamente"
            exit 0
            ;;
        *) break ;;
    esac
done

# Si no se pasaron argumentos con flags, leer de linea de comandos
if [[ -z "$url" || -z "$nota" ]]; then
    if [[ $# -eq 2 ]]; then
        url="${1:-}"
        nota="${2:-}"
    fi
fi

# Validar que se recibieron url y nota
if [[ -z "$url" || -z "$nota" ]]; then
    echo "Error: se requiere URL y nota" >&2
    echo "Uso: $0 -u <url> -n <nota>" >&2
    echo "  O:  $0 <url> <nota>" >&2
    exit 1
fi

# Agregar https:// si no tiene protocolo
if [[ ! "$url" =~ ^https?:// ]]; then
    url="https://$url"
fi

# Obtener fecha y hora actuales
fecha=$(date +%F)   # 2026-08-28
hora=$(date +%H%M%S)
timestamp=$(date "+%Y-%m-%d - %H:%M:%S")

# Crear directorio por fecha
dir="$LINK_DIR/$fecha"
mkdir -p "$dir"

# Crear archivo unico por hora+minuto+segundo
file="$dir/link_$hora.txt"

# Escribir contenido
cat > "$file" << EOF
-enlace: $url
-nota: $nota
-fecha: $timestamp
EOF

echo "Enlace guardado: $file"
echo "  URL: $url"
echo "  Nota: $nota"
