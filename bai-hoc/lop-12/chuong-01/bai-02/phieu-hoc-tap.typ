// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Toán 12, Chương I. Ứng dụng đạo hàm để khảo sát
//  và vẽ đồ thị hàm số (KNTT)
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

// ── Nội dung riêng của Bài 2. Giá trị lớn nhất và giá trị nhỏ nhất của hàm số ──
#let TEN = [Bài 2. Giá trị lớn nhất và giá trị nhỏ nhất của hàm số]

#set page(
  paper: "a4",
  margin: (x: 12mm, top: 11mm, bottom: 12mm),
  fill: white,
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 9pt, fill: muted)
      grid(columns: (1fr, auto), [#TEN — Phiếu học tập], [Toán 12])
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

#dau-phieu(TEN, "02", [Toán 12 · Chương I — Ứng dụng đạo hàm])

#sec("1", "Giá trị lớn nhất và giá trị nhỏ nhất")

#lythuyet(
  ([Số $M$ là *giá trị lớn nhất* của $f(x)$ trên $D$ khi nào? Kí hiệu ra sao?], 4),
  ([Số $m$ là *giá trị nhỏ nhất* của $f(x)$ trên $D$ khi nào? Kí hiệu ra sao?], 4),
  ([Vì sao "chặn trên" thôi thì *chưa đủ*? Cho một ví dụ hàm số không có giá trị lớn nhất.], 3),
  ([Ba bước tìm giá trị lớn nhất, nhỏ nhất của hàm số liên tục trên đoạn $[a; b]$.], 5))

#prob(c-vd, "Ví dụ 1",
  [Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số $y = sqrt(1 - x^2)$.], 11)

#prob(c-vd, "Ví dụ 2",
  [Tìm giá trị lớn nhất và giá trị nhỏ nhất (nếu có) của hàm số $y = x - 2 + 1/x$ trên khoảng $(0; +oo)$.], 12)

#prob(c-vdung, "Vận dụng",
  [Từ một tấm bìa hình vuông cạnh $60$ cm, người ta cắt bốn hình vuông bằng nhau ở bốn góc rồi gập thành một chiếc hộp không nắp. Phải cắt các hình vuông cạnh bao nhiêu để thể tích hộp lớn nhất?], 13)

#sec("2", "Tìm giá trị lớn nhất, nhỏ nhất trên một đoạn")

#lythuyet(
  ([Vì sao trên một *đoạn* $[a; b]$ thì hàm số liên tục luôn có cả giá trị lớn nhất lẫn giá trị nhỏ nhất?], 3),
  ([Ba bước: tìm các điểm tới hạn → tính giá trị ở đâu → so sánh thế nào?], 5),
  ([Ba chỗ hay sai: quên …; lấy nghiệm nằm …; nhầm giá trị lớn nhất với …], 3))

#prob(c-vd, "Ví dụ 3",
  [Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số $y = x^4 - 4x^2 + 3$ trên đoạn $[0; 4]$.], 10)

#prob(c-vd, "Ví dụ 4",
  [Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số $y = sin x + cos x$ trên đoạn $[0; 2 pi]$.], 11)

#probm(c-lt, "Luyện tập", [Tìm giá trị lớn nhất và giá trị nhỏ nhất của các hàm số sau:],
  ("a)", [$y = 2x^3 - 3x^2 + 5x + 2$ trên đoạn $[0; 2]$;], 9),
  ("b)", [$y = (x + 1) e^(-x)$ trên đoạn $[-1; 1]$.], 10))

#sec("3", "Bài tập · SGK tr.19")

#probm(c-bt, "Bài 1.10", [Tìm giá trị lớn nhất và giá trị nhỏ nhất (nếu có) của các hàm số sau:],
  ("a)", [$y = -x^2 + 4x + 3$;], 6),
  ("b)", [$y = x^3 - 2x^2 + 1$ trên $[0; +oo)$;], 10),
  ("c)", [$y = sqrt(4x - 2x^2)$.], 9))

#probm(c-bt, "Bài 1.12", [Tìm giá trị lớn nhất và giá trị nhỏ nhất của các hàm số sau:],
  ("a)", [$y = 2x^3 - 6x + 3$ trên đoạn $[-1; 2]$;], 9),
  ("b)", [$y = x^4 - 3x^2 + 2$ trên đoạn $[0; 3]$.], 10))

#prob(c-bt, "Bài 1.13",
  [Trong các hình chữ nhật có chu vi là $24$ cm, hãy tìm hình chữ nhật có diện tích lớn nhất.], 11)

#prob(c-bt, "Bài 1.14",
  [Một chiếc hộp không nắp có đáy là hình vuông và diện tích bề mặt bằng $108$ cm#super[2]. Tìm các kích thước của hộp để thể tích lớn nhất.], 13)

#sec("4", "Tự luyện thêm")

#prob(c-lt, "Bài 1",
  [Tìm giá trị lớn nhất và giá trị nhỏ nhất của $y = x^3 - 3x^2 - 9x + 5$ trên đoạn $[-2; 4]$.], 12)

#prob(c-lt, "Bài 2",
  [Tìm giá trị nhỏ nhất của hàm số $y = x + 9/x$ trên khoảng $(0; +oo)$.], 10)

#prob(c-lt, "Bài 3",
  [Một sợi dây dài $60$ cm được cắt thành hai đoạn: một đoạn uốn thành hình vuông, đoạn kia uốn thành hình tròn. Tìm cách cắt để tổng diện tích hai hình là nhỏ nhất.], 14)

#prob(c-lt, "Bài 4",
  [Tìm $m$ để giá trị nhỏ nhất của hàm số $y = x^3 - 3x + m$ trên đoạn $[0; 2]$ bằng $1$.], 13)

#cuoi-phieu(nx: 9)
