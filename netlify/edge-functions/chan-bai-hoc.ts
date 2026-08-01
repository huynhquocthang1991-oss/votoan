/* Chặn truy cập trang bài học khi chưa đăng nhập.
 *
 * Hàm này chạy TRÊN MÁY CHỦ BIÊN, trước khi Netlify phát file tĩnh ra.
 * Chưa đăng nhập thì file bài học không bao giờ rời khỏi máy chủ — khác hẳn
 * cách chặn bằng JS (file đã nằm trong máy người xem rồi mới chặn, nên curl
 * và tắt JavaScript đều lách được).
 *
 * Token đi kèm bằng cookie "vt-token", do assets/lop-hoc.js ghi mỗi khi phiên
 * Supabase đổi. localStorage máy chủ không đọc được nên bắt buộc phải có cookie.
 *
 * Cấu hình bật/tắt nằm ở netlify.toml, mục [[edge_functions]].
 */

const URL_SUPABASE = 'https://nbyiytegndhnfkhxhlmy.supabase.co';
// Khoá công khai, giống hệt assets/lop-hoc-cauhinh.js. Sửa một nơi thì sửa cả hai.
// Cố ý KHÔNG đọc từ biến môi trường: quên đặt biến là khoá cả thầy lẫn trò ra ngoài.
const ANON_KEY = 'sb_publishable_dadQiQuN0Gugk3Ltve4FAw_ZXIqeOu4';

const TRANG_DANG_NHAP = '/lop-hoc/dang-nhap.html';

/* Nhớ tạm kết quả kiểm token để không gọi Supabase mỗi lần tải ảnh/CSS trong bài.
   Máy chủ biên sống ngắn nên bộ nhớ này tự rỗng, không cần dọn. */
const daKiem = new Map<string, { hopLe: boolean; hetHan: number }>();
const HAN_NHO = 60_000; // 1 phút

function layCookie(header: string | null, ten: string): string | null {
  if (!header) return null;
  for (const phan of header.split(';')) {
    const dau = phan.indexOf('=');
    if (dau < 0) continue;
    if (phan.slice(0, dau).trim() === ten) {
      return decodeURIComponent(phan.slice(dau + 1).trim());
    }
  }
  return null;
}

async function tokenHopLe(token: string): Promise<boolean> {
  const nho = daKiem.get(token);
  if (nho && nho.hetHan > Date.now()) return nho.hopLe;

  let hopLe = false;
  try {
    /* Hỏi thẳng Supabase thay vì tự kiểm chữ ký: cách này đúng với mọi kiểu
       ký (HS256 hay khoá bất đối xứng) và không cần giữ bí mật nào ở đây. */
    const dap = await fetch(URL_SUPABASE + '/auth/v1/user', {
      headers: { Authorization: 'Bearer ' + token, apikey: ANON_KEY },
    });
    hopLe = dap.status === 200;
  } catch {
    /* Mất mạng tới Supabase thì coi như chưa đăng nhập. Chặn nhầm còn hơn
       lọt nhầm — đây là lớp bảo vệ, không phải tính năng tiện lợi. */
    hopLe = false;
  }

  daKiem.set(token, { hopLe, hetHan: Date.now() + HAN_NHO });
  return hopLe;
}

function duoiVeDangNhap(req: Request): Response {
  const dia = new URL(req.url);
  const ve = dia.pathname + dia.search;
  const den = new URL(TRANG_DANG_NHAP, dia.origin);
  den.searchParams.set('returnTo', ve);

  return new Response(null, {
    status: 302,
    headers: {
      Location: den.toString(),
      // Token hỏng thì xoá luôn, tránh lặp vô hạn giữa hai trang
      'Set-Cookie': 'vt-token=; Path=/; Max-Age=0; SameSite=Lax',
      // Không cho CDN nhớ bản chuyển hướng này
      'Cache-Control': 'no-store',
    },
  });
}

export default async function (req: Request, ctx: { next: () => Promise<Response> }) {
  const token = layCookie(req.headers.get('cookie'), 'vt-token');
  if (!token) return duoiVeDangNhap(req);
  if (!(await tokenHopLe(token))) return duoiVeDangNhap(req);

  const dap = await ctx.next();
  /* Bài học là nội dung riêng cho từng người đã đăng nhập — cấm CDN và trình
     duyệt giữ bản dùng chung, không thì người chưa đăng nhập ăn phải bản nhớ. */
  const ra = new Response(dap.body, dap);
  ra.headers.set('Cache-Control', 'private, no-store');
  return ra;
}

/* Cố ý KHÔNG khai `export const config` ở đây. Khai cả hai nơi (file và
   netlify.toml) là đăng ký hai lần. Đường dẫn chỉ khai ở netlify.toml. */
