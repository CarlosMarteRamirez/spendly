// Spendly landing page — i18n toggle + scroll reveal
(() => {
  const i18n = {
    en: {
      "meta.title": "Spendly — Track every expense, in any currency.",
      "meta.description":
        "Spendly is a Flutter expense tracker for iOS with automatic bank email import and historical USD conversion.",
      "nav.features": "Features",
      "nav.how": "How it works",
      "nav.screenshots": "Screenshots",
      "nav.tech": "Tech",
      "hero.eyebrow": "iOS · Flutter",
      "hero.title1": "Track every expense,",
      "hero.title2": "in any currency.",
      "hero.lead":
        "Spendly is a personal expense tracker for iOS. It reads bank notification emails from Gmail, normalizes everything to USD using the historical rate for the day of the transaction, and keeps your data 100% local.",
      "hero.ctaPrimary": "View on GitHub",
      "hero.ctaSecondary": "See features",
      "hero.meta1": "iOS · Flutter · Riverpod",
      "hero.meta2": "Local-first (Drift / SQLite)",
      "hero.meta3": "Gmail + Currency API",
      "mock.heading": "My expenses",
      "mock.month": "This month (USD)",
      "mock.today": "Today",
      "mock.total": "Total",
      "mock.items": "Items",
      "mock.search": "Search by title",
      "features.eyebrow": "Features",
      "features.title": "Everything you need to understand your spending.",
      "features.lead":
        "Designed to be opened in seconds, log a charge in two taps, and answer \"how much did I really spend this month\" without doing math.",
      "features.f1.title": "Manual expenses, any currency",
      "features.f1.body":
        "Log a charge with title, amount, date and notes. Supports USD, EUR, MXN and DOP (RD$) out of the box.",
      "features.f2.title": "Automatic Gmail import",
      "features.f2.body":
        "Connects to Gmail with read-only scope and parses notifications from Qik, BHD, Popular, Banreservas, Scotiabank, APAP and Promerica. Deduplicates by Gmail message id.",
      "features.f3.title": "Summary always in USD",
      "features.f3.body":
        "Today, this month and total are normalized to USD using a historical rate for the day of each transaction, so 4,800 RD$ never looks like 4,800 USD.",
      "features.f4.title": "Per-expense USD rate",
      "features.f4.body":
        "Each expense stores its own conversion rate. Edit it manually or tap \"Fetch historical USD rate\" to pull the value for that exact date.",
      "features.f5.title": "iOS native, Material 3 UI",
      "features.f5.body":
        "Built with Flutter and Material 3, with custom app icon, launcher branding and a teal gradient identity matching the Spendly mark.",
      "features.f6.title": "Local-first storage",
      "features.f6.body":
        "All data lives on the device using Drift over SQLite. No backend, no analytics, no tracking.",
      "how.eyebrow": "How it works",
      "how.title": "From bank email to USD-normalized expense.",
      "how.lead":
        "Three small steps that happen automatically every time you sync.",
      "how.s1.title": "Connect Gmail",
      "how.s1.body":
        "Sign in once with read-only access. Spendly remembers your session and only re-prompts if it expires.",
      "how.s2.title": "Parse bank notifications",
      "how.s2.body":
        "A small parser extracts merchant, amount, currency and date from each bank email and dedupes by message id.",
      "how.s3.title": "Convert to USD by date",
      "how.s3.body":
        "The historical USD rate is fetched per expense, so a charge from last year uses last year's rate — not today's.",
      "shots.eyebrow": "Screenshots",
      "shots.title": "A clean iOS experience.",
      "shots.lead":
        "Light theme, Inter typography, teal gradient hero, and a transactions list designed to be scanned in one glance.",
      "shots.placeholder": "Add screenshot",
      "shots.cap1": "Home · USD summary",
      "shots.cap2": "Expense form · USD rate",
      "shots.cap3": "Bank email import",
      "shots.cap4": "Edit · Fetch historical rate",
      "tech.eyebrow": "Tech stack",
      "tech.title": "Built with tools I trust.",
      "tech.lead":
        "A focused stack — no bloat, no dead code paths, and every choice made to ship faster and stay maintainable.",
      "about.title": "A personal tool I actually use.",
      "about.body":
        "Spendly started as a quick scratch project because no existing expense app handled multi-currency, RD$, and historical USD rates the way I wanted. It is now a clean, opinionated iOS app I open every day — and a small portfolio piece of how I think about shipping focused products.",
      "about.cta": "Read the source on GitHub",
      "footer.note": "Made by Carlos Marte · Built with Flutter",
    },
    es: {
      "meta.title": "Spendly — Registra cada gasto, en cualquier moneda.",
      "meta.description":
        "Spendly es un control de gastos en Flutter para iOS con importación automática de correos bancarios y conversión histórica a USD.",
      "nav.features": "Funciones",
      "nav.how": "Cómo funciona",
      "nav.screenshots": "Capturas",
      "nav.tech": "Stack",
      "hero.eyebrow": "iOS · Flutter",
      "hero.title1": "Registra cada gasto,",
      "hero.title2": "en cualquier moneda.",
      "hero.lead":
        "Spendly es un control personal de gastos para iOS. Lee los correos de notificación del banco en Gmail, normaliza todo a USD usando la tasa histórica del día de la transacción y mantiene tus datos 100% locales.",
      "hero.ctaPrimary": "Ver en GitHub",
      "hero.ctaSecondary": "Ver funciones",
      "hero.meta1": "iOS · Flutter · Riverpod",
      "hero.meta2": "Local-first (Drift / SQLite)",
      "hero.meta3": "Gmail + Currency API",
      "mock.heading": "Mis gastos",
      "mock.month": "Este mes (USD)",
      "mock.today": "Hoy",
      "mock.total": "Total",
      "mock.items": "Items",
      "mock.search": "Buscar por título",
      "features.eyebrow": "Funciones",
      "features.title": "Todo lo necesario para entender en qué gastas.",
      "features.lead":
        "Diseñada para abrirse en segundos, registrar un gasto en dos toques y responder \"¿cuánto gasté de verdad este mes?\" sin sumar a mano.",
      "features.f1.title": "Gastos manuales, en cualquier moneda",
      "features.f1.body":
        "Registra un gasto con título, monto, fecha y notas. Soporta USD, EUR, MXN y DOP (RD$).",
      "features.f2.title": "Importación automática desde Gmail",
      "features.f2.body":
        "Se conecta a Gmail solo en modo lectura y parsea notificaciones de Qik, BHD, Popular, Banreservas, Scotiabank, APAP y Promerica. Evita duplicados por message id.",
      "features.f3.title": "Resumen siempre en USD",
      "features.f3.body":
        "Hoy, este mes y total se normalizan a USD con tasa histórica del día de cada transacción, así 4,800 RD$ no se ven como 4,800 USD.",
      "features.f4.title": "Tasa USD por gasto",
      "features.f4.body":
        "Cada gasto guarda su propia tasa de conversión. Edítala manualmente o toca \"Fetch historical USD rate\" para traer la del día exacto.",
      "features.f5.title": "iOS nativo, UI Material 3",
      "features.f5.body":
        "Construida con Flutter y Material 3, con icono personalizado, branding de launcher y la identidad teal de Spendly.",
      "features.f6.title": "Almacenamiento local",
      "features.f6.body":
        "Todos los datos viven en el dispositivo con Drift sobre SQLite. Sin backend, sin analítica, sin tracking.",
      "how.eyebrow": "Cómo funciona",
      "how.title": "Del correo bancario al gasto en USD.",
      "how.lead":
        "Tres pasos pequeños que ocurren automáticamente cada vez que sincronizas.",
      "how.s1.title": "Conecta Gmail",
      "how.s1.body":
        "Inicia sesión una vez con acceso solo lectura. Spendly recuerda tu sesión y solo vuelve a pedir login si expira.",
      "how.s2.title": "Parsea notificaciones bancarias",
      "how.s2.body":
        "Un parser pequeño extrae comercio, monto, moneda y fecha de cada correo y deduplica por message id.",
      "how.s3.title": "Convierte a USD por fecha",
      "how.s3.body":
        "La tasa USD histórica se busca por cada gasto, así un cargo del año pasado usa la tasa del año pasado, no la de hoy.",
      "shots.eyebrow": "Capturas",
      "shots.title": "Una experiencia iOS limpia.",
      "shots.lead":
        "Tema claro, tipografía Inter, hero con degradado teal y una lista de transacciones diseñada para escanear de un vistazo.",
      "shots.placeholder": "Añadir captura",
      "shots.cap1": "Inicio · resumen USD",
      "shots.cap2": "Formulario · tasa USD",
      "shots.cap3": "Importación de correos",
      "shots.cap4": "Editar · traer tasa histórica",
      "tech.eyebrow": "Stack técnico",
      "tech.title": "Construida con herramientas en las que confío.",
      "tech.lead":
        "Un stack enfocado — sin bloat, sin código muerto, cada decisión pensada para entregar rápido y mantener.",
      "about.title": "Una herramienta personal que sí uso.",
      "about.body":
        "Spendly nació como un proyecto rápido porque ninguna app de gastos existente manejaba multi-moneda, RD$ y tasas históricas USD como yo quería. Hoy es una app iOS limpia y opinada que abro todos los días — y una pieza pequeña de portafolio sobre cómo pienso al construir productos enfocados.",
      "about.cta": "Ver el código en GitHub",
      "footer.note": "Hecho por Carlos Marte · Construido con Flutter",
    },
  };

  const STORAGE_KEY = "spendly.lang";
  const SUPPORTED = ["en", "es"];

  const detectInitialLang = () => {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored && SUPPORTED.includes(stored)) return stored;
    const nav = (navigator.language || "en").slice(0, 2).toLowerCase();
    return SUPPORTED.includes(nav) ? nav : "en";
  };

  const applyLang = (lang) => {
    document.documentElement.lang = lang;
    const dict = i18n[lang] || i18n.en;
    document.querySelectorAll("[data-i18n]").forEach((node) => {
      const key = node.getAttribute("data-i18n");
      const value = dict[key];
      if (typeof value !== "string") return;
      if (node.tagName === "META") {
        node.setAttribute("content", value);
      } else if (node.tagName === "TITLE") {
        document.title = value;
      } else {
        node.textContent = value;
      }
    });
    const label = document.getElementById("langLabel");
    if (label) label.textContent = lang === "en" ? "ES" : "EN";
    localStorage.setItem(STORAGE_KEY, lang);
  };

  // Initial language
  applyLang(detectInitialLang());

  // Toggle button
  const toggle = document.getElementById("langToggle");
  if (toggle) {
    toggle.addEventListener("click", () => {
      const next = document.documentElement.lang === "en" ? "es" : "en";
      applyLang(next);
    });
  }

  // Reveal-on-scroll
  const prefersReduced = window.matchMedia(
    "(prefers-reduced-motion: reduce)"
  ).matches;
  const reveals = document.querySelectorAll(".reveal");

  if (prefersReduced || !("IntersectionObserver" in window)) {
    reveals.forEach((el) => el.classList.add("in-view"));
  } else {
    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("in-view");
            io.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: "0px 0px -60px 0px" }
    );
    reveals.forEach((el) => io.observe(el));
  }
})();
