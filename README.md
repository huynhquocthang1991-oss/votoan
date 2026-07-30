# Vở Toán

Mã nguồn trang https://votoan.netlify.app — bài học Toán THCS bám sát bộ sách
Kết nối tri thức, đọc được trên điện thoại và máy tính, miễn phí, không quảng cáo.

## Cấu trúc

| Thư mục | Nội dung |
| --- | --- |
| `index.html` | Trang chủ |
| `bai-hoc/lop-*/` | Bài học, mỗi bài một thư mục riêng |
| `lop-hoc/` | Phần lớp học: đăng nhập, bảng giáo viên, duyệt tài khoản |
| `assets/` | CSS, JS, ảnh, game |
| `netlify.toml` | Cấu hình deploy |

Trang tĩnh thuần, không có bước build. Netlify lấy thẳng thư mục gốc của repo
(`publish = "."`), mỗi lần đẩy lên nhánh `main` là tự deploy.

## Phần lớp học

Mặc định **tắt**. Muốn bật thì điền hai giá trị công khai của dự án Supabase vào
`assets/lop-hoc-cauhinh.js`:

```js
window.LOP_HOC_CAUHINH = {
  URL: 'https://<mã-dự-án>.supabase.co',
  ANON_KEY: '<khoá ẩn danh>'
};
```

Chưa điền thì trang bài học chạy y hệt như cũ, chỉ không có phần nộp bài.
Không bao giờ để `service_role` key hay khoá API của model vào repo này —
chúng nằm ở Supabase Secrets. Các bước cài đặt đầy đủ xem `lop-hoc/CAI_DAT.md`
trong dự án gốc.

### Luồng vào lớp học

- Học sinh chọn bài từ trang chủ. Khi đăng nhập bằng mã và mật khẩu tại
  `/lop-hoc/dang-nhap.html`, em được đưa trở lại đúng trang đang học.
- Giáo viên dùng nút đăng nhập chung, xác thực bằng Google và được đưa tới
  `/lop-hoc/giao-vien.html` sau khi tài khoản đã được duyệt.
- Quản trị viên không có lối vào công khai riêng. Tài khoản có `la_admin = true`
  dùng cùng luồng Google; hệ thống tự chuyển tới `/lop-hoc/admin.html`. Liên kết
  Quản trị chỉ hiện sau khi vai trò đã được xác nhận.
