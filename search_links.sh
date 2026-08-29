#!/usr/bin/env bash
set -e

# =====================================================
# Script para buscar enlaces por palabra clave o tag
# =====================================================

# Determinar el workspace
WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Función para mostrar ayuda
mostrar_ayuda() {
    echo -e "${GREEN}Uso:${NC} $0 [OPCIONES] <query>"
    echo ""
    echo "Opciones:"
    echo "  -t, --tag <tag>           Buscar por tag específico"
    echo "  -u, --url <texto>         Buscar en URLs"
    echo "  -n, --note <texto>        Buscar en notas"
    echo "  -h, --help                Mostrar esta ayuda"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0 'ia'                    # Buscar 'ia' en todos los campos"
    echo "  $0 -t urgente              # Buscar por tag"
    echo "  $0 -n tutorial             # Buscar en notas"
    echo "  $0 -u github               # Buscar en URLs"
    exit 0
}

# Verificar que existe el directorio
if [[ ! -d "$LINK_DIR" ]]; then
    echo -e "${RED}No hay enlaces guardados aún.${NC}"
    exit 0
fi

# Variables
modo=""
query=""

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tag) modo="tag"; shift ;;
        -u|--url) modo="url"; shift ;;
        -n|--note) modo="note"; shift ;;
        -h|--help) mostrar_ayuda ;;
        *) query="$1"; shift ;;
    esac
done

# Si no hay query, mostrar ayuda
if [[ -z "$query" ]]; then
    mostrar_ayuda
fi

# Función para mostrar un enlace formateado
mostrar_enlace() {
    local archivo="$1"
    
    url=$(grep "^Enlace:" "$archivo" | cut -d' ' -f2-)
    nota=$(grep "^Nota:" "$archivo" | cut -d' ' -f2-)
    tags=$(grep "^Tags:" "$archivo" | cut -d' ' -f2-)
    fecha=$(grep "^Fecha:" "$archivo" | cut -d' ' -f2-)
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📎 ${NC}$url"
    echo -e "${GREEN}📝 ${NC}$nota"
    
    if [[ -n "$tags" ]]; then
        echo -ne "${YELLOW}🏷️  ${NC}"
        IFS=',' read -ra ARRAY_TAGS <<< "$tags"
        for t in "${ARRAY_TAGS[@]}"; do
            echo -ne " [$t]"
        done
        echo ""
    fi
    
    echo -e "${NC}📅 $fecha"
}

# Si se busca por tag
if [[ "$modo" == "tag" ]]; then
    tag_query=$(echo "$query" | tr '[:upper:]' '[:lower:]')
    echo -e "${GREEN}🔍 Buscando tag: ${YELLOW}$tag_query${NC}"
    echo ""
    
    encontrados=false
    while IFS= read -r archivo; do
        tags=$(grep "^Tags:" "$archivo" 2>/dev/null | cut -d' ' -f2-)
        if echo "$tags" | grep -qi "$tag_query"; then
            mostrar_enlace "$archivo"
            encontrados=true
        fi
    done < <(find "$LINK_DIR" -name "*.txt" -type f | sort -r)
    
    if ! $encontrados; then
        echo -e "${RED}No se encontraron enlaces con el tag: $tag_query${NC}"
    fi
    exit 0
fi

# Si se busca por URL
if [[ "$modo" == "url" ]]; then
    echo -e "${GREEN}🔍 Buscando en URLs: ${YELLOW}$query${NC}"
    echo ""
    
    encontrados=false
    while IFS= read -r archivo; do
        url=$(grep "^Enlace:" "$archivo" | cut -d' ' -f2-)
        if echo "$url" | grep -qi "$query"; then
            mostrar_enlace "$archivo"
            encontrados=true
        fi
    done < <(find "$LINK_DIR" -name "*.txt" -type f | sort -r)
    
    if ! $encontrados; then
        echo -e "${RED}No se encontraron enlaces con '$query' en la URL${NC}"
    fi
    exit 0
fi

# Si se busca por nota
if [[ "$modo" == "note" ]]; then
    echo -e "${GREEN}🔍 Buscando en notas: ${YELLOW}$query${NC}"
    echo ""
    
    encontrados=false
    while IFS= read -r archivo; do
        nota=$(grep "^Nota:" "$archivo" | cut -d' ' -f2-)
        if echo "$nota" | grep -qi "$query"; then
            mostrar_enlace "$archivo"
            encontrados=true
        fi
    done < <(find "$LINK_DIR" -name "*.txt" -type f | sort -r)
    
    if ! $encontrados; then
        echo -e "${RED}No se encontraron enlaces con '$query' en la nota${NC}"
    fi
    exit 0
fi

# Búsqueda general (en todos los campos)
echo -e "${GREEN}🔍 Buscando: ${YELLOW}$query${NC}"
echo ""

encontrados=false
while IFS= read -r archivo; do
    if grep -qi "$query" "$archivo" 2>/dev/null; then
        mostrar_enlace "$archivo"
        encontrados=true
    fi
done < <(find "$LINK_DIR" -name "*.txt" -type f | sort -r)

if ! $encontrados; then
    echo -e "${RED}No se encontraron enlaces con '$query'${NC}"
    echo ""
    echo "Sugerencias:"
    echo "  $0 -t <tag>    # Buscar por tag"
    echo "  $0 -u <texto>  # Buscar en URL"
    echo "  $0 -n <texto>  # Buscar en nota"
fi
