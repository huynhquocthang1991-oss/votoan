/* Cấu hình phần lớp học.
 *
 * Hai giá trị dưới đây LẤY TỪ Supabase → Settings → API. Cả hai đều CÔNG KHAI,
 * nằm trong file này là đúng chỗ, không phải bí mật:
 *   URL       địa chỉ dự án
 *   ANON_KEY  khoá ẩn danh — mọi quyền vẫn do RLS quyết định
 *
 * KHÔNG BAO GIỜ dán vào đây:
 *   service_role key   — mở toang mọi bảng, bỏ qua RLS
 *   khoá API của model — xem CAI_DAT.md bước 5, nó nằm ở Supabase Secrets
 *
 * Để trống thì web chạy y như cũ, chỉ không có phần lớp học.
 */
window.LOP_HOC_CAUHINH = {
  URL: '',
  ANON_KEY: ''
};
