// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Bài 2. Đa thức (Toán 8)
//  Nền vở ô ly 5mm · chữ 13,5pt · dòng chấm · in nhẹ mực (ít nền đặc).
//  Mỗi câu a)/b) một dòng · chỗ viết = nội dung +25%.
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
  margin: (x: 13mm, top: 13mm, bottom: 14mm),
  fill: oly,
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 9pt, fill: muted)
      grid(columns: (1fr, auto),
        [Bài 2. Đa thức — Phiếu học tập], [Toán 8])
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
#set par(leading: 0.58em, justify: false)
#set block(spacing: 1.5mm)
#show math.equation: set text(font: ("STIX Two Math", "New Computer Modern Math"))
// dfrac: phân số kiểu display (to, xếp chồng) + box để không ngắt công thức qua 2 dòng
#show math.equation.where(block: false): it => box(math.display(it))
#let dc(s) = math.text(s)

// ── Dòng kẻ chấm để viết (pitch 7,8mm — rộng rãi cho HS viết) ─────
#let lh = 7.8mm
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
  v(2mm)
  block(breakable: false, grid(columns: (auto, auto, 1fr), gutter: 2.8mm, align: horizon,
    box(fill: primary, radius: 2mm, inset: (x: 2.6mm, y: 1.3mm),
      text(fill: white, font: display, weight: 800, size: 13pt, num)),
    text(font: display, weight: 800, size: 15pt, fill: ink)[#upper(title)],
    line(length: 100%, stroke: 0.7pt + hair)))
  v(0.8mm)
}
#let sub(title) = {
  v(1.4mm)
  block(breakable: false, grid(columns: (auto, 1fr), gutter: 2.4mm, align: horizon,
    box(width: 2.2mm, height: 2.2mm, fill: primary, radius: 0.5mm),
    text(font: display, weight: 700, size: 13pt, fill: primaryd, title)))
  v(0.2mm)
}

// ── Bài tập một phần: nhãn + đề rồi dòng chấm ─────────────────────
#let prob(col, label, body, n) = {
  v(1.8mm)
  block(breakable: false, { tag(col, label); h(2mm); body; dots(1) })
  if n > 1 { moredots(n - 1) }
}
// ── Bài tập nhiều câu a) b): MỖI CÂU MỘT DÒNG, chỗ viết riêng ─────
#let probm(col, label, stem, ..parts) = {
  v(1.8mm)
  block(breakable: false, { tag(col, label); h(2mm); stem })
  for p in parts.pos() {
    let (pl, pt, pn) = p
    block(breakable: false, above: 1.4mm, {
      grid(columns: (auto, 1fr), gutter: 1.8mm, align: (top, top),
        text(weight: 700, fill: primaryd, pl), pt)
      dots(1)
    })
    if pn > 1 { moredots(pn - 1) }
  }
}

// ── Khung ghi lý thuyết (để trống cho HS tự ghi) ─────────────────
#let lythuyet(..items) = {
  v(1.4mm)
  block(width: 100%, fill: tint, radius: 3mm, inset: (x: 4mm, y: 3mm),
    stroke: (left: 1.3mm + primary), breakable: true, {
    text(font: display, weight: 800, size: 10pt, fill: primary, tracking: 0.1em)[#upper("Lý thuyết")]
    for it in items.pos() {
      let (label, n) = it
      v(1.8mm)
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
      text(fill: primaryd, font: display, weight: 800, size: 26pt)[Bài 2. Đa thức]
      v(1.2mm)
      text(fill: muted, size: 11.5pt)[Toán 8 · Chương I — Đa thức]
    },
    text(font: display, weight: 800, size: 42pt, fill: primary.transparentize(72%))[02]))

#v(2mm)
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
#sec("1", "Khái niệm đa thức")

#sub("Đa thức và các hạng tử của đa thức")
#lythuyet(
  ([*Đa thức* là ...; mỗi *hạng tử* là:], 3),
  ([*Chú ý* (đơn thức cũng là đa thức; biến ở mẫu / dưới căn):], 3))
#prob(c-vd, "Ví dụ 1",
  [Hãy kể ra các hạng tử của đa thức $A = x^3 - 3 x^2 y + 3 x y^2 - y^3 + x y - 1$.], 3)
#prob(c-lt, "Luyện tập 1",
  [Biểu thức nào là đa thức? Chỉ rõ các hạng tử của mỗi đa thức: $3 x y^2 - 1$;  $x + 1/x$;  $sqrt(2) x + sqrt(3) y$;  $x + sqrt(x y) + y$.], 4)
#probm(c-vdung, "Vận dụng",
  [Mỗi quyển vở giá $x$ đồng; mỗi chiếc bút giá $y$ đồng.],
  ("a)", [Viết biểu thức số tiền phải trả để mua: 8 quyển vở và 7 chiếc bút; 3 xấp vở và 2 hộp bút (mỗi xấp 10 quyển, mỗi hộp 12 chiếc).], 4),
  ("b)", [Mỗi biểu thức tìm được ở câu a) có phải là đa thức không?], 2))

// ══════════════════════════════════════════════════════════════════
//  MỤC 2
// ══════════════════════════════════════════════════════════════════
#sec("2", "Đa thức thu gọn · Bậc của đa thức")

#sub("Đa thức thu gọn · Thu gọn một đa thức")
#lythuyet(
  ([*Đa thức thu gọn* là ...; các bước thu gọn:], 3),
  ([*Bậc của đa thức* (nhớ thu gọn trước; số $0$ và số khác $0$):], 3))
#prob(c-lt, "Câu hỏi",
  [Đa thức $x^2 + y^2 + 1/2 x y$ có phải là đa thức thu gọn không? Vì sao?], 3)
#prob(c-vd, "Ví dụ 2",
  [Thu gọn đa thức $M = x^2 y - 5 x y + 7 x y^2 + 3 x^2 y + x y^2 - 4 x y^2 + 2$.], 4)
#probm(c-lt, "Luyện tập 2",
  [Cho đa thức $N = 5 y^2 z^2 - 2 x y^2 z + 1/3 x^4 - 2 y^2 z^2 + 2/3 x^4 + x y^2 z$.],
  ("a)", [Thu gọn đa thức $N$.], 3),
  ("b)", [Xác định hệ số và bậc của từng hạng tử trong dạng thu gọn của $N$.], 4))
#probm(c-vd, "Ví dụ 3",
  [Cho đa thức $P = 3 x^4 + 1/3 x y z - 3 x^4 - 4/3 x y z + 2 x^2 y - 6 z$.],
  ("a)", [Tìm bậc của đa thức $P$.], 3),
  ("b)", [Tính giá trị của $P$ khi $x = 1$;  $y = 3$;  $z = 1/3$.], 3))
#probm(c-lt, "Luyện tập 3",
  [Thu gọn (nếu cần) và tìm bậc của mỗi đa thức:],
  ("a)", [$Q = 5 x^2 - 7 x y + dc("2,5") y^2 + 2 x - dc("8,3") y + 1$.], 3),
  ("b)", [$H = 4 x^5 - 1/2 x^3 y + 3/4 x^2 y^2 - 4 x^5 + 2 y^2 - 7$.], 3))
#prob(c-tl, "Tranh luận",
  [Một đa thức bậc hai thu gọn với hai biến $x, y$ mà mỗi hạng tử đều có hệ số bằng 1 thì có nhiều nhất mấy hạng tử? Nêu ví dụ.], 4)

// ══════════════════════════════════════════════════════════════════
//  MỤC 3 — BÀI TẬP VỀ NHÀ
// ══════════════════════════════════════════════════════════════════
#sec("3", "Bài tập về nhà · SGK tr.14")

#prob(c-bt, "Bài 1.8",
  [Trong các biểu thức sau, biểu thức nào là đa thức? $-x^2 + 3 x + 1$;  $x / sqrt(5)$;  $x - sqrt(5) / x$;  $2024$;  $3 x^2 y^2 - 5 x^3 y + dc("2,4")$;  $1 / (x^2 + x + 1)$.], 4)
#probm(c-bt, "Bài 1.9",
  [Xác định hệ số và bậc của từng hạng tử trong đa thức sau:],
  ("a)", [$x^2 y - 3 x y + 5 x^2 y^2 + dc("0,5") x - 4$.], 4),
  ("b)", [$x sqrt(2) - 2 x y^3 + y^3 - 7 x^3 y$.], 4))
#probm(c-bt, "Bài 1.10",
  [Thu gọn các đa thức sau:],
  ("a)", [$5 x^4 - 2 x^3 y + 20 x y^3 + 6 x^3 y - 3 x^2 y^2 + x y^3 - y^4$.], 3),
  ("b)", [$dc("0,6") x^3 + x^2 z - dc("2,7") x y^2 + dc("0,4") x^3 + dc("1,7") x y^2$.], 3))
#probm(c-bt, "Bài 1.11",
  [Thu gọn (nếu cần) và tìm bậc của mỗi đa thức:],
  ("a)", [$x^4 - 3 x^2 y^2 + 3 x y^2 - x^4 + 1$.], 3),
  ("b)", [$5 x^2 y + 8 x y - 2 x^2 - 5 x^2 y + x^2$.], 3))
#prob(c-bt, "Bài 1.12",
  [Thu gọn rồi tính giá trị của đa thức $M = 1/3 x^2 y + x y^2 - x y + 1/2 x y^2 - 5 x y - 1/3 x^2 y$ tại $x = dc("0,5")$ và $y = 1$.], 5)
#probm(c-bt, "Bài 1.13",
  [Cho đa thức $P = 8 x^2 y^2 z - 2 x y z + 5 y^2 z - 5 x^2 y^2 z + x^2 y^2 - 3 x^2 y^2 z$.],
  ("a)", [Thu gọn và tìm bậc của đa thức $P$.], 3),
  ("b)", [Tính giá trị của $P$ tại $x = -4$;  $y = 2$;  $z = 1$.], 4))

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
