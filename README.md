# Opsmaru site

Astro marketing site for **[opsmaru.dev](https://opsmaru.dev)**, using Tailwind CSS 4 and the **daisyUI Night** theme. Deployed as a static-assets Cloudflare Worker named `opsmaru-site`.

## Local development

Use Node.js 24 LTS (minimum 22.23.4) and npm.

```sh
npm ci
npm run dev
```

Astro prints the available development URL, normally `http://localhost:4321`. Fonts, styles, and the legacy gradient logo are served locally; there are no external font requests, analytics, or signup services.

## Checks and previews

```sh
npm run check                 # Strict Astro / TypeScript checks
npm run build                 # Pre-render into dist/
npm run preview               # Preview the Astro build
npm run preview:worker        # Build and serve with local Wrangler
npm run deploy:check          # Build and validate Worker packaging, no upload

npx playwright install chromium
npm test                      # Desktop, mobile, and 320px mobile browser checks
```

The tests start a dedicated **local** Wrangler server on port 8791; that port must be free. They validate actual Workers Static Assets behavior, CSP, metadata, target selection, mobile navigation, FAQ interaction, layout overflow, automated WCAG AA checks, no-JavaScript content, assets, and HTTP 404 handling. Automated accessibility checks do not replace manual accessibility review.

## Deployment

`wrangler.jsonc` configures:

- Worker: `opsmaru-site`
- Production custom domain: `opsmaru.dev`
- Assets: `dist/`, with a real custom 404 (not an SPA fallback)
- Compatibility date: `2026-11-13`
- Workers observability and traces enabled
- `workers.dev` and public version preview URLs disabled

This is an entirely pre-rendered Astro site. Per [Cloudflare's static Astro guidance](https://developers.cloudflare.com/workers/framework-guides/web-apps/astro/#if-you-have-a-static-site), it does not need an SSR adapter, Worker handler, Node.js compatibility flag, runtime bindings, or secrets. Static requests do not execute application Worker code; do not expect custom application logs or spans for those requests.

Before deploying, confirm the intended Cloudflare account and that **opsmaru.dev is an active Cloudflare zone in that account**. The custom-domain deployment manages DNS and certificates; resolve any conflicting DNS record deliberately. Authenticate locally with Wrangler or provide an appropriately scoped Cloudflare API token through your deployment environment—never commit it.

```sh
npx wrangler login
npx wrangler whoami
npm run deploy:check
npm run deploy
```

Deployment is explicit: no Git push triggers a production deployment. The included GitHub Actions workflow only validates the site. For Workers Builds, use `npm run build` as the build command and `npx wrangler deploy` as the deploy command.

Security/cache response headers are in `public/_headers`. Scripts are deliberately emitted as external assets so `script-src 'self'` works without inline-script permission. The site has no API or compute backend; all architecture diagrams are explanatory, not live infrastructure status.

## Structure

```text
src/pages/index.astro         Landing page copy and sections
src/pages/404.astro           Custom not-found page
src/layouts/Layout.astro     Night theme, local fonts, SEO/social metadata
src/components/ComputeMap.astro  Interactive architecture illustration
src/components/Icon.astro    Shared inline SVG icons
src/data/compute-targets.ts   Local and cloud target explanations
src/styles/global.css        daisyUI setup, layout, responsive styles
public/images/               Original logo and generated social card
public/_headers              Workers security and cache headers
scripts/generate-social.mjs   Reproducible 1200 × 630 social image
```

To regenerate the checked-in social image after brand/copy changes:

```sh
npx playwright install chromium
npm run social:generate
```

## Product messaging and provenance

The site presents the product direction: a universal compute substrate for agents, safe sandbox environments, an Incus normalization layer, and future scheduling/orchestration across local and cloud hosts. It does **not** claim the central service or cloud provisioning is already available.

The content was informed by the sibling repositories:

- `../opsmaru/README.md` and `openspec/changes/add-compute-substrate/` plus `add-remote-api-and-oauth/`: registered targets, MCP/REST direction, scoped identity, direct HTTPS, private-network connectors, and later orchestration.
- `../opsmaru-incus/README.md` and `openspec/specs/`: native client semantics, shared operation contracts, host-owned trust, bounds, confirmation, and the embeddable gateway.
- The existing central specs explicitly defer placement scheduling. Cloud provisioning and the scheduler are shown as the broader roadmap supplied for this site, not as completed spec implementation.
- `public/images/opsmaru-logo.svg` is copied unchanged from `../opsmaru-site-legacy/priv/static/images/logo-color.svg`; the ICO favicon also comes from the legacy site. No sibling repository is required to build this project.

Repository links point to `upmaru/opsmaru` and `upmaru/opsmaru-incus`. Update the roadmap and FAQ as capabilities ship.

Site repository: `git@github.com:upmaru/opsmaru-site.git`.
