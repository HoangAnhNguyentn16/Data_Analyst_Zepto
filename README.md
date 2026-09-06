# 📦 Zepto - Product & Inventory Data Analysis
> **Portfolio Project:** Phân tích dữ liệu sản phẩm và hàng tồn kho bằng SQL Server và Power BI.

---

## 📌 1. Tổng quan (Overview)

Dự án này tập trung phân tích danh mục sản phẩm, mức định giá, chương trình giảm giá và tình trạng hàng tồn kho của hệ thống phân phối Zepto. Mục tiêu chính là đánh giá giá trị hàng tồn kho, tối ưu hóa chiến lược giá theo khối lượng, và thiết lập cảnh báo bổ sung hàng hóa cho các sản phẩm có giá trị cao. 

Dự án bao gồm 2 bước chính:
1. **SQL (SQL Server):** Khám phá, kiểm tra chất lượng dữ liệu, làm sạch các điểm bất thường và thực hiện các phân tích nghiệp vụ cốt lõi.
2. **Power BI:** Xây dựng bảng điều khiển trực quan theo dõi lượng tồn kho và doanh thu dự kiến.

---

## 📊 2. Tập dữ liệu (Dataset)

* **Tên bảng CSDL:** `zepto_v2$` (được import trực tiếp từ file Excel/CSV vào SQL Server).
* **Các trường dữ liệu chính:**
  * `sku_id`, `name`, `Category`: Thông tin định danh và phân loại sản phẩm[cite: 5].
  * `mrp` (Giá bán lẻ tối đa), `discountedSellingPrice`, `discountPercent`: Thông tin giá và tỷ lệ giảm giá[cite: 5].
  * `availableQuantity`, `quantity`, `outOfStock`: Tình trạng và số lượng hàng tồn kho[cite: 5].
  * `weightInGms`: Khối lượng sản phẩm (tính bằng Gram)[cite: 5].

---

## 🛠️ 3. Công cụ & Công nghệ (Tools & Technologies)

* **Cơ sở dữ liệu:** Microsoft SQL Server (sử dụng T-SQL để làm sạch dữ liệu, tổng hợp và xử lý Logic điều kiện với `CASE WHEN`)[cite: 5].
* **Trực quan hóa:** Power BI Desktop.
* **Môi trường phát triển:** SQL Server Management Studio (SSMS).

---

## 🔄 4. Quy trình thực hiện (Workflow)

### 🧹 Bước 1: Khám phá & Làm sạch dữ liệu (SQL Server)
* **Kiểm tra Null:** Sử dụng mệnh đề `WHERE ... IS NULL` để rà soát toàn bộ các cột quan trọng (`name`, `mrp`, `discountPercent`, `Category`, v.v.), kết quả cho thấy bộ dữ liệu hoàn thiện, không có giá trị Null[cite: 5].
* **Định danh danh mục:** Khai thác trường `Category`, hệ thống hiện đang kinh doanh tổng cộng 14 danh mục sản phẩm khác nhau[cite: 5].
* **Kiểm tra trùng lặp:** Phát hiện các trường hợp cùng một tên sản phẩm (`name`) nhưng được gán nhiều mã `sku_id` khác nhau thông qua hàm `COUNT(sku_id) > 1`[cite: 5].
* **Xử lý lỗi Logic:** Phát hiện và sử dụng lệnh `DELETE` để xóa các bản ghi sản phẩm có giá niêm yết bằng 0 (`mrp = 0`) nhằm không làm sai lệch kết quả phân tích giá[cite: 5].

---

### 🗄️ Bước 2: Truy vấn & Phân tích chuyên sâu (SQL Server)
Thực thi **8 truy vấn chiến lược** trên tập dữ liệu đã làm sạch bao gồm:
1. **Top giảm giá sâu:** Tìm 10 sản phẩm có tỷ lệ phần trăm giảm giá (`discountPercent`) cao nhất[cite: 5].
2. **Cảnh báo hết hàng giá trị cao:** Lọc danh sách các mặt hàng đắt tiền (giá `mrp` > 30.000) đang trong tình trạng hết hàng (`outOfStock = 'TRUE'`) để ưu tiên nhập bổ sung sớm[cite: 5].
3. **Phân tích Doanh thu tiềm năng:** Tính tổng doanh thu dự kiến cho từng danh mục sản phẩm dựa trên giá bán sau giảm và số lượng đang có sẵn (`discountedSellingPrice * availableQuantity`)[cite: 5].
4. **Phân tích chiến lược giá:** Lọc toàn bộ mặt hàng cao cấp có giá trên 50.000 nhưng tỷ lệ giảm giá thấp (dưới 10%)[cite: 5].
5. **Đánh giá khuyến mãi theo danh mục:** Tìm 5 danh mục sản phẩm có mức giảm giá trung bình sâu nhất[cite: 5].
6. **Tối ưu hóa giá trị theo khối lượng:** Phân tích giá thành trên mỗi Gram (`discountedSellingPrice / weightInGms`) cho các mặt hàng nặng từ 100g trở lên để tìm sản phẩm có giá trị tốt nhất[cite: 5].
7. **Phân loại sản phẩm (Segmentation):** Phân khúc sản phẩm dựa trên khối lượng sử dụng mệnh đề `CASE WHEN`: Low (< 1000g), Medium (< 5000g), và High (còn lại)[cite: 5].
8. **Đánh giá sức chứa kho hàng:** Tính tổng khối lượng hàng tồn kho (Gram) hiện đang lưu trữ theo từng danh mục sản phẩm[cite: 5].

---

### 📊 Bước 3: Trực quan hóa dữ liệu (Power BI)
* Kết nối Power BI trực tiếp với SQL Server hoặc file dữ liệu sạch.
* Xây dựng biểu đồ theo dõi các chỉ số KPIs (Tổng giá trị kho, Số lượng mã hàng hết hạn, Danh mục đóng góp tỷ trọng tồn kho lớn nhất).
* Thiết kế ma trận đánh giá hiệu quả chương trình giảm giá chéo với doanh thu dự kiến.

---

## 📈 5. Bảng điều khiển (Dashboard)

* **Trang 1 - Tổng quan Tồn kho:** Hiển thị trực quan cảnh báo mặt hàng `outOfStock`, tổng khối lượng tồn kho và doanh thu tiềm năng.
* **Trang 2 - Phân tích Phân khúc & Khuyến mãi:** Báo cáo về tỷ lệ giảm giá trung bình theo từng nhóm `Category` và mức giá trên mỗi Gram của các sản phẩm.

---

## 💡 6. Kết quả & Phát hiện chính (Key Insights)

* **Chất lượng dữ liệu:** Dữ liệu khá sạch, không chứa giá trị Null ở các trường trọng yếu, tuy nhiên tồn tại một số lỗi vận hành khi nhập giá (`mrp = 0`) và lỗi lặp mã SKU trên cùng một tên sản phẩm[cite: 5].
* **Danh mục kinh doanh:** Zepto duy trì 14 danh mục sản phẩm, giúp đa dạng hóa lựa chọn cho người tiêu dùng[cite: 5].
* **Quản trị Tồn kho hiệu quả:** Việc nhóm sản phẩm theo dải khối lượng (`Low`, `Medium`, `High`) và tính toán tổng khối lượng tồn kho theo danh mục giúp doanh nghiệp tối ưu hóa chi phí và không gian lưu kho vật lý[cite: 5].
* **Chiến lược giá:** Xác định được các danh mục có mức giảm giá trung bình cao nhất, hỗ trợ ban quản lý điều phối lại ngân sách khuyến mãi để tối đa hóa lợi nhuận[cite: 5].

---

## 🚀 7. Hướng dẫn chạy dự án (How to Run)

### 7.1 Clone (tải) dự án về máy

```bash
# Clone (tải) dự án về máy
git clone [https://github.com/your-username/zepto_inventory_analysis.git](https://github.com/your-username/zepto_inventory_analysis.git)

# Di chuyển vào thư mục dự án vừa tải về
cd zepto_inventory_analysis
