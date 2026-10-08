# ✳ HẺM 404 — PIXEL WORLD / DCBAS ARENA
**Bản gameplay V1 · 08.10.2026** · Vào nhầm hẻm. Gặp đúng người.

Website trò chơi cộng đồng trồng cây pixel art, mỗi tài khoản một khu vườn; đua thứ hạng DCBAS, nuôi cây lớn bằng thời gian thật, thu hoạch, EXP, Xu Hẻm, nhiệm vụ, phần thưởng chung Vườn Sao và ghé thăm vườn hàng xóm.

## 1. Chơi thử NGAY (không cần tài khoản)

Trên Windows đã có Python: giải nén ZIP → mở `MO_GAME_WINDOWS.bat` → vào http://localhost:8000.

Hoặc nhấp đúp `index.html` để chạy offline; nếu trình duyệt giới hạn lưu dữ liệu `file://`, hãy dùng `MO_GAME_WINDOWS.bat` / máy chủ localhost. Không cần cài Node.js hay build dự án.

- Bản xem thử **DEMO** xuất hiện khi `config.js` để trống. Có 4 cư dân mẫu và có thể tạo thêm cư dân demo.
- Chọn menu **Vườn của tôi**, bấm ô đất, chọn hạt → gieo. Bấm cây để tưới hoặc thu hoạch khi trưởng thành.
- Nút **+6 giờ** (chỉ trong DEMO) giúp kiểm thử tốc độ lớn của cây. Khi dùng Supabase thật **không có nút tăng giờ**.
- Vào **DCBAS** để chuyển BXH mùa / toàn thời gian / thu hoạch; chuyển qua các cư dân giả lập để thấy vườn và điểm khác nhau.
- Dữ liệu DEMO chỉ lưu trong `localStorage` của trình duyệt trên thiết bị đó. **Không có password, không phải tài khoản thực, không đồng bộ giữa máy khác và không tính là BXH cộng đồng thật.** Dữ liệu NPC là mẫu hư cấu.

## 2. Các tính năng ĐÃ CÓ trong mã nguồn

| Chức năng | DEMO | Khi kết nối Supabase |
|---|---|---|
| Giao diện Pixel Art, responsive | ✅ | ✅ |
| Username duy nhất / email / mật khẩu | Hồ sơ giả lập không mật khẩu | Supabase Auth, SQL kiểm tra username |
| Lưu 20 ô vườn theo cư dân | localStorage theo hồ sơ demo | DB theo UUID tài khoản |
| 6 cây × 5 giai đoạn | ✅ | ✅ |
| Sinh trưởng theo thời gian, thiếu ẩm lớn chậm | mô phỏng bằng timestamp + nút tua | máy chủ chốt tiến độ bằng `now()` |
| Tưới 9 lượt/ngày, cooldown 4h/cây | ✅ | SQL RPC kiểm tra |
| Thu hoạch 1 lần, cây lớn mới có thưởng | ✅ | SQL RPC kiểm tra |
| EXP / level / Xu Hẻm / DCBAS | ✅ | server ghi trong giao dịch |
| Giới hạn 180 DCBAS/ngày/người | ✅ | server tính theo ngày VN |
| BXH tháng, trọn đời, số cây thu hoạch | trong thiết bị | server query tất cả cư dân |
| 3 nhiệm vụ và điểm danh mỗi ngày | ✅ | server xác nhận hoàn thành |
| Huy hiệu thành tích | suy ra từ thống kê | suy ra từ thống kê của server |
| Vườn Sao: thu hoạch chung 50 cây mở rương | ✅ | RPC phần thưởng theo milestone duy nhất |
| Tên, avatar, theme, chế độ mở cửa | ✅ | SQL và RLS |
| Hàng xóm, thả tim, lưu bút | ✅ | SQL rate limit và quyền vườn |
| Mua hạt và vật phẩm bằng Xu ảo | ✅ | SQL trừ Xu atomically |
| Nhật ký tương tác | localStorage | bảng `pw_events` |

Đây là bản **V1 gameplay có mã backend**, không phải sản phẩm đã vận hành trên Internet. Kết nối Supabase thực tế và kiểm thử tích hợp chưa được làm vì chưa có dự án Supabase của bạn.

## 3. Bật game NHIỀU NGƯỜI THẬT

**Bước 1 – Tạo Supabase**

1. Truy cập https://supabase.com/dashboard → tạo project mới.
2. SQL Editor → dán toàn bộ nội dung `backend/schema.sql` → Run. File này chứa các bảng và hàm cho Pixel World, có tiền tố `pw_` nên không ghi đè các bảng HẺM 404 phiên bản cũ.
3. Authentication → Providers → Email: bật Email. **Nên bật xác nhận email** và cấu hình gửi thư; nếu chạy công khai cần SMTP/giới hạn gửi mail phù hợp.
4. Authentication → URL Configuration: đặt **Site URL** và **Redirect URLs** khớp website HTTPS và `http://localhost:8000`. Với tính năng gửi email xác nhận/reset cần chạy qua localhost hoặc HTTPS, không dùng file://.

**Bước 2 – Điền khóa công khai**

Supabase dashboard → Project Settings → API Keys: lấy **Project URL** và **publishable / anon key**. Mở `config.js`, thay hai chuỗi rỗng:

```js
window.HEM404_CONFIG = {
  supabaseUrl: 'https://YOUR-PROJECT.supabase.co',
  supabaseAnonKey: 'YOUR_PUBLISHABLE_OR_ANON_KEY'
};
```

**KHÔNG bao giờ dán `service_role`, `sb_secret_...` hoặc mật khẩu database vào `config.js`.** Đây là file công khai trên website. File SQL chỉ chạy trong SQL Editor với quyền quản trị, không chạy từ frontend.

**Bước 3 – Chạy và kiểm thử**

1. Chạy `MO_GAME_WINDOWS.bat` và mở website từ `http://localhost:8000`.
2. Đăng ký email A, username A, xác nhận email nếu được yêu cầu, đăng nhập bằng **email + mật khẩu**. Username hiển thị công khai và phải duy nhất, chưa hỗ trợ đăng nhập trực tiếp bằng username.
3. Tạo email B / username B khác trên trình duyệt hoặc cửa sổ ẩn danh.
4. A đặt vườn **công khai**, B vào **Cư dân** và ghé xem; B thả tim / lưu bút. B không thể trồng hay sửa cây A.
5. A chuyển vườn **riêng tư**: B không được đọc qua giao diện và API.
6. A và B gieo cây, tưới, thử click nhanh nhiều lần, đăng xuất/đăng nhập, đổi máy; kiểm tra bảng mùa và tiền thưởng.
7. Truy cập SQL Editor và xác nhận điểm không đổi khi người chơi gửi UPDATE trực tiếp vào `pw_players` hoặc `pw_season_scores` bằng khóa publishable.

**Bước 4 – Đưa online**

Đưa *chỉ các tệp frontend* `index.html`, `config.js`, `assets/` lên nền tảng hosting static như Netlify/Vercel (khuyến nghị HTTPS). Nếu đưa cả thư mục mã nguồn lên hosting, `docs/`, `backend/` và `archive/` có thể bị công khai không cần thiết. Không nên upload những thư mục đó.

Supabase project của bạn lưu tài khoản/vườn trên đám mây; frontend static có thể dùng chung cho rất nhiều cư dân. Để vận hành thật cần SMTP, chống bot/CAPTCHA, chính sách dữ liệu, backup, vận hành và giám sát.

## 4. Quy tắc gameplay

- **Hạt giống:** Nấm Đốm 3h / Hoa Hướng Dương 6h / Xương Rồng 12h / Anh Đào 24h / Sồi 36h / Hoa Trăng 48h.
- **Thời gian:** tiến độ tăng bằng giây thực tế (server-side RPC `pw_tick()`); khi ẩm giảm, cây tăng trưởng chậm. Không chết vĩnh viễn khi vắng mặt.
- **Tưới:** tăng 38% độ ẩm, cần chờ 4h/cây, năng lượng hồi về 9 lượt mỗi ngày theo Asia/Ho_Chi_Minh.
- **Trồng:** trừ Xu theo giá hạt; mỗi lần trồng +5 EXP +2 DCBAS. Không gieo đè lên cây chưa thu hoạch.
- **Thu hoạch:** chỉ khi đạt 100% sinh trưởng; mỗi cây chỉ trao thưởng một lần; sau đó ô đất có thể được gieo lại.
- **Mùa giải:** tháng dương lịch tại Việt Nam; DCBAS theo tháng, tổng điểm tích lũy vẫn giữ ở BXH trọn đời. Giới hạn điểm DCBAS 180/ngày; các hoạt động vượt giới hạn có thể vẫn mang EXP và Xu.
- **Nhiệm vụ:** trồng hai hạt / tưới ba lượt / thu hoạch một cây trong cùng ngày; mỗi nhiệm vụ nhận thưởng một lần.
- **Vườn Sao:** tổng số cây thu hoạch của cả server đạt 50, 100, 150, ... → mỗi cư dân có thể nhận rương cho từng mốc một lần, kể cả khi chưa góp cây. Thưởng: +35 EXP, +50 Xu, tối đa +10 DCBAS nếu còn hạn mức ngày.

## 5. Bảo mật / chống gian lận

- Password do Supabase Auth xử lý. Game DB không chứa password plaintext.
- Bảng cây/cư dân/bảng điểm bật Row Level Security. Không cấp INSERT/UPDATE/DELETE trực tiếp cho client.
- Mọi thao tác có thưởng (`pw_plant`, `pw_water`, `pw_harvest`, `pw_daily`, `pw_quest`, `pw_world_claim`) đều chạy trong PostgreSQL `SECURITY DEFINER` với kiểm tra `auth.uid()`, hạn mức điểm, điều kiện thời gian và khóa dòng tài khoản.
- UUID người dùng lấy từ session server, không nhận từ trình duyệt làm `owner` cho các hành động ghi; người khác không chỉnh vườn bạn.
- API public chỉ trả dữ liệu trong phạm vi phù hợp; các vườn riêng tư không xuất hiện trong danh bạ. Username và tên hiển thị chủ động được công khai trên BXH.
- Tim toggle 1 người/1 vườn; lưu bút tối đa 3/24h/tác giả, giới hạn 180 ký tự. Cần bổ sung quản trị kiểm duyệt, báo cáo lạm dụng, xóa nội dung và chống bot trước khi công khai cho lượng lớn người dùng.

## 6. Lộ trình sau V1 (CHƯA triển khai)

- **V2 — Neighborhood:** kết bạn, tặng quà, quyền tưới giúp bạn bè, chợ trao đổi có nhật ký an toàn, bang hội và trang cá nhân.
- **V3 — Competition:** giải đấu 7/30 ngày có cúp, thể lệ chống gian lận, cây lai giống/đột biến, thú cưng làm vườn, sự kiện có nhiệm vụ.
- **V4 — Living World:** bản đồ di chuyển nhân vật nhiều người thời gian thực, radio phòng chung hợp pháp, rừng bí mật và quản trị sự kiện Creator Room.
- **Đối với bản HẺM 404 cũ:** nguồn gốc được giữ trong `archive/HEM404_GARDEN_EDITION_GOC.zip`, ý tưởng gốc `docs/HO_SO_DU_AN_GOC.docx`. Cơ sở dữ liệu/tiệm ảnh/radio cũ **chưa được tự động tích hợp** vào Pixel World V1.

## 7. Cấu trúc dự án

- `index.html`: shell chạy trên trình duyệt.
- `assets/style.css`: giao diện Pixel World, responsive desktop/mobile.
- `assets/sprites/`: toàn bộ sprite tự tạo, có cả `make_sprites.py` để tái tạo các PNG.
- `assets/engine.js`: công thức hiển thị/sinh trưởng dùng chung.
- `assets/demo.js`: bộ engine mô phỏng dành cho một thiết bị và cư dân demo.
- `assets/cloud.js`: kết nối Supabase Auth, PostgREST và RPC.
- `assets/app.js`: giao diện, tương tác và điều hướng.
- `backend/schema.sql`: bảng Postgres, RLS, RPC server-side, BXH và luật chơi.
- `docs/test_pixel_world.py`, `docs/test_mechanics.py`: kiểm thử bằng Playwright; cần `pip install playwright` và Chromium.

## 8. Trạng thái kiểm thử

Đã chạy thử DOM, 20 ô đất, điều hướng, trồng hạt, trừ tiền, +6h giả lập, bảng xếp hạng, đổi cư dân, giao diện 390px; các kiểm thử gameplay gồm chống gieo đè, không thu hoạch sớm, giới hạn tưới, không thu hoạch trùng, điểm danh mỗi ngày, Vườn Sao, rate limit lưu bút và vườn riêng tư đều qua trên **demo**.

**Chưa kiểm thử tích hợp trên Supabase thật, chưa pentest, chưa load test nhiều người đồng thời, chưa có bộ điều khoản/quyền riêng tư hoàn chỉnh.** Trước khi mở công khai, cần làm đủ các bước này.
