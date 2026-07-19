import { mkdir, readFile, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const projectDir = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const distDir = resolve(projectDir, "dist");
const homeHtml = await readFile(resolve(projectDir, "index.html"), "utf8");
const lessonHtml = await readFile(
  resolve(projectDir, "bai-hoc/lop-8/chuong-01/bai-01/index.html"),
  "utf8",
);
const worker = `const pages = new Map([
  ["/", ${JSON.stringify(homeHtml)}],
  ["/index.html", ${JSON.stringify(homeHtml)}],
  ["/bai-hoc/lop-8/chuong-01/bai-01", ${JSON.stringify(lessonHtml)}],
  ["/bai-hoc/lop-8/chuong-01/bai-01/", ${JSON.stringify(lessonHtml)}],
  ["/bai-hoc/lop-8/chuong-01/bai-01/index.html", ${JSON.stringify(lessonHtml)}]
]);

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const html = pages.get(url.pathname);
    if (!html) {
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
