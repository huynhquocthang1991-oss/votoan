// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Luyện tập chung (tr.25–26) (Toán 8)
//  Nền vở ô ly 5mm · chữ 13.5pt · dòng chấm · in nhẹ mực (ít nền đặc).
//  Pitch dòng viết = cỡ chữ HS giả định 14pt + 25% chỗ thừa = 17,5pt (≈6,17mm).
//  Biên dịch:
//    PYTHONPATH="$HOME/Library/Python/3.9/lib/python/site-packages" python3 -c "import typst; typst.compile('phieu-hoc-tap.typ', output='phieu-hoc-tap.pdf', font_paths=['$HOME/Library/Fonts'])"
// ══════════════════════════════════════════════════════════════════

// ── Màu (in nhẹ: hạn chế nền đặc, xanh chỉ dùng ở nét mảnh) ────────
#let primary   = rgb("#1f3fd4")
#let primaryd  = rgb("#15288f")
#let tint      = rgb("#eef1fe")
#let ink       = rgb("#1a2438")
#let muted     = rgb("#5a6880")
#let hair      = rgb("#dbe2ee")
#let dotc      = rgb("#9aa8c2")     // màu dòng chấm để viết
#let gridc     = rgb("#e6eaf2")     // màu kẻ ô ly (xám nhạt, in nhẹ)
#let c-vd      = primary
#let c-lt      = rgb("#0e7c6b")
#let c-tl      = rgb("#6d28d9")
#let c-vdung   = rgb("#b45309")
#let c-bt      = rgb("#be123c")
#let display   = "Bricolage Grotesque"

// ── Nền vở ô ly 5mm ───────────────────────────────────────────────
#let oly = tiling(size: (5mm, 5mm))[
  #box(width: 5mm, height: 5mm, fill: rgb("#fdfefe"),
       stroke: (paint: gridc, thickness: 0.25pt))
]

// ── Trang ─────────────────────────────────────────────────────────
#set page(
  paper: "a4",
  margin: (x: 12mm, top: 11mm, bottom: 12mm),
  fill: oly,
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 9pt, fill: muted)
      grid(columns: (1fr, auto),
        [Luyện tập chung (tr.25–26) — Phiếu học tập], [Toán 8])
      v(-1mm)
      line(length: 100%, stroke: 0.5pt + hair)
    }
  },
  footer: context {
    set text(size: 9pt, fill: muted)
    align(center)[Trang #counter(page).display() / #counter(page).final().first()]
  },
)

#set text(font: ("Be Vietnam Pro", "Helvetica Neue", "Arial"),
  size: 13.5pt, weight: "regular", fill: ink, lang: "vi")
#set par(leading: 0.52em, justify: false)
#set block(spacing: 1.2mm)
#show math.equation: set text(font: ("STIX Two Math", "New Computer Modern Math"))
// dfrac: phân số kiểu display (to, xếp chồng) + box để không ngắt công thức qua 2 dòng
#show math.equation.where(block: false): it => box(math.display(it))
#let dc(s) = math.text(s)

// ── Dòng kẻ chấm để viết (pitch chuẩn 17,5pt ≈ 6,17mm) ───────────
#let lh = 17.5pt
#let dline = block(width: 100%, height: lh, above: 0pt, below: 0pt,
  place(bottom + left, dy: -0.9mm,
    line(length: 100%, stroke: (paint: dotc, thickness: 1pt, dash: "dotted"))))
#let dots(n) = { v(1mm); for _ in range(n) { dline } }
#let moredots(n) = { for _ in range(n) { dline } }

// ── Chip nhãn ─────────────────────────────────────────────────────
#let tag(col, label) = box(fill: col, radius: 1.6mm, inset: (x: 2.8mm, y: 1.3mm),
  baseline: 0.26em,
  text(fill: white, font: display, weight: 700, size: 10pt, tracking: 0.04em,
    top-edge: "bounds", bottom-edge: "bounds")[#upper(label)])

// ── Tiêu đề mục / mục con ─────────────────────────────────────────
#let sec(num, title) = {
  v(1.6mm)
  block(breakable: false, grid(columns: (auto, auto, 1fr), gutter: 2.8mm, align: horizon,
    box(fill: primary, radius: 2mm, inset: (x: 2.6mm, y: 1.3mm),
      text(fill: white, font: display, weight: 800, size: 13pt, num)),
    text(font: display, weight: 800, size: 15pt, fill: ink)[#upper(title)],
    line(length: 100%, stroke: 0.7pt + hair)))
  v(0.4mm)
}
#let sub(title) = {
  v(1mm)
  block(breakable: false, grid(columns: (auto, 1fr), gutter: 2.4mm, align: horizon,
    box(width: 2.2mm, height: 2.2mm, fill: primary, radius: 0.5mm),
    text(font: display, weight: 700, size: 13pt, fill: primaryd, title)))
  v(0.2mm)
}

// ── Bài tập một phần: nhãn + đề rồi dòng chấm ─────────────────────
#let prob(col, label, body, n) = {
  v(1.4mm)
  block(breakable: false, { tag(col, label); h(2mm); body })
  if n > 0 { dots(n) }
}
// ── Bài tập nhiều câu a) b): MỖI CÂU MỘT DÒNG, chỗ viết riêng ─────
#let probm(col, label, stem, ..parts) = {
  v(1.4mm)
  block(breakable: false, { tag(col, label); h(2mm); stem })
  for p in parts.pos() {
    let (pl, pt, pn) = p
    block(breakable: false, above: 1.2mm, {
      grid(columns: (auto, 1fr), gutter: 1.8mm, align: (top, top),
        text(weight: 700, fill: primaryd, pl), pt)
    })
    if pn > 0 { dots(pn) }
  }
}

// ── Khung ghi lý thuyết (để trống cho HS tự ghi) ─────────────────
#let lythuyet(..items) = {
  v(1.2mm)
  block(width: 100%, fill: tint, radius: 3mm, inset: (x: 4mm, y: 3mm),
    stroke: (left: 1.3mm + primary), breakable: true, {
    text(font: display, weight: 800, size: 10pt, fill: primary, tracking: 0.1em)[#upper("Lý thuyết — Em tự ghi")]
    for it in items.pos() {
      let (label, n) = it
      v(1.4mm)
      text(weight: 600, size: 13pt, fill: ink, label)
      dots(n)
    }
  })
}

// ── Ô điền dòng chấm ngắn ─────────────────────────────────────────
#let udots = box(width: 100%, height: 1.4em,
  place(bottom, line(length: 100%, stroke: (paint: dotc, thickness: 1pt, dash: "dotted"))))

// ══════════════════════════════════════════════════════════════════
//  ĐẦU PHIẾU (bản in nhẹ: nền phớt xanh + nẹp trái, không nền đặc)
// ══════════════════════════════════════════════════════════════════
#block(width: 100%, radius: 3mm, inset: (x: 6mm, y: 5mm),
  fill: tint, stroke: (left: 3mm + primary),
  grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
    {
      text(fill: primary, font: display, weight: 700, size: 10pt, tracking: 0.18em)[#upper("Phiếu học tập")]
      v(1.4mm)
      text(fill: primaryd, font: display, weight: 800, size: 24pt)[Luyện tập chung (tr.25–26)]
      v(1.2mm)
      text(fill: muted, size: 11.5pt)[Toán 8 · Chương I — Đa thức]
    },
    text(font: display, weight: 800, size: 42pt, fill: primary.transparentize(72%))[07]))

#v(2mm)
#block(breakable: false, grid(columns: (1.7fr, 0.7fr, 1.1fr), gutter: 5mm, align: bottom,
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Họ và tên], udots),
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Lớp], udots),
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Ngày], udots)))

// ══════════════════════════════════════════════════════════════════
//  MỤC 1 — KIẾN THỨC CẦN NHỚ
// ══════════════════════════════════════════════════════════════════
#sec("1", "Kiến thức cần nhớ")

#sub("Phối hợp phép nhân, phép chia và tìm thành phần chưa biết")
#lythuyet(
  ([*Nhân đa thức:* (nhân từng hạng tử thế nào? cuối cùng làm gì?)], 3),
  ([*Chia cho đơn thức:* (muốn chia hết thì sao? chia từng hạng tử thế nào?)], 3),
  ([*Tìm thành phần chưa biết:* (biết $M \cdot B = A$ thì tìm $M$ thế nào? biết $A : M = Q$ thì tìm $M$ thế nào?)], 3))

#prob(c-vd, "Ví dụ 1", [Rút gọn biểu thức $T = (5x y - 4y^2)(3x^2 + 4x y) - 15x y(x + y)(x - y)$. Tìm đa thức $D$ sao cho $T : D = x y^2$.], 7)

#probm(c-vd, "Ví dụ 2", [Cho đa thức $A = 2x^2 y^2 - 5x y^3$ và đơn thức $B = 3x^m y^2$, với $m$ là số tự nhiên.],
  ("a)", [Tìm số nguyên dương $m$ sao cho $A$ chia hết cho $B$.], 5),
  ("b)", [Với giá trị tìm được của $m$, hãy thực hiện phép chia $A : B$.], 5))

// ══════════════════════════════════════════════════════════════════
//  BÀI TẬP (SGK tr.25–26)
// ══════════════════════════════════════════════════════════════════
#sec("BT", "Bài tập (SGK tr.25–26)")

#probm(c-bt, "Bài 1.33", [Cho biểu thức $P = 5x(3x^2 y - 2x y^2 + 1) - 3x y(5x^2 - 3x y) + x^2 y^2$.],
  ("a)", [Bằng cách thu gọn, chứng tỏ rằng giá trị của biểu thức $P$ chỉ phụ thuộc vào biến $x$, không phụ thuộc vào biến $y$.], 6),
  ("b)", [Tìm giá trị của $x$ sao cho $P = 10$.], 4))

#prob(c-bt, "Bài 1.34", [Rút gọn biểu thức $(3x^2 - 5x y - 4y^2)(2x^2 + y^2) + (2x^4 y^2 + x^3 y^3 + x^2 y^4) : (1/5 x y)$.], 10)

#prob(c-bt, "Bài 1.35", [Bà Khanh dự định mua $x$ hộp sữa, mỗi hộp giá $y$ đồng. Khi đến cửa hàng, bà thấy giá sữa đã giảm $1 500$ đồng mỗi hộp nên quyết định mua thêm $3$ hộp. Tìm đa thức biểu thị số tiền bà Khanh phải trả.], 6)

#probm(c-bt, "Bài 1.36", [],
  ("a)", [Tìm đơn thức $B$ nếu $4x^3 y^2 : B = -2x y$.], 5),
  ("b)", [Với đơn thức $B$ tìm được ở câu a, hãy tìm đơn thức $H$ để $(4x^3 y^2 - 3x^2 y^3) : B = -2x y + H$.], 7))

#probm(c-bt, "Bài 1.37", [],
  ("a)", [Tìm đơn thức $C$ nếu $5x y^2 \cdot C = 10x^3 y^3$.], 5),
  ("b)", [Với đơn thức $C$ tìm được ở câu a, hãy tìm đơn thức $K$ sao cho $(K + 5x y^2) \cdot C = 6x^4 y + 10x^3 y^3$.], 7))

#probm(c-bt, "Bài 1.38", [Thỏ chạy nhanh gấp 60 lần Rùa nhưng chỉ chạy trong $t$ phút rồi dừng lại. Rùa chạy liên tục trong $90t$ phút và đến đích trước Thỏ.],
  ("a)", [Gọi $v$ (m/phút) là vận tốc của Rùa. Viết các đơn thức biểu thị quãng đường Thỏ và Rùa đã chạy.], 4),
  ("b)", [Quãng đường Rùa chạy dài gấp bao nhiêu lần quãng đường Thỏ chạy?], 4))

// ── Kết phiếu: tự đánh giá · nhận xét ──────────────────────────────
#let chk(t) = box[#box(width: 3.4mm, height: 3.4mm, radius: 0.8mm,
  stroke: 1.2pt + muted, baseline: 0.18em)#h(1.6mm)#text(size: 12pt, t)]
#v(2.6mm)
#block(width: 100%, breakable: false, stroke: 0.8pt + hair, radius: 3mm, clip: true, {
  block(width: 100%, fill: tint, inset: (x: 4mm, y: 2.4mm),
    text(font: display, weight: 800, size: 10.5pt, fill: primaryd, tracking: 0.08em)[
      #upper("Tự đánh giá · Nhận xét của giáo viên")])
  block(width: 100%, inset: (x: 4mm, y: 3mm), {
    grid(columns: (auto, 1fr), gutter: 4mm, align: horizon,
      text(weight: 600, size: 12pt)[Em tự đánh giá:],
      { chk[Hoàn thành tốt]; h(6mm); chk[Hoàn thành]; h(6mm); chk[Cần cố gắng] })
    v(2.6mm)
    text(weight: 600, size: 12pt, fill: muted)[Nhận xét của giáo viên]
    moredots(5)
    v(3mm)
    grid(columns: (1fr, 1.1fr), gutter: 6mm, align: (left + top, center + top),
      grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
        text(weight: 600, size: 12pt, fill: muted)[Điểm], udots),
      align(center, {
        text(weight: 600, size: 12pt, fill: muted)[Chữ ký của giáo viên]
        v(18mm)   // chừa nhiều chỗ cho GV ký
      }))
  })
})
