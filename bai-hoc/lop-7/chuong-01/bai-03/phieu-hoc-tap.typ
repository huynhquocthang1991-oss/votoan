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

// ── Nội dung riêng của Luyện tập chung (Bài 1 – Bài 2) ────────────
#let TEN = [Luyện tập chung (Bài 1 – Bài 2)]

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

#dau-phieu(TEN, "03", [Toán 7 · Chương I — Số hữu tỉ])

// ══════════════════════════════════════════════════════════════════
#sec("1", "Nhắc lại công cụ đã học")

#lythuyet(
  ([Muốn *so sánh* hai số hữu tỉ, ta đưa chúng về dạng nào? Với hai số âm thì sao?], 4),
  ([Nhắc lại quy tắc *cộng, trừ* và quy tắc *nhân, chia* hai số hữu tỉ.], 5),
  ([Những tính chất nào giúp *tính hợp lí*? Khi nào thì đặt được thừa số chung?], 4))

// ══════════════════════════════════════════════════════════════════
#sec("2", "Ví dụ mẫu")

#probm(c-vd, "Ví dụ 1", [Tính một cách hợp lí:],
  ("a)", [$A = 37/5 + (-dc("0,7")) + 5/2 + (-dc("4,3"))$;], 6),
  ("b)", [$B = 3/2 dot (-37/10) + 17/2 dot (-37/10)$.], 5))

#block(breakable: false, {
  tag(c-vd, "Ví dụ 2"); h(2mm)
  [a) Biểu diễn các số hữu tỉ $dc("1,75")$; $-dc("1,25")$ và $1/4$ trên trục số dưới đây (chia mỗi đoạn thẳng đơn vị thành bốn phần bằng nhau).]
  v(1.6mm)
  trucso(-2, 2, 1, ((-2, "−2"), (-1, "−1"), (0, "0"), (1, "1"), (2, "2")))
})
#dots(2)
#block(breakable: false, {
  [b) Dựa vào trục số vừa vẽ, sắp xếp ba số trên theo thứ tự từ nhỏ đến lớn.]
})
#dots(3)

// ══════════════════════════════════════════════════════════════════
#sec("3", "Bài tập · SGK tr.14–15")

#probm(c-bt, "Bài 1.12", [So sánh:],
  ("a)", [$123/7$ và $dc("17,75")$;], 5),
  ("b)", [$-65/9$ và $-dc("7,125")$.], 5))

#block(breakable: false, {
  tag(c-bt, "Bài 1.13"); h(2mm)
  [Bảng sau cho biết điểm đông đặc và điểm sôi của sáu nguyên tố được gọi là khí hiếm.]
  v(1.6mm)
  table(columns: (1.4fr, 1fr, 1fr),
    stroke: 0.6pt + hair, align: center + horizon, inset: (x: 2mm, y: 1.9mm),
    hcell([Khí hiếm]), hcell([Điểm đông đặc (°C)]), hcell([Điểm sôi (°C)]),
    [Argon], $-dc("189,2")$, $-dc("185,7")$,
    [Helium], $-dc("272,2")$, $-dc("268,6")$,
    [Neon], $-dc("248,67")$, $-dc("245,72")$,
    [Krypton], $-dc("156,6")$, $-dc("152,3")$,
    [Radon], $-dc("71,0")$, $-dc("61,8")$,
    [Xenon], $-dc("111,9")$, $-dc("107,1")$)
})
#v(1.4mm)
#block(breakable: false, [a) Khí hiếm nào có điểm đông đặc nhỏ hơn điểm đông đặc của Krypton?])
#dots(2)
#block(breakable: false, [b) Khí hiếm nào có điểm sôi lớn hơn điểm sôi của Argon?])
#dots(2)
#block(breakable: false, [c) Sắp xếp các khí hiếm theo thứ tự điểm đông đặc tăng dần.])
#dots(3)
#block(breakable: false, [d) Sắp xếp các khí hiếm theo thứ tự điểm sôi giảm dần.])
#dots(3)

#prob(c-bt, "Bài 1.14",
  [Ngày 10-01-2021, nhiệt độ thấp nhất tại thị xã Sa Pa là $-dc("0,7")$ °C; nhiệt độ tại thành phố Lào Cai khoảng $dc("9,6")$ °C. Hỏi nhiệt độ tại thành phố Lào Cai cao hơn nhiệt độ tại thị xã Sa Pa bao nhiêu độ C?], 5)

#prob(c-bt, "Bài 1.15",
  [Trong một sơ đồ tháp bốn tầng, hàng dưới cùng lần lượt là $dc("0,01")$; $-10$; $10$; $-dc("0,01")$. Số trong mỗi ô ở hàng trên bằng tích của hai số trong hai ô kề nó ở hàng dưới. Hãy tìm các số ở ba hàng còn lại.], 8)

#probm(c-bt, "Bài 1.16", [Tính giá trị của các biểu thức sau:],
  ("a)", [$A = (2 - 1/2 - 1/8) : (1 - 3/2 - 3/4)$;], 7),
  ("b)", [$B = 5 - (1 + 1/3)/(1 - 1/3)$.], 6))

#prob(c-bt, "Bài 1.17",
  [Tính một cách hợp lí: $dc("1,2") dot 15/4 + 16/7 dot (-85)/8 - dc("1,2") dot 5 3/4 - 16/7 dot (-71)/8$.], 8)

// ══════════════════════════════════════════════════════════════════
#sec("4", "Tự luyện thêm")

#prob(c-lt, "Bài 1",
  [Sắp xếp các số sau theo thứ tự từ nhỏ đến lớn: $-dc("2,4")$; $-12/5$; $-7/3$; $-dc("2,45")$.], 7)

#prob(c-lt, "Bài 2",
  [Tính một cách hợp lí: $C = 13/9 dot (-dc("2,5")) + 13/9 dot (-dc("7,5"))$.], 7)

#prob(c-lt, "Bài 3",
  [Một bể nước chứa $dc("1,25")$ m#super[3] nước. Người ta lấy ra $3/5$ m#super[3] rồi lại đổ thêm vào $dc("0,45")$ m#super[3]. Hỏi trong bể còn bao nhiêu mét khối nước?], 8)

#prob(c-lt, "Bài 4",
  [Cho $x = -3/5$ và $y = dc("1,5")$. Tính $x + y$; $x - y$; $x dot y$ và $x : y$.], 10)

#prob(c-lt, "Bài 5",
  [Ba bạn góp tiền mua một món quà. An góp $dc("35,5")$ nghìn đồng, Bình góp $71/2$ nghìn đồng, Cường góp phần còn lại. Biết món quà giá $75$ nghìn đồng, hỏi Cường góp bao nhiêu nghìn đồng và bạn nào góp nhiều nhất?], 12)

#cuoi-phieu()
