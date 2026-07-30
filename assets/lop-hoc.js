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
    var ten = toi.id + '/' + maBaiTap.replace(/\//g, '_') + '-' + Date.now() + '.jpg';
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
                '<p>' + thoat(k.nhan_xet_cho_hoc_sinh || '') + '</p>' +
                (k.goi_y ? '<p class="lh-goiy"><b>Gợi ý.</b> ' + thoat(k.goi_y) + '</p>' : '') +
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
      return goi('cham-trac-nghiem', { bai: bai, ma_cau: maCau, chon: chon });
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

  napSupabase().then(function (lib) {
    sb = lib.createClient(CH.URL, CH.ANON_KEY);
    API.sb = function () { return sb; };
    return sb.auth.getSession();
  }).then(function (r) {
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
