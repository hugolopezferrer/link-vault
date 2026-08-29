# Links App 🔗

Una app simple para guardar enlaces organizados por fecha con notas y **tags** para clasificación.

## ✨ Características

- 📅 **Organización por fecha**: Los enlaces se guardan en carpetas por día (YYYY-MM-DD)
- 🏷️ **Sistema de tags**: Clasifica tus enlaces con tags personalizables
- 🔍 **Búsqueda avanzada**: Filtra por texto, URL, nota o tag
- 🌐 **Interfaz web**: Gestiona tus enlaces visualmente
- 💾 **Backup automático**: Todo se guarda en archivos de texto plano
- 🔗 **Auto-https**: Agrega automáticamente `https://` si falta en la URL

## 🏷️ Tags Predefinidos

| Tag | Descripción | Color |
|-----|-------------|-------|
| `ver-mas-tarde` | Para revisar después | 🔴 Rojo |
| `revisar` | Pendiente de revisar | 🟡 Amarillo |
| `compartir` | Para enviar a otros | 🟢 Verde |
| `desarrollar` | Para desarrollar ideas | 🔵 Azul |
| `urgente` | Importante, prioridad alta | 🔴 Rojo |
| `referencia` | Material de consulta | 🟣 Morado |
| `favorito` | Marcado como favorito | 🌸 Rosa |

## 📦 Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/hugolopezferrer/links-app.git
cd links-app

# 2. Hacer ejecutables los scripts
chmod +x *.sh

# 3. (Opcional) Configurar workspace personalizado
export LINKS_APP_WORKSPACE="$HOME/workspace/links_app"
```

## 🚀 Uso desde la línea de comandos

### Agregar un nuevo enlace

```bash
# Con flags (recomendado)
./add_link.sh -u https://github.com -n "Plataforma de código" -t "favorito,referencia"

# Con argumentos posicionales
./add_link.sh "https://google.com" "Buscador" "ver-mas-tarde"

# Sin tags
./add_link.sh -u https://example.com -n "Mi sitio favorito"
```

**Salida:**
```
✓ Enlace guardado: /home/usuario/workspace/links_app/links/2026-08-28/link_202809.txt
  URL:   https://github.com
  Nota:  Plataforma de código
  Tags:  favorito,referencia
```

### Listar enlaces

```bash
# Ver todos los enlaces
./list_links.sh

# Filtrar por fecha
./list_links.sh -d 2026-08-28

# Filtrar por tag
./list_links.sh -t ver-mas-tarde

# Ver estadísticas
./list_links.sh -s
```

**Salida de estadísticas:**
```
📊 Estadísticas
══════════════════════════════════════
Total de enlaces: 12
Días con enlaces: 3

📅 Enlaces por fecha:
  2026-08-28: 5 enlace(s)
  2026-08-27: 4 enlace(s)
  2026-08-26: 3 enlace(s)

🏷️  Enlaces por tag:
  ver-mas-tarde: 5
  favorito: 3
  referencia: 4
```

### Buscar enlaces

```bash
# Búsqueda general
./search_links.sh "tutorial"

# Solo en URLs
./search_links.sh -u github

# Solo en notas
./search_links.sh -n "machine learning"

# Solo por tag
./search_links.sh -t urgente
```

### Ver ayuda

```bash
./add_link.sh --help
./list_links.sh --help
./search_links.sh --help
```

## 🌐 Uso desde la interfaz web

```bash
# Opción 1: Abrir localmente
xdg-open index.html    # Linux
open index.html        # macOS

# Opción 2: GitHub Pages (acceso en línea)
# Visita: https://hugolopezferrer.github.io/links-app/
```

La interfaz web incluye:
- 📊 Estadísticas en tiempo real
- ➕ Formulario con selector visual de tags
- 🔍 Búsqueda en vivo
- 🎯 Filtros por tag
- 🗑️ Eliminar enlaces
- 💾 Guardado automático en localStorage

## 📁 Estructura de archivos

```
links-app/
├── README.md               # Este archivo
├── add_link.sh             # Script para añadir enlaces
├── list_links.sh           # Script para listar/buscar por tag/fecha
├── search_links.sh         # Script para búsqueda
├── index.html              # Interfaz web
└── links/                  # Carpeta principal (se crea automáticamente)
    └── 2026-08-28/         # Subcarpetas por fecha
        ├── link_202809.txt
        └── link_202830.txt
```

## 📄 Formato de archivo de enlace

Cada archivo `.txt` contiene:

```
Enlace: https://ejemplo.com
Nota: Artículo interesante sobre IA
Tags: ver-mas-tarde,desarrollar,favorito
Fecha: 2026-08-28 - 20:28:00
```

## 🛠️ Configuración avanzada

### Cambiar el directorio de trabajo

```bash
# Temporal (solo esta sesión)
export LINKS_APP_WORKSPACE="/ruta/personalizada/links_app"

# Permanente (agregar a ~/.bashrc o ~/.zshrc)
echo 'export LINKS_APP_WORKSPACE="$HOME/Documents/links_app"' >> ~/.bashrc
```

### Agregar nuevos tags personalizados

Edita el array `TAGS_PREDIFINIDOS` en `add_link.sh` y agrega los iconos correspondientes en `index.html` (función `getTagIcon`).

## 🤝 Contribuir

1. Haz fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📝 Licencia

MIT - Libre para usar y modificar
