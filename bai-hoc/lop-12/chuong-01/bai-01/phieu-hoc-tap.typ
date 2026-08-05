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

// ── Nội dung riêng của Bài 1. Tính đơn điệu và cực trị của hàm số ──
#let TEN = [Bài 1. Tính đơn điệu và cực trị của hàm số]

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

#dau-phieu(TEN, "01", [Toán 12 · Chương I — Ứng dụng đạo hàm])

// ══════════════════════════════════════════════════════════════════
#sec("1", "Tính đơn điệu của hàm số")

#lythuyet(
  ([Hàm số $y = f(x)$ *đồng biến* trên $K$ khi nào? *Nghịch biến* trên $K$ khi nào?], 4),
  ([Định lí về dấu của đạo hàm: nếu $f'(x) > 0$ trên $K$ thì …; nếu $f'(x) < 0$ trên $K$ thì …], 4),
  ([Nhìn đồ thị: hàm số đồng biến thì đồ thị …, nghịch biến thì đồ thị …], 2),
  ([Bốn bước xét tính đơn điệu của hàm số bằng bảng biến thiên.], 5))

#prob(c-vd, "Ví dụ 1",
  [Tìm các khoảng đồng biến, khoảng nghịch biến của hàm số $y = x^2 - 4x + 2$.], 5)

#prob(c-vd, "Ví dụ 2",
  [Tìm các khoảng đơn điệu của hàm số $y = (x^2 - 2x + 5)/(x - 1)$. Nhớ lập bảng biến thiên rồi mới kết luận.], 12)

#prob(c-lt, "Luyện tập 1",
  [Tìm các khoảng đơn điệu của hàm số $y = 1/3 x^3 + 3x^2 + 5x + 2$.], 12)

#prob(c-vdung, "Vận dụng",
  [Một chất điểm chuyển động trên trục số nằm ngang, chiều dương từ trái sang phải. Vị trí $s(t)$ (mét) tại thời điểm $t$ (giây) là $s(t) = t^3 - 9t^2 + 15t$, với $t >= 0$. Trong khoảng thời gian nào chất điểm chuyển động sang phải, trong khoảng nào chuyển động sang trái?], 9)

// ══════════════════════════════════════════════════════════════════
#sec("2", "Cực trị của hàm số")

#lythuyet(
  ([Hàm số $f(x)$ đạt *cực đại* tại $x_0$ khi nào? Đạt *cực tiểu* tại $x_0$ khi nào?], 4),
  ([Phân biệt *điểm cực đại của hàm số*, *giá trị cực đại* và *điểm cực đại của đồ thị*.], 3),
  ([Định lí: nếu $f'(x)$ đổi dấu từ $-$ sang $+$ khi $x$ qua $x_0$ thì …; từ $+$ sang $-$ thì …], 3),
  ([Bốn bước tìm cực trị của hàm số. Khi nào $f'(x_0) = 0$ mà $x_0$ *không* là điểm cực trị?], 5))

#prob(c-vd, "Ví dụ 3",
  [Tìm cực trị của hàm số $y = x^3 - 6x^2 + 9x + 30$.], 11)

#prob(c-vd, "Ví dụ 4",
  [Tìm cực trị của hàm số $y = (x^2 - 2x + 9)/(x - 2)$.], 13)

#prob(c-lt, "Luyện tập 2",
  [Tìm cực trị của hàm số $y = x^4 - 3x^2 + 1$.], 13)

#prob(c-vdung, "Vận dụng",
  [Một vật được phóng thẳng đứng lên trên từ độ cao $2$ m với vận tốc ban đầu $dc("24,5")$ m/s. Bỏ qua sức cản của không khí thì độ cao $h$ (mét) của vật sau $t$ giây là $h(t) = 2 + dc("24,5") t - dc("4,9") t^2$. Hỏi tại thời điểm nào vật đạt độ cao lớn nhất?], 8)

// ══════════════════════════════════════════════════════════════════
#sec("3", "Bài tập · SGK tr.13 – 14")

#probm(c-bt, "Bài 1.2", [Xét sự đồng biến, nghịch biến của các hàm số sau:],
  ("a)", [$y = 1/3 x^3 - 2x^2 + 3x + 1$;], 9),
  ("b)", [$y = -x^3 + 2x^2 - 5x + 3$.], 6))

#probm(c-bt, "Bài 1.3", [Tìm các khoảng đơn điệu của các hàm số sau:],
  ("a)", [$y = (2x - 1)/(x + 2)$;], 6),
  ("b)", [$y = (x^2 + x + 4)/(x - 3)$.], 10))

#probm(c-bt, "Bài 1.4", [Xét chiều biến thiên của các hàm số sau:],
  ("a)", [$y = sqrt(4 - x^2)$;], 7),
  ("b)", [$y = x/(x^2 + 1)$.], 10))

#prob(c-bt, "Bài 1.5",
  [Số dân của một thị trấn sau $t$ năm kể từ năm $2000$ được mô tả bởi hàm số $N(t) = (25t + 10)/(t + 5)$ với $t >= 0$, trong đó $N(t)$ tính bằng nghìn người. Tính số dân vào các năm $2000$ và $2015$; tính $N'(t)$ và giới hạn của $N(t)$ khi $t -> +oo$, từ đó giải thích vì sao số dân luôn tăng nhưng không vượt quá một ngưỡng nào đó.], 13)

#probm(c-bt, "Bài 1.7", [Tìm cực trị của các hàm số sau:],
  ("a)", [$y = 2x^3 - 9x^2 + 12x - 5$;], 10),
  ("b)", [$y = x^4 - 4x^2 + 2$;], 11),
  ("c)", [$y = sqrt(4x - 2x^2)$.], 10))

// ══════════════════════════════════════════════════════════════════
#sec("4", "Tự luyện thêm")

#prob(c-lt, "Bài 1",
  [Tìm các khoảng đồng biến, nghịch biến của hàm số $y = -x^3 + 3x^2 + 9x - 1$.], 10)

#prob(c-lt, "Bài 2",
  [Chứng minh hàm số $y = (3x + 1)/(x - 2)$ nghịch biến trên mỗi khoảng của tập xác định.], 9)

#prob(c-lt, "Bài 3",
  [Tìm cực trị của hàm số $y = x + 4/x$.], 12)

#prob(c-lt, "Bài 4",
  [Tìm tất cả các giá trị của tham số $m$ để hàm số $y = 1/3 x^3 - m x^2 + 9x + 2024$ đồng biến trên $RR$.], 11)

#prob(c-lt, "Bài 5",
  [Một mảnh vườn hình chữ nhật có chu vi $60$ m. Gọi $x$ (m) là chiều rộng. Viết diện tích mảnh vườn theo $x$ rồi tìm $x$ để diện tích lớn nhất.], 13)

#prob(c-lt, "Bài 6",
  [Cho hàm số $y = (x^2 + 3)/(x + 1)$. Tìm tập xác định, tính $y'$ và lập bảng biến thiên của hàm số.], 11)

#prob(c-lt, "Bài 7",
  [Tìm $m$ để hàm số $y = x^3 - 3x^2 + m x$ có hai điểm cực trị.], 8)

#prob(c-lt, "Bài 8",
  [Một công ty ước tính lợi nhuận (triệu đồng) khi bán $x$ sản phẩm mỗi tháng là $L(x) = -x^3 + 45x^2 - 600x + 500$ với $0 <= x <= 30$. Tìm số sản phẩm cần bán để lợi nhuận đạt cực đại.], 9)

#cuoi-phieu()
