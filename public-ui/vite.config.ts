import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
// import { urbitPlugin } from "@urbit/vite-plugin-urbit";

import path = require("path");

import dotenv = require("dotenv");
dotenv.config();
// const target = process.env.VITE_URBIT_TARGET;
// const base = process.env.VITE_URBIT_DESK;

export default defineConfig({
  base: '/login/',
  plugins: [vue()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  build: {
    chunkSizeWarningLimit: 600,
    cssCodeSplit: false,
    rollupOptions: {
      output: {
        entryFileNames: `assets/[name].js`,
        chunkFileNames: `assets/[name].js`,
        assetFileNames: `assets/[name].[ext]`
      }
    }
  },
});
