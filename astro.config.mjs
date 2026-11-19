import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://opsmaru.dev',
  output: 'static',
  // Emit /macus as macus.html so Workers Static Assets serves the clean /macus URL.
  trailingSlash: 'never',
  build: { format: 'file' },
  vite: {
    plugins: [tailwindcss()],
    // Keep scripts external so Workers can enforce script-src 'self'.
    build: { assetsInlineLimit: 0 },
  },
});
