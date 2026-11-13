import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://opsmaru.dev',
  output: 'static',
  vite: {
    plugins: [tailwindcss()],
    // Keep scripts external so Workers can enforce script-src 'self'.
    build: { assetsInlineLimit: 0 },
  },
});
