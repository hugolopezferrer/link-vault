# Links App

Una app simple para guardar enlaces organizados por fecha con notas.

## Características

- **Organización por fecha**: Los enlaces se guardan en carpetas por día (YYYY-MM-DD)
- **Formato claro**: Cada enlace incluye URL y una nota
- **Fácil de usar**: Scripts de ayuda para agregar y listar enlaces

## Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/hugolopezferrer/links-app.git
cd links-app
chmod +x *.sh
```

2. Configura el workspace (opcional):
```bash
export LINKS_APP_WORKSPACE="$HOME/workspace/links_app"
```

## Uso

### Agregar un nuevo enlace
```bash
./add_link.sh "https://ejemplo.com" "Nota sobre este enlace"
```

### Listar todos los enlaces guardados
```bash
./list_links.sh
```

### Buscar enlaces por palabra clave
```bash
./search_links.sh "IA"
```

### Consultar enlaces de una fecha específica
```bash
./list_links.sh "2026-08-28"
```

## Estructura de archivos

```
links-app/
├── README.md              # Este archivo
├── add_link.sh            # Script para añadir enlaces
├── list_links.sh          # Script para listar enlaces
├── search_links.sh        # Script para buscar enlaces
└── links/                 # Carpeta principal de enlaces (se crea automáticamente)
    └── 2026-08-28/        # Subcarpetas por fecha
        └── link_HHMMSS.txt
```

## Formato de archivo de enlace

Cada archivo `.txt` dentro de las subcarpetas contiene:
```
Enlace: https://sitio.com
Nota: Comentario sobre el enlace
Fecha: 2026-08-28 - 20:28:00
```

## Licencia

MIT - Libre para usar y modificar