#!/usr/bin/env bash
set -e

# =====================================================
# link-vault - buscar enlaces por texto o tag
# uso: search_links.sh [texto] [-t tag]
# =====================================================

WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

query=""
tag_filter=""

# leer argumentos con flags (acepta tambien posicionales: texto tag)
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tag) tag_filter="$2"; shift 2 ;;
        -h|--help)
            echo "uso: $0 [texto] [-t <tag>]"
            echo ""
            echo "  texto          Buscar en url, nota o tags (insensible a mayusculas)"
            echo "  -t, --tag      Filtrar por tag exacto"
            echo "  -h, --help     Mostrar esta ayuda"
            echo ""
            echo "ejemplos:"
            echo "  $0 github                # buscar 'github' en url, nota o tags"
            echo "  $0 -t urgente            # solo por tag"
            echo "  $0 tutorial -t ia        # texto + tag"
            exit 0
            ;;
        -*)
            echo "opcion desconocida: $1" >&2
            echo "usa '$0 --help' para mas informacion" >&2
            exit 1
            ;;
        *)
            if [[ -z "$query" ]]; then
                query="$1"
            elif [[ -z "$tag_filter" ]]; then
                tag_filter="$1"
            fi
            shift
            ;;
    esac
done

if [[ -z "$query" && -z "$tag_filter" ]]; then
    echo "uso: $0 [texto] [-t <tag>]"
    echo "usa '$0 --help' para mas informacion"
    exit 0
fi

if [[ ! -d "$LINK_DIR" ]]; then
    echo "no hay enlaces guardados aun."
    exit 0
fi

echo "🔍 buscando: \"$query\" ${tag_filter:+tag: \"$tag_filter\"}"
echo "=========================================="

found=0
for f in $(find "$LINK_DIR" -name "*.txt" -type f 2>/dev/null | sort -r); do
    match=false

    # buscar texto en archivo
    if [[ -n "$query" ]]; then
        if grep -qi "$query" "$f" 2>/dev/null; then
            match=true
        fi
    fi

    # filtrar por tag si se especifico
    if [[ -n "$tag_filter" && "$match" == true ]]; then
        ftags=$(grep "^-tags:" "$f" 2>/dev/null | sed 's/^-tags: *//')
        if [[ -z "$ftags" ]] || [[ ",$ftags," != *",$tag_filter,"* ]]; then
            match=false
        fi
    elif [[ -z "$query" && -n "$tag_filter" ]]; then
        # solo tag, sin texto
        ftags=$(grep "^-tags:" "$f" 2>/dev/null | sed 's/^-tags: *//')
        if [[ -n "$ftags" ]] && [[ ",$ftags," == *",$tag_filter,"* ]]; then
            match=true
        fi
    fi

    if [[ "$match" == true ]]; then
        found=$((found + 1))
        fdate=$(basename "$(dirname "$f")")
        echo ""
        echo "--- resultado $found ---"
        echo "  📅 fecha: $fdate"
        echo "  🔗 url:   $(grep '^-enlace:' "$f" | sed 's/^-enlace: *//')"
        echo "  📝 nota:  $(grep '^-nota:' "$f" | sed 's/^-nota: *//')"
        ftags=$(grep "^-tags:" "$f" 2>/dev/null | sed 's/^-tags: *//')
        if [[ -n "$ftags" ]]; then
            echo "  🏷️  tags: $ftags"
        fi
    fi
done

echo ""
echo "=========================================="
if [[ $found -eq 0 ]]; then
    echo "❌ no se encontraron coincidencias."
else
    echo "✓ $found enlace(s) coincidente(s)"
fi
