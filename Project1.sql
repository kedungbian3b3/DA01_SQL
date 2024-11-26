Project1:
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


