// ══════════════════════════════════════════════════════════════════
//  PHIẾU HỌC TẬP — Bài 1. Khái niệm phương trình và hệ hai phương
//  trình bậc nhất hai ẩn (Toán 9 — KNTT)
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
        [Bài 1. Phương trình và hệ hai phương trình bậc nhất hai ẩn — Phiếu học tập],
        [Toán 9])
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

// ── Hệ hai phương trình (ngoặc nhọn ôm hai dòng) ───────────────────
#let he(a, b) = math.equation(block: false,
  $cases(delim: "{", #a, #b)$)

// ── Lưới toạ độ trống để HS tự vẽ đường thẳng ─────────────────────
// o = số ô mỗi phía; u = cạnh một ô. Trục Ox, Oy có mũi tên và vạch chia.
#let luoi(w: 5, h: 4, u: 6mm) = {
  let W = (2 * w + 1) * u
  let H = (2 * h + 1) * u
  let ox = (w + 0.5) * u
  let oy = (h + 0.5) * u
  box(width: W, height: H, {
    // ô ly nhạt
    for i in range(2 * w + 2) {
      place(top + left, dx: i * u, dy: 0mm,
        line(length: H, angle: 90deg, stroke: 0.35pt + rgb("#dfe6f2")))
    }
    for j in range(2 * h + 2) {
      place(top + left, dx: 0mm, dy: j * u,
        line(length: W, stroke: 0.35pt + rgb("#dfe6f2")))
    }
    // trục
    place(top + left, dx: 0mm, dy: oy,
      line(length: W, stroke: 0.8pt + primaryd))
    place(top + left, dx: ox, dy: 0mm,
      line(length: H, angle: 90deg, stroke: 0.8pt + primaryd))
    // mũi tên
    place(top + left, dx: W - 1.6mm, dy: oy - 1.1mm,
      polygon(fill: primaryd, (0mm, 0mm), (1.8mm, 1.1mm), (0mm, 2.2mm)))
    place(top + left, dx: ox - 1.1mm, dy: 0mm,
      polygon(fill: primaryd, (0mm, 1.8mm), (1.1mm, 0mm), (2.2mm, 1.8mm)))
    // nhãn trục và gốc
    place(top + left, dx: W - 3.4mm, dy: oy + 1.2mm,
      text(size: 8pt, style: "italic", fill: primaryd)[x])
    place(top + left, dx: ox + 1.2mm, dy: 0.6mm,
      text(size: 8pt, style: "italic", fill: primaryd)[y])
    place(top + left, dx: ox - 3.4mm, dy: oy + 0.6mm,
      text(size: 8pt, weight: 700, fill: primaryd)[O])
    // vạch 1 trên hai trục
    place(top + left, dx: ox + u - 0.9mm, dy: oy + 0.6mm,
      text(size: 7.5pt, fill: muted)[1])
    place(top + left, dx: ox - 3.2mm, dy: oy - u - 1.4mm,
      text(size: 7.5pt, fill: muted)[1])
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
      text(fill: primaryd, font: display, weight: 800, size: 19pt)[Bài 1. Khái niệm phương trình và hệ hai phương trình bậc nhất hai ẩn]
      v(0.6mm)
      text(fill: muted, size: 11.5pt)[Toán 9 · Chương I — Phương trình và hệ hai phương trình bậc nhất hai ẩn]
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

#prob(c-vdung, "Mở đầu",
  [Bài toán cổ: “Quýt, cam mười bảy quả tươi / Đem chia cho một trăm người cùng vui. / Chia ba mỗi quả quýt rồi, / Còn cam, mỗi quả chia mười vừa xinh.” Gọi $x$ là số cam, $y$ là số quýt. Hãy viết hai hệ thức biểu thị các giả thiết của bài toán.], 3)

// ══════════════════════════════════════════════════════════════════
//  MỤC 1
// ══════════════════════════════════════════════════════════════════
#sec("1", "Phương trình bậc nhất hai ẩn")

#sub("Khái niệm · nghiệm · số nghiệm")
#lythuyet(
  ([*Phương trình bậc nhất hai ẩn* $x$ và $y$ là hệ thức dạng:], 4),
  ([Cặp số $(x_0; y_0)$ là *một nghiệm* của phương trình khi:], 4),
  ([Số nghiệm của một phương trình bậc nhất hai ẩn:], 2))
#probm(c-vd, "Ví dụ 1",
  [Cho các hệ thức $4x + 3y = 5$;  $0x + y = -1$;  $0x + 0y = 3$.],
  ("a)", [Hệ thức nào là phương trình bậc nhất hai ẩn? Vì sao?], 4),
  ("b)", [Trong hai cặp số $(2; -1)$ và $(1; 0)$, cặp nào là nghiệm của $4x + 3y = 5$?], 4))
#prob(c-lt, "Luyện tập 1",
  [Hãy viết một phương trình bậc nhất hai ẩn và chỉ ra một nghiệm của nó.], 4)

#prob(c-vd, "Ví dụ 2",
  [Giả sử $(x; y)$ là nghiệm của phương trình $x + 2y = 5$. Điền vào bảng rồi viết 5 nghiệm của phương trình.], 0)
#v(1mm)
#block(breakable: false, table(columns: (1.1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  rows: (9mm, 9mm), stroke: 0.6pt + hair, align: center + horizon,
  inset: (x: 2mm, y: 2mm),
  hcell($x$), $-2$, $-1$, $0$, [], [],
  hcell($y$), [], [], [], $1$, $2$))
#moredots(3)


#sub("Biểu diễn hình học tất cả các nghiệm")
#lythuyet(
  ([*Nghiệm tổng quát* — cách viết:], 3),
  ([Tập hợp các điểm $(x; y)$ thoả mãn $a x + b y = c$ là:], 3),
  ([Hai trường hợp đặc biệt $y = m$ và $x = m$:], 3))

#v(1.4mm)
#block(breakable: false, {
  tag(c-vd, "Ví dụ 3"); h(2mm)
  [Viết nghiệm tổng quát và vẽ đường thẳng biểu diễn tất cả các nghiệm của phương trình $x + 2y = 3$.]
})
#v(1.6mm)
#block(breakable: false,
  grid(columns: (auto, 1fr), gutter: 5mm, align: (center + top, left + top),
    box(stroke: 0.6pt + hair, radius: 2.5mm, fill: rgb("#fcfdff"), inset: 2mm, {
      luoi(w: 4, h: 3)
      v(0.4mm)
      align(center, text(size: 8.5pt, fill: muted)[Em vẽ đường thẳng vào đây])
    }),
    { dline; dline; dline; dline; dline; dline }))

#probm(c-lt, "Luyện tập 2",
  [Viết nghiệm của mỗi phương trình bậc nhất hai ẩn sau và cho biết đường thẳng biểu diễn nằm như thế nào:],
  ("a)", [$2x - 3y = 5$], 3),
  ("b)", [$0x + y = 3$], 2),
  ("c)", [$x + 0y = -2$], 2))

// ══════════════════════════════════════════════════════════════════
//  MỤC 2
// ══════════════════════════════════════════════════════════════════
#sec("2", "Hệ hai phương trình bậc nhất hai ẩn")

#sub("Khái niệm hệ và nghiệm của hệ")
#lythuyet(
  ([*Hệ hai phương trình bậc nhất hai ẩn* là:], 4),
  ([Cặp số $(x_0; y_0)$ là *nghiệm của hệ* khi:], 3),
  ([Ý nghĩa hình học của nghiệm của hệ:], 3))


#prob(c-vd, "Ví dụ 4",
  [Trong ba hệ #text(weight: 700)[a)] #he($2x = -6$, $5x + 4y = 1$) #h(2mm) #text(weight: 700)[b)] #he($x + 2y = -3$, $0x + 0y = 1$) #h(2mm) #text(weight: 700)[c)] #he($3x - y = 1$, $x + y = 3$) hệ nào *không* phải là hệ hai phương trình bậc nhất hai ẩn? Vì sao?], 5)

#prob(c-vd, "Ví dụ 5",
  [Giải thích tại sao cặp số $(1; 2)$ là một nghiệm của hệ phương trình #he($2x - y = 0$, $x + y = 3$)], 6)

#prob(c-lt, "Luyện tập 3",
  [Trong hai cặp số $(0; -2)$ và $(2; -1)$, cặp nào là nghiệm của hệ #he($x - 2y = 4$, $4x + 3y = 5$)?], 7)

#prob(c-vdung, "Vận dụng",
  [Trở lại bài toán cổ ở đầu phiếu, ta có hệ #he($x + y = 17$, $10x + 3y = 100$). Trong hai cặp số $(10; 7)$ và $(7; 10)$, cặp nào là nghiệm của hệ? Từ đó cho biết số cam và số quýt.], 8)

// ══════════════════════════════════════════════════════════════════
//  MỤC 3 — BÀI TẬP VỀ NHÀ
// ══════════════════════════════════════════════════════════════════
#sec("3", "Bài tập về nhà · SGK tr.10")

#prob(c-bt, "Bài 1.1",
  [Phương trình nào sau đây là phương trình bậc nhất hai ẩn? Vì sao? $5x - 8y = 0$;  $4x + 0y = -2$;  $0x + 0y = 1$;  $0x - 3y = 9$.], 7)


#probm(c-bt, "Bài 1.2",
  [Cho phương trình $2x - y = 1$.],
  ("a)", [Điền giá trị thích hợp vào bảng dưới rồi cho biết 6 nghiệm của phương trình.], 0),
  ("b)", [Viết nghiệm tổng quát của phương trình đã cho.], 3))
#v(1mm)
#block(breakable: false, table(columns: (1.5fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  rows: (9mm, 9mm), stroke: 0.6pt + hair, align: center + horizon,
  inset: (x: 1.6mm, y: 2mm),
  hcell($x$), $-1$, $-dc("0,5")$, $0$, $dc("0,5")$, $1$, $2$,
  hcell($y = 2x - 1$), [], [], [], [], [], []))
#moredots(2)

#v(1.6mm)
#block(breakable: false, { tag(c-bt, "Bài 1.3"); h(2mm)
  [Viết nghiệm và biểu diễn hình học tất cả các nghiệm của mỗi phương trình bậc nhất hai ẩn sau.] })
#v(1.4mm)
#let o-ve(nhan) = {
  align(left, text(weight: 600, nhan))
  v(1mm)
  box(stroke: 0.6pt + hair, radius: 2.5mm, fill: rgb("#fcfdff"), inset: 1.6mm,
    luoi(w: 3, h: 3, u: 5.4mm))
}
#block(breakable: false,
  grid(columns: (1fr, 1fr, 1fr), gutter: 3mm, align: center + top,
    o-ve[a) $2x - y = 3$],
    o-ve[b) $0x + 2y = -4$],
    o-ve[c) $3x + 0y = 5$]))
#moredots(5)

#probm(c-bt, "Bài 1.4",
  [Cho hệ phương trình #he($2x = -6$, $5x + 4y = 1$)],
  ("a)", [Hệ trên có là một hệ hai phương trình bậc nhất hai ẩn không? Vì sao?], 4),
  ("b)", [Cặp số $(-3; 4)$ có là một nghiệm của hệ hay không? Vì sao?], 5))


#probm(c-bt, "Bài 1.5",
  [Cho các cặp số $(-2; 1)$;  $(0; 2)$;  $(1; 0)$;  $(dc("1,5"); 3)$;  $(4; -3)$ và hai phương trình $5x + 4y = 8$ #h(2mm) (1);  $3x + 5y = -3$ #h(2mm) (2).],
  ("a)", [Những cặp số nào là nghiệm của phương trình (1)?], 6),
  ("b)", [Cặp số nào là nghiệm của hệ gồm phương trình (1) và phương trình (2)?], 8))
#v(1.4mm)
#block(breakable: false,
  grid(columns: (auto, 1fr), gutter: 5mm, align: (center + top, left + top),
    box(stroke: 0.6pt + hair, radius: 2.5mm, fill: rgb("#fcfdff"), inset: 2mm, {
      luoi(w: 5, h: 4, u: 8mm)
      v(0.4mm)
      align(center, text(size: 8.5pt, fill: muted)[c) Vẽ hai đường thẳng để minh hoạ])
    }),
    { text(weight: 600)[Nhận xét về giao điểm của hai đường thẳng:]
      dline; dline; dline; dline; dline; dline; dline; dline; dline; dline }))

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
    moredots(9)
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
