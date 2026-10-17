#!/usr/bin/env bash
set -e

# =====================================================
# link-vault - script para agregar un nuevo enlace
# tags: cualquier tag personalizado (separados por coma)
# =====================================================

# determinar el workspace
WORKSPACE="${LINKS_APP_WORKSPACE:-$HOME/workspace/links_app}"
LINK_DIR="$WORKSPACE/links"

# valores por defecto
url=""
nota=""
tags=""

# leer argumentos con flags
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--url) url="$2"; shift 2 ;;
        -n|--note) nota="$2"; shift 2 ;;
        -t|--tags) tags="$2"; shift 2 ;;
        -h|--help)
            echo "uso: $0 -u <url> -n <nota> [-t <tags>]"
            echo ""
            echo "  -u, --url    URL del enlace"
            echo "  -n, --note   Nota o descripcion"
            echo "  -t, --tags   Tags separados por coma (ej: urgente,ia,trabajo)"
            echo "  -h, --help   Mostrar esta ayuda"
            echo ""
            echo "ejemplos:"
            echo "  $0 -u https://github.com -n 'Plataforma de codigo'"
            echo "  $0 -u github.com -n 'Para ver despues' -t 'ver-mas-tarde,favorito'"
            echo "  $0 https://github.com 'Plataforma' 'urgente,trabajo'"
            exit 0
            ;;
        *)
            # si no es flag, tratar como argumentos posicionales
            if [[ -z "$url" ]]; then
                url="$1"
            elif [[ -z "$nota" ]]; then
                nota="$1"
            elif [[ -z "$tags" ]]; then
                tags="$1"
            fi
            shift
            ;;
    esac
done

# validar url y nota
if [[ -z "$url" || -z "$nota" ]]; then
    echo "error: se requieren url y nota" >&2
    echo "uso: $0 -u <url> -n <nota> [-t <tags>]" >&2
    echo "usa '$0 --help' para mas informacion" >&2
    exit 1
fi

# agregar https:// si no tiene protocolo
if [[ ! "$url" =~ ^https?:// ]]; then
    url="https://$url"
fi

# normalizar tags: minusculas, sin espacios, separados por coma
if [[ -n "$tags" ]]; then
    # convertir a minusculas y limpiar
    tags_normalized=$(echo "$tags" | tr '[:upper:]' '[:lower:]' | tr -s ' ' | sed 's/^ *//;s/ *$//')
    # separar por coma, limpiar cada tag, eliminar vacios
    tags_clean=""
    IFS=',' read -ra TAG_ARRAY <<< "$tags_normalized"
    for tag in "${TAG_ARRAY[@]}"; do
        # eliminar espacios y caracteres especiales basicos
        tag=$(echo "$tag" | tr -d ' ' | sed 's/[^a-z0-9_-]//g')
        if [[ -n "$tag" ]]; then
            if [[ -z "$tags_clean" ]]; then
                tags_clean="$tag"
            else
                tags_clean="$tags_clean,$tag"
            fi
        fi
    done
    tags="$tags_clean"
fi

# obtener fecha y hora
fecha=$(date +%F)   # 2026-08-28
base=$(date +%H%M%S%N)
timestamp=$(date "+%Y-%m-%d - %H:%M:%S")

# crear directorio por fecha
dir="$LINK_DIR/$fecha"
mkdir -p "$dir"

# crear archivo unico (nanosegundos + contador anti-colision)
file="$dir/link_$base.txt"
n=1
while [[ -e "$file" ]]; do
    file="$dir/link_${base}_$n.txt"
    n=$((n + 1))
done

# escribir contenido
{
    echo "-enlace: $url"
    echo "-nota: $nota"
    if [[ -n "$tags" ]]; then
        echo "-tags: $tags"
    fi
    echo "-fecha: $timestamp"
} > "$file"

echo "✓ enlace guardado: $file"
echo "  url:  $url"
echo "  nota: $nota"
if [[ -n "$tags" ]]; then
    echo "  tags: $tags"
fi
