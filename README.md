🇺🇸 [English](README.md) | 🇪🇸 [Español](README.es.md)

# Link Vault 🔗

![100% free](https://img.shields.io/badge/100%25_free-brightgreen) ![open source](https://img.shields.io/badge/open_source-orange) ![bash + web](https://img.shields.io/badge/bash_%2B_web-blue)

**What this is:** a free app to save links with a note and tags, organized automatically by date. It has two faces: three small terminal scripts and a visual web page.

**Who it's for:** anyone who keeps losing interesting links in chat histories, open tabs, or screenshots. If you can copy and paste, you can use this.

## What you need

- A computer with **bash** (Linux or macOS — no extra installs)
- A web browser (only for the visual page)
- That's it. No accounts, no servers, no databases.

## Install

**Step 1 — Download it:**

```bash
git clone https://github.com/hugolopezferrer/link-vault.git
cd link-vault
```

**Step 2 — Make the scripts executable:**

```bash
chmod +x *.sh
```

**Step 3 — Check that it works:**

```bash
./add_link.sh --help
```

You should see the usage instructions (in Spanish — the scripts speak Spanish):

```
uso: ./add_link.sh -u <url> -n <nota> [-t <tags>]

  -u, --url    URL del enlace
  -n, --note   Nota o descripcion
  -t, --tags   Tags separados por coma (ej: urgente,ia,trabajo)
  -h, --help   Mostrar esta ayuda
```

If you see that, the install is done. Nothing else to configure.

## Quick start: save your first link

**Step 1 — Save a link:**

```bash
./add_link.sh -u https://github.com -n "Code platform" -t "favorito,referencia"
```

You should see:

```
✓ enlace guardado: /home/usuario/workspace/links_app/links/2026-08-28/link_202809123456789.txt
  url:  https://github.com
  nota:  Code platform
  tags: favorito,referencia
```

(The scripts answer in Spanish. `enlace guardado` = link saved, `nota` = note.)

**Step 2 — See all your links:**

```bash
./list_links.sh
```

**Step 3 — Find it again later:**

```bash
./search_links.sh "github"
```

That's the whole loop: save → list → search.

## Adding links (`add_link.sh`)

Two ways to add a link. With flags (recommended, clearer):

```bash
./add_link.sh -u https://github.com -n "Code platform" -t "favorito,referencia"
```

Or with positional arguments (faster to type):

```bash
./add_link.sh "https://github.com" "Code platform" "favorito,referencia"
```

Rules the script applies for you:

- **URL and note are required.** Tags are optional.
- **Missing `https://`?** It adds it. `github.com` becomes `https://github.com`.
- **Tags get normalized:** lowercase, no spaces, only letters/numbers/`-`/`_`. So `Urgente!` becomes `urgente`, and `Ver Más Tarde` becomes `vermstarde`. Write them already normalized to avoid surprises.

## Listing links (`list_links.sh`)

```bash
./list_links.sh                  # everything, newest first, grouped by date
./list_links.sh 2026-08-28       # only that date (format: YYYY-MM-DD)
./list_links.sh -t urgente       # only links tagged "urgente"
./list_links.sh 2026-08-28 -t ia # date + tag combined
./list_links.sh -s               # statistics
```

Real statistics output:

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

## Searching links (`search_links.sh`)

```bash
./search_links.sh "tutorial"          # searches URL, note AND tags (case-insensitive)
./search_links.sh -t urgente         # by tag only
./search_links.sh "tutorial" -t ia   # text + tag combined
```

A real result looks like this:

```
--- resultado 1 ---
  📅 fecha: 2026-08-28
  🔗 url:   https://github.com
  📝 nota:  Code platform
  🏷️  tags: favorito,referencia
```

> [!NOTE]
> Search looks inside the whole file (URL, note, tags, even the date line). It matches any part of a word: searching `git` also finds `github`.

## Web interface (`index.html`)

Prefer clicking to typing? Open the visual page:

```bash
xdg-open index.html    # Linux
open index.html        # macOS
```

Or online (if GitHub Pages is enabled): https://hugolopezferrer.github.io/link-vault/

The page lets you add and **edit** links with a visual tag picker, search live, filter by tag, delete links, **export/import your links as JSON**, and see statistics.

- **Edit:** every link has an ✏️ Editar button that loads it back into the form. Change what you need and save.
- **Backup:** 📥 Exportar JSON downloads all your links to a file; 📤 Importar JSON loads them back — even into another browser. Your data is never trapped.

> [!IMPORTANT]
> The web page and the terminal scripts **do not share data**. The page saves in your browser (localStorage); the scripts save text files on disk. A link added in one will not appear in the other. Pick the one you like and stick with it.

## Where your data lives

Honest warning first: **this app has no database.** Nothing is sent to any server. Here's exactly where your links go:

- **Web page:** inside your browser (localStorage), on that device. They survive restarts and updates — but they are gone if you clear your browser data, use incognito mode, or uninstall the browser.
- **Terminal scripts:** real text files on your computer, in `~/workspace/links_app/links/YYYY-MM-DD/` (or wherever `$LINKS_APP_WORKSPACE` points). Those are permanent — copy them, back them up, sync them with Drive like any file.

**Recommendation:** export your backup regularly. The web page has a 📥 Export JSON button — download the file and keep it wherever you keep important things (Drive, a folder, a USB stick). If anything ever happens, 📤 Import brings it all back.

### Install it as an app

Link Vault works in the browser, but you can give it its own icon:

- **On your phone:** open the page in Chrome → menu ⋮ → "Add to Home screen" (or "Install app"). The Link Vault icon appears on your home screen and opens full-screen, like any app.
- **On desktop:** in Chrome, Edge or Brave → menu → "Save and share" → "Create shortcut" → check "Open as window". You get a Link Vault icon on your desktop/taskbar that opens in its own window.

## Tags

Seven preset tags to start with:

| Tag | Meaning | Color |
|-----|---------|-------|
| `ver-mas-tarde` | Read later | 🔴 Red |
| `revisar` | Pending review | 🟡 Yellow |
| `compartir` | To share with others | 🟢 Green |
| `desarrollar` | Ideas to develop | 🔵 Blue |
| `urgente` | Important, high priority | 🔴 Red |
| `referencia` | Reference material | 🟣 Purple |
| `favorito` | Marked as favorite | 🌸 Pink |

You can invent your own tags freely — `trabajo`, `ia`, `recetas` — anything lowercase without spaces.

## How your links are stored

Everything is plain text. No database to break, no export needed — your data is already files.

```
link-vault/
├── README.md               # This file
├── README.es.md            # Spanish version
├── LICENSE                 # MIT license
├── add_link.sh             # Add links
├── list_links.sh           # List / filter / stats
├── search_links.sh         # Search
├── index.html              # Web interface
└── links/                  # Created automatically on first save
    └── 2026-08-28/         # One folder per day
        ├── link_202809123456789.txt
        └── link_202830987654321.txt
```

Each link is one `.txt` file, looking exactly like this:

```
-enlace: https://github.com
-nota: Code platform
-tags: favorito,referencia
-fecha: 2026-08-28 - 20:28:09
```

(The `-tags:` line only appears if you added tags.)

## Configuration

By default everything lives in `~/workspace/links_app`. To use another folder:

```bash
# Just this terminal session:
export LINKS_APP_WORKSPACE="$HOME/Documents/my_links"

# Forever (run once):
echo 'export LINKS_APP_WORKSPACE="$HOME/Documents/my_links"' >> ~/.bashrc
```

> [!WARNING]
> If you set `LINKS_APP_WORKSPACE` in one terminal and not in another, each terminal sees a **different** collection of links. Use the same value everywhere, or don't set it at all.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `no hay enlaces guardados aun.` but you saved links before | Different workspace in this terminal (`LINKS_APP_WORKSPACE` set elsewhere) | Run `echo $LINKS_APP_WORKSPACE` in both terminals and use the same value |
| `permission denied` when running a script | Scripts aren't executable | Run `chmod +x *.sh` inside the repo folder |
| `error: se requieren url y nota` | URL or note missing | Both are required: `./add_link.sh -u <url> -n <note>`; run `./add_link.sh --help` |
| Search finds nothing | Tag written differently (remember: lowercase, no spaces) | List your tags with `./list_links.sh -s` and copy the exact tag |
| Links from the terminal don't show on the web page (or vice versa) | They use separate storage (files vs browser) | Normal — pick one interface and stick with it |
| `Archivo inválido` when importing | The file isn't a JSON export from this app | Export first with 📥 Exportar JSON, then import that file |

## License

MIT — free to use, copy, and modify. See [LICENSE](LICENSE).
