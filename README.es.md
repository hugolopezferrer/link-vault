🇪🇸 [Español](README.es.md) | 🇺🇸 [English](README.md)

# Link Vault 🔗

![100% free](https://img.shields.io/badge/100%25_free-brightgreen) ![open source](https://img.shields.io/badge/open_source-orange) ![bash + web](https://img.shields.io/badge/bash_%2B_web-blue)

**Qué es:** una app gratuita para guardar enlaces con una nota y tags, organizados automáticamente por fecha. Tiene dos caras: tres pequeños scripts de terminal y una página web visual.

**Para quién es:** para cualquiera que pierde enlaces interesantes en historiales de chat, pestañas abiertas o capturas de pantalla. Si sabes copiar y pegar, puedes usarla.

## Qué necesitas

- Una computadora con **bash** (Linux o macOS — nada que instalar)
- Un navegador web (solo para la página visual)
- Eso es todo. Sin cuentas, sin servidores, sin bases de datos.

## Instalación

**Paso 1 — Descárgala:**

```bash
git clone https://github.com/hugolopezferrer/link-vault.git
cd link-vault
```

**Paso 2 — Haz ejecutables los scripts:**

```bash
chmod +x *.sh
```

**Paso 3 — Comprueba que funciona:**

```bash
./add_link.sh --help
```

Deberías ver las instrucciones de uso:

```
uso: ./add_link.sh -u <url> -n <nota> [-t <tags>]

  -u, --url    URL del enlace
  -n, --note   Nota o descripcion
  -t, --tags   Tags separados por coma (ej: urgente,ia,trabajo)
  -h, --help   Mostrar esta ayuda
```

Si ves eso, la instalación está lista. Nada más que configurar.

## Empieza rápido: guarda tu primer enlace

**Paso 1 — Guarda un enlace:**

```bash
./add_link.sh -u https://github.com -n "Code platform" -t "favorito,referencia"
```

Deberías ver:

```
✓ enlace guardado: /home/usuario/workspace/links_app/links/2026-08-28/link_202809123456789.txt
  url:  https://github.com
  nota:  Code platform
  tags: favorito,referencia
```

**Paso 2 — Mira todos tus enlaces:**

```bash
./list_links.sh
```

**Paso 3 — Encuéntralo después:**

```bash
./search_links.sh "github"
```

Ese es todo el ciclo: guardar → listar → buscar.

## Agregar enlaces (`add_link.sh`)

Dos formas de agregar un enlace. Con flags (recomendado, más claro):

```bash
./add_link.sh -u https://github.com -n "Code platform" -t "favorito,referencia"
```

O con argumentos posicionales (más rápido de escribir):

```bash
./add_link.sh "https://github.com" "Code platform" "favorito,referencia"
```

Reglas que el script aplica por ti:

- **URL y nota son obligatorios.** Los tags son opcionales.
- **¿Falta el `https://`?** Lo agrega solo. `github.com` se convierte en `https://github.com`.
- **Los tags se normalizan:** minúsculas, sin espacios, solo letras/números/`-`/`_`. Así que `Urgente!` se convierte en `urgente`, y `Ver Más Tarde` en `vermstarde`. Escríbelos ya normalizados para evitar sorpresas.

## Listar enlaces (`list_links.sh`)

```bash
./list_links.sh                  # todo, lo nuevo primero, agrupado por fecha
./list_links.sh 2026-08-28       # solo esa fecha (formato: AAAA-MM-DD)
./list_links.sh -t urgente       # solo enlaces con el tag "urgente"
./list_links.sh 2026-08-28 -t ia # fecha + tag combinados
./list_links.sh -s               # estadísticas
```

Salida real de las estadísticas:

```
📊 estadisticas de link-vault
============================
total enlaces: 12
con tags: 10
dias con enlaces: 3

tags mas usados:
  #ver-mas-tarde  →  5
  #referencia  →  4

ultimos dias:
  2026-08-28  →  5
  2026-08-27  →  4
```

## Buscar enlaces (`search_links.sh`)

```bash
./search_links.sh "tutorial"          # busca en URL, nota Y tags (sin importar mayúsculas)
./search_links.sh -t urgente         # solo por tag
./search_links.sh "tutorial" -t ia   # texto + tag combinados
```

Un resultado real se ve así:

```
--- resultado 1 ---
  📅 fecha: 2026-08-28
  🔗 url:   https://github.com
  📝 nota:  Code platform
  🏷️  tags: favorito,referencia
```

> [!NOTE]
> La búsqueda mira dentro del archivo completo (URL, nota, tags, hasta la línea de fecha). Coincide con cualquier parte de una palabra: buscar `git` también encuentra `github`.

## Interfaz web (`index.html`)

¿Prefieres hacer clic a escribir? Abre la página visual:

```bash
xdg-open index.html    # Linux
open index.html        # macOS
```

O en línea (si GitHub Pages está activado): https://hugolopezferrer.github.io/link-vault/

La página permite agregar y **editar** enlaces con selector visual de tags, buscar en vivo, filtrar por tag, eliminar enlaces, **exportar/importar tus enlaces como JSON** y ver estadísticas.

- **Editar:** cada enlace tiene un botón ✏️ Editar que lo carga de vuelta en el formulario. Cambia lo que necesites y guarda.
- **Respaldo:** 📥 Exportar JSON descarga todos tus enlaces a un archivo; 📤 Importar JSON los carga de vuelta — incluso en otro navegador. Tus datos nunca quedan atrapados.

> [!IMPORTANT]
> La página web y los scripts de terminal **no comparten datos**. La página guarda en tu navegador (localStorage); los scripts guardan archivos de texto en el disco. Un enlace agregado en uno no aparecerá en el otro. Elige el que te guste y quédate con él.

## Tags

Siete tags predefinidos para empezar:

| Tag | Significado | Color |
|-----|-------------|-------|
| `ver-mas-tarde` | Para leer después | 🔴 Rojo |
| `revisar` | Pendiente de revisar | 🟡 Amarillo |
| `compartir` | Para compartir con otros | 🟢 Verde |
| `desarrollar` | Ideas por desarrollar | 🔵 Azul |
| `urgente` | Importante, prioridad alta | 🔴 Rojo |
| `referencia` | Material de consulta | 🟣 Morado |
| `favorito` | Marcado como favorito | 🌸 Rosa |

Puedes inventar tus propios tags libremente — `trabajo`, `ia`, `recetas` — cualquiera en minúsculas y sin espacios.

## Cómo se guardan tus enlaces

Todo es texto plano. Nada que se rompa, nada que exportar — tus datos ya son archivos.

```
link-vault/
├── README.md               # Este archivo en inglés
├── README.es.md            # Este archivo
├── LICENSE                 # Licencia MIT
├── add_link.sh             # Agregar enlaces
├── list_links.sh           # Listar / filtrar / estadísticas
├── search_links.sh         # Buscar
├── index.html              # Interfaz web
└── links/                  # Se crea sola al guardar
    └── 2026-08-28/         # Una carpeta por día
        ├── link_202809123456789.txt
        └── link_202830987654321.txt
```

Cada enlace es un archivo `.txt`, exactamente así:

```
-enlace: https://github.com
-nota: Code platform
-tags: favorito,referencia
-fecha: 2026-08-28 - 20:28:09
```

(La línea `-tags:` solo aparece si agregaste tags.)

## Configuración

Por defecto todo vive en `~/workspace/links_app`. Para usar otra carpeta:

```bash
# Solo esta sesión de terminal:
export LINKS_APP_WORKSPACE="$HOME/Documents/my_links"

# Para siempre (ejecútalo una vez):
echo 'export LINKS_APP_WORKSPACE="$HOME/Documents/my_links"' >> ~/.bashrc
```

> [!WARNING]
> Si defines `LINKS_APP_WORKSPACE` en una terminal y en otra no, cada terminal verá una colección **distinta** de enlaces. Usa el mismo valor en todas partes, o no lo definas.

## Troubleshooting

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| `no hay enlaces guardados aun.` pero ya guardaste enlaces | Otro workspace en esta terminal (`LINKS_APP_WORKSPACE` definido en otro lado) | Ejecuta `echo $LINKS_APP_WORKSPACE` en ambas terminales y usa el mismo valor |
| `permission denied` al ejecutar un script | Los scripts no son ejecutables | Ejecuta `chmod +x *.sh` dentro de la carpeta del repo |
| `error: se requieren url y nota` | Falta la URL o la nota | Ambos son obligatorios: `./add_link.sh -u <url> -n <nota>`; ejecuta `./add_link.sh --help` |
| La búsqueda no encuentra nada | Tag escrito distinto (recuerda: minúsculas, sin espacios) | Lista tus tags con `./list_links.sh -s` y copia el tag exacto |
| Los enlaces del terminal no salen en la página web (o viceversa) | Usan almacenamientos separados (archivos vs navegador) | Normal — elige una interfaz y quédate con ella |
| `Archivo inválido` al importar | El archivo no es un JSON exportado por esta app | Exporta primero con 📥 Exportar JSON e importa ese archivo |

## Licencia

MIT — libre de usar, copiar y modificar. Ver [LICENSE](LICENSE).
