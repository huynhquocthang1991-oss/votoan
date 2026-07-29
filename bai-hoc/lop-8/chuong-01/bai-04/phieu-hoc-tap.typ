// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Luyện tập chung (tr.17–18) (Toán 8)
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
        [Luyện tập chung (tr.17–18) — Phiếu học tập], [Toán 8])
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

// ── Bảng làm bài ──────────────────────────────────────────────────
#let hcell(t) = table.cell(fill: tint, align: center + horizon,
  text(fill: primaryd, weight: 700, size: 11.5pt, t))
#let dcell(t) = table.cell(align: center + horizon, text(size: 11.5pt, t))

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
      text(fill: primaryd, font: display, weight: 800, size: 24pt)[Luyện tập chung (tr.17–18)]
      v(1.2mm)
      text(fill: muted, size: 11.5pt)[Toán 8 · Chương I — Đa thức]
    },
    text(font: display, weight: 800, size: 42pt, fill: primary.transparentize(72%))[04]))

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
#sec("★", "Kiến thức cần nhớ")

#sub("Đơn thức · Đa thức · Cộng và trừ đa thức")
#lythuyet(
  ([*Đơn thức:* (khái niệm, cách thu gọn, bậc, đơn thức đồng dạng):], 6),
  ([*Đa thức:* (khái niệm, cách thu gọn, bậc, đa thức không):], 6),
  ([*Cộng và trừ hai đa thức:* (nối bằng dấu gì? bỏ ngoặc ra sao? nhóm các hạng tử nào?)], 5))

#probm(c-vd, "Ví dụ",
  [Cho hai đa thức $A = 5x^2 - 2x^3 y + 7x^3 y^2 - 118$ và $B = -7x^3 y^2 + x^3 y - 5x y^2 - 4x^2 + y$.],
  ("a)", [Liệt kê các hạng tử của đa thức $A$; trong đó hạng tử nào có bậc cao nhất?], 5),
  ("b)", [Tìm tổng $A + B$ và xác định bậc của đa thức $A + B$.], 6),
  ("c)", [Tìm hiệu $A - B$ và tính giá trị của hiệu tại $x = 1$ và $y = -2$.], 8))

// ══════════════════════════════════════════════════════════════════
//  MỤC 2 — BÀI TẬP VỀ NHÀ
// ══════════════════════════════════════════════════════════════════
#sec("BT", "Bài tập (SGK tr.17–18)")

#probm(c-bt, "Bài 1.18",
  [Cho các biểu thức: $4/5 x$; $(sqrt(2) - 1) x y$; $-3x y^2$; $1/2 x^2 y$; $1/x y^3$; $-x y + sqrt(2)$; $-3/2 x^2 y$; $sqrt(x) / 5$.],
  ("a)", [Biểu thức nào là đơn thức, biểu thức nào không là đơn thức?], 6),
  ("b)", [Chỉ ra hệ số và phần biến của mỗi đơn thức đã cho.], 0)
)
#v(1mm)
#block(breakable: false, table(columns: (1.2fr, 0.9fr, 1.4fr, 1fr, 1.2fr, 1.2fr),
  rows: (auto, 8.5mm, 8.5mm), stroke: 0.6pt + hair, align: center + horizon,
  inset: (x: 2mm, y: 2mm),
  hcell("Đơn thức"), dcell[$4/5 x$], dcell[$(sqrt(2) - 1) x y$], dcell[$-3x y^2$], dcell[$1/2 x^2 y$], dcell[$-3/2 x^2 y$],
  hcell("Hệ số"), [], [], [], [], [],
  hcell("Phần biến"), [], [], [], [], []))
#moredots(2)

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 1.8mm, align: (top, top),
  text(weight: 700, fill: primaryd, "c)"), [Viết tổng tất cả các đơn thức trên để được một đa thức. Xác định bậc của đa thức đó.]))
#dots(6)

#probm(c-bt, "Bài 1.19",
  [Khách sạn có hai bể bơi dạng hình hộp chữ nhật. Bể thứ nhất sâu $dc("1,2")$ m, đáy dài $x$ mét, rộng $y$ mét. Bể thứ hai sâu $dc("1,5")$ m, hai kích thước đáy gấp 5 lần hai kích thước đáy của bể thứ nhất.],
  ("a)", [Tìm đơn thức biểu thị số mét khối nước cần có để bơm đầy cả hai bể bơi.], 6),
  ("b)", [Tính lượng nước bơm đầy hai bể nếu $x = 5$ m, $y = 3$ m.], 5))

#prob(c-bt, "Bài 1.20",
  [Tìm bậc của mỗi đa thức sau rồi tính giá trị của chúng tại $x = 1$; $y = -2$: \
  $P = 5x^4 - 3x^3 y + 2x y^3 - x^3 y + 2y^4 - 7x^2 y^2 - 2x y^3$; \
  $Q = x^3 + x^2 y + x y^2 - x^2 y - x y^2 - x^3$.], 14)

#probm(c-bt, "Bài 1.21",
  [Cho hai đa thức $A = 7x y z^2 - 5x y^2 z + 3x^2 y z - x y z + 1$ và $B = 7x^2 y z - 5x y^2 z + 3x y z^2 - 2$.],
  ("a)", [Tìm đa thức $C$ sao cho $A - C = B$.], 6),
  ("b)", [Tìm đa thức $D$ sao cho $A + D = B$.], 6),
  ("c)", [Tìm đa thức $E$ sao cho $E - A = B$.], 6))

#prob(c-bt, "Bài 1.22",
  [Từ một miếng bìa, người ta cắt ra hai hình tròn có bán kính $x$ (cm) và $y$ (cm). Tìm biểu thức biểu thị diện tích phần còn lại của miếng bìa, biết miếng bìa có hình dạng gồm hai hình vuông ghép lại với kích thước như Hình 1.2. Biểu thức đó có phải là một đa thức không? Nếu phải thì đó là đa thức bậc mấy?], 0)
#v(1mm)
#align(center, image("hinh-1-2.svg", width: 50%))
#dots(8)

#prob(c-bt, "Bài 1.23",
  [Cho ba đa thức $M = 3x^3 - 4x^2 y + 3x - y$; $N = 5x y - 3x + 2$; $P = 3x^3 + 2x^2 y + 7x - 1$. \
  Tính $M + N - P$ và $M - N - P$.], 14)

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
