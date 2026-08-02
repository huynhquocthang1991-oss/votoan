// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Bài tập cuối chương I (Toán 7 — KNTT)
//  Chữ đề 13,5pt · dòng chấm · in nhẹ mực (ít nền đặc).
//  Pitch dòng viết = cỡ chữ HS giả định 14pt + 25% chỗ thừa = 17,5pt.
//  Tăng chỗ viết bằng SỐ dòng (giữ nguyên pitch).
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
#let c-vd      = primary
#let c-lt      = rgb("#0e7c6b")
#let c-tl      = rgb("#6d28d9")
#let c-vdung   = rgb("#b45309")
#let c-bt      = rgb("#be123c")
#let display   = "Bricolage Grotesque"

// ── Trang ─────────────────────────────────────────────────────────
#set page(
  paper: "a4",
  margin: (x: 12mm, top: 11mm, bottom: 12mm),
  fill: white,
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 9pt, fill: muted)
      grid(columns: (1fr, auto),
        [Bài tập cuối chương I — Số hữu tỉ — Phiếu học tập],
        [Toán 7])
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
// Dòng chấm nằm NGOÀI block(breakable:false) để bài dài không nhảy nguyên trang.
#let prob(col, label, body, n) = {
  v(1mm)
  block(breakable: false, { tag(col, label); h(2mm); body })
  if n > 0 { dots(1) }
  if n > 1 { moredots(n - 1) }
}
// ── Bài tập nhiều câu a) b): MỖI CÂU MỘT DÒNG, chỗ viết riêng ─────
#let probm(col, label, stem, ..parts) = {
  v(1mm)
  block(breakable: false, { tag(col, label); h(2mm); stem })
  for p in parts.pos() {
    let (pl, pt, pn) = p
    block(breakable: false, above: 2.6mm, {
      grid(columns: (auto, 1fr), gutter: 1.8mm, align: (top, top),
        text(weight: 700, fill: primaryd, pl), pt)
    })
    if pn > 0 { dots(1) }
    if pn > 1 { moredots(pn - 1) }
  }
}

// ── Khung ghi lý thuyết (để trống cho HS tự ghi) ─────────────────
#let lythuyet(..items) = {
  v(0.6mm)
  block(width: 100%, fill: tint, radius: 3mm, inset: (x: 3.5mm, y: 2.5mm),
    stroke: (left: 1.3mm + primary), breakable: true, {
    text(font: display, weight: 800, size: 10pt, fill: primary, tracking: 0.1em)[#upper("Lý thuyết — em tự ghi")]
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

// ── Hình 1.14: năm điểm so với mực nước biển ──────────────────────
// Vẽ lại theo SGK Toán 7, tập một, tr.25 — giữ đúng thứ tự cao thấp:
// B cao hơn A; C ở ngay mực nước biển; D sâu hơn E.
#let hinh114() = {
  let W = 108mm
  let H = 44mm
  let sea = 19mm
  let net = rgb("#1f2a3c")
  let cham(x, y, vien) = place(top + left, dx: x - 1.3mm, dy: y - 1.3mm,
    circle(radius: 1.3mm, fill: white, stroke: 1pt + vien))
  let giong(x, y1, y2, mau) = place(top + left, dx: x, dy: y1,
    line(length: y2 - y1, angle: 90deg,
      stroke: (paint: mau, thickness: 0.6pt, dash: "dashed")))
  box(width: W, height: H, {
    // nước biển
    place(top + left, dx: 0mm, dy: sea,
      rect(width: W, height: H - sea, fill: rgb("#dcf1ef"), stroke: none))
    // hai ngọn núi (B cao hơn A)
    place(top + left, dx: 24mm, dy: sea - 15mm,
      polygon(fill: rgb("#a8ce6d"), (0mm, 15mm), (13mm, 0mm), (26mm, 15mm)))
    place(top + left, dx: 9mm, dy: sea - 10mm,
      polygon(fill: rgb("#c6e096"), (0mm, 10mm), (10mm, 0mm), (20mm, 10mm)))
    // con tàu ở mặt nước
    place(top + left, dx: 54mm, dy: sea - 4.6mm,
      polygon(fill: rgb("#d6396a"), (0mm, 0mm), (13mm, 0mm), (11mm, 4.6mm), (2mm, 4.6mm)))
    // mực nước biển
    place(top + left, dx: 0mm, dy: sea, line(length: W, stroke: 1.1pt + net))
    place(top + left, dx: 76mm, dy: sea - 5.8mm,
      text(size: 8.5pt, fill: net)[mực nước biển])
    // đường gióng
    giong(19mm, sea - 10mm, sea, net)
    giong(37mm, sea - 15mm, sea, net)
    giong(74mm, sea, sea + 17mm, white)
    giong(93mm, sea, sea + 9mm, white)
    // năm điểm
    cham(19mm, sea - 10mm, primaryd)
    cham(37mm, sea - 15mm, primaryd)
    cham(60mm, sea, primaryd)
    cham(74mm, sea + 17mm, c-bt)
    cham(93mm, sea + 9mm, c-bt)
    // nhãn
    let nhan(x, y, mau, t) = place(top + left, dx: x, dy: y,
      text(size: 10.5pt, weight: 700, style: "italic", fill: mau, t))
    nhan(16.5mm, sea - 16.5mm, primaryd)[A]
    nhan(34.5mm, sea - 21.5mm, primaryd)[B]
    nhan(57.5mm, sea + 1.6mm, c-bt)[C]
    nhan(69mm, sea + 13mm, c-bt)[D]
    nhan(95.5mm, sea + 5.6mm, c-bt)[E]
  })
}

// ══════════════════════════════════════════════════════════════════
//  ĐẦU PHIẾU (bản in nhẹ: nền phớt xanh + nẹp trái, không nền đặc)
// ══════════════════════════════════════════════════════════════════
#block(width: 100%, radius: 3mm, inset: (x: 5mm, y: 3.5mm),
  fill: tint, stroke: (left: 3mm + primary),
  grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
    {
      text(fill: primary, font: display, weight: 700, size: 10pt, tracking: 0.18em)[#upper("Phiếu học tập")]
      v(0.7mm)
      text(fill: primaryd, font: display, weight: 800, size: 21pt)[Bài tập cuối chương I]
      v(0.6mm)
      text(fill: muted, size: 11.5pt)[Toán 7 · Chương I — Số hữu tỉ]
    },
    text(font: display, weight: 800, size: 38pt, fill: primary.transparentize(72%))[07]))

#v(0.8mm)
#block(breakable: false, grid(columns: (1.7fr, 0.7fr, 1.1fr), gutter: 5mm, align: bottom,
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Họ và tên], udots),
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Lớp], udots),
  grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
    text(weight: 600, size: 11.5pt, fill: muted)[Ngày], udots)))

// ══════════════════════════════════════════════════════════════════
//  MỤC 1 — HỆ THỐNG KIẾN THỨC
// ══════════════════════════════════════════════════════════════════
#sec("1", "Hệ thống kiến thức")

#sub("Số hữu tỉ · So sánh · Bốn phép tính")
#lythuyet(
  ([*Số hữu tỉ* là số viết được dưới dạng:], 3),
  ([Muốn *so sánh* hai số hữu tỉ, ta làm thế nào?], 3),
  ([Quy tắc *cộng, trừ* hai số hữu tỉ (chú ý khi bỏ dấu ngoặc):], 4),
  ([Quy tắc *nhân, chia* hai số hữu tỉ:], 4))

#sub("Luỹ thừa · Thứ tự thực hiện phép tính · Quy tắc chuyển vế")
#lythuyet(
  ([Nhân, chia hai luỹ thừa *cùng cơ số*: $x^m dot x^n = ?$ và $x^m : x^n = ?$], 3),
  ([Luỹ thừa của một luỹ thừa, của một tích, của một thương:], 4),
  ([*Thứ tự* thực hiện các phép tính (có ngoặc và không có ngoặc):], 4),
  ([*Quy tắc chuyển vế*:], 3))

// ══════════════════════════════════════════════════════════════════
//  MỤC 2 — BÀI TẬP
// ══════════════════════════════════════════════════════════════════
#sec("2", "Bài tập · SGK tr.25")

#v(1mm)
#block(breakable: false, {
  tag(c-bt, "Bài 1.35"); h(2mm)
  [Hình 1.14 mô phỏng vị trí của năm điểm $A$, $B$, $C$, $D$, $E$ so với mực nước biển. Biết độ cao (đơn vị kilômét) so với mực nước biển của mỗi điểm là một trong các số sau: $33/12$; $79/30$; $-25/12$; $-5/6$; $0$. Quan sát hình và cho biết độ cao của mỗi điểm.]
  v(1.6mm)
  align(center, hinh114())
  v(0.6mm)
  align(center, text(size: 9pt, fill: muted)[Hình 1.14])
})
#dots(1)
#moredots(6)

#probm(c-bt, "Bài 1.36",
  [Tính giá trị của các biểu thức sau:],
  ("a)", [$(3^12 + 3^15) / (1 + 3^3)$], 5),
  ("b)", [$2 : (1/2 - 2/3)^2 + dc("0,125")^3 dot 8^3 - (-12)^4 : 6^4$], 8))

#prob(c-bt, "Bài 1.37",
  [Chị Trang đang có ba tháng thực tập tại Mỹ. Gần hết thời gian thực tập, chị Trang và bạn có kế hoạch tổ chức một bữa tiệc chia tay trước khi về nước. Chị ấy dự định mua 4 cái bánh pizza, mỗi cái giá #dc("10,25") USD. Chị Trang có phiếu giảm giá #dc("1,5") USD cho mỗi cái bánh pizza, hãy tính tổng số tiền chị ấy dùng để mua bánh.], 6)

#prob(c-bt, "Bài 1.38",
  [Bố của Hà chuẩn bị đi công tác bằng máy bay. Theo kế hoạch, máy bay sẽ cất cánh lúc 14 giờ 40 phút. Bố của Hà cần phải có mặt ở sân bay trước ít nhất 2 giờ để làm thủ tục, biết rằng đi từ nhà Hà đến sân bay mất khoảng 45 phút. Hỏi bố của Hà phải đi từ nhà muộn nhất là lúc mấy giờ để đến sân bay cho kịp giờ bay?], 7)

// ══════════════════════════════════════════════════════════════════
//  MỤC 3 — GÓC CÔNG NGHỆ
// ══════════════════════════════════════════════════════════════════
#sec("3", "Góc công nghệ · Máy tính cầm tay")

#prob(c-vdung, "Thực hành",
  [Em hãy tự tính ra nháp, rồi bấm máy tính cầm tay để kiểm tra lại. Điền kết quả vào cột cuối.], 0)
#v(1.4mm)
#block(breakable: false, table(columns: (1.15fr, 1.5fr, 1fr),
  rows: (auto, 10mm, 10mm, 10mm, 10mm, 10mm),
  stroke: 0.6pt + hair, align: center + horizon, inset: (x: 2mm, y: 2mm),
  hcell([Tính]), hcell([Ấn các phím]), hcell([Kết quả]),
  $(-dc("1,7")) + (-dc("2,9"))$, text(size: 10.5pt)[(−) 1 . 7 + (−) 2 . 9 =], [],
  $(-16/5) - (-dc("0,8"))$, text(size: 10.5pt)[(−) a b/c 1 6 ▼ 5 ▶ − (−) 0 . 8 =], [],
  $dc("4,1") dot (-8/5)$, text(size: 10.5pt)[4 . 1 × (−) a b/c 8 ▼ 5 =], [],
  $(-dc("3,45")) : (-dc("2,3"))$, text(size: 10.5pt)[(−) 3 . 4 5 ÷ (−) 2 . 3 =], [],
  $dc("0,5") dot (-dc("2,1")) + dc("1,5") : (-dc("0,3"))$,
    text(size: 10.5pt)[0 . 5 × (−) 2 . 1 + 1 . 5 ÷ (−) 0 . 3 =], []))
#v(1.4mm)
#text(weight: 600, size: 12.5pt)[Nhận xét: máy tính giúp em điều gì, và điều gì máy tính *không* làm thay em được?]
#dots(3)

// ══════════════════════════════════════════════════════════════════
//  MỤC 4 — TỰ LUYỆN THÊM (mỗi bài một công cụ của chương)
// ══════════════════════════════════════════════════════════════════
#sec("4", "Tự luyện thêm")

#prob(c-lt, "Bài 1",
  [Tìm $x$, biết $3x - 2/5 = 1/2$.], 6)

#prob(c-lt, "Bài 2",
  [Tính một cách hợp lí: $B = dc("18,7") - (dc("6,7") + dc("9,3")) + (dc("11,3") - dc("4,5"))$.], 7)

#prob(c-lt, "Bài 3",
  [Viết $(-9)^3 : 3^3$ thành một số, rồi sắp xếp ba số $-3/4$;  $-5/6$;  $-7/9$ theo thứ tự tăng dần.], 5)

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
    moredots(7)
    v(3mm)
    grid(columns: (1fr, 1.1fr), gutter: 6mm, align: (left + top, center + top),
      grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
        text(weight: 600, size: 12pt, fill: muted)[Điểm], udots),
      align(center, {
        text(weight: 600, size: 12pt, fill: muted)[Chữ ký của giáo viên]
        v(26mm)   // chừa nhiều chỗ cho GV ký
      }))
  })
})
