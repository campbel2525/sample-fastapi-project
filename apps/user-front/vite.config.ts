import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import path from 'path';

export default defineConfig({
  plugins: [sveltekit()],
  resolve: {
    alias: {
      '@api': path.resolve('./src/api'),
      '@config': path.resolve('./src/config'),
      '@schemas': path.resolve('./src/schemas'),
      '@components': path.resolve('./src/components'),
      '@stores': path.resolve('./src/stores'),
    },
  },
});
