#!/usr/bin/env bash
set -e

# =====================================================
# Script para agregar un nuevo enlace a la app de enlaces
# Soporta tags para organizar los enlaces
# =====================================================

# Determinar el workspace
WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Tags predefinidos
TAGS_PREDIFINIDOS=("ver-mas-tarde" "revisar" "compartir" "desarrollar" "urgente" "referencia" "favorito")

# Función para mostrar ayuda
mostrar_ayuda() {
    echo -e "${GREEN}Uso:${NC} $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  -u, --url <url>          URL del enlace (requerido)"
    echo "  -n, --note <nota>        Nota descriptiva (requerido)"
    echo "  -t, --tags <tags>        Tags separados por coma (opcional)"
    echo "  -h, --help               Mostrar esta ayuda"
    echo ""
    echo -e "${YELLOW}Tags predefinidos:${NC}"
    echo "  ver-mas-tarde, revisar, compartir, desarrollar, urgente, referencia, favorito"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0 -u https://ejemplo.com -n 'Artículo sobre IA' -t 'ver-mas-tarde,desarrollar'"
    echo "  $0 'https://github.com' 'Repositorio útil' 'favorito,referencia'"
    exit 0
}

# Variables
url=""
nota=""
tags=""

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--url) url="$2"; shift 2 ;;
        -n|--note) nota="$2"; shift 2 ;;
        -t|--tags) tags="$2"; shift 2 ;;
        -h|--help) mostrar_ayuda ;;
        *) break ;;
    esac
done

# Si no se pasaron argumentos con flags, leer argumentos posicionales
if [[ -z "$url" || -z "$nota" ]]; then
    if [[ $# -ge 2 ]]; then
        url="${1:-}"
        nota="${2:-}"
        tags="${3:-}"
    fi
fi

# Validar que se recibieron url y nota
if [[ -z "$url" || -z "$nota" ]]; then
    echo -e "${RED}Error: se requiere url y nota${NC}" >&2
    echo "Uso: $0 -u <url> -n <nota> [-t <tags>]" >&2
    echo "  o:  $0 <url> <nota> [tags]" >&2
    echo "  o:  $0 --help" >&2
    exit 1
fi

# Agregar https:// si no tiene protocolo
if [[ ! "$url" =~ ^https?:// ]]; then
    url="https://$url"
    echo -e "${YELLOW}→ Se agregó https:// automáticamente${NC}"
fi

# Escapar caracteres especiales para regex
url_escaped=$(echo "$url" | sed 's/[[\/.*^$]/\\&/g')

# Validar formato URL básico
if [[ ! "$url" =~ ^https?:// ]]; then
    echo -e "${RED}Error: URL inválida${NC}" >&2
    exit 1
fi

# Obtener fecha y hora actuales
fecha=$(date +%F)   # 2026-08-28
hora=$(date +%H%M%S)
timestamp=$(date "+%Y-%m-%d - %H:%M:%S")

# Crear directorio por fecha
dir="$LINK_DIR/$fecha"
mkdir -p "$dir"

# Crear archivo único por hora+minuto+segundo
file="$dir/link_${hora}.txt"

# Escribir contenido con tags si existen
if [[ -n "$tags" ]]; then
    # Normalizar tags: reemplazar espacios por guiones, minúsculas
    tags_normalized=$(echo "$tags" | sed 's/, /,/g' | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    cat > "$file" << EOF
Enlace: $url
Nota: $nota
Tags: $tags_normalized
Fecha: $timestamp
EOF
else
    cat > "$file" << EOF
Enlace: $url
Nota: $nota
Fecha: $timestamp
EOF
fi

echo ""
echo -e "${GREEN}✓ Enlace guardado:${NC} $file"
echo -e "  URL:   $url"
echo -e "  Nota:  $nota"
if [[ -n "$tags_normalized" ]]; then
    echo -e "  Tags:  $tags_normalized"
fi
