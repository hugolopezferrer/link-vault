#!/usr/bin/env bash
set -e

# =====================================================
# script para buscar enlaces por palabra clave
# =====================================================

# determinar el workspace
WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

# parametro de busqueda
query="${1:-}"

if [[ -z "$query" ]]; then
    echo "uso: $0 <palabra_clave>"
    echo "ejemplo: $0 ia"
    echo "ejemplo: $0 python tutorial"
    exit 0
fi

if [[ ! -d "$LINK_DIR" ]]; then
    echo "no hay enlaces guardados aun."
    exit 0
fi

# buscar en todos los archivos txt
echo "buscando: \"$query\""
echo "=========================================="

# usar grep con -i para no distinguir mayusculas/minusculas
resultados=$(grep -irl "$query" "$LINK_DIR"/*.txt 2>/dev/null || true)

if [[ -z "$resultados" ]]; then
    echo "no se encontraron coincidencias."
    exit 0
fi

for f in $resultados; do
    [[ -e "$f" ]] || continue
    echo "---"
    echo "archivo: $f"
    echo "---"
    # mostrar solo las lineas que coinciden
    grep -i -n "$query" "$f" || true
    echo ""
done

# total de coincidencias
total=$(echo "$resultados" | grep -c . || echo "0")
echo "total: $total archivo(s) coincidente(s)"