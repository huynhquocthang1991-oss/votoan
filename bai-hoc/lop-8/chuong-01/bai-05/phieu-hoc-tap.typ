// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Bài 4. Phép nhân đa thức (Toán 8)
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
#let c-tt      = rgb("#6b21a8")
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
        [Bài 4. Phép nhân đa thức — Phiếu học tập], [Toán 8])
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
      text(fill: primaryd, font: display, weight: 800, size: 24pt)[Bài 4. Phép nhân đa thức]
      v(1.2mm)
      text(fill: muted, size: 11.5pt)[Toán 8 · Chương I — Đa thức]
    },
    text(font: display, weight: 800, size: 42pt, fill: primary.transparentize(72%))[05]))

#v(2mm)
#block(breakable: false, grid(columns: (1.7fr, 0.7fr, 1.1fr), gutter: 5mm, align: bottom,
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Họ và tên], udots),
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Lớp], udots),
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Ngày], udots)))

// ══════════════════════════════════════════════════════════════════
//  MỤC 1 — NHÂN ĐƠN THỨC VỚI ĐA THỨC
// ══════════════════════════════════════════════════════════════════
#sec("1", "Nhân đơn thức với đa thức")

#sub("Quy tắc nhân")
#lythuyet(
  ([*Nhân hai đơn thức:* ta nhân hai hệ số với nhau và …], 3),
  ([*Nhân đơn thức với đa thức:* ta nhân đơn thức với từng …], 4))

#prob(c-vd, "Ví dụ 1", [Thực hiện phép nhân $(-1/3 x y^3) (9x^2 y z)$.], 3)

#probm(c-lt, "Luyện tập 1", [Nhân hai đơn thức:],
  ("a)", [$3x^2$ và $2x^3$;], 2),
  ("b)", [$-x y$ và $4z^3$;], 2),
  ("c)", [$6x y^3$ và $-dc("0,5") x^2$.], 2))

#prob(c-vd, "Ví dụ 2", [Thực hiện phép nhân $(-4x y) (2x^2 + x y - y^2)$.], 4)

#probm(c-lt, "Luyện tập 2", [Làm tính nhân:],
  ("a)", [$(x y) (x^2 + x y - y^2)$;], 3),
  ("b)", [$(x y + y z + z x) (-x y z)$.], 3))

#prob(c-vdung, "Vận dụng", [Rút gọn biểu thức $x^3(x + y) - x(x^3 + y^3)$.], 6)

// ══════════════════════════════════════════════════════════════════
//  MỤC 2 — NHÂN ĐA THỨC VỚI ĐA THỨC
// ══════════════════════════════════════════════════════════════════
#sec("2", "Nhân đa thức với đa thức")

#sub("Quy tắc và tính chất")
#lythuyet(
  ([*Quy tắc:* muốn nhân một đa thức với một đa thức, ta …], 4),
  ([*Chú ý — Tính chất:*], 4))

#prob(c-vd, "Ví dụ 3", [Thực hiện phép nhân $(x + 3y + 2)(x + y)$.], 6)

#prob(c-vd, "Ví dụ 4", [Rút gọn biểu thức $(x + y)(2x - y) - (x - y)(2x + y)$.], 7)

#probm(c-lt, "Luyện tập 3", [Thực hiện phép nhân:],
  ("a)", [$(2x + y)(4x^2 - 2x y + y^2)$;], 6),
  ("b)", [$(x^2 y^2 - 3)(3 + x^2 y^2)$.], 5))

#probm(c-tt, "Thử thách nhỏ", [Xét biểu thức $P = (2k - 3)(3m - 2) - (3k - 2)(2m - 3)$ với hai biến $k$ và $m$.],
  ("a)", [Rút gọn biểu thức $P$.], 6),
  ("b)", [Chứng minh rằng tại mọi giá trị nguyên của $k$ và $m$, giá trị của $P$ luôn là một số nguyên chia hết cho 5.], 4))

// ══════════════════════════════════════════════════════════════════
//  BÀI TẬP (SGK tr.21)
// ══════════════════════════════════════════════════════════════════
#sec("BT", "Bài tập (SGK tr.21)")

#probm(c-bt, "Bài 1.24", [Nhân hai đơn thức:],
  ("a)", [$5x^2 y$ và $2x y^2$;], 3),
  ("b)", [$3/4 x y$ và $8x^3 y^2$;], 3),
  ("c)", [$dc("1,5") x y^2 z^3$ và $2x^3 y^2 z$.], 3))

#probm(c-bt, "Bài 1.25", [Tìm tích của đơn thức với đa thức:],
  ("a)", [$(-dc("0,5")) x y^2 (2x y - x^2 + 4y)$;], 5),
  ("b)", [$(x^3 y - 1/2 x^2 + 1/3 x y) 6x y^3$.], 5))

#prob(c-bt, "Bài 1.26", [Rút gọn biểu thức $x(x^2 - y) - x^2(x + y) + x y(x - 1)$.], 6)

#probm(c-bt, "Bài 1.27", [Làm tính nhân:],
  ("a)", [$(x^2 - x y + 1)(x y + 3)$;], 6),
  ("b)", [$(x^2 y^2 - 1/2 x y + 2)(x - 2y)$.], 6))

#prob(c-bt, "Bài 1.28", [Rút gọn biểu thức sau để thấy rằng giá trị của nó không phụ thuộc vào giá trị của biến: $(x - 5)(2x + 3) - 2x(x - 3) + x + 7$.], 8)

#prob(c-bt, "Bài 1.29", [Chứng minh đẳng thức $(2x + y)(2x^2 + x y - y^2) = (2x - y)(2x^2 + 3x y + y^2)$.], 14)

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
