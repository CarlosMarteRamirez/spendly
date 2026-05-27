# Spendly landing page

Static showcase site for [Spendly](../). Pure HTML + CSS + a tiny JS for the EN/ES toggle and reveal-on-scroll. Designed to be served from GitHub Pages with zero build.

## Local preview

Just open `docs/index.html` in any browser, or serve it locally:

```bash
cd docs
python3 -m http.server 4000
# then visit http://localhost:4000
```

## Deploy to GitHub Pages

GitHub Pages can serve straight from this folder, no Actions needed:

1. Push the repo to GitHub (already done).
2. Go to **Repository → Settings → Pages**.
3. Under **Source**, pick:
   - Branch: `main`
   - Folder: `/docs`
4. Save. After ~1 minute, your site is live at:

   `https://<your-github-username>.github.io/spendly/`

5. Paste that URL in your CV / portfolio.

## Add your own screenshots

The page expects these PNG/JPG files (drop them in `docs/assets/screenshots/`). If a file is missing, a placeholder is shown instead.

| File                                | Shown as                          |
| ----------------------------------- | --------------------------------- |
| `assets/screenshots/home.png`       | Home · USD summary                |
| `assets/screenshots/expense-form.png` | Expense form · USD rate         |
| `assets/screenshots/email-import.png` | Bank email import               |
| `assets/screenshots/edit.png`       | Edit · Fetch historical rate      |

Tip: take screenshots on the iPhone 14 / 15 simulator at 1170×2532 (or any similar 9:19.5 ratio) for cleanest fit inside the CSS phone frame.

## Customize

- **Brand colors:** edit the CSS variables at the top of `styles.css` (`--primary`, `--accent`, etc).
- **Copy:** edit the `i18n` dictionary in `script.js` (keys are mirrored between `en` and `es`).
- **Sections:** edit `index.html` directly. Each block is grouped and commented.
- **GitHub URL:** the `View on GitHub` buttons point to `https://github.com/CarlosMarteRamirez/spendly` — update if you fork or rename.

## Stack

- HTML, CSS, vanilla JS (no framework, no build step)
- Inter via Google Fonts CDN
- `IntersectionObserver` for reveal animations (with `prefers-reduced-motion` fallback)
- `localStorage` for language persistence
