import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

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

test('architecture targets update with accessible selection state', async ({ page }) => {
  await page.goto('/');
  const group = page.getByRole('group', { name: 'Explore compute targets' });
  for (const [label, name] of [['AWS', 'Amazon Web Services'], ['GCP', 'Google Cloud'], ['DigitalOcean', 'DigitalOcean'], ['Local', 'Your machine']]) {
    await group.getByRole('button', { name: label, exact: true }).click();
    await expect(group.getByRole('button', { name: label, exact: true })).toHaveAttribute('aria-pressed', 'true');
    await expect(group.locator('[aria-pressed="true"]')).toHaveCount(1);
    await expect(page.locator('[data-target-name]')).toHaveText(name);
    if (label !== 'Local') await expect(page.locator('[data-target-description]')).toContainText('planned');
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

test('navigation works and layout stays within the viewport', async ({ page }, testInfo) => {
  await page.goto('/');
  if (testInfo.project.name !== 'desktop') {
    await page.getByLabel('Open navigation').click();
    await page.locator('.mobile-nav').getByRole('link', { name: 'Platform', exact: true }).click();
    await expect(page.locator('.mobile-nav')).not.toHaveAttribute('open');
  } else {
    await page.locator('.desktop-nav').getByRole('link', { name: 'Platform', exact: true }).click();
  }
  await expect(page).toHaveURL(/#platform$/);
  const overflow = await page.evaluate(() => {
    const width = document.documentElement.clientWidth;
    return [...document.querySelectorAll('main *')].filter((element) => {
      const rect = element.getBoundingClientRect();
      return rect.width > 0 && (rect.right > width + 1 || rect.left < -1)
        && getComputedStyle(element).position !== 'absolute'
        && !element.closest('[aria-hidden="true"]');
    }).map((element) => `${element.tagName}.${element.className}`);
  });
  expect(overflow).toEqual([]);
  await page.screenshot({ path: testInfo.outputPath('landing.png'), fullPage: true });
});

test('body copy stays readable across responsive breakpoints', async ({ page }) => {
  for (const width of [320, 390, 768, 1024, 1440]) {
    await page.setViewportSize({ width, height: 1000 });
    await page.goto('/');
    const undersized = await page.locator([
      '.hero-description', '.section-intro', '.feature-card p', '.workflow-steps p',
      '.principles-copy > p:not(.eyebrow)', '.principle-list p', '.roadmap-card p',
      '.faq-list .collapse-content', '.closing-content > p:not(.eyebrow)',
    ].join(',')).evaluateAll((elements) => elements
      .filter((element) => parseFloat(getComputedStyle(element).fontSize) < 16)
      .map((element) => `${element.tagName}.${element.className}`));
    expect(undersized, `body text at ${width}px`).toEqual([]);
    const overflow = await page.locator('main').evaluate((main) => {
      const width = document.documentElement.clientWidth;
      return [...main.querySelectorAll('*')].filter((element) => {
        const rect = element.getBoundingClientRect();
        return rect.width > 0 && (rect.right > width + 1 || rect.left < -1)
          && getComputedStyle(element).position !== 'absolute'
          && !element.closest('[aria-hidden="true"]');
      }).map((element) => `${element.tagName}.${element.className}`);
    });
    expect(overflow, `layout at ${width}px`).toEqual([]);
  }
});

test('meets automated WCAG AA accessibility checks', async ({ page }) => {
  await page.goto('/');
  await page.evaluate(() => document.fonts.ready);
  const results = await new AxeBuilder({ page }).withTags(['wcag2a', 'wcag2aa', 'wcag21aa']).analyze();
  expect(results.violations).toEqual([]);
});

test('serves a real custom 404 rather than a successful SPA fallback', async ({ page }) => {
  const response = await page.goto('/not-a-real-page');
  expect(response?.status()).toBe(404);
  await expect(page.getByRole('heading', { level: 1 })).toContainText('off the grid');
  await expect(page.locator('meta[name="robots"]')).toHaveAttribute('content', 'noindex');
  await page.getByRole('link', { name: 'Back to Opsmaru' }).click();
  await expect(page).toHaveURL('/');
});

test('internal links and social assets resolve', async ({ page, request }) => {
  await page.goto('/');
  const missingAnchors = await page.locator('a[href^="#"]').evaluateAll((links) => links.map((link) => link.getAttribute('href')!).filter((href) => !document.getElementById(href.slice(1))));
  expect(missingAnchors).toEqual([]);
  for (const path of ['/images/opsmaru-logo.svg', '/images/social-card.png', '/robots.txt', '/sitemap.xml']) {
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
  await context.close();
});
