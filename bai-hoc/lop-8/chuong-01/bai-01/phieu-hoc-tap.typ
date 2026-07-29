// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Bài 1. Đơn thức (Toán 8)
//  Nền vở ô ly 5mm · chữ đề 13,5pt · dòng chấm · in nhẹ mực (ít nền đặc).
//  Pitch dòng viết = cỡ chữ HS giả định 14pt + 25% chỗ thừa = 17,5pt (≈6,17mm).
//  Tăng chỗ viết bằng SỐ dòng (giữ nguyên pitch), giữ đúng 6 mặt A4.
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

// ── Nền: TRẮNG SẠCH (đã bỏ ô ly để không rối với dòng chấm) ───────
// Muốn bật lại ô ly: đổi `fill: white` ở #set page thành `fill: oly`.
// #let oly = tiling(size: (5mm, 5mm))[
//   #box(width: 5mm, height: 5mm, fill: rgb("#fdfefe"),
//        stroke: (paint: gridc, thickness: 0.25pt))
// ]

// ── Trang ─────────────────────────────────────────────────────────
#set page(
  paper: "a4",
  margin: (x: 12mm, top: 11mm, bottom: 12mm),
  fill: white,
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 9pt, fill: muted)
      grid(columns: (1fr, auto),
        [Bài 1. Đơn thức — Phiếu học tập], [Toán 8])
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

// ── Dòng kẻ chấm để viết (thống nhất toàn phiếu) ─────────────────
// pitch = ước tính chữ viết tay HS 14pt + 25% chỗ thừa = 17,5pt (≈6,17mm)
#let lh = 17.5pt
#let dline = block(width: 100%, height: lh, above: 0pt, below: 0pt,
  place(bottom + left, dy: -0.9mm,
    line(length: 100%, stroke: (paint: dotc, thickness: 1pt, dash: "dotted"))))
#let dots(n) = { v(1mm); for _ in range(n) { dline } }
#let moredots(n) = { for _ in range(n) { dline } }

// ── Chip nhãn ─────────────────────────────────────────────────────
// Chip nhãn: đệm rộng + text dùng bounds để ôm trọn dấu tiếng Việt (Ệ, Ậ…) khỏi bị sát/cắt.
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
      text(fill: primaryd, font: display, weight: 800, size: 24pt)[Bài 1. Đơn thức]
      v(0.6mm)
      text(fill: muted, size: 11.5pt)[Toán 8 · Chương I — Đa thức]
    },
    text(font: display, weight: 800, size: 38pt, fill: primary.transparentize(72%))[01]))

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
#sec("1", "Đơn thức và đơn thức thu gọn")

#sub("Khái niệm đơn thức")
#lythuyet(
  ([*Đơn thức* là biểu thức đại số chỉ gồm:], 5),
  ([Biểu thức *không* là đơn thức khi:], 4))
#prob(c-vd, "Ví dụ 1",
  [Trong các biểu thức sau, biểu thức nào là đơn thức? $-x dot 6y$;  $x + 2y$;  $dc("0,3") x y dot x^2$;  $5x sqrt(y)$.], 4)
#prob(c-lt, "Luyện tập 1",
  [Biểu thức nào là đơn thức? $3x^3 y$;  $-4$;  $(3 - x) x^2 y^2$;  $12x^5$;  $-5/9 x y z$;  $(x^2 y) / 2$;  $3/x + y^2$.], 4)
#prob(c-tl, "Tranh luận",
  [Biểu thức $(1 + sqrt(2)) x^2 y$ có phải là đơn thức không? Vì sao?], 3)

#sub("Đơn thức thu gọn · Hệ số · Phần biến · Bậc")
#lythuyet(
  ([*Đơn thức thu gọn* — cách thu gọn:], 5),
  ([*Hệ số* và *phần biến* (lưu ý hệ số $plus.minus 1$):], 5),
  ([*Bậc* của đơn thức (kể cả số $0$):], 5))
#prob(c-lt, "Bài tập",
  [Xác định hệ số, phần biến và bậc của mỗi đơn thức trong bảng.], 0)
#v(1mm)
#block(breakable: false, table(columns: (1.5fr, 1fr, 1.7fr, 1fr),
  rows: (auto, 8.5mm, 8.5mm, 8.5mm), stroke: 0.6pt + hair, align: center + horizon,
  inset: (x: 2mm, y: 2mm),
  hcell("Đơn thức"), hcell("Hệ số"), hcell("Phần biến"), hcell("Bậc"),
  $dc("2,5") x$, [], [], [],
  $-1/4 y^2 z^3$, [], [], [],
  $dc("0,35") x y^2 z^4$, [], [], []))

#prob(c-vd, "Ví dụ 2",
  [Thu gọn rồi xác định hệ số, phần biến và bậc của đơn thức $dc("0,5") x y^2 dot 4 x^2$.], 8)
#prob(c-lt, "Luyện tập 2",
  [Thu gọn và xác định bậc của đơn thức $dc("4,5") x^2 y (-2) x y z$.], 7)

#pagebreak()
#v(1.4mm)
#block(breakable: false, fill: rgb("#fbfcff"), stroke: 0.6pt + hair, radius: 2.5mm,
  inset: (x: 3.5mm, y: 2.4mm),
  grid(columns: (auto, 1fr), gutter: 2.4mm, align: (horizon, bottom),
    text(weight: 700, size: 11.5pt, fill: primaryd)[Quy ước khi nói đến một đơn thức:], udots))

// ══════════════════════════════════════════════════════════════════
//  MỤC 2
// ══════════════════════════════════════════════════════════════════
#sec("2", "Đơn thức đồng dạng")

#sub("Khái niệm đơn thức đồng dạng")
#lythuyet(
  ([*Hai đơn thức đồng dạng* là:], 4),
  ([Nhận xét (về bậc; về hai số khác $0$):], 5))
#prob(c-lt, "Luyện tập 3",
  [Xếp các đơn thức sau thành từng nhóm đồng dạng: $5/3 x^2 y$;  $-x y^2$;  $dc("0,5") x^4$;  $-2 x y^2$;  $dc("2,75") x^4$;  $-1/4 x^2 y$;  $3 x y^2$.], 0)
#v(1mm)
#block(breakable: false, table(columns: (1fr, 1fr, 1fr),
  rows: (auto, 8.5mm, 8.5mm, 8.5mm), stroke: 0.6pt + hair, align: center + horizon,
  inset: (x: 2mm, y: 2mm),
  hcell("Nhóm 1"), hcell("Nhóm 2"), hcell("Nhóm 3"),
  [], [], [], [], [], [], [], [], []))

#prob(c-tl, "Tranh luận",
  [Hai đơn thức nhiều biến cùng bậc có chắc chắn đồng dạng không? Nêu ví dụ minh hoạ.], 6)

#sub("Cộng và trừ đơn thức đồng dạng")
#lythuyet(
  ([*Quy tắc* cộng (trừ) hai đơn thức đồng dạng:], 10))
#prob(c-vd, "Ví dụ 3",
  [Cho $A = 3 x y^2$;  $B = -5 x y^2$;  $C = x y^2$. Tính $A + B$;  $A - B$;  $A + B + C$.], 4)
#probm(c-lt, "Luyện tập 4",
  [Cho ba đơn thức $-x^3 y$;  $4 x^3 y$;  $-2 x^3 y$.],
  ("a)", [Tính tổng $S$ của ba đơn thức.], 3),
  ("b)", [Tính giá trị của $S$ tại $x = 2$;  $y = -3$.], 3))
#prob(c-vdung, "Vận dụng",
  [Mỗi phần quà gồm $x$ kg gạo (12 nghìn đồng/kg) và $x$ gói mì (4,5 nghìn đồng/gói); có $y$ phần quà. Tròn viết số tiền là $12 x y + dc("4,5") x y$, Vuông viết $dc("16,5") x y$. Bạn nào đúng?], 6)

// ══════════════════════════════════════════════════════════════════
//  MỤC 3 — BÀI TẬP VỀ NHÀ
// ══════════════════════════════════════════════════════════════════
#sec("3", "Bài tập về nhà · SGK tr.9–10")

#prob(c-bt, "Bài 1.1",
  [Trong các biểu thức sau, biểu thức nào là đơn thức? $-x$;  $(1 + x) y^2$;  $(3 + sqrt(3)) x y$;  $0$;  $1/y x^2$;  $2 sqrt(x y)$.], 7)
#probm(c-bt, "Bài 1.2",
  [Cho $A = 4 x (-2) x^2 y$;  $B = dc("12,75") x y z$;  $C = (1 + 2 dot dc("4,5")) x^2 y dot 1/5 y^3$;  $D = (2 - sqrt(5)) x$.],
  ("a)", [Liệt kê các đơn thức đã thu gọn; thu gọn các đơn thức còn lại.], 6),
  ("b)", [Nêu hệ số, phần biến và bậc của mỗi đơn thức.], 6))
#probm(c-bt, "Bài 1.3",
  [Thu gọn rồi tính giá trị của mỗi đơn thức:],
  ("a)", [$A = (-2) x^2 y dot 1/2 x y$ khi $x = -2$;  $y = 1/2$.], 4),
  ("b)", [$B = x y z (-dc("0,5")) y^2 z$ khi $x = 4$;  $y = dc("0,5")$;  $z = 2$.], 4))
#prob(c-bt, "Bài 1.4",
  [Xếp thành từng nhóm các đơn thức đồng dạng: $3 x^3 y^2$;  $-dc("0,2") x^2 y^3$;  $7 x^3 y^2$;  $-4y$;  $3/4 x^2 y^3$;  $y sqrt(2)$.], 6)
#prob(c-bt, "Bài 1.5",
  [Rút gọn rồi tính giá trị $S = 1/2 x^2 y^5 - 5/2 x^2 y^5$ khi $x = -2$;  $y = 1$.], 5)
#prob(c-bt, "Bài 1.6",
  [Tính tổng của bốn đơn thức: $2 x^2 y^3$;  $-3/5 x^2 y^3$;  $-14 x^2 y^3$;  $8/5 x^2 y^3$.], 4)

// Bài 1.7 — có hình vẽ
#let fig17 = {
  let s = 58mm / 340
  box(width: 58mm, height: 36mm, {
    place(top + left, dx: 40*s,  dy: 70*s, rect(width: 180*s, height: 110*s,
      fill: rgb("#dbeeff"), stroke: 0.7pt + rgb("#245a86")))
    place(top + left, dx: 220*s, dy: 20*s, rect(width: 90*s, height: 160*s,
      fill: rgb("#c2e2fb"), stroke: 0.7pt + rgb("#245a86")))
    place(top + left, dx: 40*s,  dy: 20*s, rect(width: 180*s, height: 50*s,
      stroke: (paint: rgb("#718096"), thickness: 0.6pt, dash: "dashed")))
    let lbl(x, y, t) = place(top + left, dx: x*s, dy: y*s,
      text(size: 8.5pt, fill: rgb("#173b5e"), weight: 600, t))
    lbl(27, 2, "H");  lbl(207, 2, "E");  lbl(311, 2, "F")
    lbl(23, 56, "A"); lbl(225, 47, "B")
    lbl(23, 178, "D"); lbl(205, 180, "C"); lbl(311, 180, "G")
    let dim(x, y, t) = place(top + left, dx: x*s, dy: y*s,
      text(size: 8.5pt, style: "italic", fill: ink, t))
    dim(2, 112, [2#math.italic("x")]); dim(318, 90, [3#math.italic("x")])
    dim(116, 150, [2#math.italic("y")]); dim(256, 150, math.italic("y"))
  })
}
#v(1.8mm)
#block(breakable: false, {
  tag(c-bt, "Bài 1.7"); h(2mm)
  [Tìm đơn thức thu gọn hai biến $x$, $y$ biểu thị diện tích mảnh đất tô màu bằng *hai cách*: (1) tổng diện tích hai hình chữ nhật $A B C D$ và $E F G C$; (2) diện tích $H F G D$ trừ diện tích $H E B A$.]
  v(1.8mm)
  grid(columns: (60mm, 1fr), gutter: 4mm, align: (center + top, left + top),
    box(stroke: 0.6pt + hair, radius: 2.5mm, fill: rgb("#fbfdff"), inset: 2mm, {
      fig17
      v(0.6mm)
      align(center, text(size: 9pt, fill: muted)[Hình bài 1.7])
    }),
    { dline; dline; dline })
})
#moredots(10)

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
