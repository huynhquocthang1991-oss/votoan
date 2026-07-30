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
