#!/usr/bin/env bash
set -e

# =====================================================
# links-app - listar enlaces guardados
# uso: list_links.sh [YYYY-MM-DD] [-t tag] [-s]
# =====================================================

WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

# valores por defecto
fecha_filtrar=""
tag_filtrar=""
mostrar_stats=false

# parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tag) tag_filtrar="$2"; shift 2 ;;
        -s|--stats) mostrar_stats=true; shift ;;
        -h|--help)
            echo "uso: $0 [YYYY-MM-DD] [-t <tag>] [-s]"
            echo ""
            echo "  YYYY-MM-DD   Filtrar por fecha especifica"
            echo "  -t, --tag    Filtrar por tag"
            echo "  -s, --stats  Mostrar estadisticas"
            echo "  -h, --help   Mostrar esta ayuda"
            echo ""
            echo "ejemplos:"
            echo "  $0                    # todos los enlaces"
            echo "  $0 2026-08-28         # enlaces de hoy"
            echo "  $0 -t urgente         # enlaces con tag 'urgente'"
            echo "  $0 2026-08-28 -t ia   # combinar fecha y tag"
            echo "  $0 -s                 # ver estadisticas"
            exit 0
            ;;
        -*) echo "opcion desconocida: $1"; exit 1 ;;
        *) fecha_filtrar="$1"; shift ;;
    esac
done

# si no hay enlaces
if [[ ! -d "$LINK_DIR" ]]; then
    echo "no hay enlaces guardados aun."
    echo "ejecuta: add_link.sh -u <url> -n <nota>"
    exit 0
fi

# funcion para obtener tags de un archivo
get_tags() {
    local file="$1"
    grep "^-tags:" "$file" 2>/dev/null | sed 's/^-tags: *//'
}

# funcion para verificar si un archivo tiene un tag especifico
has_tag() {
    local file="$1"
    local target_tag="$2"
    local file_tags
    file_tags=$(get_tags "$file")
    [[ -n "$file_tags" ]] && [[ ",$file_tags," == *",$target_tag,"* ]]
}

# mostrar estadisticas
if [[ "$mostrar_stats" == true ]]; then
    echo "📊 estadisticas de links-app"
    echo "============================"
    total=0
    total_con_tags=0
    declare -A tag_count
    declare -A fecha_count

    for f in $(find "$LINK_DIR" -name "*.txt" -type f 2>/dev/null); do
        total=$((total + 1))
        ftags=$(get_tags "$f")
        if [[ -n "$ftags" ]]; then
            total_con_tags=$((total_con_tags + 1))
            IFS=',' read -ra TAGS <<< "$ftags"
            for t in "${TAGS[@]}"; do
                t=$(echo "$t" | tr -d ' ')
                if [[ -n "$t" ]]; then
                    tag_count[$t]=$((${tag_count[$t]:-0} + 1))
                fi
            done
        fi
        fdate=$(basename "$(dirname "$f")")
        fecha_count[$fdate]=$((${fecha_count[$fdate]:-0} + 1))
    done

    echo "total enlaces: $total"
    echo "con tags: $total_con_tags"
    echo "dias con enlaces: ${#fecha_count[@]}"
    echo ""
    echo "tags mas usados:"
    if [[ ${#tag_count[@]} -gt 0 ]]; then
        for t in "${!tag_count[@]}"; do
            echo "  #$t  →  ${tag_count[$t]}"
        done | sort -t'→' -k2 -nr | head -10
    else
        echo "  (ninguno)"
    fi
    echo ""
    echo "ultimos dias:"
    for d in "${!fecha_count[@]}"; do
        echo "  $d  →  ${fecha_count[$d]}"
    done | sort -r | head -7
    exit 0
fi

# filtrar archivos
files_to_show=$(find "$LINK_DIR" -name "*.txt" -type f 2>/dev/null | sort -r)

# aplicar filtro de fecha
if [[ -n "$fecha_filtrar" ]]; then
    files_to_show=$(echo "$files_to_show" | grep "/$fecha_filtrar/")
fi

# aplicar filtro de tag
if [[ -n "$tag_filtrar" ]]; then
    filtered=""
    while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        if has_tag "$f" "$tag_filtrar"; then
            filtered="$filtered$f\n"
        fi
    done <<< "$files_to_show"
    files_to_show=$(echo -e "$filtered" | grep -v '^$')
fi

# mostrar resultados
if [[ -z "$files_to_show" ]]; then
    echo "no se encontraron enlaces con esos filtros."
    exit 0
fi

count=$(echo "$files_to_show" | grep -c .)
echo "📚 $count enlace(s) encontrado(s)"
echo "================================"

# agrupar por fecha
current_date=""
while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    fdate=$(basename "$(dirname "$f")")
    if [[ "$fdate" != "$current_date" ]]; then
        if [[ -n "$current_date" ]]; then
            echo ""
        fi
        echo ""
        echo "📅 $fdate"
        echo "--------------------------------"
        current_date="$fdate"
    fi
    echo ""
    echo "  🔗 $(grep '^-enlace:' "$f" | sed 's/^-enlace: *//')"
    echo "  📝 $(grep '^-nota:' "$f" | sed 's/^-nota: *//')"
    ftags=$(get_tags "$f")
    if [[ -n "$ftags" ]]; then
        IFS=',' read -ra TAGS <<< "$ftags"
        tag_str=""
        for t in "${TAGS[@]}"; do
            t=$(echo "$t" | tr -d ' ')
            tag_str="$tag_str #$t"
        done
        echo "  🏷️  $tag_str"
    fi
done <<< "$files_to_show"
