### A Pluto.jl notebook ###
# v0.20.0

# ╔═╡ 09102026-0000-4000-8000-000000000001
begin
    READ_DATA = true
    RUN_APP = true
    ROOT_DATA = joinpath(@__DIR__, "data")
end

# ╔═╡ 09102026-0000-4000-8000-000000000002
AppCore = let
    sandbox = Module(:ThucHanhNgay0910)
    Base.include(sandbox, joinpath(@__DIR__, "TH_2026_10_09_Sinh_vien.jl"))
    Base.invokelatest(getfield, sandbox, :GiaoDon)
end

# ╔═╡ 09102026-0000-4000-8000-000000000003
"""Mục tiêu: giải thích một luồng từ CSV đến giao đơn. Hoàn thiện bốn hàm trong file Julia chung; tạo dữ liệu bằng chế độ --data trước khi bật READ_DATA và RUN_APP. Bổ sung các ô ghi ý tưởng, giả mã, điều kiện áp dụng, chi phí và liên kết GitHub."""

# ╔═╡ 09102026-0000-4000-8000-000000000004
ho_so = AppCore.mini_profile()

# ╔═╡ 09102026-0000-4000-8000-000000000005
du_lieu = READ_DATA ? AppCore.read_data(joinpath(ROOT_DATA,"MINI001")) : nothing

# ╔═╡ 09102026-0000-4000-8000-000000000006
bao_cao = !RUN_APP || du_lieu === nothing ? nothing : let
    s = AppCore.build_session(du_lieu.orders,du_lieu.edges,ho_so)
    r = AppCore.plan!(s)
    trace = NamedTuple[]
    save(label) = push!(trace,(buoc=label,queue=AppCore.queue_values(s.pending),
                              stack=copy(s.completed),spent=s.spent,earned=s.earned))
    save("Sau lập kế hoạch")
    AppCore.deliver!(s); save("Sau giao một đơn")
    AppCore.undo!(s); save("Sau hoàn tác")
    while s.pending.count > 0
        AppCore.deliver!(s)
    end
    save("Sau giao hết")
    (chi_phi=copy(s.costs),tuyen=deepcopy(s.routes),chon=copy(s.selected_ids),
     loi_ich_toi_uu=r.optimal.value,truy_vet=trace,bat_bien=AppCore.check_invariants(s))
end

# ╔═╡ 09102026-0000-4000-8000-000000000007
"""Giải thích một ô của bảng F(i,b) và các vị trí tương ứng table[i+1,b+1] trong Julia. Vì sao nhánh chọn lấy từ hàng i−1? So sánh kết quả với vét cạn trên cùng dữ liệu."""

# ╔═╡ 09102026-0000-4000-8000-000000000008
"""Minh chứng nộp: bốn hàm, lệnh kiểm thử và kết quả thực, bảng truy vết, CSV kết quả, URL GitHub cùng commit SHA. Khi mở rộng, dùng hồ sơ và CSV của MSSV cá nhân; giữ nguyên nguyên tắc các bước dùng kết quả của nhau."""

# ╔═╡ 09102026-0000-4000-8000-000000000009
if RUN_APP && bao_cao !== nothing
    println("Kết quả từ cùng lõi ứng dụng Julia:")
    show(stdout, "text/plain", bao_cao)
    println()
end

# ╔═╡ Cell order:
# ╠═09102026-0000-4000-8000-000000000001
# ╠═09102026-0000-4000-8000-000000000002
# ╠═09102026-0000-4000-8000-000000000003
# ╠═09102026-0000-4000-8000-000000000004
# ╠═09102026-0000-4000-8000-000000000005
# ╠═09102026-0000-4000-8000-000000000006
# ╠═09102026-0000-4000-8000-000000000007
# ╠═09102026-0000-4000-8000-000000000008
# ╠═09102026-0000-4000-8000-000000000009
# ===== GIAI THICH BAI THUC HANH =====
#
# 1. Bai toan va du lieu
# Doc don_hang.csv va ban_do.csv.
# Moi don la mot chuyen: kho 1 -> diem giao -> kho 1.
# Chi phi = 2 * so canh duong BFS + thoi gian phuc vu.
# Chon moi don toi da mot lan de loi ich lon nhat,
# voi tong chi phi khong vuot ngan sach.
#
# 2. Merge Sort
# Chia doi day, sap xep de quy hai nua, roi tron.
# Dung khi day co khong qua mot phan tu.
# Khi khoa hoa, lay ben trai truoc de giu tinh on dinh.
# Tra day moi va khong thay doi dau vao.
# Thoi gian O(n log n); bo nho song O(n),
# ngan xep de quy O(log n).
# Hien thuc dung lat cat: tong cap phat O(n log n).
#
# 3. Binary Search
# Dieu kien: danh muc Order tang theo ID, ID duy nhat.
# So sanh ID voi phan tu giua, loai nua khong phu hop.
# Tim thay tra Order; het khoang tra nothing.
# Thoi gian O(log n), bo nho phu O(1).
#
# 4. BFS
# Dung FIFO, danh dau dinh ngay khi dua vao hang doi.
# Luu distance va parent, lan nguoc parent de dung tuyen.
# Dinh khong toi duoc: distance = -1, tuyen rong.
# BFS toi thieu so canh khi do thi khong trong so.
# BFS cot loi: O(V + E) thoi gian, O(V) bo nho phu.
# Dung va luu moi tuyen can them O(L), voi L la
# tong do dai cac tuyen; L co the dat O(V^2).
#
# 5. Knapsack 0/1
# F(i,b): loi ich tot nhat khi xet i don voi ngan sach b.
# Khong lay: F(i-1,b).
# Lay neu du ngan sach:
# loi_ich_i + F(i-1,b-chi_phi_i).
# Chon gia tri lon hon; khi hoa giu phuong an khong lay.
# Dung hang truoc de khong chon lap mot don.
# F(i,b) luu o table[i+1,b+1].
# Truy vet tu (n,B) de lay ID, tong chi phi va loi ich.
# Thoi gian va bo nho bang day du: O(nB).
#
# 6. Truy vet MINI001
# Chi phi ID 1,2,3 lan luot la 3,5,7; ngan sach 8.
# F(2,8) = max(6, 8 + 6) = 14, o table[3,9].
# Bo ID 3, lay ID 2, con ngan sach 3; lay ID 1.
# Tap chon {1,2}, chi phi 8, loi ich 14.
# Vet can 8 tap con tren cung du lieu cho cung toi uu.
#
# 7. Giao va hoan tac
# Ban dau: queue [1,2], stack [], spent 0, earned 0.
# Giao ID 1: queue [2], stack [1], spent 3, earned 6.
# Hoan tac: tra ID 1 ve DAU queue, tro ve trang thai dau.
# Giao het: queue [], stack [1,2], spent 8, earned 14.
# ID cho va da giao khong trung, hop bang tap chon.
# Cac tong phai khop cac don da giao va khong vuot B.
#
# 8. Kiem thu va ket qua
# Julia tren may: 1.12.7.
# Da dat: data 12, sort 8, search 5, bfs 7, dp 12, app 16.
# Pha all dat 60/60 phep kiem tra.
# Minh chung: ket_qua_kiem_thu.txt.
# CSV mini: data/MINI001/ket_qua.csv.
# Du lieu ca nhan: data/N24DCDT088.
#
# 9. Gioi han
# Thu tu uu tien theo loi ich/chi phi khong thay DP.
# Tham lam khong luon toi uu cho bai toan ba lo 0/1.
# BST tra cuu O(h); cay lech co the O(n).
# Bai nay khong toi uu mot chuyen giao nhieu diem.