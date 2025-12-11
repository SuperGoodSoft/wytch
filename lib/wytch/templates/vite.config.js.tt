import { defineConfig } from "vite";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";

export default defineConfig({
  plugins: [
    createReScriptPlugin({
      loader: {
        suffix: ".res.js",
      },
    }),
  ],
  build: {
    outDir: "build",
    manifest: true,
    rollupOptions: {
      input: {
        main: "./assets/main.css",
        app: "./assets/Main.res",
      },
    },
  },
  server: {
    port: 6970,
    strictPort: false,
  },
});
