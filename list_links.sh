#!/usr/bin/env bash
set -e

# =====================================================
# Script para listar enlaces guardados
# Soporta filtrado por fecha y tags
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
    echo -e "${GREEN}Uso:${NC} $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  -d, --date <YYYY-MM-DD>   Filtrar por fecha específica"
    echo "  -t, --tag <tag>            Filtrar por tag específico"
    echo "  -a, --all                  Mostrar todos los enlaces (default)"
    echo "  -s, --stats                Mostrar estadísticas"
    echo "  -h, --help                 Mostrar esta ayuda"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0                        # Ver todos los enlaces"
    echo "  $0 -d 2026-08-28          # Ver enlaces de una fecha"
    echo "  $0 -t ver-mas-tarde       # Ver enlaces con tag específico"
    echo "  $0 -s                     # Ver estadísticas"
    exit 0
}

# Función para extraer tags de un archivo
obtener_tags() {
    local archivo="$1"
    grep "^Tags:" "$archivo" 2>/dev/null | cut -d' ' -f2-
}

# Función para mostrar un enlace formateado
mostrar_enlace() {
    local archivo="$1"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Extraer datos
    url=$(grep "^Enlace:" "$archivo" | cut -d' ' -f2-)
    nota=$(grep "^Nota:" "$archivo" | cut -d' ' -f2-)
    tags=$(grep "^Tags:" "$archivo" | cut -d' ' -f2-)
    fecha=$(grep "^Fecha:" "$archivo" | cut -d' ' -f2-)
    
    # Mostrar datos
    echo -e "${BLUE}📎 URL:${NC} $url"
    echo -e "${GREEN}📝 Nota:${NC} $nota"
    
    # Mostrar tags con colores
    if [[ -n "$tags" ]]; then
        echo -ne "${YELLOW}🏷️  Tags:${NC} "
        IFS=',' read -ra ARRAY_TAGS <<< "$tags"
        for t in "${ARRAY_TAGS[@]}"; do
            case "$t" in
                ver-mas-tarde)  echo -ne " ${RED}[$t]${NC}" ;;
                revisar)        echo -ne " ${YELLOW}[$t]${NC}" ;;
                compartir)      echo -ne " ${GREEN}[$t]${NC}" ;;
                desarrollar)    echo -ne " ${BLUE}[$t]${NC}" ;;
                urgente)        echo -ne " ${RED}[$t]${NC}" ;;
                referencia)     echo -ne " ${CYAN}[$t]${NC}" ;;
                favorito)       echo -ne " ${YELLOW}[$t]${NC}" ;;
                *)              echo -ne " [$t]" ;;
            esac
        done
        echo ""
    fi
    
    echo -e "${NC}📅 $fecha"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Función para mostrar estadísticas
mostrar_estadisticas() {
    echo ""
    echo -e "${GREEN}📊 Estadísticas${NC}"
    echo -e "${CYAN}══════════════════════════════════════${NC}"
    
    if [[ ! -d "$LINK_DIR" ]]; then
        echo "No hay enlaces guardados aún."
        return
    fi
    
    # Total de enlaces
    total=$(find "$LINK_DIR" -name "*.txt" -type f | wc -l)
    echo -e "Total de enlaces: ${YELLOW}$total${NC}"
    
    # Total de días
    dias=$(find "$LINK_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
    echo -e "Días con enlaces: ${YELLOW}$dias${NC}"
    
    echo ""
    echo -e "${GREEN}📅 Enlaces por fecha:${NC}"
    for dir in $(find "$LINK_DIR" -mindepth 1 -maxdepth 1 -type d -name "*-*-*" | sort -r); do
        fecha=$(basename "$dir")
        count=$(find "$dir" -name "*.txt" -type f | wc -l)
        echo "  $fecha: $count enlace(s)"
    done
    
    echo ""
    echo -e "${GREEN}🏷️  Enlaces por tag:${NC}"
    tags_totales=$(grep -rh "^Tags:" "$LINK_DIR" 2>/dev/null | cut -d' ' -f2- | tr ',' '\n' | grep -v "^$" | sort | uniq -c | sort -rn)
    if [[ -n "$tags_totales" ]]; then
        echo "$tags_totales" | while read count tag; do
            echo "  $tag: $count"
        done
    else
        echo "  (sin tags)"
    fi
}

# Variables
fecha_filtro=""
tag_filtro=""
mostrar_todo=false
modo_stats=false

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--date) fecha_filtro="$2"; shift 2 ;;
        -t|--tag) tag_filtro="$2"; shift 2 ;;
        -a|--all) mostrar_todo=true; shift ;;
        -s|--stats) modo_stats=true; shift ;;
        -h|--help) mostrar_ayuda ;;
        *) shift ;;
    esac
done

# Modo estadísticas
if $modo_stats; then
    mostrar_estadisticas
    exit 0
fi

# Verificar que existe el directorio
if [[ ! -d "$LINK_DIR" ]]; then
    echo -e "${RED}No hay enlaces guardados aún.${NC}"
    echo "Usa add_link.sh para agregar tu primer enlace."
    exit 0
fi

# Si se filtró por tag
if [[ -n "$tag_filtro" ]]; then
    tag_filtro=$(echo "$tag_filtro" | tr '[:upper:]' '[:lower:]')
    echo -e "${GREEN}🔍 Buscando enlaces con tag: ${YELLOW}$tag_filtro${NC}"
    echo ""
    
    encontrados=false
    while IFS= read -r archivo; do
        tags=$(obtener_tags "$archivo")
        if echo "$tags" | grep -qi "$tag_filtro"; then
            mostrar_enlace "$archivo"
            encontrados=true
        fi
    done < <(find "$LINK_DIR" -name "*.txt" -type f | sort -r)
    
    if ! $encontrados; then
        echo -e "${RED}No se encontraron enlaces con el tag: $tag_filtro${NC}"
    fi
    exit 0
fi

# Si se filtró por fecha
if [[ -n "$fecha_filtro" ]]; then
    dir="$LINK_DIR/$fecha_filtro"
    if [[ -d "$dir" ]]; then
        echo -e "${GREEN}📅 Enlaces del: ${YELLOW}$fecha_filtro${NC}"
        echo ""
        for archivo in $(find "$dir" -name "*.txt" -type f | sort -r); do
            mostrar_enlace "$archivo"
        done
    else
        echo -e "${RED}No hay enlaces para la fecha: $fecha_filtro${NC}"
        echo ""
        echo "Fechas disponibles:"
        find "$LINK_DIR" -mindepth 1 -maxdepth 1 -type d -name "*-*-*" | xargs -n1 basename | sort -r | head -5
    fi
    exit 0
fi

# Mostrar todos los enlaces
echo -e "${GREEN}📋 Todos los enlaces guardados${NC}"
echo ""

encontrados=false
for dir in $(find "$LINK_DIR" -mindepth 1 -maxdepth 1 -type d -name "*-*-*" | sort -r); do
    fecha=$(basename "$dir")
    archivos=$(find "$dir" -name "*.txt" -type f | sort -r)
    
    if [[ -n "$archivos" ]]; then
        echo -e "${YELLOW}━━━ $fecha ━━━${NC}"
        for archivo in $archivos; do
            mostrar_enlace "$archivo"
        done
        encontrados=true
    fi
done

if ! $encontrados; then
    echo -e "${RED}No hay enlaces guardados.${NC}"
    echo "Usa: add_link.sh -u <url> -n <nota> [-t <tags>]"
fi

echo ""
echo -e "${CYAN}Para filtrar por fecha:  $0 -d YYYY-MM-DD${NC}"
echo -e "${CYAN}Para filtrar por tag:    $0 -t ver-mas-tarde${NC}"
echo -e "${CYAN}Para ver estadísticas:   $0 -s${NC}"
