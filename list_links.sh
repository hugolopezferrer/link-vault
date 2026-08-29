#!/usr/bin/env bash
set -e

# =====================================================
# script para listar enlaces guardados
# =====================================================

# determinar el workspace
WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

# parametro opcional: fecha especifica (YYYY-MM-DD)
fecha_filtrar="${1:-}"

if [[ ! -d "$LINK_DIR" ]]; then
    echo "no hay enlaces guardados aun."
    echo "crea tu primera carpeta de enlaces con ./add_link.sh"
    exit 0
fi

# si se especifico fecha, solo mostrar ese dia
if [[ -n "$fecha_filtrar" ]]; then
    dir="$LINK_DIR/$fecha_filtrar"
    if [[ -d "$dir" ]]; then
        echo "enlaces de: $fecha_filtrar"
        echo "================================"
        for f in "$dir"/*.txt; do
            [[ -e "$f" ]] || continue
            echo "--- $f ---"
            cat "$f"
            echo ""
        done
    else
        echo "no hay enlaces para la fecha: $fecha_filtrar"
        echo "fechas disponibles:"
        ls -1 "$LINK_DIR" | sort -r | head -10
    fi
    exit 0
fi

# listar todas las fechas con enlaces
echo "resumen de enlaces guardados"
echo "============================"

for dir in "$LINK_DIR"/*; do
    [[ -d "$dir" ]] || continue
    fecha=$(basename "$dir")
    count=$(find "$dir" -name "*.txt" -type f | wc -l)
    echo "- $fecha: $count enlace(s)"
done | sort -t' ' -k2 -r

echo ""
echo "para ver una fecha completa: $0 <YYYY-MM-DD>"
echo "ejemplo: $0 2026-08-28"