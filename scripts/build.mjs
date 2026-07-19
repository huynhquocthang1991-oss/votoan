import { mkdir, readFile, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const projectDir = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const distDir = resolve(projectDir, "dist");
const html = await readFile(resolve(projectDir, "index.html"), "utf8");
const worker = `const html = ${JSON.stringify(html)};

export default {
  async fetch(request) {
    const url = new URL(request.url);
    if (url.pathname !== "/" && url.pathname !== "/index.html") {
      return new Response("Không tìm thấy trang", {
        status: 404,
        headers: { "content-type": "text/plain; charset=UTF-8" }
      });
    }

    return new Response(html, {
      headers: {
        "content-type": "text/html; charset=UTF-8",
        "cache-control": "public, max-age=300"
      }
    });
  }
};
`;

await rm(distDir, { recursive: true, force: true });
await mkdir(resolve(distDir, "server"), { recursive: true });
await writeFile(resolve(distDir, "server/index.js"), worker);
console.log("Built Vở Toán for deployment.");
