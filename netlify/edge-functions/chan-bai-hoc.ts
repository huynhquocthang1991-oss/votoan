/* Chặn truy cập trang bài học — theo ĐĂNG NHẬP, theo VAI, và theo KHỐI.
 *
 * Hàm này chạy TRÊN MÁY CHỦ BIÊN, trước khi Netlify phát file tĩnh ra.
 * Chưa đủ quyền thì file không bao giờ rời khỏi máy chủ — khác hẳn cách chặn
 * bằng JS (file đã nằm trong máy người xem rồi mới chặn, nên curl và tắt
 * JavaScript đều lách được).
 *
 * Ba lớp luật, xét theo đúng thứ tự này:
 *
 *   1. Chưa đăng nhập          → đuổi về trang đăng nhập.
 *   2. Học sinh khối nào chỉ vào được học liệu khối đó.
 *   3. index.html / trinh-chieu.html của MỘT BÀI → chỉ giáo viên.
 *      Học sinh học trên hoc.html, là bản rút gọn sinh ra từ chính index.html
 *      (tools/tach_ban_hoc_sinh.py). Học sinh gõ tay đường dẫn index.html thì
 *      được chuyển sang hoc.html chứ không nhận mặt lỗi — em không làm gì sai.
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

type HoSo = { vaiTro: string; khoi: number | null };

/* Trả về khi RPC ho_so_dang_nhap KHÔNG TỒN TẠI, tức migration 005 chưa chạy mà
 * web đã lên. Phải tách khỏi "token hỏng": token hỏng thì đuổi về đăng nhập là
 * đúng, còn thiếu hàm thì đuổi về đăng nhập là VÒNG VÔ HẠN — đăng nhập xong
 * quay lại vẫn thiếu hàm, lại bị đuổi, cả thầy lẫn trò không vào được bài nào
 * và trên màn hình không có lấy một chữ nói vì sao. */
const CHUA_CAI_DAT: HoSo = { vaiTro: 'chua_cai_dat', khoi: null };

/* Nhớ tạm kết quả kiểm token để không gọi Supabase mỗi lần tải ảnh/CSS trong bài.
   Máy chủ biên sống ngắn nên bộ nhớ này tự rỗng, không cần dọn. */
const daKiem = new Map<string, { hoSo: HoSo | null; hetHan: number }>();
const HAN_NHO = 60_000; // 1 phút

/* Trang của MỘT BÀI: /bai-hoc/lop-8/chuong-01/bai-01/<tên file>
 *
 * Bẫy suýt dẫm: /bai-hoc/lop-8/index.html cũng tên index.html nhưng là MỤC LỤC
 * LỚP, không phải bài. Chặn nhầm nó là học sinh mất luôn đường vào mọi bài.
 * Vì vậy phải khớp đủ ba tầng lop-N / chuong-NN / bai-NN.
 */
const RE_TRANG_BAI = /^\/bai-hoc\/lop-\d+\/chuong-\d+\/bai-\d+\/([^/]*)$/;
/* Mọi đường dẫn dưới /bai-hoc/lop-N/, kể cả mục lục lớp lẫn file trong bài. */
const RE_KHOI = /^\/bai-hoc\/lop-(\d+)(\/|$)/;

/* Chỉ giáo viên: trang bài học đầy đủ và slide đứng lớp. Chuỗi rỗng là khi
   người dùng mở thư mục bài (…/bai-01/), Netlify sẽ phát index.html ra. */
const CHI_GIAO_VIEN = new Set(['index.html', '', 'trinh-chieu.html']);

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

/* Hỏi Supabase: token này là ai, và nếu là học sinh thì khối mấy.
   Trả null nghĩa là token hỏng hoặc hết hạn. */
async function hoiHoSo(token: string): Promise<HoSo | null> {
  const nho = daKiem.get(token);
  if (nho && nho.hetHan > Date.now()) return nho.hoSo;

  let hoSo: HoSo | null = null;
  try {
    /* Gọi RPC ho_so_dang_nhap (migration 005) thay vì tự kiểm chữ ký: cách này
       đúng với mọi kiểu ký, không cần giữ bí mật nào ở đây, và trả luôn cả vai
       lẫn khối trong MỘT vòng — máy chủ biên không nên gọi hai lần cho một
       trang. Token sai hoặc hết hạn thì Supabase trả 401, coi như chưa đăng nhập. */
    const dap = await fetch(URL_SUPABASE + '/rest/v1/rpc/ho_so_dang_nhap', {
      method: 'POST',
      headers: {
        Authorization: 'Bearer ' + token,
        apikey: ANON_KEY,
        'Content-Type': 'application/json',
      },
      body: '{}',
    });
    if (dap.status === 200) {
      const hang = await dap.json();
      const d = Array.isArray(hang) ? hang[0] : hang;
      if (d && d.vai_tro) {
        hoSo = {
          vaiTro: String(d.vai_tro),
          khoi: d.khoi === null || d.khoi === undefined ? null : Number(d.khoi),
        };
      }
    } else if (dap.status === 404) {
      /* PostgREST trả 404 khi hàm không có trong lược đồ. Token vẫn tốt, chỉ là
         database chưa chạy migration 005. Nói ra, đừng đuổi về đăng nhập. */
      hoSo = CHUA_CAI_DAT;
    }
  } catch {
    /* Mất mạng tới Supabase thì coi như chưa đăng nhập. Chặn nhầm còn hơn
       lọt nhầm — đây là lớp bảo vệ, không phải tính năng tiện lợi. */
    hoSo = null;
  }

  daKiem.set(token, { hoSo, hetHan: Date.now() + HAN_NHO });
  return hoSo;
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

/* Chuyển hướng mềm, KHÔNG xoá cookie: người dùng vẫn đăng nhập đàng hoàng,
   chỉ là đang gõ nhầm cửa. Xoá cookie ở đây là đá em ra khỏi phiên vì một
   đường dẫn gõ nhầm. */
function chuyenSang(dich: string): Response {
  return new Response(null, {
    status: 302,
    headers: { Location: dich, 'Cache-Control': 'no-store' },
  });
}

function tuChoi(loi: string): Response {
  return new Response(loi, {
    status: 403,
    headers: { 'Content-Type': 'text/plain; charset=utf-8', 'Cache-Control': 'no-store' },
  });
}

export default async function (req: Request, ctx: { next: () => Promise<Response> }) {
  const token = layCookie(req.headers.get('cookie'), 'vt-token');
  if (!token) return duoiVeDangNhap(req);

  const hoSo = await hoiHoSo(token);
  if (!hoSo) return duoiVeDangNhap(req);

  /* Database chưa có migration 005.
   *
   * Lùi về đúng cách cư xử CŨ: đã đăng nhập thì xem được, không phân vai không
   * phân khối. Cố ý không dựng tường lỗi ở đây, vì thứ tự triển khai thật là
   * "đẩy web trước, chạy SQL sau" cũng có thể xảy ra, và một cái tường 503 trên
   * mọi trang bài học thì tệ hơn hẳn so với việc tạm thời chưa siết vai — mức
   * chưa siết đó chính là mức web đang chạy hôm nay, không hở thêm gì cả.
   *
   * Luật vai và luật khối tự bật lên khi migration vào, chậm nhất sau HAN_NHO.
   * Gắn thêm một header để soi được từ ngoài mà không phải mở log. */
  if (hoSo.vaiTro === 'chua_cai_dat') {
    const dapCu = await ctx.next();
    const raCu = new Response(dapCu.body, dapCu);
    raCu.headers.set('Cache-Control', 'private, no-store');
    raCu.headers.set('X-Vo-Toan', 'thieu-migration-005');
    return raCu;
  }

  /* Giáo viên chờ duyệt / tài khoản khoá: đăng nhập được nhưng chưa có học liệu
     nào. Nói thẳng, đừng đá về trang đăng nhập rồi lại vào được — lặp vô hạn. */
  if (hoSo.vaiTro === 'chua_gan') {
    return tuChoi('Tài khoản chưa được duyệt. Thầy cô chờ quản trị viên duyệt giúp nhé.');
  }

  const duong = new URL(req.url).pathname;
  const laHocSinh = hoSo.vaiTro === 'hoc_sinh';

  if (laHocSinh) {
    /* Luật khối. Xét TRƯỚC luật vai: em lớp 8 gõ nhầm sang bài lớp 9 thì phải
       về mục lục lớp 8, chứ không phải sang hoc.html của bài lớp 9. */
    const mKhoi = RE_KHOI.exec(duong);
    if (mKhoi && hoSo.khoi !== null && Number(mKhoi[1]) !== hoSo.khoi) {
      return chuyenSang(`/bai-hoc/lop-${hoSo.khoi}/`);
    }

    /* Luật vai: trang bài học đầy đủ và trình chiếu là của thầy cô. */
    const mBai = RE_TRANG_BAI.exec(duong);
    if (mBai && CHI_GIAO_VIEN.has(mBai[1])) {
      const thuMuc = duong.slice(0, duong.lastIndexOf('/') + 1);
      return chuyenSang(thuMuc + 'hoc.html');
    }
  }

  const dap = await ctx.next();
  /* Bài học là nội dung riêng cho từng người đã đăng nhập — cấm CDN và trình
     duyệt giữ bản dùng chung, không thì người chưa đăng nhập ăn phải bản nhớ.
     Càng đúng hơn từ khi cùng một đường dẫn trả kết quả khác nhau theo vai. */
  const ra = new Response(dap.body, dap);
  ra.headers.set('Cache-Control', 'private, no-store');
  ra.headers.set('Vary', 'Cookie');
  return ra;
}

/* Cố ý KHÔNG khai `export const config` ở đây. Khai cả hai nơi (file và
   netlify.toml) là đăng ký hai lần. Đường dẫn chỉ khai ở netlify.toml. */
