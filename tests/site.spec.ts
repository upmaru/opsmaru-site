import { test, expect, type Page } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';
import { macusRelease } from '../src/data/macus-release';

const pages = ['/', '/macus'] as const;

async function overflowingElements(page: Page) {
  return page.locator('main').evaluate((main) => {
    const width = document.documentElement.clientWidth;
    return [...main.querySelectorAll('*')].filter((element) => {
      const rect = element.getBoundingClientRect();
      return rect.width > 0 && (rect.right > width + 1 || rect.left < -1)
        && getComputedStyle(element).position !== 'absolute'
        && !element.closest('[aria-hidden="true"]')
        // Code samples scroll horizontally inside their own box by design.
        && !element.parentElement?.closest('pre');
    }).map((element) => `${element.tagName}.${element.className}`);
  });
}

test('landing page has correct metadata and loads without runtime errors', async ({ page }) => {
  const errors: string[] = [];
  page.on('pageerror', (error) => errors.push(error.message));
  page.on('console', (message) => {
    if (message.type() === 'error') errors.push(message.text());
  });
  const response = await page.goto('/');
  expect(response?.status()).toBe(200);
  expect(response?.headers()['x-content-type-options']).toBe('nosniff');
  await expect(page).toHaveTitle('Opsmaru — The universal compute substrate for agents');
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'night');
  await expect(page.locator('link[rel="canonical"]')).toHaveAttribute('href', 'https://opsmaru.dev/');
  await expect(page.getByRole('heading', { level: 1 })).toHaveText('Agents need a place to do real work.');
  await page.evaluate(() => document.fonts.ready);
  expect(errors).toEqual([]);
});

test('Macus page is served at a clean URL with its own metadata', async ({ page }) => {
  const errors: string[] = [];
  page.on('pageerror', (error) => errors.push(error.message));
  page.on('console', (message) => {
    if (message.type() === 'error') errors.push(message.text());
  });
  const response = await page.goto('/macus');
  expect(response?.status()).toBe(200);
  expect(response?.url()).toMatch(/\/macus$/);
  await expect(page).toHaveTitle('Macus — A Linux Incus host on your Mac');
  await expect(page.locator('link[rel="canonical"]')).toHaveAttribute('href', 'https://opsmaru.dev/macus');
  await expect(page.locator('meta[property="og:image"]')).toHaveAttribute('content', 'https://opsmaru.dev/images/macus-social-card.png');
  await expect(page.getByRole('heading', { level: 1 })).toHaveText('Linux compute on your Mac. One command.');
  await page.evaluate(() => document.fonts.ready);
  expect(errors).toEqual([]);
});

test('architecture targets update with accessible selection state', async ({ page }) => {
  await page.goto('/');
  const group = page.getByRole('group', { name: 'Explore compute targets' });
  for (const [label, name] of [['AWS', 'Amazon Web Services'], ['GCP', 'Google Cloud'], ['DigitalOcean', 'DigitalOcean'], ['Mac', 'Mac with Macus'], ['Linux', 'Linux with Incus']]) {
    await group.getByRole('button', { name: label, exact: true }).click();
    await expect(group.getByRole('button', { name: label, exact: true })).toHaveAttribute('aria-pressed', 'true');
    await expect(group.locator('[aria-pressed="true"]')).toHaveCount(1);
    await expect(page.locator('[data-target-name]')).toHaveText(name);
    if (!['Linux', 'Mac'].includes(label)) await expect(page.locator('[data-target-description]')).toContainText('Planned');
  }
  // Keyboard activation uses native button behavior.
  await group.getByRole('button', { name: 'AWS', exact: true }).focus();
  await page.keyboard.press('Enter');
  await expect(page.locator('[data-target-name]')).toHaveText('Amazon Web Services');
});

test('FAQ discloses current product status', async ({ page }) => {
  await page.goto('/');
  const question = page.getByText('What can I use today?', { exact: true });
  await question.click();
  const details = question.locator('..');
  await expect(details).toHaveAttribute('open', '');
  await expect(details.locator('.collapse-content')).toBeVisible();
  await expect(details).toContainText('still in development or planning');
});

test('Macus install options reflect the release data', async ({ page }) => {
  await page.goto('/macus');
  const install = page.locator('#install');
  const downloadCard = install.locator('.install-card').filter({ has: page.getByRole('heading', { name: 'Download for macOS' }) });
  const brewCard = install.locator('.install-card').filter({ has: page.getByRole('heading', { name: 'Homebrew' }) });
  if (macusRelease.download.available) {
    await expect(downloadCard.getByRole('link', { name: /^Download / })).toHaveAttribute('href', macusRelease.download.url!);
    await expect(page.locator('.hero-actions').first().getByRole('link', { name: 'Download for macOS' })).toBeVisible();
  } else {
    await expect(downloadCard).toContainText('Coming soon');
    await expect(downloadCard.getByRole('link', { name: /^Download / })).toHaveCount(0);
  }
  await expect(brewCard).toContainText(macusRelease.homebrew.available ? 'Available' : 'Coming soon');
  await expect(brewCard.locator('code')).toHaveText(macusRelease.homebrew.command);
  await expect(install.getByRole('heading', { name: 'Build from source' })).toBeVisible();
  await expect(install.getByRole('heading', { name: 'System requirements' })).toBeVisible();
});

test('copy buttons copy commands when JavaScript is available', async ({ page, context, browserName }, testInfo) => {
  test.skip(testInfo.project.name !== 'desktop' || browserName !== 'chromium', 'Clipboard permissions are granted on desktop Chromium only.');
  await context.grantPermissions(['clipboard-read', 'clipboard-write']);
  await page.goto('/macus');
  const block = page.locator('.after-install [data-code-block]');
  await block.getByRole('button', { name: 'Copy First run' }).click();
  await expect(block.getByRole('button', { name: 'Copy First run' })).toContainText('Copied');
  expect(await page.evaluate(() => navigator.clipboard.readText())).toContain('macus start');
});

test('navigation works across pages and layout stays within the viewport', async ({ page }, testInfo) => {
  await page.goto('/');
  const nav = testInfo.project.name === 'desktop' ? page.locator('.desktop-nav') : page.locator('.mobile-nav');
  if (testInfo.project.name !== 'desktop') {
    await page.getByLabel('Open navigation').click();
    await nav.getByRole('link', { name: 'Platform', exact: true }).click();
    await expect(page.locator('.mobile-nav')).not.toHaveAttribute('open');
  } else {
    await nav.getByRole('link', { name: 'Platform', exact: true }).click();
  }
  await expect(page).toHaveURL(/#platform$/);
  expect(await overflowingElements(page)).toEqual([]);
  await page.screenshot({ path: testInfo.outputPath('landing.png'), fullPage: true });

  if (testInfo.project.name !== 'desktop') await page.getByLabel('Open navigation').click();
  await nav.getByRole('link', { name: 'Macus', exact: true }).click();
  await expect(page).toHaveURL(/\/macus$/);
  await expect(nav.locator('a[aria-current="page"]')).toHaveText('Macus');
  expect(await overflowingElements(page)).toEqual([]);
  await page.screenshot({ path: testInfo.outputPath('macus.png'), fullPage: true });

  if (testInfo.project.name !== 'desktop') await page.getByLabel('Open navigation').click();
  await nav.getByRole('link', { name: 'Stack', exact: true }).click();
  await expect(page).toHaveURL(/\/#stack$/);
  await expect(page.locator('#stack')).toBeInViewport();
});

test('body copy stays readable across responsive breakpoints', async ({ page }) => {
  const selectors: Record<(typeof pages)[number], string[]> = {
    '/': [
      '.hero-description', '.section-intro', '.feature-card p', '.agents-intro', '.agent-points p', '.workflow-steps p',
      '.macus-teaser-copy > p:not(.eyebrow)', '.principles-copy > p:not(.eyebrow)', '.principle-list p', '.stack-row > p',
      '.faq-list .collapse-content', '.closing-content > p:not(.eyebrow)',
    ],
    '/macus': [
      '.hero-description', '.section-intro', '.stage-grid p', '.agents-intro', '.feature-card p', '.install-card > p',
      '.after-install p:not(.eyebrow)', '.roadmap-card p', '.faq-list .collapse-content', '.closing-content > p:not(.eyebrow)',
    ],
  };
  for (const path of pages) {
    for (const width of [320, 390, 768, 1024, 1440]) {
      await page.setViewportSize({ width, height: 1000 });
      await page.goto(path);
      const undersized = await page.locator(selectors[path].join(',')).evaluateAll((elements) => elements
        .filter((element) => parseFloat(getComputedStyle(element).fontSize) < 16)
        .map((element) => `${element.tagName}.${element.className}`));
      expect(undersized, `body text on ${path} at ${width}px`).toEqual([]);
      expect(await overflowingElements(page), `layout on ${path} at ${width}px`).toEqual([]);
    }
  }
});

for (const path of pages) {
  test(`meets automated WCAG AA accessibility checks on ${path}`, async ({ page }) => {
    await page.goto(path);
    await page.evaluate(() => document.fonts.ready);
    const results = await new AxeBuilder({ page }).withTags(['wcag2a', 'wcag2aa', 'wcag21aa']).analyze();
    expect(results.violations).toEqual([]);
  });
}

test('serves a real custom 404 rather than a successful SPA fallback', async ({ page }) => {
  const response = await page.goto('/not-a-real-page');
  expect(response?.status()).toBe(404);
  await expect(page.getByRole('heading', { level: 1 })).toContainText('off the grid');
  await expect(page.locator('meta[name="robots"]')).toHaveAttribute('content', 'noindex');
  await page.getByRole('link', { name: 'Back to Opsmaru' }).click();
  await expect(page).toHaveURL('/');
});

test('internal links and social assets resolve', async ({ page, request }) => {
  for (const path of pages) {
    await page.goto(path);
    const missingAnchors = await page.locator('a[href^="#"]').evaluateAll((links) => links.map((link) => link.getAttribute('href')!).filter((href) => !document.getElementById(href.slice(1))));
    expect(missingAnchors, `in-page anchors on ${path}`).toEqual([]);
  }
  // Cross-page anchors from /macus must land on sections of the landing page.
  await page.goto('/macus');
  const homeAnchors = await page.locator('a[href^="/#"]').evaluateAll((links) => [...new Set(links.map((link) => link.getAttribute('href')!.slice(2)))]);
  await page.goto('/');
  for (const id of homeAnchors) await expect(page.locator(`#${id}`), `/#${id}`).toHaveCount(1);
  for (const path of ['/images/opsmaru-logo.svg', '/images/social-card.png', '/images/macus-social-card.png', '/robots.txt', '/sitemap.xml']) {
    expect((await request.get(path)).status(), path).toBe(200);
  }
});

test('core content remains readable without JavaScript', async ({ browser, baseURL }) => {
  const context = await browser.newContext({ javaScriptEnabled: false, baseURL });
  const page = await context.newPage();
  await page.goto('/');
  await expect(page.getByRole('heading', { level: 1 })).toContainText('do real work');
  await page.getByText('What can I use today?', { exact: true }).click();
  await expect(page.getByText('What can I use today?', { exact: true }).locator('..')).toHaveAttribute('open', '');
  await page.goto('/macus');
  await expect(page.locator('#install')).toContainText('macus start');
  await expect(page.locator('[data-copy]').first()).toBeHidden();
  await context.close();
});
