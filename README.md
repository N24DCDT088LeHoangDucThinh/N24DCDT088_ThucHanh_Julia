# Thực hành Cấu trúc dữ liệu và giải thuật bằng Julia

- Họ tên: Lê Hoàng Đức Thịnh
- MSSV: N24DCDT088
- Lớp: D24CQDT01-N
- Ngày thực hành: 09/10/2026
- Môi trường đã chạy: Windows 11, Julia 1.12.7

## Nội dung

Ứng dụng điều phối giao đơn trong khuôn viên trường.

Luồng xử lý:
đọc CSV → sắp xếp và tra cứu → BFS tính đường đi, chi phí
→ quy hoạch động chọn đơn → giao và hoàn tác → xuất CSV.

Bốn hàm cần hoàn thiện trong khung của giảng viên:
merge_sort, binary_search, bfs_routes và knapsack.

Mỗi đơn là một chuyến riêng từ kho 1 đến điểm giao rồi về kho.
Chi phí = 2 × số cạnh đường BFS + thời gian phục vụ.
Mục tiêu là tối đa tổng lợi ích trong ngân sách;
mỗi đơn được chọn tối đa một lần.

## Các tệp cần có

- TH_2026_10_09_Sinh_vien.jl: code lõi và bốn hàm thuật toán.
- TH_2026_10_09_Kiem_thu.jl: bộ kiểm thử của giảng viên.
- TH_2026_10_09_Pluto.jl: notebook gọi cùng code lõi, kèm giải thích.
- ket_qua_kiem_thu.txt: kết quả kiểm thử thực tế của bản nộp.
- data/MINI001/: hai CSV đầu vào và CSV kết quả mẫu.
- data/N24DCDT088/: hai CSV đầu vào và CSV kết quả cá nhân.

## Cách chạy lại

Tải repository bằng Code → Download ZIP rồi giải nén.
Mở terminal trong thư mục chứa các tệp .jl.
Máy cần gọi được lệnh julia; code lõi chỉ dùng Julia Base.

### 1. Đọc dữ liệu mẫu và kiểm thử

```text
julia TH_2026_10_09_Sinh_vien.jl --data
julia TH_2026_10_09_Kiem_thu.jl --phase=all
```

Có thể kiểm riêng từng pha:
data, sort, search, bfs, dp hoặc app.

Bộ kiểm thử gồm 60 phép kiểm tra:
data 12, sort 8, search 5, bfs 7, dp 12 và app 16.
Kết quả thực tế được lưu trong ket_qua_kiem_thu.txt.

### 2. Chạy ứng dụng mẫu

```text
julia TH_2026_10_09_Sinh_vien.jl --mini
```

Kết quả mẫu mong đợi:
ngân sách 8, chọn ID 1 và 2, tổng chi phí 8, lợi ích 14.

Giao ID 1 rồi hoàn tác phải khôi phục hàng đợi [1,2],
lịch sử rỗng và hai tổng về 0.

CSV được xuất tại data/MINI001/ket_qua.csv.

### 3. Chạy notebook

```text
julia TH_2026_10_09_Pluto.jl
```

Bật READ_DATA = true và RUN_APP = true trong notebook.
Notebook gọi cùng code lõi; có thể mở bằng Pluto
hoặc chạy trực tiếp bằng Julia như trên.

### 4. Chạy dữ liệu cá nhân của Thịnh

```text
julia TH_2026_10_09_Sinh_vien.jl --data N24DCDT088
julia TH_2026_10_09_Sinh_vien.jl N24DCDT088 --demo
```

CSV kết quả được xuất tại data/N24DCDT088/ket_qua.csv.
Số đơn, ngân sách và tập chọn được tính từ dữ liệu cá nhân;
không dùng kết quả của MSSV khác.

CSV xuất sau chuỗi thao tác:
lập kế hoạch → giao một đơn → hoàn tác → giao lại và giao hết.
Giữ nguyên cấu trúc thư mục data khi tải và chạy.

## Giới hạn

BFS tối thiểu số cạnh trên đồ thị không trọng số.
Tham lam theo lợi ích/chi phí không luôn tối ưu cho ba lô 0/1.
BST tra cứu O(h), với h là chiều cao cây;
cây lệch có thể cần O(n).
Ứng dụng không tối ưu một chuyến giao nhiều điểm.
