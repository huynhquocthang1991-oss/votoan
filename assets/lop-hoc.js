/* =====================================================================
 * lop-hoc.js — phần lớp học nhúng vào trang bài học.
 * Đặc tả: CHUAN_LOP_HOC.md mục 3.1, 6, 9.
 *
 * Nguyên tắc số 1 của cả file này (mục 1.2):
 *   KHÔNG ĐĂNG NHẬP THÌ TRANG BÀI HỌC HIỆN Y HỆT NHƯ CŨ.
 *   Đăng nhập chỉ để THÊM, không để CHẶN.
 * Chưa cấu hình Supabase cũng vậy — im lặng rút lui, không báo lỗi đỏ lên trang.
 * ===================================================================== */
(function () {
  'use strict';

  var CH = window.LOP_HOC_CAUHINH || {};
  var BAT = !!(CH.URL && CH.ANON_KEY);

  var CANH_DAI_TOI_DA = 1600;   // mục 6.3 — ảnh 12MP không giúp AI đọc tốt hơn
  var NGUONG_MO = 55;           // phương sai Laplacian, dưới ngưỡng là mờ
  var NGUONG_TOI = 42;          // độ sáng trung bình 0–255
  var CANH_TOI_THIEU = 800;

  var phien = null, toi = null, giaoVien = null, sb = null, vaiTro = 'khach';

  /* Lời hứa "đã đọc xong phiên đăng nhập". Trang trắc nghiệm phải đợi cái này
   * trước khi gửi câu trả lời đầu tiên: em bấm trong giây đầu mà phiên chưa
   * đọc xong thì goi() gửi bằng ANON_KEY, server coi là khách vãng lai và câu
   * đó KHÔNG được sao. Lỗi im lặng, chỉ rơi vào em nào bấm nhanh. */
  var khoiDong = null;

  /* ------------------------------------------------------------ nền tảng */

  function napSupabase() {
    return new Promise(function (ok, hong) {
      if (window.supabase) return ok(window.supabase);
      var s = document.createElement('script');
      s.src = 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.js';
      s.onload = function () { ok(window.supabase); };
      s.onerror = function () { hong(new Error('mat-mang')); };
      document.head.appendChild(s);
    });
  }

  function goi(ten, than) {
    return fetch(CH.URL + '/functions/v1/' + ten, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + (phien ? phien.access_token : CH.ANON_KEY),
        'apikey': CH.ANON_KEY
      },
      body: JSON.stringify(than)
    }).then(function (r) {
      if (!r.ok) return r.json().catch(function () { return {}; })
        .then(function (j) { throw new Error(j.loi || 'that-bai'); });
      return r.json();
    }, function () { throw new Error('mat-mang'); });
  }

  /* ------------------------------------------------------------ ảnh */

  /* Kiểm ngay trên máy trước khi gửi (mục 6.2). Chặn sớm rẻ hơn nhiều so với
   * gửi lên rồi AI trả về "không đọc được". */
  function xetAnh(canvas) {
    var ctx = canvas.getContext('2d');
    var n = 220;
    var c2 = document.createElement('canvas');
    c2.width = n; c2.height = Math.round(n * canvas.height / canvas.width);
    c2.getContext('2d').drawImage(canvas, 0, 0, c2.width, c2.height);
    var d = c2.getContext('2d').getImageData(0, 0, c2.width, c2.height).data;

    var xam = new Float32Array(c2.width * c2.height), tong = 0;
    for (var i = 0; i < xam.length; i++) {
      var v = 0.299 * d[i * 4] + 0.587 * d[i * 4 + 1] + 0.114 * d[i * 4 + 2];
      xam[i] = v; tong += v;
    }
    var sang = tong / xam.length;

    // Laplacian 4 hướng — phương sai thấp nghĩa là ít biên, tức là mờ.
    var lap = [], w = c2.width;
    for (var y = 1; y < c2.height - 1; y++) {
      for (var x = 1; x < w - 1; x++) {
        var k = y * w + x;
        lap.push(4 * xam[k] - xam[k - 1] - xam[k + 1] - xam[k - w] - xam[k + w]);
      }
    }
    var tb = lap.reduce(function (a, b) { return a + b; }, 0) / lap.length;
    var ps = lap.reduce(function (a, b) { return a + (b - tb) * (b - tb); }, 0) / lap.length;

    if (Math.max(canvas.width, canvas.height) < CANH_TOI_THIEU)
      return 'Ảnh hơi nhỏ. Em lại gần hơn chút rồi chụp lại nhé.';
    if (sang < NGUONG_TOI)
      return 'Chỗ này thiếu sáng quá, thầy cô nhìn không rõ. Em ra chỗ sáng hơn nhé.';
    if (ps < NGUONG_MO)
      return 'Ảnh hơi mờ. Em giữ máy chắc tay rồi chụp lại nhé.';
    return null;
  }

  function nenAnh(file) {
    return new Promise(function (ok, hong) {
      var img = new Image();
      img.onload = function () {
        var t = Math.min(1, CANH_DAI_TOI_DA / Math.max(img.width, img.height));
        var c = document.createElement('canvas');
        c.width = Math.round(img.width * t);
        c.height = Math.round(img.height * t);
        c.getContext('2d').drawImage(img, 0, 0, c.width, c.height);
        var loi = xetAnh(c);
        if (loi) return hong(new Error(loi));
        c.toBlob(function (b) { ok(b); }, 'image/jpeg', 0.8);
        URL.revokeObjectURL(img.src);
      };
      img.onerror = function () { hong(new Error('Không đọc được ảnh này.')); };
      img.src = URL.createObjectURL(file);
    });
  }

  /* ------------------------------------------------------------ chú thích lên ảnh */

  /* Vẽ nhận xét của máy đè lên chính ảnh bài làm.
   *
   * CỐ Ý KHÔNG để model sinh ảnh mới: nó sẽ vẽ lại bài của học sinh thành một
   * bài khác, chữ Việt hỏng, và mỗi lần chạy ra một kiểu. Ở đây model chỉ trả
   * TOẠ ĐỘ (mục "chu_thich" trong cham-bai), còn nét vẽ là của mình — chuẩn,
   * lặp lại được, không tốn thêm đồng API nào.
   *
   * Vẽ DẢI NGANG chứ không đóng khung ôm sát chữ: model định vị chữ viết tay
   * chỉ chính xác cỡ vài phần trăm chiều cao ảnh, khung ôm sát mà lệch là đóng
   * vào dòng bên cạnh.
   */
  var MAU_CHU_THICH = {
    sai:   { vien: '#c62828', nen: 'rgba(198,40,40,.14)',  chu: '#fff' },
    thieu: { vien: '#d84f00', nen: 'rgba(216,79,0,.14)',   chu: '#fff' },
    tot:   { vien: '#2e7d32', nen: 'rgba(46,125,50,.14)',  chu: '#fff' }
  };

  function veChuThich(anh, danhSach) {
    var c = document.createElement('canvas');
    c.width = anh.naturalWidth || anh.width;
    c.height = anh.naturalHeight || anh.height;
    var ctx = c.getContext('2d');
    ctx.drawImage(anh, 0, 0);

    var don = Math.max(12, Math.round(c.width / 46));   // cỡ chữ theo bề ngang ảnh
    (danhSach || []).forEach(function (ct) {
      var mau = MAU_CHU_THICH[ct.loai] || MAU_CHU_THICH.sai;
      var y = ct.tu * c.height;
      var cao = Math.max(don * 1.2, (ct.den - ct.tu) * c.height);

      ctx.fillStyle = mau.nen;
      ctx.fillRect(0, y, c.width, cao);
      ctx.strokeStyle = mau.vien;
      ctx.lineWidth = Math.max(2, c.width / 300);
      ctx.strokeRect(ctx.lineWidth / 2, y, c.width - ctx.lineWidth, cao);

      if (!ct.chu) return;
      ctx.font = '600 ' + don + 'px "Be Vietnam Pro",system-ui,sans-serif';
      var rong = ctx.measureText(ct.chu).width + don;
      /* Nhãn nằm trong lòng ảnh, ưu tiên mép phải; dải sát mép dưới thì lật
         nhãn lên trên, không thì chữ rơi ra ngoài khung. */
      var nx = Math.max(0, c.width - rong - don / 2);
      var ny = y + cao + don * 1.4 < c.height ? y + cao : y - don * 1.4;
      ctx.fillStyle = mau.vien;
      ctx.fillRect(nx, ny, rong, don * 1.4);
      ctx.fillStyle = mau.chu;
      ctx.fillText(ct.chu, nx + don / 2, ny + don * 1.02);
    });
    return c;
  }

  /* Ảnh trong Storage là riêng tư nên phải xin đường dẫn ký hạn giờ. */
  function duongDanAnh(url) {
    return sb.storage.from('bai-lam').createSignedUrl(url, 3600)
      .then(function (r) {
        if (r.error || !r.data) throw new Error('không mở được ảnh');
        return r.data.signedUrl;
      });
  }

  function napAnh(src) {
    return new Promise(function (ok, hong) {
      var i = new Image();
      i.crossOrigin = 'anonymous';
      i.onload = function () { ok(i); };
      i.onerror = function () { hong(new Error('không tải được ảnh')); };
      i.src = src;
    });
  }

  /* ------------------------------------------------------------ nộp bài */

  function veKhoiNop(bt) {
    var ma = bt.dataset.ma;
    var hop = document.createElement('div');
    hop.className = 'lh-nop';
    hop.innerHTML =
      '<div class="lh-nop-dau">' +
        '<b>Nộp bài làm</b>' +
        '<span class="lh-luot"></span>' +
      '</div>' +
      '<p class="lh-dan">Chụp <b>riêng câu này</b>, đừng chụp cả trang — máy đọc rõ hơn nhiều. ' +
      'Em <b>không cần ghi tên lên giấy</b> nhé.</p>' +
      '<label class="lh-nut-chup">Chụp / chọn ảnh' +
        '<input type="file" accept="image/*" capture="environment" hidden>' +
      '</label>' +
      '<p class="lh-bao" role="status"></p>' +
      '<div class="lh-kq"></div>';
    bt.appendChild(hop);

    var nhap = hop.querySelector('input');
    var bao = hop.querySelector('.lh-bao');
    var kq = hop.querySelector('.lh-kq');

    nhap.addEventListener('change', function () {
      var f = nhap.files[0];
      if (!f) return;
      bao.className = 'lh-bao dang';
      bao.textContent = 'Đang xử lí ảnh…';
      nenAnh(f).then(function (blob) {
        bao.textContent = 'Đang gửi…';
        return taiLen(ma, blob);
      }).then(function (r) {
        bao.className = 'lh-bao';
        bao.textContent = 'Đã gửi. Đang chấm…';
        return doiKetQua(r.bai_nop_id, kq, bao);
      }).catch(function (e) {
        bao.className = 'lh-bao loi';
        bao.textContent = e.message === 'mat-mang'
          ? 'Máy chưa nối mạng. Bài của em được giữ lại, gửi sau khi có mạng nhé.'
          : e.message;
        nhap.value = '';
      });
    });

    capNhatLuot(ma, hop);
  }

  function taiLen(maBaiTap, blob) {
    /* Mã bài có dấu # (…/bai-13#bt7). Để nguyên trong đường dẫn Storage thì
     * trình duyệt cắt phần sau # thành fragment: mọi câu trong cùng bài đụng
     * chung một tên và ảnh đầu tiên cũng không tải lại được. Chỉ giữ bộ ký tự
     * an toàn cho một đoạn đường dẫn; dấu / và # đều chuyển thành _. */
    var maAnToan = maBaiTap.replace(/[^A-Za-z0-9._-]+/g, '_');
    var ten = toi.id + '/' + maAnToan + '-' + Date.now() + '.jpg';
    return sb.storage.from('bai-lam').upload(ten, blob, { contentType: 'image/jpeg' })
      .then(function (r) {
        if (r.error) throw new Error('Gửi ảnh không được, em thử lại nhé.');
        return goi('nop-bai', { bai_tap_ma: maBaiTap, anh_url: ten });
      });
  }

  /* Học sinh xem nhận xét NGAY, có nhãn chờ duyệt (mục 9). */
  function doiKetQua(baiNopId, kq, bao) {
    var lan = 0;
    return new Promise(function (ok) {
      (function hoi() {
        sb.from('bai_nop').select('trang_thai').eq('id', baiNopId).single()
          .then(function (r) {
            if (r.data && r.data.trang_thai !== 'dang_cham') {
              bao.textContent = '';
              return veNhanXet(baiNopId, kq).then(ok);
            }
            if (++lan > 40) { bao.textContent = 'Chấm hơi lâu, em quay lại sau nhé.'; return ok(); }
            setTimeout(hoi, 1500);
          });
      })();
    });
  }

  /* Chỗ lập luận chưa chắc, tách khỏi kết luận đúng/sai.
   *
   * Máy chấm theo KẾT QUẢ (mục 7.4): em ra đúng đáp số bằng cách nào cũng là
   * đúng. Nhưng chỗ hỏng trên đường đi thì vẫn phải nói — nói ở đây, dưới dạng
   * lời nhắc cho lần sau, và nói rõ là không mất điểm. Trộn nó vào phần kết luận
   * là em đọc xong không biết rốt cuộc mình đúng hay sai.
   */
  function luuYLapLuan(k) {
    var ds = k && k.luu_y_lap_luan;
    if (!Array.isArray(ds) || !ds.length) return '';
    return '<div class="lh-luuy"><p class="lh-luuy-dau">' +
      (k.ket_luan === 'dung'
        ? 'Vài chỗ để lần sau chắc tay hơn — không làm em mất điểm nào cả:'
        : 'Vài chỗ trong lập luận em xem lại nhé:') +
      '</p><ul>' + ds.map(function (l) {
        return '<li>' + (l && l.cho ? '<b>' + thoat(l.cho) + '.</b> ' : '') +
               thoat(l && l.van_de) + '</li>';
      }).join('') + '</ul></div>';
  }

  function veNhanXet(baiNopId, kq) {
    return Promise.all([
      sb.from('bai_nop').select('trang_thai,luc_hoc_sinh_doc,lan_thu').eq('id', baiNopId).single(),
      sb.from('cham_may').select('ket_qua_json,luc_cham').eq('bai_nop_id', baiNopId)
        .order('luc_cham', { ascending: false }).limit(1),
      sb.from('cham_nguoi').select('ket_luan,nhan_xet,luc_duyet').eq('bai_nop_id', baiNopId)
        .order('luc_duyet', { ascending: false }).limit(1)
    ]).then(function (r) {
      var bn = r[0].data, may = (r[1].data || [])[0], nguoi = (r[2].data || [])[0];
      if (!bn) return;

      var html = '';
      var daDoc = !!bn.luc_hoc_sinh_doc;

      if (nguoi && bn.trang_thai === 'da_sua' && daDoc) {
        /* Đính chính điều học sinh ĐÃ ĐỌC. Tuyệt đối không ghi đè lặng lẽ —
         * mục 9.3. Hiện cả hai bản, có mốc thời gian. */
        html += '<details class="lh-cu"><summary>Nhận xét tự động · ' + gio(may && may.luc_cham) +
                '</summary><p>' + thoat(may ? may.ket_qua_json.nhan_xet_cho_hoc_sinh : '') + '</p></details>';
        html += '<div class="lh-nx lh-sua"><span class="lh-huy">Thầy/cô đính chính · ' +
                gio(nguoi.luc_duyet) + '</span><p>' + thoat(nguoi.nhan_xet || '') + '</p></div>';
      } else if (nguoi) {
        html += '<div class="lh-nx lh-duyet"><span class="lh-huy">Thầy/cô đã xác nhận</span><p>' +
                thoat(nguoi.nhan_xet || (may ? may.ket_qua_json.nhan_xet_cho_hoc_sinh : '')) + '</p></div>';
      } else if (bn.trang_thai === 'loi_cham') {
        /* Máy chấm không chạy được (migration 004). Không nói "máy hỏng" — với em
         * thì thông tin dùng được duy nhất là bài đã tới tay thầy cô và không cần
         * nộp lại. Bài đang nằm trong hàng đợi duyệt nên chắc chắn có người xem. */
        html += '<div class="lh-nx lh-may"><span class="lh-huy">Đã gửi tới thầy/cô</span>' +
                '<p>Bài của em thầy/cô sẽ xem và nhận xét trực tiếp nhé. ' +
                'Em không phải nộp lại đâu.</p></div>';
      } else if (may) {
        var k = may.ket_qua_json;
        html += '<div class="lh-nx lh-may"><span class="lh-huy">Máy chấm · chờ thầy cô xem lại</span>' +
                (k.ket_luan === 'dung'
                  ? '<p class="lh-dung">✓ Kết quả của em đúng rồi.</p>' : '') +
                '<p>' + thoat(k.nhan_xet_cho_hoc_sinh || '') + '</p>' +
                (k.goi_y ? '<p class="lh-goiy"><b>Gợi ý.</b> ' + thoat(k.goi_y) + '</p>' : '') +
                luuYLapLuan(k) +
                '</div>';
        if (bn.lan_thu >= 3 && k.ket_luan !== 'dung') {
          /* Hết 3 lượt mà vẫn sai — mục 10.1. Không để em đứng trước ô xám. */
          html += '<p class="lh-het-luot">Câu này khó với em thật rồi. ' +
                  'Thầy/cô sẽ xem giúp em nhé.</p>';
        }
      }
      kq.innerHTML = html;
      if (window.MathJax && MathJax.typesetPromise) MathJax.typesetPromise([kq]);

      if (!daDoc) {
        sb.from('bai_nop').update({ luc_hoc_sinh_doc: new Date().toISOString() })
          .eq('id', baiNopId).then(function () {});
      }
    });
  }

  function capNhatLuot(ma, hop) {
    sb.from('bai_nop').select('id,lan_thu').eq('bai_tap_ma', ma)
      .eq('hoc_sinh_id', toi.id).order('lan_thu', { ascending: false })
      .then(function (r) {
        var ds = r.data || [];
        var o = hop.querySelector('.lh-luot');
        o.textContent = ds.length ? 'Lượt ' + ds.length + '/3' : '';
        if (ds.length) veNhanXet(ds[0].id, hop.querySelector('.lh-kq'));
        if (ds.length >= 3) {
          hop.querySelector('.lh-nut-chup').classList.add('lh-khoa');
          hop.querySelector('input').disabled = true;
        }
      });
  }

  /* ------------------------------------------------------------ tiện ích */

  function thoat(s) {
    var d = document.createElement('div');
    d.textContent = s == null ? '' : String(s);
    return d.innerHTML;
  }

  function gio(t) {
    if (!t) return '';
    var d = new Date(t);
    return ('0' + d.getHours()).slice(-2) + ':' + ('0' + d.getMinutes()).slice(-2);
  }

  function duongDangNhap() {
    var ve = location.pathname + location.search + location.hash;
    return '/lop-hoc/dang-nhap.html?returnTo=' + encodeURIComponent(ve);
  }

  function tenTaiKhoan() {
    if (vaiTro === 'hoc_sinh') return toi.ten_hien_thi || toi.ma || 'Học sinh';
    if (giaoVien) return giaoVien.ten || giaoVien.email || 'Thầy/cô';
    return '';
  }

  function nhanVaiTro() {
    if (vaiTro === 'admin') return 'Quản trị viên';
    if (vaiTro === 'giao_vien') return 'Giáo viên';
    if (vaiTro === 'hoc_sinh') return 'Học sinh';
    if (vaiTro === 'cho_duyet') return 'Giáo viên · đang chờ duyệt';
    if (vaiTro === 'khoa') return 'Tài khoản đang bị khoá';
    if (vaiTro === 'chua_gan') return 'Tài khoản chưa được cấp quyền';
    return '';
  }

  function menuTaiKhoan() {
    if (vaiTro === 'khach') {
      return '<a class="lh-account-button lh-account-primary" href="' + duongDangNhap() + '">' +
        '<span class="lh-account-short" aria-hidden="true">Vào</span>' +
        '<span class="lh-account-label">Đăng nhập</span></a>';
    }

    var ten = thoat(tenTaiKhoan());
    var nhan = thoat(nhanVaiTro());
    var vietTat = vaiTro === 'admin' ? 'QT' : vaiTro === 'hoc_sinh' ? 'HS' : 'GV';
    var muc = '';
    if (vaiTro === 'admin') {
      muc += '<a href="/lop-hoc/admin.html">Quản trị giáo viên</a>';
      muc += '<a href="/lop-hoc/giao-vien.html">Bảng giáo viên</a>';
    } else if (vaiTro === 'giao_vien') {
      muc += '<a href="/lop-hoc/giao-vien.html">Bảng giáo viên</a>';
    } else if (vaiTro === 'hoc_sinh') {
      muc += '<a href="/">Chọn bài để học</a>';
    } else {
      muc += '<a href="' + duongDangNhap() + '">Xem trạng thái tài khoản</a>';
    }
    muc += '<button class="lh-danger" type="button" data-lh-logout>Đăng xuất</button>';

    return '<div class="lh-account-menu">' +
      '<button class="lh-account-button" type="button" data-lh-menu aria-haspopup="true" aria-expanded="false" ' +
        'aria-label="Mở menu tài khoản ' + ten + '">' +
        '<span class="lh-account-short" aria-hidden="true">' + vietTat + '</span>' +
        '<span class="lh-account-label">' + ten + '</span>' +
      '</button>' +
      '<div class="lh-account-popover" hidden>' +
        '<strong>' + ten + '</strong><small>' + nhan + '</small>' + muc +
      '</div></div>';
  }

  function ganSuKienTaiKhoan(goc) {
    var mo = goc.querySelector('[data-lh-menu]');
    var bang = goc.querySelector('.lh-account-popover');
    if (mo && bang) {
      mo.addEventListener('click', function () {
        var dangMo = !bang.hidden;
        document.querySelectorAll('.lh-account-popover').forEach(function (p) { p.hidden = true; });
        document.querySelectorAll('[data-lh-menu]').forEach(function (b) {
          b.setAttribute('aria-expanded', 'false');
        });
        bang.hidden = dangMo;
        mo.setAttribute('aria-expanded', String(!dangMo));
      });
    }
    var thoatNut = goc.querySelector('[data-lh-logout]');
    if (thoatNut) thoatNut.addEventListener('click', function () {
      thoatNut.disabled = true;
      sb.auth.signOut().then(function () { location.href = '/'; });
    });
  }

  function veThanhTren() {
    var cacCho = Array.prototype.slice.call(document.querySelectorAll('[data-lop-hoc-nav]'));
    if (cacCho.length) {
      cacCho.forEach(function (o) {
        o.classList.add('lh-nav-slot');
        o.innerHTML = menuTaiKhoan();
        ganSuKienTaiKhoan(o);
      });
      return;
    }

    var t = document.createElement('div');
    t.className = 'lh-thanh';
    var loiChao = vaiTro === 'khach'
      ? 'Đăng nhập để nộp bài và nhận sao'
      : nhanVaiTro() + ' · ' + tenTaiKhoan();
    t.innerHTML = '<span>' + thoat(loiChao) + '</span>' +
      '<div class="lh-nav-slot">' + menuTaiKhoan() + '</div>';
    document.body.insertBefore(t, document.body.firstChild);
    ganSuKienTaiKhoan(t);
  }

  /* ------------------------------------------------------------ khởi động */

  var API = {
    /* Trắc nghiệm chấm ở server — đáp án không còn trong file (mục 15.1).
     * Chưa đăng nhập vẫn chấm được, chỉ là không có sao. */
    chamTracNghiem: function (bai, maCau, chon) {
      if (!BAT) return Promise.reject(new Error('chua-cau-hinh'));
      return API.sanSang().then(function () {
        return goi('cham-trac-nghiem', { bai: bai, ma_cau: maCau, chon: chon });
      });
    },

    /* Xem lại một lượt trắc nghiệm đã làm: đáp án + lời giải thích của những câu
     * em ĐÃ trả lời. Đáp án nằm ở bảng tn_dap_an, bảng đó không có policy nào
     * nên trình duyệt không đọc thẳng được — phải qua đây. Câu em bỏ dở thì máy
     * chủ không trả về gì, nên không có đường nào xem trước đáp án. */
    xemLaiTracNghiem: function (bai, lanThu) {
      if (!BAT) return Promise.reject(new Error('chua-cau-hinh'));
      return API.sanSang().then(function () {
        return goi('xem-lai-trac-nghiem', { bai: bai, lan_thu: lanThu });
      });
    },
    /* Đợi đọc xong phiên đăng nhập. Chưa cấu hình thì trả về ngay. */
    sanSang: function () { return khoiDong || Promise.resolve(); },

    /* Trang nộp bài riêng (/lop-hoc/nop.html) dùng lại đúng đường ống của khối
     * nộp trong bài học: cùng cách nén, cùng ngưỡng mờ/tối, cùng hàm chờ chấm.
     * Viết lại một bản thứ hai là hai bản lệch nhau sau vài tháng. */
    nop: {
      tuFile: function (ma, file) {
        return API.sanSang().then(function () {
          if (!toi) throw new Error('chua-dang-nhap');
          return nenAnh(file);
        }).then(function (blob) { return taiLen(ma, blob); });
      },
      /* Nét viết trên iPad: đã là ảnh sạch nền trắng, KHÔNG chạy xetAnh —
       * ảnh nền trắng có phương sai Laplacian thấp, bộ đo độ mờ sẽ báo "ảnh
       * mờ quá" và chặn oan một bài làm hoàn toàn rõ. */
      tuBlob: function (ma, blob) {
        return API.sanSang().then(function () {
          if (!toi) throw new Error('chua-dang-nhap');
          return taiLen(ma, blob);
        });
      },
      theoDoi: function (baiNopId, oKq, oBao) { return doiKetQua(baiNopId, oKq, oBao); },
      daNop: function (ma) {
        return sb.from('bai_nop')
          .select('id,lan_thu,trang_thai,luc_nop')
          .eq('hoc_sinh_id', toi.id).eq('bai_tap_ma', ma)
          .order('lan_thu', { ascending: false });
      }
    },

    /* Ảnh bài làm + chú thích của máy, trả về canvas đã vẽ xong. */
    anhDaChamGoc: duongDanAnh,
    veChuThichLen: veChuThich,
    veAnhDaCham: function (anhUrl, chuThich) {
      return duongDanAnh(anhUrl).then(napAnh).then(function (anh) {
        return veChuThich(anh, chuThich);
      });
    },
    dangNhapHocSinh: function (ma, matKhau) {
      return sb.auth.signInWithPassword({
        email: ma.toLowerCase() + '@hs.local', password: matKhau
      });
    },
    sb: function () { return sb; },
    toi: function () { return toi; }
  };
  window.LopHoc = API;

  if (!BAT) return;   // chưa cấu hình → trang hiện y như cũ

  document.addEventListener('pointerdown', function (e) {
    if (e.target.closest('.lh-account-menu')) return;
    document.querySelectorAll('.lh-account-popover').forEach(function (p) { p.hidden = true; });
    document.querySelectorAll('[data-lh-menu]').forEach(function (b) {
      b.setAttribute('aria-expanded', 'false');
    });
  });
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    document.querySelectorAll('.lh-account-popover').forEach(function (p) { p.hidden = true; });
    document.querySelectorAll('[data-lh-menu]').forEach(function (b) {
      b.setAttribute('aria-expanded', 'false');
    });
  });

  /* Gửi token sang máy chủ dưới dạng cookie.
   *
   * Supabase để phiên trong localStorage, mà localStorage thì máy chủ không
   * đọc được. Edge Function chặn /bai-hoc/* cần đọc được token, nên ta soi
   * thêm access_token ra cookie. Chỉ access_token thôi — refresh_token vẫn
   * nằm yên trong localStorage, không đưa lên đường truyền.
   *
   * Xem netlify/edge-functions/chan-bai-hoc.ts.
   */
  function ghiCookiePhien(s) {
    var an = location.protocol === 'https:' ? '; Secure' : '';
    if (s && s.access_token) {
      var con = s.expires_at ? (s.expires_at * 1000 - Date.now()) / 1000 : 3600;
      if (con < 0) con = 0;
      document.cookie = 'vt-token=' + encodeURIComponent(s.access_token) +
        '; Path=/; Max-Age=' + Math.floor(con) + '; SameSite=Lax' + an;
    } else {
      document.cookie = 'vt-token=; Path=/; Max-Age=0; SameSite=Lax' + an;
    }
  }

  khoiDong = napSupabase().then(function (lib) {
    sb = lib.createClient(CH.URL, CH.ANON_KEY);
    API.sb = function () { return sb; };
    // Bắt cả lúc đăng nhập, lúc thoát, và lúc token tự gia hạn
    sb.auth.onAuthStateChange(function (_su, s) {
      /* Supabase tự gia hạn access token. Nếu chỉ cập nhật cookie mà giữ biến
       * phien cũ, Storage dùng token mới nhưng Edge Function lại nhận token đã
       * hết hạn và hiểu nhầm học sinh thành khách. */
      phien = s;
      ghiCookiePhien(s);
    });
    return sb.auth.getSession();
  }).then(function (r) {
    ghiCookiePhien(r && r.data ? r.data.session : null);
    phien = r.data.session;
    if (!phien) { vaiTro = 'khach'; veThanhTren(); return; }
    return sb.from('hoc_sinh').select('id,ma,ten_hien_thi,lop_id')
      .eq('id', phien.user.id).maybeSingle()
      .then(function (h) {
        toi = h.data;
        if (toi) {
          vaiTro = 'hoc_sinh';
          veThanhTren();
          document.querySelectorAll('[data-nop="1"][data-ma]').forEach(veKhoiNop);
          return;
        }
        return sb.from('giao_vien').select('id,ten,email,trang_thai,la_admin')
          .eq('id', phien.user.id).maybeSingle().then(function (g) {
            giaoVien = g.data;
            if (!giaoVien) {
              giaoVien = { email: phien.user.email || 'Tài khoản' };
              vaiTro = 'chua_gan';
            } else if (giaoVien.trang_thai === 'cho_duyet') {
              vaiTro = 'cho_duyet';
            } else if (giaoVien.trang_thai === 'khoa') {
              vaiTro = 'khoa';
            } else {
              vaiTro = giaoVien.la_admin ? 'admin' : 'giao_vien';
              document.querySelectorAll('[data-vaitro="gv"]').forEach(function (e) {
                e.hidden = false;
              });
            }
            veThanhTren();
          });
      });
  }).catch(function () {
    /* Mạng hỏng hay CDN chặn — trang bài học vẫn phải đọc được bình thường.
     * Không hiện lỗi đỏ, không chặn gì cả. */
  });
})();
