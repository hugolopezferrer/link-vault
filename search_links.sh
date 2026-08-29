#!/usr/bin/env bash
set -e

# =====================================================
# links-app - buscar enlaces por texto o tag
# uso: search_links.sh <texto_o_tag> [-t tag]
# =====================================================

WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

query="${1:-}"
tag_filter="${2:-}"

if [[ -z "$query" && -z "$tag_filter" ]]; then
    echo "uso: $0 <texto> [-t <tag>]"
    echo ""
    echo "ejemplos:"
    echo "  $0 github                # buscar 'github' en url, nota o tags"
    echo "  $0 -t urgente            # buscar por tag especifico"
    echo "  $0 tutorial -t ia        # texto + tag"
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
