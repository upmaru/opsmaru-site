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

The tests start a dedicated **local** Wrangler server on port 8791; that port must be free. They validate actual Workers Static Assets behavior on both pages, CSP, metadata and clean URLs, target selection, cross-page navigation, FAQ interaction, Macus install state against the release data, copy buttons, layout overflow, automated WCAG AA checks, no-JavaScript content, assets, and HTTP 404 handling. Automated accessibility checks do not replace manual accessibility review.

## Deployment

`wrangler.jsonc` configures:

- Worker: `opsmaru-site`
- Production custom domain: `opsmaru.dev`
- Assets: `dist/`, with a real custom 404 (not an SPA fallback)
- Compatibility date: `2026-11-13`
- Workers observability and traces enabled
- `workers.dev` and public version preview URLs disabled
- An empty `previews` block, required by `npx wrangler preview`, which Workers Builds runs for non-production branches. Previews reuse the top-level assets and get no public `workers.dev` URL while `preview_urls` is `false`

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
src/pages/macus.astro         Macus product and install page (served at /macus)
src/pages/404.astro           Custom not-found page
src/layouts/Layout.astro     Night theme, local fonts, SEO/social metadata
src/components/SiteHeader.astro  Shared navigation (anchors resolve to the landing page)
src/components/SiteFooter.astro  Shared footer
src/components/ComputeMap.astro  Interactive architecture illustration
src/components/CodeBlock.astro   Command sample with a progressive-enhancement copy button
src/components/Icon.astro    Shared inline SVG icons
src/data/compute-targets.ts   Linux, Mac and cloud target explanations
src/data/macus-release.ts     Macus distribution state: download, Homebrew, requirements
src/styles/global.css        daisyUI setup, layout, responsive styles
public/images/               Original logo and generated social cards
public/_headers              Workers security and cache headers
scripts/generate-social.mjs   Reproducible 1200 × 630 social images
```

Pages are emitted as files (`build.format: 'file'`), so `/macus` is served from `macus.html` without a trailing-slash redirect. Canonical URLs use the clean path.

## Releasing Macus

The Macus page reads everything release-specific from `src/data/macus-release.ts`. Until a channel ships it shows **Preview**, with download and Homebrew marked *Coming soon* and build-from-source as the live option. On release day:

1. Attach the signed, notarized installer to a GitHub Release on `upmaru/macus`.
2. In `macus-release.ts`, set `version` and `releasedOn`, and set `download.available: true` with its `url`, `fileName`, `sha256` and `sizeLabel`. Adjust `download.steps` to match the installer (for example, disk image versus `.pkg`).
3. When `upmaru/homebrew-tap` publishes a verified `Formula/macus.rb` with bottles, set `homebrew.available: true`.
4. Run `npm run check && npm test`, then deploy.

The hero button, status chip, install cards, landing-page teaser and the Macus row in the stack all derive from that file. The test suite asserts the install section against the same data. Review the "What’s next" items and FAQ on the Macus page at the same time.

To regenerate the checked-in social images after brand/copy changes:

```sh
npx playwright install chromium
npm run social:generate
```

## Product messaging and provenance

The site presents the product direction: a universal compute substrate for agents, safe sandbox environments, an Incus normalization layer, a two-tool agent interface, Macus for Apple Silicon, and future registration, cloud provisioning and orchestration across local and cloud hosts. It does **not** claim the central service, cloud provisioning or Macus prebuilt distribution are already available.

The content was informed by the sibling repositories:

- `../opsmaru/README.md` and `openspec/changes/add-compute-substrate/`, `add-remote-api-and-oauth/` and `add-cloud-host-provisioning/`: registered targets, MCP/REST, scoped identity, direct HTTPS, private-network connectors, and native-adapter cloud host provisioning (AWS, GCP, DigitalOcean) with cloud-init bootstrap and enrolment-token registration.
- `../opsmaru-incus/README.md`, `CHANGELOG.md` and `openspec/specs/`: native client semantics, the embeddable gateway, 32 composite and 274 native operations published as `tama-operations/1` documents, host-owned trust, bounds and confirmation.
- `../../_kritama/tama-dex/README.md` (`kritama/tama-dex`): the `search` / `execute` MCP tools, scope-filtered search, confirmation and `dispatched` error semantics.
- `../macus/README.md`, `docs/` and `openspec/changes/` (`add-elixir-server`, `add-homebrew-tap`, `prebuilt-appliance-image`, `add-central-registration`): `macus start` stages, the HTTPS gateway (`/1.0`, `/runtime`, `/mcp`), token scopes, requirements, upgrade/removal and the roadmap. Homebrew and signed/notarized downloads are shown as coming soon.
- Placement scheduling is explicitly deferred by the central specs. It is shown as later vision, not as completed or specified work.
- `public/images/opsmaru-logo.svg` is copied unchanged from `../opsmaru-site-legacy/priv/static/images/logo-color.svg`; the ICO favicon also comes from the legacy site. No sibling repository is required to build this project.

Repository links point to `upmaru/opsmaru`, `upmaru/opsmaru-incus`, `kritama/tama-dex` and `upmaru/macus`. Update the stack, Macus roadmap and FAQs as capabilities ship.

Site repository: `git@github.com:upmaru/opsmaru-site.git`.
