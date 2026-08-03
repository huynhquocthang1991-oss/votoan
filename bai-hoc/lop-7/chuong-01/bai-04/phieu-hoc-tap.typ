// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Toán 7, Chương I. Số hữu tỉ (KNTT)
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

// ── Dòng kẻ chấm để viết (thống nhất toàn phiếu) ─────────────────
#let lh = 17.5pt
#let dline = block(width: 100%, height: lh, above: 0pt, below: 0pt,
  place(bottom + left, dy: -0.9mm,
    line(length: 100%, stroke: (paint: dotc, thickness: 1pt, dash: "dotted"))))
#let dots(n) = { v(1mm); for _ in range(n) { dline } }
#let moredots(n) = { for _ in range(n) { dline } }

// ── Ô điền dòng chấm ngắn ────────────────────────────────────────
#let udots = box(width: 100%, height: 1.4em,
  place(bottom, line(length: 100%, stroke: (paint: dotc, thickness: 1pt, dash: "dotted"))))

// ── Ô đánh dấu ───────────────────────────────────────────────────
#let chk(t) = box[#box(width: 3.4mm, height: 3.4mm, radius: 0.8mm,
  stroke: 1.2pt + muted, baseline: 0.18em)#h(1.6mm)#text(size: 12pt, t)]

// ── Chip nhãn ────────────────────────────────────────────────────
#let tag(col, label) = box(fill: col, radius: 1.6mm, inset: (x: 2.8mm, y: 1.3mm),
  baseline: 0.26em,
  text(fill: white, font: display, weight: 700, size: 10pt, tracking: 0.04em,
    top-edge: "bounds", bottom-edge: "bounds")[#upper(label)])

// ── Tiêu đề mục / mục con ────────────────────────────────────────
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

// ── Bài tập một phần: nhãn + đề rồi dòng chấm ────────────────────
// Dòng chấm nằm NGOÀI block(breakable:false) để bài dài không nhảy nguyên trang.
#let prob(col, label, body, n) = {
  v(1mm)
  block(breakable: false, { tag(col, label); h(2mm); body })
  if n > 0 { dots(1) }
  if n > 1 { moredots(n - 1) }
}
// ── Bài tập nhiều câu a) b): MỖI CÂU MỘT DÒNG, chỗ viết riêng ────
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

// ── Bảng làm bài ─────────────────────────────────────────────────
#let hcell(t) = table.cell(fill: tint, align: center + horizon,
  text(fill: primaryd, weight: 700, size: 11.5pt, t))

// ── Số thập phân dấu phẩy kiểu Việt Nam ──────────────────────────
#let dc(s) = math.text(s)

// ── Trục số ──────────────────────────────────────────────────────
// nhan = ((giá trị, chữ),…) các vạch có ghi sẵn số dưới trục.
// diem = ((giá trị, tên),…) các điểm tô đỏ, tên chữ ghi phía trên.
// Bỏ trống diem là được một trục số để HS tự đánh dấu.
#let trucso(tmin, tmax, chia, nhan, diem: ()) = {
  let W = 148mm
  let dv = W / (tmax - tmin)
  let y = 6mm
  align(center, box(width: W, height: 14mm, {
    let n = int((tmax - tmin) * chia)
    for k in range(n + 1) {
      let t = tmin + k / chia
      let h = if calc.rem(k, chia) == 0 { 2.2mm } else { 1.3mm }
      place(top + left, dx: (t - tmin) * dv, dy: y - h,
        line(length: 2 * h, angle: 90deg, stroke: 0.8pt + ink))
    }
    place(top + left, dx: 0mm, dy: y, line(length: W - 3mm, stroke: 1pt + ink))
    place(top + left, dx: W - 3.4mm, dy: y - 1.5mm,
      polygon(fill: ink, (0mm, 0mm), (3.4mm, 1.5mm), (0mm, 3mm)))
    for (t, s) in nhan {
      place(top + left, dx: (t - tmin) * dv - 6mm, dy: y + 1.6mm,
        box(width: 12mm, align(center, text(size: 10pt, fill: muted, s))))
    }
    for (t, s) in diem {
      place(top + left, dx: (t - tmin) * dv - 1.1mm, dy: y - 1.1mm,
        circle(radius: 1.1mm, fill: c-bt, stroke: none))
      place(top + left, dx: (t - tmin) * dv - 6mm, dy: y - 6.6mm,
        box(width: 12mm, align(center,
          text(size: 11pt, weight: 700, style: "italic", fill: c-bt, s))))
    }
  }))
}

// ── Đầu phiếu (nền phớt xanh + nẹp trái, không nền đặc) ──────────
#let dau-phieu(ten-bai, so-bai, phu-de) = {
  block(width: 100%, radius: 3mm, inset: (x: 5mm, y: 3.5mm),
    fill: tint, stroke: (left: 3mm + primary),
    grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
      {
        text(fill: primary, font: display, weight: 700, size: 10pt, tracking: 0.18em)[#upper("Phiếu học tập")]
        v(0.7mm)
        text(fill: primaryd, font: display, weight: 800, size: 19pt, ten-bai)
        v(0.6mm)
        text(fill: muted, size: 11.5pt, phu-de)
      },
      text(font: display, weight: 800, size: 38pt, fill: primary.transparentize(72%), so-bai)))
  v(0.8mm)
  block(breakable: false, grid(columns: (1.7fr, 0.7fr, 1.1fr), gutter: 5mm, align: bottom,
    grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
      text(weight: 600, size: 11.5pt, fill: muted)[Họ và tên], udots),
    grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
      text(weight: 600, size: 11.5pt, fill: muted)[Lớp], udots),
    grid(columns: (auto, 1fr), gutter: 2mm, align: (horizon, bottom),
      text(weight: 600, size: 11.5pt, fill: muted)[Ngày], udots)))
}

// ── Kết phiếu: tự đánh giá · nhận xét của giáo viên ──────────────
#let cuoi-phieu(nx: 7) = {
  v(2.6mm)
  block(width: 100%, breakable: false, stroke: 0.8pt + hair, radius: 3mm, clip: true, {
    block(width: 100%, fill: tint, inset: (x: 4mm, y: 2.4mm),
      text(font: display, weight: 800, size: 10.5pt, fill: primaryd, tracking: 0.08em)[
        #upper("Tự đánh giá · Nhận xét của giáo viên")])
    block(width: 100%, inset: (x: 4mm, y: 3mm), {
      grid(columns: (auto, 1fr), gutter: 4mm, align: horizon,
        text(weight: 600, size: 12pt)[Em tự đánh giá:],
        { chk[Hoàn thành tốt]; h(6mm); chk[Hoàn thành]; h(6mm); chk[Cần cố gắng] })
      v(2.6mm)
      text(weight: 600, size: 12pt, fill: muted)[Nhận xét của giáo viên]
      moredots(nx)
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
}

// ── Nội dung riêng của Bài 3. Luỹ thừa với số mũ tự nhiên ────────
#let TEN = [Bài 3. Luỹ thừa với số mũ tự nhiên]

#set page(
  paper: "a4",
  margin: (x: 12mm, top: 11mm, bottom: 12mm),
  fill: white,
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 9pt, fill: muted)
      grid(columns: (1fr, auto), [#TEN — Phiếu học tập], [Toán 7])
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
#show math.equation.where(block: false): it => box(math.display(it))

#dau-phieu(TEN, "04", [Toán 7 · Chương I — Số hữu tỉ])

// ══════════════════════════════════════════════════════════════════
#sec("1", "Hệ thống kiến thức")

#sub("Luỹ thừa với số mũ tự nhiên")
#lythuyet(
  ([*Luỹ thừa bậc $n$* của số hữu tỉ $x$ là gì? Đâu là cơ số, đâu là số mũ?], 3),
  ([Hai *quy ước*: $x^0 = ?$ (với $x != 0$) và $x^1 = ?$], 2),
  ([Viết công thức luỹ thừa của một *tích* và luỹ thừa của một *thương*.], 3))

#sub("Nhân · chia cùng cơ số · Luỹ thừa của luỹ thừa")
#lythuyet(
  ([Nhân hai luỹ thừa *cùng cơ số*: $x^m dot x^n = ?$ Phát biểu bằng lời.], 3),
  ([Chia hai luỹ thừa *cùng cơ số* khác $0$: $x^m : x^n = ?$ Cần điều kiện gì?], 3),
  ([*Luỹ thừa của luỹ thừa*: $(x^m)^n = ?$ Khác gì với $x^m dot x^n$?], 3))

// ══════════════════════════════════════════════════════════════════
#sec("2", "Ví dụ · Luyện tập")

#probm(c-vd, "Ví dụ 1", [Tính:],
  ("a)", [$(-3)^3$;], 3),
  ("b)", [$(1/3)^4$.], 3))

#probm(c-lt, "Luyện tập 1", [Tính:],
  ("a)", [$(-4/5)^4$;], 3),
  ("b)", [$(dc("0,7"))^3$.], 3))

#probm(c-vd, "Ví dụ 2", [Tính và so sánh:],
  ("a)", [$2^2 dot 3^2$ và $(2 dot 3)^2$;], 4),
  ("b)", [$(-14)^2 / 7^2$ và $((-14)/7)^2$.], 4))

#probm(c-lt, "Luyện tập 2", [Tính:],
  ("a)", [$(2/3)^10 dot 3^10$;], 3),
  ("b)", [$(-125)^3 : 25^3$;], 3),
  ("c)", [$(dc("0,08"))^3 dot 10^3$.], 3))

#prob(c-vdung, "Vận dụng",
  [Viết công thức tính thể tích của hình lập phương cạnh $a$ dưới dạng luỹ thừa. Từ đó viết biểu thức luỹ thừa để tính toàn bộ lượng nước trên Trái Đất, biết bể chứa hết lượng nước ấy là hình lập phương cạnh $dc("1 111,34")$ km.], 5)

#probm(c-vd, "Ví dụ 3", [Tính:],
  ("a)", [$(2/3)^5 dot (2/3)^3$;], 4),
  ("b)", [$(-5)^5 : (-5)^5$.], 3))

#probm(c-lt, "Luyện tập 3", [Viết kết quả dưới dạng luỹ thừa:],
  ("a)", [$(-2)^3 dot (-2)^4$;], 3),
  ("b)", [$(dc("0,25"))^7 : (dc("0,25"))^3$.], 3))

#prob(c-vd, "Ví dụ 4", [Tính $[(-5)^3]^7$.], 3)

#prob(c-lt, "Luyện tập 4",
  [Viết các số $(1/4)^8$; $(1/8)^3$ dưới dạng luỹ thừa cơ số $1/2$.], 6)

#block(breakable: false, {
  tag(c-vdung, "Thử thách nhỏ"); h(2mm)
  [Thay mỗi dấu "?" bằng một luỹ thừa của $2$, biết tích các luỹ thừa trên mỗi hàng, mỗi cột và mỗi đường chéo đều bằng nhau.]
  v(1.6mm)
  align(center, table(columns: (18mm, 18mm, 18mm), rows: (11mm, 11mm, 11mm),
    stroke: 0.7pt + hair, align: center + horizon,
    $2^3$, [?], [?],
    [?], $2^4$, [?],
    [?], $2^6$, $2^5$))
})
#dots(6)

// ══════════════════════════════════════════════════════════════════
#sec("3", "Bài tập · SGK tr.18–19")

#prob(c-bt, "Bài 1.18",
  [Viết các số $125$; $3 125$ dưới dạng luỹ thừa của $5$.], 4)

#prob(c-bt, "Bài 1.19",
  [Viết các số $(1/9)^5$; $(1/27)^7$ dưới dạng luỹ thừa cơ số $1/3$.], 6)

#block(breakable: false, {
  tag(c-bt, "Bài 1.20"); h(2mm)
  [Thay mỗi dấu "?" bởi một luỹ thừa của $3$, biết rằng từ ô thứ ba, luỹ thừa cần tìm là tích của hai luỹ thừa ở hai ô liền trước.]
  v(1.6mm)
  align(center, table(columns: (17mm,) * 7, rows: (11mm,),
    stroke: 0.7pt + hair, align: center + horizon,
    $3^0$, $3^1$, [?], [?], [?], [?], [?]))
})
#dots(5)

#probm(c-bt, "Bài 1.21", [Không sử dụng máy tính, hãy tính:],
  ("a)", [$(-3)^8$, biết $(-3)^7 = -2 187$;], 4),
  ("b)", [$(-2/3)^12$, biết $(-2/3)^11 = (-2 048)/(177 147)$.], 5))

#probm(c-bt, "Bài 1.22", [Viết các biểu thức sau dưới dạng luỹ thừa của một số hữu tỉ:],
  ("a)", [$15^8 dot 2^4$;], 4),
  ("b)", [$27^5 : 32^3$.], 5))

#probm(c-bt, "Bài 1.23", [Tính:],
  ("a)", [$(1 + 1/2 - 1/4)^2 dot (2 + 3/7)$;], 6),
  ("b)", [$4 : (1/2 - 1/3)^3$.], 5))

#prob(c-bt, "Bài 1.24",
  [Khoảng cách từ Trái Đất đến Mặt Trời bằng khoảng $dc("1,5") dot 10^8$ km. Khoảng cách từ Mộc tinh đến Mặt Trời khoảng $dc("7,78") dot 10^8$ km. Hỏi khoảng cách từ Mộc tinh đến Mặt Trời gấp khoảng bao nhiêu lần khoảng cách từ Trái Đất đến Mặt Trời?], 6)

#block(breakable: false, {
  tag(c-bt, "Bài 1.25"); h(2mm)
  [Bảng dưới đây cho biết số lượt khách quốc tế đến thăm Việt Nam năm 2019. Em hãy sắp xếp tên các quốc gia theo thứ tự số lượt khách từ nhỏ đến lớn.]
  v(1.6mm)
  table(columns: (1.3fr, 1fr, 1fr, 1fr, 1fr),
    stroke: 0.6pt + hair, align: center + horizon, inset: (x: 2mm, y: 2.2mm),
    hcell([Quốc gia]), hcell([Hàn Quốc]), hcell([Hoa Kỳ]), hcell([Pháp]), hcell([Ý]),
    text(size: 11.5pt)[Số lượt khách],
    $dc("4,3") dot 10^6$, $dc("7,4") dot 10^5$, $dc("2,9") dot 10^5$, $7 dot 10^4$)
})
#dots(6)

// ══════════════════════════════════════════════════════════════════
#sec("4", "Tự luyện thêm")

#prob(c-lt, "Bài 1",
  [Viết mỗi số sau dưới dạng luỹ thừa cơ số $2$: $64$; $(1/32)$; $8^4$.], 7)

#prob(c-lt, "Bài 2",
  [Tính: $(-1/2)^3 dot (-1/2)^2$; $(dc("0,2"))^6 : (dc("0,2"))^4$; $[(3/5)^2]^3$.], 8)

#prob(c-lt, "Bài 3",
  [Một tế bào cứ sau mỗi giờ lại phân đôi một lần. Hỏi sau $10$ giờ, từ một tế bào ban đầu sẽ có bao nhiêu tế bào? Viết kết quả dưới dạng luỹ thừa rồi tính ra số.], 8)

#prob(c-lt, "Bài 4",
  [So sánh $(1/3)^20$ và $(1/9)^9$ bằng cách đưa về cùng một cơ số.], 8)

#prob(c-lt, "Bài 5",
  [Khối lượng của Trái Đất khoảng $6 dot 10^24$ kg, khối lượng của Mặt Trăng khoảng $dc("7,5") dot 10^22$ kg. Hỏi khối lượng Trái Đất gấp khoảng bao nhiêu lần khối lượng Mặt Trăng?], 11)

#cuoi-phieu()
