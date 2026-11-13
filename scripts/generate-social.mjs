import { chromium } from '@playwright/test';
import { readFile } from 'node:fs/promises';

const logo = (await readFile(new URL('../public/images/opsmaru-logo.svg', import.meta.url))).toString('base64');
const font = (await readFile(new URL('../node_modules/@fontsource-variable/space-grotesk/files/space-grotesk-latin-wght-normal.woff2', import.meta.url))).toString('base64');
const browser = await chromium.launch();
try {
  const page = await browser.newPage({ viewport: { width: 1200, height: 630 }, deviceScaleFactor: 1 });
  await page.setContent(`<!doctype html><html><head><style>
    @font-face { font-family: Space; src: url(data:font/woff2;base64,${font}); font-weight: 300 700; }
    * { box-sizing: border-box; }
    body { margin: 0; width: 1200px; height: 630px; background: #0f1729; color: #e7edf7; font-family: Space, sans-serif; padding: 54px 65px; position: relative; overflow: hidden; }
    .brand { display: flex; align-items: center; gap: 13px; font-size: 35px; font-weight: 600; letter-spacing: -1.5px; }
    .brand img { width: 44px; height: 44px; }
    .dot { color: #38bdf8; }
    h1 { font-size: 78px; line-height: 1.03; letter-spacing: -4px; font-weight: 500; margin: 43px 0 22px; position: relative; z-index: 1; }
    h1 span { background: linear-gradient(100deg, #7a9cff, #52ceff, #72e4ed); background-clip: text; -webkit-text-fill-color: transparent; }
    p { color: #adbed5; font-size: 23px; margin: 0; position: relative; z-index: 1; }
    footer { position: absolute; bottom: 40px; left: 65px; right: 65px; padding-top: 22px; border-top: 1px solid #ffffff18; display: flex; justify-content: space-between; font: 13px monospace; color: #91a5c0; }
    .orbit { width: 510px; height: 510px; border: 1px solid #4d8bc430; position: absolute; right: -80px; top: 30px; border-radius: 50%; display: grid; place-items: center; background: radial-gradient(#2773a21c, transparent 68%); }
    .orbit::before { content: ''; position: absolute; width: 340px; height: 340px; border: 1px solid #4d8bc430; border-radius: 50%; }
    .orbit img { width: 180px; height: 180px; opacity: .7; }
  </style></head><body>
    <div class="brand"><img src="data:image/svg+xml;base64,${logo}" alt="" />opsmaru<span class="dot">.</span></div>
    <h1>The universal compute<br />substrate <span>for agents.</span></h1>
    <p>A safe place to do real work.</p>
    <div class="orbit"><img src="data:image/svg+xml;base64,${logo}" alt="" /></div>
    <footer><span>LOCAL TO CLOUD. NORMALIZED BY INCUS.</span><span>opsmaru.dev</span></footer>
  </body></html>`);
  await page.evaluate(() => document.fonts.ready);
  await page.screenshot({ path: new URL('../public/images/social-card.png', import.meta.url).pathname });
} finally {
  await browser.close();
}
