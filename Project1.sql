Project1:
/* 1) Tạo Database ‘Project';
Dataset: https://drive.google.com/drive/folders/1IWerRguFB0-VXLrIuHmZrfRu3O-H5WXF
2) Tạo bảng chứa dataset theo câu lệnh sau:

create table SALES_DATASET_RFM_PRJ

(ordernumber VARCHAR,

quantityordered VARCHAR,

priceeach        VARCHAR,

orderlinenumber  VARCHAR,

sales            VARCHAR,

orderdate        VARCHAR,

status           VARCHAR,

productline      VARCHAR,

msrp             VARCHAR,

productcode      VARCHAR,

customername     VARCHAR,

phone            VARCHAR,

addressline1     VARCHAR,

addressline2     VARCHAR,

city             VARCHAR,

state            VARCHAR,

postalcode       VARCHAR,

country          VARCHAR,

territory        VARCHAR,

contactfullname  VARCHAR,

dealsize         VARCHAR

) 

3) Import dữ liệu từ file CSV vào bảng SALES_DATASET_RFM_PRJ vừa tạo

(dataset này sau khi làm sạch sẽ được sử dụng lại ở PROJECT 3)

Lưu ý:

Nếu sales_data_clean_rfm.csv import bị lỗi thì thử với file còn lại  sales_data_clean_rfm_bk.csv

Bước 2: 

Lưu ý: với lệnh DELETE ko nên chạy trước khi bài được review

Hãy làm sạch dữ liệu theo hướng dẫn sau:

Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 

Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.

Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 

Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 

Gợi ý: ( ADD column sau đó UPDATE)

Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 

Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)

Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN */

	
	
	
--Tạo bảng
CREATE TABLE SALES_DATASET_RFM_PRJ (
    ordernumber VARCHAR,
    quantityordered VARCHAR,
    priceeach VARCHAR,
    orderlinenumber VARCHAR,
    sales VARCHAR,
    orderdate VARCHAR,
    status VARCHAR,
    productline VARCHAR,
    msrp VARCHAR,
    productcode VARCHAR,
    customername VARCHAR,
    phone VARCHAR,
    addressline1 VARCHAR,
    addressline2 VARCHAR,
    city VARCHAR,
    state VARCHAR,
    postalcode VARCHAR,
    country VARCHAR,
    territory VARCHAR,
    contactfullname VARCHAR,
    dealsize VARCHAR
);

--Kiểm tra dữ liệu null hoặc ''
SELECT * 
FROM SALES_DATASET_RFM_PRJ
WHERE ordernumber IS NULL OR ordernumber = ''
   OR quantityordered IS NULL OR quantityordered = ''
   OR priceeach IS NULL OR priceeach = ''
   OR orderlinenumber IS NULL OR orderlinenumber = ''
   OR sales IS NULL OR sales = ''
   OR orderdate IS NULL OR orderdate = '';    --Không có dữ liệu null/''

--Chuyển đổi kiểu dữ liệu của các trường
ALTER TABLE SALES_DATASET_RFM_PRJ
    ALTER COLUMN ordernumber TYPE INT USING ordernumber::INT,
    ALTER COLUMN quantityordered TYPE INT USING quantityordered::INT,
    ALTER COLUMN priceeach TYPE NUMERIC USING priceeach::NUMERIC,
    ALTER COLUMN sales TYPE NUMERIC USING sales::NUMERIC,
    ALTER COLUMN orderlinenumber TYPE INT USING orderlinenumber::INT,
    ALTER COLUMN orderdate TYPE DATE USING TO_DATE(orderdate, 'MM/DD/YYYY');

--Thêm cột Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN contactlastname VARCHAR,
ADD COLUMN contactfirstname VARCHAR;
UPDATE SALES_DATASET_RFM_PRJ
SET contactfirstname = SUBSTRING(contactfullname FROM 1 FOR POSITION(' ' IN contactfullname) - 1);
UPDATE SALES_DATASET_RFM_PRJ
SET contactlastname = SUBSTRING(contactfullname FROM POSITION(' ' IN contactfullname) + 1);
UPDATE SALES_DATASET_RFM_PRJ
SET contactlastname = UPPER(SUBSTRING(contactlastname FROM 1 FOR 1)) || LOWER(SUBSTRING(contactlastname FROM 2));
UPDATE SALES_DATASET_RFM_PRJ
SET contactfirstname = UPPER(SUBSTRING(contactfirstname FROM 1 FOR 1)) || LOWER(SUBSTRING(contactfirstname FROM 2));

-- Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN qtr_id INT,
ADD COLUMN month_id INT,
ADD COLUMN year_id INT;
UPDATE SALES_DATASET_RFM_PRJ
SET qtr_id = EXTRACT(QUARTER FROM orderdate),
    month_id = EXTRACT(MONTH FROM orderdate),
    year_id = EXTRACT(YEAR FROM orderdate);

--Xử lý outliers
with cte as (
	select *,
	(select avg(sales) 
	from SALES_DATASET_RFM_PRJ) as avg,
	(select stddev(sales) 
	from SALES_DATASET_RFM_PRJ) as stddev
	from SALES_DATASET_RFM_PRJ
)
DELETE FROM SALES_DATASET_RFM_PRJ
WHERE (sales - avg) / stddev > 3;


--Tạo bảng mới 
CREATE TABLE SALES_DATASET_RFM_PRJ_NEW AS
SELECT * 
FROM SALES_DATASET_RFM_PRJ;


