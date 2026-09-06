-- Chạy thử dữ liệu Import vào SQL Server

SELECT TOP (100) *
  FROM [Project 5].[dbo].[zepto_v2$];
-- Dữ liệu đúng như trong file Excel


-- Xác định và loại bỏ giá trị Null

SELECT *
FROM [Project 5].[dbo].[zepto_v2$]
WHERE 
    name is null
    OR [mrp] is null
    OR [discountPercent] is null
    OR [availableQuantity] is null
    OR [discountedSellingPrice] is null
    OR [weightInGms] is null
    OR [outOfStock] is null
    OR [Category] is null
    OR [quantity] is null;
--Không có giá trị null nào cả 


--Các danh mục sản phẩm kinh doanh của DN

SELECT
    DISTINCT [Category]
FROM [Project 5].[dbo].[zepto_v2$]
ORDER BY 1;
--Có 14 Danh mục sản phẩm kinh doanh


--Số lượng sản phẩm còn hàng trong kho và sp đã hết


SELECT 
    [outOfStock]
    , COUNT(sku_id) AS SL
FROM [Project 5].[dbo].[zepto_v2$]
GROUP BY 
    [outOfStock];



-- Cùng tên sản phảm nhưng khác mã sku_id

SELECT 
    name
    ,COUNT(sku_id) AS Lần_xuất_hiện
FROM [Project 5].[dbo].[zepto_v2$]
GROUP BY
    name
HAVING COUNT 
    (sku_id) > 1
ORDER BY
    Lần_xuất_hiện DESC;



-- LÀM SẠCH DỮ LIỆU 
  
-- Sản phẩm có giá = 0


SELECT
    *
FROM [Project 5].[dbo].[zepto_v2$]
WHERE
    [mrp] = 0
    OR [discountedSellingPrice] = 0;
-- Có sản phẩm giá = 0
-- Xóa dòng đó đi 
DELETE FROM [Project 5].[dbo].[zepto_v2$]
WHERE [mrp] = 0;



-- Câu 1: Tìm 10 sản phẩm có % giảm giá cao nhất

SELECT
    TOP (10)
    name
    ,[mrp]
    ,[discountPercent]
FROM [Project 5].[dbo].[zepto_v2$]
ORDER BY
    [discountPercent] DESC;

-- Câu 2: Kiểm tra xem có mặt hàng đắt tiền nào đã hết, nên bổ sung hàng sớm


SELECT
    DISTINCT name
    , [mrp]
    , [outOfStock]
FROM [Project 5].[dbo].[zepto_v2$]
WHERE
    [outOfStock] = 'TRUE'
    AND [mrp] > 30000
ORDER BY 
    [mrp] DESC;

-- Câu 3: Tính toán tổng doanh thu cho từng danh mục


SELECT
    [Category]
    , SUM([discountedSellingPrice] * [availableQuantity]) AS Tổng_doanh_thu
FROM [Project 5].[dbo].[zepto_v2$]
GROUP BY
    [Category]
ORDER BY
    Tổng_doanh_thu DESC;

-- Câu 4: Tìm toàn bộ sản phẩm có 'giá bán > 50000' và 'giảm giá < 10%'

SELECT
    DISTINCT name
    , [mrp]
    , [discountPercent]
FROM [Project 5].[dbo].[zepto_v2$]
WHERE
    [mrp] > 50000
    AND [discountPercent] < 10 
ORDER BY
    [mrp] DESC
    , [discountPercent] DESC

-- Câu 5: Tìm 5 danh mục sản phẩm có mức giảm giá TB sâu nhất


SELECT
    TOP (5)[Category]
    , ROUND(AVG([discountPercent]),2) AS giảm_giá_TB
FROM [Project 5].[dbo].[zepto_v2$]
GROUP BY
    [Category]
ORDER BY
    giảm_giá_TB DESC;

-- Câu 6: Tìm giá thành trên mỗi Gram cho các sản phẩm > 100 Gram, tìm sản phẩm có gtri tốt nhất

SELECT
    DISTINCT name
    , [weightInGms]
    , [discountedSellingPrice]
    , ROUND(([discountedSellingPrice] / [weightInGms]),2) AS Giá_trên_gram
FROM [Project 5].[dbo].[zepto_v2$]
WHERE
    [weightInGms] >= 100
ORDER BY
    Giá_trên_gram;

-- Câu 7: Phân loại sản phẩm theo khối lượng Low, Medium, High


SELECT
    DISTINCT name
    , [weightInGms]
    , CASE WHEN [weightInGms] < 1000 THEN 'Low'
           WHEN [weightInGms] < 5000 THEN 'Medium'
           ELSE 'High'
      END AS Phân_loại
FROM [Project 5].[dbo].[zepto_v2$];

-- Câu 8: Danh mục sản phẩm có nhiều khối lượng hàng tồn kho (Tính theo khối lượng)

SELECT
    [Category]
    , SUM([weightInGms] * [availableQuantity]) AS Tổng_khối_lượng_tồn_kho
FROM [Project 5].[dbo].[zepto_v2$]
GROUP BY
    [Category]
ORDER BY
    Tổng_khối_lượng_tồn_kho DESC;