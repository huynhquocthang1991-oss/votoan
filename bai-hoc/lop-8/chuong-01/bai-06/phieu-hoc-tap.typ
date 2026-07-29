// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Bài 5. Phép chia đa thức cho đơn thức (Toán 8)
//  Nền vở ô ly 5mm · chữ 13pt · dòng chấm · in nhẹ mực (ít nền đặc).
//  Mọi dòng viết dùng cùng pitch 7mm; tăng chỗ viết bằng số dòng.
//  Biên dịch:
//    python3 -c "import typst;typst.compile('phieu-hoc-tap.typ',
//               output='phieu-hoc-tap.pdf',
//               font_paths=['$HOME/Library/Fonts'])"
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
        [Bài 5. Phép chia đa thức cho đơn thức — Phiếu học tập], [Toán 8])
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
  size: 13.2pt, weight: "regular", fill: ink, lang: "vi")
#set par(leading: 0.52em, justify: false)
#set block(spacing: 1.2mm)
#show math.equation: set text(font: ("STIX Two Math", "New Computer Modern Math"))
// dfrac: phân số kiểu display (to, xếp chồng) + box để không ngắt công thức qua 2 dòng
#show math.equation.where(block: false): it => box(math.display(it))
#let dc(s) = math.text(s)

// ── Dòng kẻ chấm để viết (thống nhất toàn phiếu: pitch 7mm) ───────
#let lh = 7mm
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
  v(1mm)
  block(breakable: false, grid(columns: (auto, auto, 1fr), gutter: 2.8mm, align: horizon,
    box(fill: primary, radius: 2mm, inset: (x: 2.6mm, y: 1.3mm),
      text(fill: white, font: display, weight: 800, size: 13pt, num)),
    text(font: display, weight: 800, size: 15pt, fill: ink)[#upper(title)],
    line(length: 100%, stroke: 0.7pt + hair)))
  v(0.2mm)
}
#let sub(title) = {
  v(0.6mm)
  block(breakable: false, grid(columns: (auto, 1fr), gutter: 2.4mm, align: horizon,
    box(width: 2.2mm, height: 2.2mm, fill: primary, radius: 0.5mm),
    text(font: display, weight: 700, size: 13pt, fill: primaryd, title)))
}

// ── Bài tập một phần: nhãn + đề rồi dòng chấm ─────────────────────
#let prob(col, label, body, n) = {
  v(1mm)
  block(breakable: false, {
    tag(col, label); h(2mm); body
    if n > 0 { dots(1) }
    if n > 1 { moredots(n - 1) }
  })
}
// ── Bài tập nhiều câu a) b): MỖI CÂU MỘT DÒNG, chỗ viết riêng ─────
#let probm(col, label, stem, ..parts) = {
  v(1mm)
  block(breakable: false, { tag(col, label); h(2mm); stem })
  for p in parts.pos() {
    let (pl, pt, pn) = p
    block(breakable: false, above: 1mm, {
      grid(columns: (auto, 1fr), gutter: 1.8mm, align: (top, top),
        text(weight: 700, fill: primaryd, pl), pt)
      if pn > 0 { dots(1) }
      if pn > 1 { moredots(pn - 1) }
    })
  }
}

// ── Khung ghi lý thuyết (để trống cho HS tự ghi) ─────────────────
#let lythuyet(..items) = {
  v(0.6mm)
  block(width: 100%, fill: tint, radius: 3mm, inset: (x: 3.5mm, y: 2.5mm),
    stroke: (left: 1.3mm + primary), breakable: true, {
    text(font: display, weight: 800, size: 10pt, fill: primary, tracking: 0.1em)[#upper("Lý thuyết")]
    for it in items.pos() {
      let (label, n) = it
      v(1.3mm)
      text(weight: 600, size: 13pt, fill: ink, label)
      dots(n)
    }
  })
}

// ── Bảng làm bài ──────────────────────────────────────────────────
#let hcell(t) = table.cell(fill: tint, align: center + horizon,
  text(fill: primaryd, weight: 700, size: 11.5pt, t))

// ── Ô điền dòng chấm ngắn ─────────────────────────────────────────
#let udots = box(width: 100%, height: 1.4em,
  place(bottom, line(length: 100%, stroke: (paint: dotc, thickness: 1pt, dash: "dotted"))))

// ══════════════════════════════════════════════════════════════════
//  ĐẦU PHIẾU (bản in nhẹ: nền phớt xanh + nẹp trái, không nền đặc)
// ══════════════════════════════════════════════════════════════════
#block(width: 100%, radius: 3mm, inset: (x: 5mm, y: 3.5mm),
  fill: tint, stroke: (left: 3mm + primary),
  grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
    {
      text(fill: primary, font: display, weight: 700, size: 10pt, tracking: 0.18em)[#upper("Phiếu học tập")]
      v(0.7mm)
      text(fill: primaryd, font: display, weight: 800, size: 22pt)[Bài 5. Phép chia đa thức cho đơn thức]
      v(0.6mm)
      text(fill: muted, size: 11.5pt)[Toán 8 · Chương I — Đa thức]
    },
    text(font: display, weight: 800, size: 38pt, fill: primary.transparentize(72%))[05]))

#v(0.8mm)
#block(breakable: false, grid(columns: (1.7fr, 0.7fr, 1.1fr), gutter: 5mm, align: bottom,
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Họ và tên], udots),
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Lớp], udots),
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Ngày], udots)))

// ══════════════════════════════════════════════════════════════════
//  MỤC 1
// ══════════════════════════════════════════════════════════════════
#sec("1", "Chia đơn thức cho đơn thức")

#sub("Khái niệm chia hết · Cách chia")
#lythuyet(
  ([*Đơn thức* $A$ chia hết cho *đơn thức* $B$ $(B != 0)$ khi:], 3),
  ([*Cách chia* (trường hợp chia hết) — ba bước:], 4),
  ([Nhắc lại quy tắc chia lũy thừa cùng cơ số $x^m : x^n$ (với $m >= n$):], 1))
#probm(c-vd, "Ví dụ 1",
  [Cho đơn thức $A = 5 x^2 y z^3$.],
  ("a)", [Giải thích tại sao $A$ *không* chia hết cho $B = x^2 y^2 z^2$.], 3),
  ("b)", [Giải thích tại sao $A$ chia hết cho $C = -2 x^2 z^2$ và tìm thương $A : C$.], 5))
#probm(c-lt, "Luyện tập 1",
  [Phép chia nào *không* là phép chia hết? Vì sao? Tìm thương của các phép chia còn lại.],
  ("a)", [$-15 x^2 y^2$ chia cho $3 x^2 y$;], 2),
  ("b)", [$6 x y$ chia cho $2 y z$;], 2),
  ("c)", [$4 x y^3$ chia cho $6 x y^2$.], 2))
#prob(c-vdung, "Vận dụng 1",
  [Khối hộp chữ nhật thứ nhất có ba kích thước $x$, $2x$, $3y$; khối hộp thứ hai có diện tích đáy là $2 x y$. Biết hai khối hộp có cùng thể tích, tính chiều cao (cạnh bên) của khối hộp thứ hai.], 7)

// ══════════════════════════════════════════════════════════════════
//  MỤC 2
// ══════════════════════════════════════════════════════════════════
#sec("2", "Chia đa thức cho đơn thức")

#sub("Điều kiện chia hết · Quy tắc chia")
#lythuyet(
  ([*Đa thức* $A$ chia hết cho *đơn thức* $B$ khi:], 2),
  ([*Quy tắc chia:* muốn chia đa thức $A$ cho đơn thức $B$, ta:], 3))
#prob(c-vd, "Ví dụ 2",
  [Thực hiện phép chia $(15 x^2 y^4 - 4 x^3 y^3 + 20 x^2 y) : 5 x^2 y$.], 6)
#prob(c-lt, "Luyện tập 2",
  [Làm tính chia $(6 x^4 y^3 - 8 x^3 y^4 + 3 x^2 y^2) : 2 x y^2$.], 6)
#prob(c-vdung, "Vận dụng 2",
  [Tìm đa thức $A$ sao cho $A dot (-3 x y) = 9 x^3 y + 3 x y^3 - 6 x^2 y^2$.], 6)

// ══════════════════════════════════════════════════════════════════
//  MỤC 3 — BÀI TẬP VỀ NHÀ
// ══════════════════════════════════════════════════════════════════
#sec("3", "Bài tập về nhà · SGK tr.24")

#probm(c-bt, "Bài 1.30",
  [Tìm đơn thức chưa biết trong mỗi phép chia sau:],
  ("a)", [Tìm $M$, biết rằng $7/3 x^3 y^2 : M = 7 x y^2$.], 5),
  ("b)", [Tìm $N$ sao cho $N : dc("0,5") x y^2 z = -x y$.], 5))
#probm(c-bt, "Bài 1.31",
  [Cho đa thức $A = 9 x y^4 - 12 x^2 y^3 + 6 x^3 y^2$. Xét xem $A$ có chia hết cho $B$ không; nếu có thì thực hiện phép chia.],
  ("a)", [$B = 3 x^2 y$;], 5),
  ("b)", [$B = -3 x y^2$.], 6))
#prob(c-bt, "Bài 1.32",
  [Thực hiện phép chia $(7 y^5 z^2 - 14 y^4 z^3 + dc("2,1") y^3 z^4) : (-7 y^3 z^2)$.], 14)

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
